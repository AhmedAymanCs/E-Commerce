import 'package:e_commerce/feature/home/logic/cubit.dart';
import 'package:e_commerce/feature/home/logic/states.dart';
import 'package:e_commerce/feature/home/presentation/wish_list/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        final HomeCubit cubit = HomeCubit.get(context);
        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.all(16.w),
                itemBuilder: (context, index) => WishlistItem(
                  product: cubit.wishList[index],
                  addCartOnPressed: () =>
                      cubit.addToCart(cubit.wishList[index]),
                  deleteOnPressed: () =>
                      cubit.toggleWishlist(cubit.wishList[index]),
                ),

                separatorBuilder: (context, index) => SizedBox(height: 15.h),
                itemCount: cubit.wishList.length,
              ),
            ),
          ],
        );
      },
    );
  }
}
