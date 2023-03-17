import 'package:bill_split/app/models/bills.dart';
import 'package:bill_split/app/models/user.dart';
import 'package:bill_split/app/modules/home/controllers/dashboard_controller.dart';
import 'package:bill_split/app/services/cloud_firestore/add_bills.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:h_alert_dialog/h_alert_dialog.dart';

class ChatController extends GetxController with StateMixin<List<BillModel>> {
  UserModel friendUser = Get.arguments;
  List commonBillsId = [];
  List<BillModel> commonBills = [];

  getAllCommonBills() async {
    for (var bill in friendUser.bills!) {
      for (var sBill in Get.find<DashboardController>().appUser.bills!) {
        if (bill == sBill) {
          commonBillsId.add(bill);
          var billModel = await FirebaseBills().getBill(bill);
          commonBills.add(billModel);
        }
      }
    }
    change(commonBills, status: RxStatus.success());
  }

  settleBalance(billId) {
    FirebaseBills().settleBill(billId).then((response) {
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
          commonBills = [];
          getAllCommonBills();
          change(commonBills, status: RxStatus.success());
        });
      } else {
        Get.snackbar(response.toString(), "message");
      }
    });
  }

  deleteBill(billId) {
    FirebaseBills().removeBill(billId).then((response) {
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
          commonBills = [];
          getAllCommonBills();
          change(commonBills, status: RxStatus.success());
        });
      } else {
        Get.snackbar(response.toString(), "message");
      }
    });
  }

  @override
  void onInit() {
    getAllCommonBills();

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
