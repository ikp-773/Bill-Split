import 'package:bill_split/app/constants/commom.dart';
import 'package:bill_split/app/models/group_model.dart';
import 'package:bill_split/app/models/group_summary_model.dart';
import 'package:bill_split/app/services/cloud_firestore/get_user.dart';
import 'package:bill_split/app/services/cloud_firestore/groups.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h_alert_dialog/h_alert_dialog.dart';

import '../../../models/bill_model.dart';

import '../../../models/user.dart';
import '../../../services/cloud_firestore/bills.dart';

class ChatGroupController extends GetxController
    with StateMixin<List<BillModel>> {
  GroupModel group = Get.arguments;

  List<BillModel> groupBills = [];

  List<GroupSummaryModel> summaryList = [];

  List groupMemberList = [];
  List<String> groupMembersIdList = [];

  getGroupBills() async {
    for (var bill in group.bills!) {
      var billModel = await FirebaseBills().getBill(bill);

      groupBills.add(billModel);
    }
    for (var userId in group.members!) {
      if (userId != CommonInstances.storage.read(CommonInstances.uid)) {
        await UserDetFirebase().getUser(userId).then((u) {
          groupMemberList.add(u.name!);
          groupMembersIdList.add(u.uid!);
        });
      }
    }
    await summarizeGroup();
    change(groupBills, status: RxStatus.success());
  }

  summarizeGroup() async {
    summaryList.clear();
    for (var user in group.members!) {
      if (user != CommonInstances.storage.read(CommonInstances.uid)) {
        num total = 0;
        UserModel? userModel = await UserDetFirebase().getUser(user);

        for (var element in userModel!.bills!) {
          if (group.bills!.contains(element)) {
            BillModel billModel = await FirebaseBills().getBill(element);
            for (var u in billModel.usersSplit!) {
              if (!u.settled! && u.id == user) {
                total += u.amt!;
              }
              if (billModel.paidBy == user && u.id == user && !u.settled!) {
                total = total - (billModel.amount! - u.amt!);
              }
            }
          }
        }
        summaryList.add(GroupSummaryModel(
          name: userModel.name!,
          amount: total,
        ));
      }
    }
  }

  settleGroupBalance(billId) {
    FirebaseGroups().settleGroupBill(billId, group.groupId!).then((response) {
      if (response.runtimeType == bool && response) {
        HAlertDialog.showCustomAlertBox(
          context: Get.context!,
          timerInSeconds: 3,
          backgroundColor: Colors.blue,
          title: 'Settled',
          description: 'The split has been settled.',
          icon: Icons.swap_horizontal_circle_rounded,
          iconSize: 32,
          iconColor: Colors.blue,
          titleFontFamily: 'Raleway',
          titleFontSize: 22,
          titleFontColor: Colors.white,
          descriptionFontFamily: 'Raleway',
          descriptionFontColor: Colors.white70,
          descriptionFontSize: 18,
        ).then((value) {
          groupBills = [];
          getGroupBills();
          change(groupBills, status: RxStatus.success());
        });
      } else {
        Get.snackbar(response.toString(), "message");
      }
    });
  }

  deleteBill(billId) {
    FirebaseGroups().removeGroupBill(billId, group.groupId!).then((response) {
      if (response.runtimeType == bool && response) {
        HAlertDialog.showCustomAlertBox(
          context: Get.context!,
          timerInSeconds: 3,
          backgroundColor: Colors.red,
          title: 'Deleted',
          description: 'The split has been deleted.',
          icon: Icons.delete_rounded,
          iconSize: 32,
          iconColor: Colors.red,
          titleFontFamily: 'Raleway',
          titleFontSize: 22,
          titleFontColor: Colors.white,
          descriptionFontFamily: 'Raleway',
          descriptionFontColor: Colors.white70,
          descriptionFontSize: 18,
        ).then((value) {
          groupBills = [];
          getGroupBills();
          change(groupBills, status: RxStatus.success());
        });
      } else {
        Get.snackbar(response.toString(), "message");
      }
    });
  }

  @override
  void onInit() {
    getGroupBills();

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
