import 'package:e_commerce/core/constants/app_constants.dart';
import 'package:e_commerce/core/constants/color_manager.dart';
import 'package:e_commerce/core/constants/font_manager.dart';
import 'package:e_commerce/core/widgets/cutom_form_field.dart';
import 'package:e_commerce/feature/checkout/data/models/address_model.dart';
import 'package:e_commerce/feature/checkout/logic/cubit.dart';
import 'package:e_commerce/feature/checkout/logic/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressStepWidget extends StatelessWidget {
  const AddressStepWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final cityController = TextEditingController();
    final streetController = TextEditingController();
    final zipController = TextEditingController();
    final phoneController = TextEditingController();

    return BlocBuilder<CheckoutCubit, CheckoutStates>(
      builder: (context, state) {
        var cubit = context.read<CheckoutCubit>();

        return Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter New Address",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),

              CustomFormField(
                controller: cityController,
                hint: "City",
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 10),
              CustomFormField(
                controller: streetController,
                hint: "Street Name",
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 10),
              CustomFormField(
                controller: zipController,
                hint: "Zip Code",
                // type: TextInputType.number,
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Divider(thickness: 2),
              ),

              const Text(
                "Or Select Saved Address",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),

              if (state is GetAddressesLoading)
                const Center(child: CircularProgressIndicator())
              else if (cubit.savedAddresses.isEmpty)
                const Text(
                  "No saved addresses yet.",
                  style: TextStyle(color: Colors.grey),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cubit.savedAddresses.length,
                  itemBuilder: (context, index) {
                    final address = cubit.savedAddresses[index];

                    return RadioListTile<AddressModel>(
                      contentPadding: EdgeInsets.zero,
                      title: Text(address.street),
                      subtitle: Text("${address.city} - ${address.phone}"),
                      value: address,
                      // ignore: deprecated_member_use
                      groupValue: cubit.selectedAddress,
                      // ignore: deprecated_member_use
                      onChanged: (val) {
                        if (val != null) {
                          cubit.selectAddress(val);
                          cityController.clear();
                          streetController.clear();
                        }
                      },
                    );
                  },
                ),

              const SizedBox(height: 20),

              if (cubit.selectedAddress == null)
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      cubit.addNewAddress(
                        address: AddressModel(
                          city: cityController.text,
                          street: streetController.text,
                          phone: phoneController.text,
                          zipCode: zipController.text,
                        ),
                      );
                    }
                  },
                  child: const Text("Save & Use This Address"),
                ),
            ],
          ),
        );
      },
    );
  }
}

class PaymentStepWidget extends StatelessWidget {
  final double totalAmount;
  const PaymentStepWidget({super.key, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutStates>(
      builder: (context, state) {
        var cubit = context.read<CheckoutCubit>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Payment Method",
              style: TextStyle(
                fontWeight: FontWeightManager.bold,
                fontSize: FontSize.s16,
              ),
            ),
            SizedBox(height: 20.h),
            PaymentMethodTile(
              title: "Credit Card",
              icon: Icons.credit_card,
              isSelected: cubit.paymentMethod == 'Stripe',
              onTap: () => cubit.selectPaymentMethod('Stripe'),
            ),

            SizedBox(height: 12.h),

            PaymentMethodTile(
              title: "Cash on Delivery",
              icon: Icons.local_shipping,
              isSelected: cubit.paymentMethod == 'Cash',
              onTap: () => cubit.selectPaymentMethod('Cash'),
            ),

            SizedBox(height: 30.h),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorManager.gray300,
                borderRadius: AppRadius.button,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Amount:",
                    style: TextStyle(fontSize: FontSize.s16),
                  ),
                  Text(
                    "\$$totalAmount",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: FontSize.s18,
                      color: ColorManager.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class PaymentMethodTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodTile({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: AppRadius.button,
          border: Border.all(
            color: isSelected ? ColorManager.lightBlue : ColorManager.gray300,
            width: 2,
          ),
          color: isSelected ? ColorManager.lightBlue : Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? ColorManager.primaryColor
                  : ColorManager.gray500,
            ),
            SizedBox(width: 15.w),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: FontSize.s16,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle, color: ColorManager.primaryColor),
          ],
        ),
      ),
    );
  }
}

class SummaryInfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String content;

  const SummaryInfoCard({
    super.key,
    required this.title,
    required this.icon,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorManager.lightBlue,
        borderRadius: AppRadius.button,
        border: Border.all(color: ColorManager.lightBlue),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: ColorManager.primaryColor, size: 25),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeightManager.bold,
                    fontSize: FontSize.s14,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  content,
                  style: TextStyle(color: ColorManager.gray500, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SummaryPriceRow extends StatelessWidget {
  final String label;
  final String price;
  final bool isBold;
  final bool isGreen;

  const SummaryPriceRow({
    super.key,
    required this.label,
    required this.price,
    this.isBold = false,
    this.isGreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isBold ? FontSize.s18 : FontSize.s14,
              fontWeight: isBold
                  ? FontWeightManager.bold
                  : FontWeightManager.regular,
            ),
          ),
          Text(
            price,
            style: TextStyle(
              fontSize: isBold ? FontSize.s18 : FontSize.s14,
              fontWeight: isBold
                  ? FontWeightManager.bold
                  : FontWeightManager.regular,
              color: isGreen ? ColorManager.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class SummaryStepWidget extends StatelessWidget {
  final double totalPrice;
  final VoidCallback? onTapConfirm;
  const SummaryStepWidget({
    super.key,
    required this.totalPrice,
    this.onTapConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutStates>(
      builder: (context, state) {
        final cubit = CheckoutCubit.get(context);
        final address = cubit.selectedAddress;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order Summary",
              style: TextStyle(
                fontWeight: FontWeightManager.semiBold,
                fontSize: FontSize.s18,
              ),
            ),
            SizedBox(height: 15.h),

            SummaryInfoCard(
              title: "Shipping Address",
              icon: Icons.location_on_outlined,
              content:
                  "${address?.street}, ${address?.city}\nPhone: ${address?.phone}",
            ),

            SizedBox(height: 12.h),

            SummaryInfoCard(
              title: "Payment Method",
              icon: Icons.payment_outlined,
              content: cubit.paymentMethod == 'Stripe'
                  ? "Credit Card"
                  : "Cash on Delivery",
            ),

            SizedBox(height: 24.h),
            const Divider(),
            SummaryPriceRow(label: "Subtotal", price: "\$$totalPrice"),
            const SummaryPriceRow(
              label: "Shipping Fee",
              price: "Free",
              isGreen: true,
            ),
            Divider(height: 30.h),
            SummaryPriceRow(
              label: "Total Amount",
              price: "\$$totalPrice",
              isBold: true,
            ),

            const SizedBox(height: 30),

            ConfirmButton(state: state, onPressed: onTapConfirm),
          ],
        );
      },
    );
  }
}

class ConfirmButton extends StatelessWidget {
  final CheckoutStates state;
  final VoidCallback? onPressed;

  const ConfirmButton({super.key, required this.state, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorManager.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
          elevation: 0,
        ),
        onPressed: state is PlaceOrderLoading ? null : onPressed,
        child: state is PlaceOrderLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                "Confirm & Place Order",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: FontSize.s16,
                  fontWeight: FontWeightManager.semiBold,
                ),
              ),
      ),
    );
  }
}
