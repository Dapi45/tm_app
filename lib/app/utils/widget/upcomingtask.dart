import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../style/AppColors.dart';

class UpcomingTask extends StatelessWidget {
  const UpcomingTask({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upcoming Task',
              style: TextStyle(
                color: AppColors.primaryText,
                fontSize: 25,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: context.isPhone ? 170 : 400,
              child: ListView(
                clipBehavior: Clip.antiAlias,
                // scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  Container(
                    height: context.isPhone ? 160 : 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.cardBg,
                    ),
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: const CircleAvatar(
                                backgroundColor: Colors.amber,
                                radius: 20,
                                foregroundImage: NetworkImage(
                                    'https://pbs.twimg.com/profile_images/1539609458514358272/VeuA18MI_400x400.jpg'),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: const CircleAvatar(
                                backgroundColor: Colors.amber,
                                radius: 20,
                                foregroundImage: NetworkImage(
                                    'https://pbs.twimg.com/profile_images/1539609458514358272/VeuA18MI_400x400.jpg'),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              height: 25,
                              width: 80,
                              color: AppColors.primaryBg,
                              child: const Center(
                                child: Text(
                                  '100 %',
                                  style: TextStyle(
                                    color: AppColors.primaryText,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          height: 25,
                          width: 80,
                          color: AppColors.primaryBg,
                          child: const Center(
                            child: Text(
                              '10 / 10 Task',
                              style: TextStyle(
                                color: AppColors.primaryText,
                              ),
                            ),
                          ),
                        ),
                        const Text(
                          'Pemrograman Mobile',
                          style: TextStyle(
                              color: AppColors.primaryText, fontSize: 20),
                        ),
                        const Text(
                          'Deadline 2 hari lagi',
                          style: TextStyle(
                              color: AppColors.primaryText, fontSize: 15),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.cardBg,
                    ),
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: const CircleAvatar(
                                backgroundColor: Colors.amber,
                                radius: 20,
                                foregroundImage: NetworkImage(
                                    'https://pbs.twimg.com/profile_images/1539609458514358272/VeuA18MI_400x400.jpg'),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: const CircleAvatar(
                                backgroundColor: Colors.amber,
                                radius: 20,
                                foregroundImage: NetworkImage(
                                    'https://pbs.twimg.com/profile_images/1539609458514358272/VeuA18MI_400x400.jpg'),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              height: 25,
                              width: 80,
                              color: AppColors.primaryBg,
                              child: const Center(
                                child: Text(
                                  '100 %',
                                  style: TextStyle(
                                    color: AppColors.primaryText,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          height: 25,
                          width: 80,
                          color: AppColors.primaryBg,
                          child: const Center(
                            child: Text(
                              '10 / 10 Task',
                              style: TextStyle(
                                color: AppColors.primaryText,
                              ),
                            ),
                          ),
                        ),
                        const Text(
                          'Pemrograman Mobile',
                          style: TextStyle(
                              color: AppColors.primaryText, fontSize: 20),
                        ),
                        const Text(
                          'Deadline 2 hari lagi',
                          style: TextStyle(
                              color: AppColors.primaryText, fontSize: 15),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
