import 'package:bill_split/app/constants/commom.dart';
import 'package:bill_split/app/models/group.dart';
import 'package:bill_split/app/services/cloud_firestore/get_user.dart';
import 'package:get/get.dart';

import '../../../models/bills.dart';
import '../../../models/user.dart';
import '../../../services/cloud_firestore/bills.dart';

class ChatGroupController extends GetxController
    with StateMixin<List<BillModel>> {
  GroupModel group = Get.arguments;

  List<BillModel> groupBills = [];

  List groupMemberList = [];
  List<String> groupMembersIdList = [];

  getAllCommonBills() async {
    for (var bill in group.bills!) {
      var billModel = await FirebaseBills().getBill(bill);
      groupBills.add(billModel);
    }
    group.members!.forEach((userId) {
      if (userId != CommonInstances.storage.read(CommonInstances.uid)) {
        UserDetFirebase().getUser(userId).then((UserModel u) {
          groupMemberList.add(u.name);
          groupMembersIdList.add(u.uid!);
        });
      }
    });
    change(groupBills, status: RxStatus.success());
  }

  settleBalance(billId) {}

  deleteBill(billId) {}

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
