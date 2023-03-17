import 'package:bill_split/app/constants/commom.dart';
import 'package:bill_split/app/models/bills.dart';

import 'package:bill_split/app/services/cloud_firestore/add_bills.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h_alert_dialog/h_alert_dialog.dart';

class SplitExpenseController extends GetxController {
  RxString dropdownValue = "You".obs;

  String selUserId = Get.arguments["id"];
  String selUserName = Get.arguments["name"];

  List peopleList = [];

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
      splitEqually(amountController.text);
    } else if (option == 1) {
      splitUnequally(amountController.text);
    } else if (option == 2) {
      splitPercent(amountController.text);
    }

    print(splitAmounts);
    addBill();
  }

  void addBill() {
    FirebaseBills()
        .addBill(
      BillModel(
        billId: "",
        desc: descController.text,
        amount: num.parse(amountController.text),
        createdBy: CommonInstances.storage.read(CommonInstances.uid),
        paidBy: dropdownValue.value == "You"
            ? CommonInstances.storage.read(CommonInstances.uid)
            : selUserId,
        createdAt: DateTime.now(),
        usersSplit: [
          UsersSplit(
            id: CommonInstances.storage.read(CommonInstances.uid),
            amt: splitAmounts[0],
            settled: (dropdownValue.value == "You"
                    ? CommonInstances.storage.read(CommonInstances.uid)
                    : selUserId) ==
                CommonInstances.storage.read(CommonInstances.uid),
          ),
          UsersSplit(
            id: selUserId,
            amt: splitAmounts[1],
            settled: (dropdownValue.value == "You"
                    ? CommonInstances.storage.read(CommonInstances.uid)
                    : selUserId) ==
                selUserId,
          )
        ],
      ),
    )
        .then((response) {
      if (response.runtimeType == bool && response) {
        HAlertDialog.showCustomAlertBox(
          context: Get.context!,
          timerInSeconds: 3,
          backgroundColor: Colors.green,
          title: 'Success',
          description: 'Split added successfully. Resfresh dashboard.',
          icon: Icons.done,
          iconSize: 32,
          iconColor: Colors.green,
          titleFontFamily: 'Raleway',
          titleFontSize: 22,
          titleFontColor: Colors.white,
          descriptionFontFamily: 'Raleway',
          descriptionFontColor: Colors.white70,
          descriptionFontSize: 18,
        ).then((value) {
          Get.back();
          Get.back();
        });
      } else {
        Get.snackbar(response.toString(), "message");
      }
    });
  }

  @override
  void onInit() {
    peopleList = ['You', selUserName];
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
