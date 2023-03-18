import 'package:bill_split/app/constants/commom.dart';
import 'package:bill_split/app/models/group_model.dart';
import 'package:bill_split/app/services/cloud_firestore/get_user.dart';
import 'package:bill_split/app/services/cloud_firestore/groups.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h_alert_dialog/h_alert_dialog.dart';

import '../../../models/bills_model.dart';

import '../../../services/cloud_firestore/bills.dart';

class ChatGroupController extends GetxController
    with StateMixin<List<BillModel>> {
  GroupModel group = Get.arguments;

  List<BillModel> groupBills = [];

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

    change(groupBills, status: RxStatus.success());
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
