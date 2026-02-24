import 'package:e_commerce/core/constants/app_constants.dart';
import 'package:e_commerce/core/constants/color_manager.dart';
import 'package:flutter/material.dart';

class ProfileSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  const ProfileSection({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.button,
        side: BorderSide(color: ColorManager.gray300),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.history_rounded,
          color: ColorManager.primaryColor,
        ),
        title: Text(title),
        trailing: Icon(icon, size: 16),
        onTap: onTap,
      ),
    );
  }
}
