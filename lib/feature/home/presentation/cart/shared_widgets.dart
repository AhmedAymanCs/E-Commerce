import 'package:e_commerce/core/constants/font_manager.dart';
import 'package:e_commerce/feature/home/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartItem extends StatelessWidget {
  final ProductModel product;
  final int quantity;
  const CartItem({super.key, required this.product, required this.quantity});

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
                          QuantityBtn(icon: Icons.remove, onTap: () {}),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: Text(quantity.toString()),
                          ),
                          QuantityBtn(icon: Icons.add, onTap: () {}),
                          const Spacer(),
                          const Icon(Icons.delete_outline, color: Colors.red),
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
                Text("Subtotal"),
                Text(
                  "\$${product.price * quantity}",
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
          SummaryRow(label: "Subtotal", value: subtotal.toString()),
          SummaryRow(label: "Discount (10%)", value: discount.toString()),
          SummaryRow(label: "Tax (8%)", value: tax.toString()),
          const Divider(),
          SummaryRow(label: "Total", value: total.toString(), isBold: true),
        ],
      ),
    );
  }
}

class BottomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const BottomButton({super.key, required this.onPressed, required this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A56F0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
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
          borderRadius: BorderRadius.circular(4),
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
