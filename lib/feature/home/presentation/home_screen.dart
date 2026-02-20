import 'package:e_commerce/core/database/local/secure_storage/secure_storage_helper.dart';
import 'package:e_commerce/core/di/service_locator.dart';
import 'package:e_commerce/core/routing/routes.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              getIt<SecureStorageHelper>().clearAll();
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.loginRoute,
                (_) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(child: Text('Home')),
    );
  }
}
