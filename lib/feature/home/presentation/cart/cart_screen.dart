import 'package:e_commerce/feature/home/logic/cubit.dart';
import 'package:e_commerce/feature/home/logic/states.dart';
import 'package:e_commerce/feature/home/presentation/cart/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        final HomeCubit cubit = HomeCubit.get(context);
        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.all(12.w),
                itemCount: cubit.cartList.length,
                separatorBuilder: (_, _) => SizedBox(height: 12.h),
                itemBuilder: (context, index) => CartItem(
                  product: cubit.cartList[index],
                  deleteOnPressed: () =>
                      cubit.deleteCartlist(cubit.cartList[index].id),
                ),
              ),
            ),
            OrderSummary(
              discount: cubit.cartModel.discount,
              subtotal: cubit.cartModel.subtotal,
              tax: cubit.cartModel.tax,
              total: cubit.cartModel.total,
            ),
            BottomButton(text: "Checkout", onPressed: () {}),
          ],
        );
      },
    );
  }
}
