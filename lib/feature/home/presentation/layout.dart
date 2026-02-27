import 'package:e_commerce/core/constants/image_manager.dart';
import 'package:e_commerce/core/constants/string_manager.dart';
import 'package:e_commerce/core/database/local/secure_storage/secure_storage_helper.dart';
import 'package:e_commerce/core/di/service_locator.dart';
import 'package:e_commerce/core/models/user_model.dart';
import 'package:e_commerce/feature/home/data/repository/repository.dart';
import 'package:e_commerce/feature/home/logic/cubit.dart';
import 'package:e_commerce/feature/home/logic/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class Layout extends StatelessWidget {
  final UserModel userModel;
  const Layout({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(
        homeRepository: getIt<HomeRepository>(),
        userModel: userModel,
        secureStorageHelper: getIt<SecureStorageHelper>(),
      )..getAllHomeData(),
      child: BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final HomeCubit cubit = HomeCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              leading: SvgPicture.asset(ImageManager.logo, fit: BoxFit.contain),
              title: Text(StringManager.appName),
              actions: [
                IconButton(
                  onPressed: () => cubit.signOut(context),
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
            body: IndexedStack(
              index: cubit.navBarCurrentIndex,
              children: cubit.pages,
            ),

            bottomNavigationBar: BottomNavigationBar(
              onTap: (value) => cubit.changeNavBarIndex(value),
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home),
                  label: StringManager.home,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.favorite),
                  label: StringManager.wishlist,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.shopping_cart),
                  label: StringManager.cart,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.person),
                  label: StringManager.profile,
                ),
              ],
              currentIndex: cubit.navBarCurrentIndex,
            ),
          );
        },
      ),
    );
  }
}
