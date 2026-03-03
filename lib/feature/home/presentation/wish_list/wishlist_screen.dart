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
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final HomeCubit cubit = context.read<HomeCubit>();
        if (state.wishList.isEmpty) {
          return const Center(child: Text("No Wish List"));
        }
        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.all(16.w),
                itemBuilder: (context, index) => WishlistItem(
                  product: state.wishList[index],
                  addCartOnPressed: () =>
                      cubit.addToCart(state.wishList[index]),
                  deleteOnPressed: () =>
                      cubit.toggleWishlist(state.wishList[index]),
                ),

                separatorBuilder: (context, index) => SizedBox(height: 15.h),
                itemCount: state.wishList.length,
              ),
            ),
          ],
        );
      },
    );
  }
}
