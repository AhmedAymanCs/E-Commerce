import 'package:e_commerce/core/constants/color_manager.dart';
import 'package:e_commerce/core/constants/font_manager.dart';
import 'package:e_commerce/core/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback? onPressed;
  const CategoryCard({
    super.key,
    required this.title,
    this.onPressed,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.w),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? ColorManager.primaryColor : Colors.white,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : ColorManager.gray500,
            fontWeight: FontWeightManager.semiBold,
            fontSize: FontSize.s14,
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ProductCardItem extends StatelessWidget {
  ProductModel product;
  final VoidCallback? addToCartPreessed;
  ProductCardItem({super.key, required this.product, this.addToCartPreessed});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.network(
                product.images.isNotEmpty
                    ? product.images[0]
                    : 'https://image2url.com/r2/default/images/1771764216790-8cbef40a-56fc-4a8e-9400-c5eca3ac1604.jpg',
                height: 120,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
              if (product.stock < 10)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "Only ${product.stock} left",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    onPressed: addToCartPreessed,
                    icon: Icon(
                      product.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: product.isFavorite ? Colors.red : Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeightManager.semiBold),
                ),
                SizedBox(height: 5.h),
                Text(
                  "\$${product.price}",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeightManager.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
