import 'package:bill_split/app/models/bills.dart';
import 'package:bill_split/app/models/user.dart';
import 'package:bill_split/app/modules/home/controllers/dashboard_controller.dart';
import 'package:bill_split/app/services/cloud_firestore/get_bills.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  UserModel friendUser = Get.arguments;
  List commonBillsId = [];
  List<BillModel> commonBills = [];

  getAllCommonBills() async {
    for (var bill in friendUser.bills!) {
      for (var sBill in Get.find<DashboardController>().appUser.bills!) {
        if (bill == sBill) {
          commonBillsId.add(bill);
          var billModel = await GetBillsFirebase().getBill(bill);
          commonBills.add(billModel);
        }
      }
    }
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
