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
          Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 0, 40),
            child: Text(
              'settings',
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 0, 40, 20),
            child: ListTile(
              title: Text(
                'profile',
              ),
              onTap: () {},
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 0, 40, 20),
            child: ListTile(
              title: Text(
                'log out',
              ),
              onTap: () {
                controller.signOut();
              },
              trailing: Icon(
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
