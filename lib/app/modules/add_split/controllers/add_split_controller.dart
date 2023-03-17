import 'package:bill_split/app/modules/home/controllers/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/cloud_firestore/get_user.dart';
import '../../../models/user.dart';

class AddSplitController extends GetxController {
  List userNameList = Get.find<DashboardController>().usersNameList;
  RxList items = [].obs;

  TextEditingController searchController = TextEditingController();

  void availUserResults(String query) {
    RxList dummySearchList = [].obs;
    dummySearchList.addAll(userNameList);
    if (query.isNotEmpty) {
      RxList dummyListData = [].obs;
      for (var item in dummySearchList) {
        if (item.contains(query)) {
          dummyListData.add(item);
        }
      }
      items.clear();
      items.addAll(dummyListData.toSet().toList());

      return;
    } else {
      items.clear();
      items.addAll(userNameList.toSet().toList());
    }
  }

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
