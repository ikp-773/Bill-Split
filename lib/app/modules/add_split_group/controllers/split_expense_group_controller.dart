import 'package:bill_split/app/models/bill_model.dart';
import 'package:bill_split/app/models/group_model.dart';
import 'package:bill_split/app/services/cloud_firestore/groups.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h_alert_dialog/h_alert_dialog.dart';

import '../../../constants/commom.dart';

class SplitExpenseGroupController extends GetxController {
  RxString dropdownValue = "You".obs;

  List<String> selUserIdList = Get.arguments["id_list"];
  List selUserNameList = Get.arguments["name_list"];

  bool newGroup = Get.arguments["group_id"] == "";

  List peopleList = ["You"];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<TextEditingController>? textControllers = [];
  List<num> splitAmounts = [];
  int option = 0;

  TextEditingController grpNameController = TextEditingController();
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
    addGroupBill();
  }

  void addGroupBill() {
    List<UsersSplit> userSplitList = [];
    for (var i = 0; i < peopleList.length; i++) {
      var userSplit = UsersSplit(
        id: i == 0
            ? CommonInstances.storage.read(CommonInstances.uid)
            : selUserIdList[i - 1],
        amt: splitAmounts[i],
        settled: i == peopleList.indexOf(dropdownValue.value) ? true : false,
      );

      userSplitList.add(userSplit);
    }

    List<String>? groupMembers = selUserIdList;
    groupMembers.add(CommonInstances.storage.read(CommonInstances.uid));

    if (newGroup) {
      FirebaseGroups()
          .addGroup(
        GroupModel(
          groupId: "",
          groupName: grpNameController.text,
          members: groupMembers,
          bills: [],
        ),
      )
          .then((groupId) {
        FirebaseGroups()
            .addGroupBill(
                BillModel(
                  billId: "",
                  desc: descController.text,
                  amount: num.parse(amountController.text),
                  createdBy: CommonInstances.storage.read(CommonInstances.uid),
                  paidBy: dropdownValue.value == "You"
                      ? CommonInstances.storage.read(CommonInstances.uid)
                      : selUserIdList[
                          peopleList.indexOf(dropdownValue.value) - 1],
                  createdAt: DateTime.now(),
                  usersSplit: userSplitList,
                ),
                groupId)
            .then((response) {
          if (response.runtimeType == bool && response) {
            HAlertDialog.showCustomAlertBox(
              context: Get.context!,
              timerInSeconds: 3,
              backgroundColor: Colors.green,
              title: 'Success',
              description:
                  'Group Split added successfully. Resfresh dashboard.',
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
      });
    } else {
      FirebaseGroups()
          .addGroupBill(
              BillModel(
                billId: "",
                desc: descController.text,
                amount: num.parse(amountController.text),
                createdBy: CommonInstances.storage.read(CommonInstances.uid),
                paidBy: dropdownValue.value == "You"
                    ? CommonInstances.storage.read(CommonInstances.uid)
                    : selUserIdList[
                        peopleList.indexOf(dropdownValue.value) - 1],
                createdAt: DateTime.now(),
                usersSplit: userSplitList,
              ),
              Get.arguments["group_id"])
          .then((response) {
        if (response.runtimeType == bool && response) {
          HAlertDialog.showCustomAlertBox(
            context: Get.context!,
            timerInSeconds: 3,
            backgroundColor: Colors.green,
            title: 'Success',
            description: 'Group Split added successfully. Resfresh dashboard.',
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
  }

  @override
  void onInit() {
    if (!newGroup) {
      grpNameController.text = Get.arguments["group_name"];
    }
    peopleList.addAll(selUserNameList);
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
