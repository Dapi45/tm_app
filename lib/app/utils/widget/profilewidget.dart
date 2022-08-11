import 'package:flutter/material.dart';
import 'package:tm_app/app/utils/style/AppColors.dart';
import 'package:get/get.dart';

import '../../data/controller/auth_controller.dart';

class ProfileWidget extends StatelessWidget {
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: !context.isPhone
          ? Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ClipRRect(
                    child: CircleAvatar(
                      backgroundColor: Colors.amber,
                      radius: 150,
                      foregroundImage:
                          NetworkImage(authC.auth.currentUser!.photoURL!),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authC.auth.currentUser!.displayName!,
                        style: const TextStyle(
                            color: AppColors.primaryText, fontSize: 40),
                      ),
                      Text(
                        authC.auth.currentUser!.email!,
                        style: const TextStyle(
                            color: AppColors.primaryText, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  ClipRRect(
                    child: CircleAvatar(
                      backgroundColor: Colors.amber,
                      radius: 100,
                      foregroundImage:
                          NetworkImage(authC.auth.currentUser!.photoURL!),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    authC.auth.currentUser!.displayName!,
                    style: const TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 25,
                    ),
                  ),
                  Text(
                    authC.auth.currentUser!.email!,
                    style: const TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
