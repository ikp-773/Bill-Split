import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../models/bills.dart';
import '../../add_split_group/bindings/add_split_group_binding.dart';
import '../../add_split_group/views/split_desc_group_view.dart';
import '../../chat/views/chat_view.dart';
import '../../home/controllers/dashboard_controller.dart';
import '../controllers/chat_group_controller.dart';

class ChatGroupView extends GetView<ChatGroupController> {
  const ChatGroupView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.group.groupName!),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Split an expense',
        child: const Icon(Icons.add_card_rounded),
        onPressed: () {
          Get.to(() => const SplitDescGroupView(),
              binding: AddSplitGroupBinding(),
              arguments: {
                "id_list": controller.groupMembersIdList,
                "name_list": controller.groupMemberList,
              });
        },
      ),
      body: controller.obx(
        (commonBills) => commonBills!.isEmpty
            ? const Center(
                child: Text('No splits yet. Add a new split'),
              )
            : SingleChildScrollView(
                reverse: true,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 130),
                  shrinkWrap: true,
                  // reverse: true,
                  itemCount: commonBills.length,
                  itemBuilder: (context, index) {
                    var self = false;
                    num amt = commonBills[index].amount!, bal = 0;
                    bool settled = false;

                    BillModel bill = commonBills[index];
                    for (var u in bill.usersSplit!) {
                      if (bill.paidBy ==
                          Get.find<DashboardController>().appUser.uid) {
                        self = true;
                        bal = u.amt!;
                        settled = bill.usersSplit!
                            .every((element) => element.settled == true);
                      } else {
                        if (u.id ==
                            Get.find<DashboardController>().appUser.uid) {
                          amt = u.amt!;
                          settled = u.settled!;
                        }
                      }
                    }
                    return PaymentCard(
                      desc: bill.desc!,
                      amount: amt,
                      toGive: bal,
                      self: self,
                      settled: settled,
                      billId: bill.billId!,
                    );
                  },
                ),
              ),
      ),
    );
  }
}
