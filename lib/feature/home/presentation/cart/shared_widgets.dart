import 'package:e_commerce/core/constants/app_constants.dart';
import 'package:e_commerce/core/constants/color_manager.dart';
import 'package:e_commerce/core/constants/font_manager.dart';
import 'package:e_commerce/core/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartItem extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? deleteOnPressed;
  final VoidCallback? addQuantityOnPressed;
  final VoidCallback? removeQuantityOnPressed;
  const CartItem({
    super.key,
    required this.product,
    this.deleteOnPressed,
    this.addQuantityOnPressed,
    this.removeQuantityOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          children: [
            Row(
              children: [
                Image.network(product.images.first, width: 60.w),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(product.price.toString()),
                      Row(
                        children: [
                          QuantityBtn(
                            icon: Icons.remove,
                            onTap: removeQuantityOnPressed,
                          ), //Remove Quantity Button
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: Text(product.quantity.toString()),
                          ),
                          QuantityBtn(
                            icon: Icons.add,
                            onTap: addQuantityOnPressed,
                          ), //Add Quantity Button
                          const Spacer(),
                          IconButton(
                            icon: Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: deleteOnPressed,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Subtotal :",
                  style: TextStyle(fontWeight: FontWeightManager.semiBold),
                ),
                Text(
                  "\$${product.price * product.quantity}",
                  style: TextStyle(fontWeight: FontWeightManager.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OrderSummary extends StatelessWidget {
  final double subtotal;
  final double discount;
  final double tax;
  final double total;
  const OrderSummary({
    super.key,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      color: Colors.white,
      child: Column(
        children: [
          SummaryRow(label: "Subtotal :", value: subtotal.toString()),
          SummaryRow(label: "Discount :", value: discount.toString()),
          SummaryRow(label: "Tax (14%) :", value: tax.toString()),
          const Divider(),
          SummaryRow(label: "Total", value: total.toString(), isBold: true),
        ],
      ),
    );
  }
}

class BottomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color color;
  const BottomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.color = ColorManager.primaryColor,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50.h),
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
        ),
        onPressed: onPressed,
        child: Text(
          text,
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

class QuantityBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const QuantityBtn({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: AppRadius.button,
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? FontSize.s18 : FontSize.s14,
            ),
          ),
        ],
      ),
    );
  }
}
