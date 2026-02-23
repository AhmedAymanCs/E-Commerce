import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce/core/di/service_locator.dart';
import 'package:e_commerce/core/stripe_payment/stripe_keys.dart';
import 'package:e_commerce/core/utils/typedef.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

abstract class PaymentManager {
  static ServerResponse<void> makePayment(
    double amount,
    String currency,
  ) async {
    try {
      String clientSecret = await _getClientSecret(
        (amount * 100).toInt().toString(),
        currency,
      );
      await _initializePaymentSheet(clientSecret);
      await Stripe.instance.presentPaymentSheet();
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  static Future<void> _initializePaymentSheet(String clientSecret) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: "E-Market",
      ),
    );
  }

  static Future<String> _getClientSecret(String amount, String currency) async {
    Dio dio = getIt<Dio>();
    var response = await dio.post(
      'https://api.stripe.com/v1/payment_intents',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${ApiKeys.secretKey}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      ),
      data: {'amount': amount, 'currency': currency},
    );
    return response.data["client_secret"];
  }
}
