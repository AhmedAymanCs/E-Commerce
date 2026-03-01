import 'package:e_commerce/core/constants/color_manager.dart';
import 'package:e_commerce/core/constants/font_manager.dart';
import 'package:e_commerce/core/routing/routes.dart';
import 'package:e_commerce/feature/home/logic/cubit.dart';
import 'package:e_commerce/feature/home/logic/states.dart';
import 'package:e_commerce/feature/home/presentation/profile/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: ColorManager.gray300,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                SizedBox(height: 15.h),
                Text(
                  HomeCubit.get(context).userModel!.name!,
                  style: TextStyle(
                    fontSize: FontSize.s22,
                    fontWeight: FontWeightManager.bold,
                  ),
                ),
                SizedBox(height: 30.h),
                ProfileSection(
                  title: "Order History",
                  icon: Icons.arrow_forward_ios,
                  onTap: () =>
                      Navigator.pushNamed(context, Routes.ordersHistoryRoute),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
