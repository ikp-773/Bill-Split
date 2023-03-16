import 'package:bill_split/app/constants/commom.dart';
import 'package:bill_split/app/models/bills.dart';
import 'package:bill_split/app/modules/add_split/controllers/add_split_controller.dart';
import 'package:bill_split/app/modules/add_split/views/split_success_view.dart';
import 'package:bill_split/app/services/cloud_firestore/add_bills.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplitExpenseController extends GetxController {
  RxString dropdownValue = "You".obs;

  final List peopleList = ['You', Get.find<AddSplitController>().selUserName];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<TextEditingController>? textControllers = [];
  List<num> splitAmounts = [];
  int option = 0;

  TextEditingController descController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  void setSelected(String value) {
    dropdownValue.value = value;
  }

  splitEqually(String amt) {
    splitAmounts.clear();
    if (amt.isNotEmpty) {
      num total = num.parse(amt);
      num split = (total / textControllers!.length);
      for (var element in textControllers!) {
        element.text = split.toStringAsFixed(2);
        splitAmounts.add(split);
      }
    } else {
      for (var element in textControllers!) {
        element.text = '0.00';
      }
    }
  }

  splitUnequally(String amt) {
    splitAmounts.clear();
    num splitSum = 0;
    if (amt.isNotEmpty) {
      for (var element in textControllers!) {
        if (element.text == '') {
          element.text = '0';
        }
        num split = num.parse(element.text);
        splitAmounts.add(split);
        splitSum += split;
      }
      if (splitSum == num.parse(amt)) {
        return true;
      } else {
        Get.snackbar("Incomplete Split",
            "The Splitted amount doesn't match up with actual amount");
      }
    }
    return false;
  }

  splitPercent(String amt) {
    splitAmounts.clear();
    num percentSum = 0;
    if (amt.isNotEmpty) {
      for (var element in textControllers!) {
        if (element.text == '') {
          element.text = '0';
        }
        percentSum += num.parse(element.text);
      }
      if (percentSum == 100) {
        for (var element in textControllers!) {
          num split = ((num.parse(element.text) / 100) * num.parse(amt));
          splitAmounts.add(split);
        }
      } else {
        Get.snackbar("Percentaage Doesn't Match",
            "Make sure the percentage add upto 100%");
      }
    }
  }

  addSplit() {
    if (option == 0) {
      splitEqually(amountController.text).then((res));
    } else if (option == 1) {
      splitUnequally(amountController.text);
    } else if (option == 2) {
      splitPercent(amountController.text);
    }
    print(splitAmounts);
  }

  void addBill() {
    FirebaseBills()
        .addBill(BillModel(
            desc: descController.text,
            amount: num.parse(amountController.text),
            createdBy: CommonInstances.storage.read(CommonInstances.uid),
            paidBy: dropdownValue.value == "You"
                ? CommonInstances.storage.read(CommonInstances.uid)
                : Get.find<AddSplitController>().selUserId,
            createdAt: DateTime.now(),
            users: [
          [
            CommonInstances.storage.read(CommonInstances.uid),
            splitAmounts[0].toStringAsFixed(2)
          ],
          [
            Get.find<AddSplitController>().selUserId,
            splitAmounts[1].toStringAsFixed(2)
          ],
        ]))
        .then((response) {
      if (response) {
        Get.to(() => const SplitSuccessView());
      }
    });
  }

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
