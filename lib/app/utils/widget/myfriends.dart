import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tm_app/app/routes/app_pages.dart';

import '../../data/controller/auth_controller.dart';
import '../style/AppColors.dart';

class MyFriend extends StatelessWidget {
  final authCon = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  'My Friends',
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 25,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Get.toNamed(Routes.FRIENDS),
                  child: const Text(
                    'more',
                    style: TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 20,
                    ),
                  ),
                ),
                const Icon(
                  Ionicons.chevron_forward,
                  color: AppColors.primaryText,
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              height: 150,
              child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: authCon.streamFriends(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var myFriends = (snapshot.data!.data()
                      as Map<String, dynamic>)['emailFriends'] as List;

                  return GridView.builder(
                    shrinkWrap: true,
                    itemCount: myFriends.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: context.isPhone ? 2 : 3,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20),
                    itemBuilder: (context, index) {
                      return StreamBuilder<
                          DocumentSnapshot<Map<String, dynamic>>>(
                        stream: authCon.streamUsers(myFriends[index]),
                        builder: (context, snapshot2) {
                          if (snapshot2.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          var data = snapshot2.data!.data();

                          return Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image(
                                  image: NetworkImage(data!['photo']),
                                  height: Get.width * 0.35,
                                  width: Get.width * 0.4,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                data['name'],
                                style: const TextStyle(
                                    color: AppColors.primaryText),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
