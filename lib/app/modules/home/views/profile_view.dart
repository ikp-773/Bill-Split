import 'package:bill_split/app/constants/text_styles.dart';
import 'package:bill_split/app/modules/home/controllers/dashboard_controller.dart';
import 'package:bill_split/app/modules/home/controllers/profile_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 0, 40),
            child: Text(
              'settings',
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
            child: ListTile(
              title: const Text(
                'profile',
              ),
              onTap: () {
                Get.defaultDialog(
                    titlePadding: const EdgeInsets.all(20),
                    title: 'Account Details',
                    middleText: '''
Name : ${Get.find<DashboardController>().appUser.name!}\n
Email : ${Get.find<DashboardController>().appUser.email!}
''',
                    titleStyle: CustomFontStyles.header);
              },
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
            child: ListTile(
              title: const Text(
                'log out',
              ),
              onTap: () {
                controller.signOut();
              },
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
