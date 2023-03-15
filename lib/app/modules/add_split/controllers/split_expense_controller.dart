import 'package:bill_split/app/modules/add_split/controllers/add_split_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplitExpenseController extends GetxController {
  RxString dropdownValue = "You".obs;

  final List peopleList = ['You', Get.find<AddSplitController>().selUserName];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController descController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  void setSelected(String value) {
    dropdownValue.value = value;
  }

  addSplit() {}

  @override
  void onInit() {
    if (kDebugMode) {
      print(peopleList);
    }
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
