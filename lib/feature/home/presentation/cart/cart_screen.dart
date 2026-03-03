import 'package:e_commerce/core/constants/color_manager.dart';
import 'package:e_commerce/core/models/user_model.dart';
import 'package:e_commerce/core/routing/routes.dart';
import 'package:e_commerce/core/models/checkout_model.dart';
import 'package:e_commerce/feature/home/logic/cubit.dart';
import 'package:e_commerce/feature/home/logic/states.dart';
import 'package:e_commerce/feature/home/presentation/cart/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartPage extends StatelessWidget {
  final UserModel userModel;
  const CartPage({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final HomeCubit cubit = context.read<HomeCubit>();
        if (state.cartList.isEmpty) {
          return const Center(child: Text("No Cart List"));
        }
        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.all(12.w),
                itemCount: state.cartList.length,
                separatorBuilder: (_, _) => SizedBox(height: 12.h),
                itemBuilder: (context, index) => CartItem(
                  product: state.cartList[index],
                  deleteOnPressed: () =>
                      cubit.deleteCartlist(state.cartList[index].id),
                  addQuantityOnPressed: () => cubit.updateQuantityInCart(
                    productId: state.cartList[index].id,
                    quantity: state.cartList[index].quantity,
                  ),
                  removeQuantityOnPressed: () => cubit.updateQuantityInCart(
                    productId: state.cartList[index].id,
                    quantity: state.cartList[index].quantity,
                    addQuantity: false,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    OrderSummary(
                      discount: state.cartModel.discount,
                      subtotal: state.cartModel.subtotal,
                      tax: state.cartModel.tax,
                      total: state.cartModel.total,
                    ),
                    BottomButton(
                      text: "Clear Cart",
                      color: ColorManager.red,
                      onPressed: () => cubit.clearCart(),
                    ),
                    BottomButton(
                      text: "Checkout",
                      onPressed: () => Navigator.pushNamed(
                        context,
                        Routes.checkoutRoute,
                        arguments: CheckoutArguments(
                          totalPrice: state.cartModel.total,
                          cartList: state.cartList,
                          userModel: userModel,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
