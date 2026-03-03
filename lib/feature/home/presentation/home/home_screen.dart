import 'package:e_commerce/core/constants/app_constants.dart';
import 'package:e_commerce/core/constants/color_manager.dart';
import 'package:e_commerce/core/constants/string_manager.dart';
import 'package:e_commerce/core/models/user_model.dart';
import 'package:e_commerce/core/widgets/cutom_form_field.dart';
import 'package:e_commerce/feature/home/logic/cubit.dart';
import 'package:e_commerce/feature/home/logic/states.dart';
import 'package:e_commerce/feature/home/presentation/home/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatelessWidget {
  final UserModel userModel;
  const HomePage({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: BlocListener<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state.status is AddToCartSuccessState) {
            Fluttertoast.showToast(
              msg: StringManager.productAddedToCart,
              backgroundColor: ColorManager.green,
              textColor: ColorManager.white,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
            if (state is AddToCartErrorState) {
              Fluttertoast.showToast(
                msg: StringManager.productNotAddedToCart,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
              );
            }
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                final HomeCubit cubit = context.read<HomeCubit>();
                return CustomFormField(
                  hint: StringManager.searchHint,
                  preicon: Icons.search,
                  onChanged: (text) {
                    cubit.searchProducts(text ?? '');
                  },
                  onSubmitted: (text) {
                    cubit.searchProducts(text ?? '');
                  },
                );
              },
            ),
            SizedBox(height: 10.h),
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                HomeCubit cubit = context.read<HomeCubit>();
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...List.generate(
                        state.categoriesList.length,
                        (index) => CategoryCard(
                          title: state.categoriesList[index],
                          isSelected: state.currentCategoryIndex == index,
                          onPressed: () => cubit.selectCategory(index),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            BlocBuilder<HomeCubit, HomeState>(
              buildWhen: (previous, current) {
                return current.status is FormLoadingState ||
                    current.status is FormFailureState ||
                    current.status is FormGetProductsSuccess;
              },
              builder: (context, state) {
                final HomeCubit cubit = context.read<HomeCubit>();
                if (state.status is FormLoadingState) {
                  return const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state.status is FormFailureState) {
                  final errorMessage =
                      (state.status as FormFailureState).message;
                  return Expanded(
                    child: Center(child: Text('Error : $errorMessage')),
                  );
                } else if (state.status is FormGetProductsSuccess) {
                  if (state.products.isEmpty) {
                    return Expanded(
                      child: Center(child: Text(StringManager.noProductsFound)),
                    );
                  }
                  return Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: (state.status as FormGetProductsSuccess)
                          .products
                          .length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.7.w,
                      ),
                      itemBuilder: (context, index) {
                        final product = (state.status as FormGetProductsSuccess)
                            .products[index];
                        return ProductCardItem(
                          product: product,
                          onTapWishlist: () => cubit.toggleWishlist(product),
                          onPressed: () {
                            final currentProduct = product;
                            showDialog(
                              context: context,
                              builder: (dialogContext) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: AppRadius.card,
                                ),
                                content: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: SingleChildScrollView(
                                    child: ProductDetailsDialogContent(
                                      product: currentProduct,
                                      onTapAddToCart: () {
                                        cubit.addToCart(currentProduct);
                                        Navigator.of(dialogContext).pop();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                } else {
                  return const SizedBox();
                }

                // if (state is FormFailureState) {
                //   final errorMessage =
                //       (state.status as FormFailureState).message;
                //   return Expanded(
                //     child: Center(child: Text('Error : $errorMessage')),
                //   );
                // } else if (state is FormGetProductsSuccess) {
                //   if (state.products.isEmpty) {
                //     return Expanded(
                //       child: Center(child: Text(StringManager.noProductsFound)),
                //     );
                //   }
                //   return Expanded(
                //     child: GridView.builder(
                //       padding: const EdgeInsets.all(16),
                //       itemCount: state.products.length,
                //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //         crossAxisCount: 2,
                //         mainAxisSpacing: 10,
                //         crossAxisSpacing: 10,
                //         childAspectRatio: 0.7.w,
                //       ),
                //       itemBuilder: (context, index) {
                //         return ProductCardItem(
                //           product: state.products[index],
                //           onTapWishlist: () =>
                //               cubit.toggleWishlist(state.products[index]),
                //           onPressed: () {
                //             final currentProduct = state.products[index];
                //             showDialog(
                //               context: context,
                //               builder: (dialogContext) => AlertDialog(
                //                 shape: RoundedRectangleBorder(
                //                   borderRadius: AppRadius.card,
                //                 ),
                //                 content: SizedBox(
                //                   width:
                //                       MediaQuery.of(context).size.width * 0.9,
                //                   child: SingleChildScrollView(
                //                     child: ProductDetailsDialogContent(
                //                       product: currentProduct,
                //                       onTapAddToCart: () {
                //                         cubit.addToCart(currentProduct);
                //                         Navigator.of(dialogContext).pop();
                //                       },
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //             );
                //           },
                //         );
                //       },
                //     ),
                //   );
                // } else {
                //   return Expanded(
                //     child: const Center(child: CircularProgressIndicator()),
                //   );
                // }
              },
            ),
          ],
        ),
      ),
    );
  }
}
