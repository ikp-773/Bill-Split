import 'package:bill_split/app/modules/auth/models/user.dart';
import 'package:bill_split/app/modules/home/views/activity_view.dart';
import 'package:bill_split/app/modules/home/views/dashboard_view.dart';
import 'package:bill_split/app/services/cloud_firestore/read_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../views/profile_view.dart';

class HomeController extends GetxController {
  RxInt currentIndex = 0.obs;

  final List<Widget> screens = [
    const DashboardView(),
    const ActivityView(),
    const ProfileView(),
  ];

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
