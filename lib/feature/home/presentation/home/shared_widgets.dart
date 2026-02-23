import 'package:e_commerce/core/constants/color_manager.dart';
import 'package:e_commerce/core/constants/font_manager.dart';
import 'package:e_commerce/feature/home/data/models/product_model.dart';
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
          title.toUpperCase(),
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
  final VoidCallback? onPressed;
  final VoidCallback? onTapWishlist;
  ProductCardItem({
    super.key,
    required this.product,
    this.onPressed,
    this.onTapWishlist,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
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
                      onPressed: onTapWishlist,
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
      ),
    );
  }
}

class ProductDetailsDialogContent extends StatefulWidget {
  final ProductModel product;
  final VoidCallback? onTapAddToCart;

  const ProductDetailsDialogContent({
    super.key,
    required this.product,
    this.onTapAddToCart,
  });

  @override
  State<ProductDetailsDialogContent> createState() =>
      _ProductDetailsDialogContentState();
}

class _ProductDetailsDialogContentState
    extends State<ProductDetailsDialogContent> {
  late PageController _pageController;

  late ValueNotifier<int> _currentPage;

  @override
  void initState() {
    _pageController = PageController();
    _currentPage = ValueNotifier<int>(0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 250.h,
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: widget.product.images.length,
                onPageChanged: (index) {
                  _currentPage.value = index;
                },
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12.r),
                    ),
                    child: Image.network(
                      widget.product.images[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  );
                },
              ),
              Positioned(
                top: 10.h,
                left: 10.w,
                right: 10.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircularIcon(
                      icon: Icons.close,
                      onTap: () => Navigator.pop(context),
                    ),
                    CircularIcon(
                      icon: widget.product.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: widget.product.isFavorite
                          ? Colors.red
                          : Colors.grey,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 15.h,
                left: 0,
                right: 0,
                child: ValueListenableBuilder<int>(
                  valueListenable: _currentPage,
                  builder: (context, activeIndex, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.product.images.length,
                        (index) => BuildDot(isActive: index == activeIndex),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 15.h),
        Text(
          widget.product.title,
          style: TextStyle(
            fontSize: FontSize.s20,
            fontWeight: FontWeightManager.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "\$${widget.product.price}",
              style: TextStyle(
                fontSize: FontSize.s18,
                fontWeight: FontWeightManager.bold,
                color: ColorManager.primaryColor,
              ),
            ),
            Text(
              "(${widget.product.category.toUpperCase()})",
              style: TextStyle(
                fontSize: FontSize.s12,
                fontWeight: FontWeightManager.semiBold,
                color: ColorManager.gray500,
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                "${widget.product.stock} in stock",
                style: TextStyle(
                  color: ColorManager.green,
                  fontSize: FontSize.s12,
                  fontWeight: FontWeightManager.bold,
                ),
              ),
            ),
          ],
        ),

        Divider(height: 30.h),

        Text(
          "Description",
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),
        Text(
          widget.product.description,
          style: TextStyle(color: Colors.grey[600], height: 1.5),
        ),

        SizedBox(height: 25.h),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorManager.primaryColor,
            minimumSize: Size(double.infinity, 50.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          onPressed: widget.onTapAddToCart,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_cart_outlined, color: Colors.white),
              SizedBox(width: 10.w),
              const Text(
                "Add to Cart",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeightManager.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CircularIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color? color;
  const CircularIcon({super.key, required this.icon, this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: onTap != null ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }
}

class BuildDot extends StatelessWidget {
  final bool isActive;
  const BuildDot({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 6.h,
      width: isActive ? 20.w : 8.w,
      decoration: BoxDecoration(
        color: isActive ? ColorManager.primaryColor : ColorManager.gray300,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
