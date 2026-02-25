import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce/core/stripe_payment/stripe_keys.dart';
import 'package:e_commerce/core/utils/typedef.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentManager {
  final Dio dio;
  PaymentManager(this.dio);
  ServerResponse<Unit> makePayment(double amount, String currency) async {
    try {
      String clientSecret = await _getClientSecret(
        (amount * 100).toInt().toString(),
        currency,
      );
      await _initializePaymentSheet(clientSecret);

      await Stripe.instance.presentPaymentSheet();

      return const Right(unit);
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        return const Left("USER_CANCELED");
      }
      return Left(e.error.localizedMessage ?? "Payment Failed");
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<void> _initializePaymentSheet(String clientSecret) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: "E-Market",
      ),
    );
  }

  Future<String> _getClientSecret(String amount, String currency) async {
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
