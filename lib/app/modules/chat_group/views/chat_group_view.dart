import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../models/bills_model.dart';
import '../../add_split_group/bindings/add_split_group_binding.dart';
import '../../add_split_group/views/split_desc_group_view.dart';

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
        actions: [
          IconButton(
            onPressed: () {},
            tooltip: "summarize Expenses",
            icon: const Icon(Icons.summarize_rounded),
          ),
          const SizedBox(width: 30),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Split an expense',
        child: const Icon(Icons.add_card_rounded),
        onPressed: () {
          Get.to(() => const SplitDescGroupView(),
              binding: AddSplitGroupBinding(),
              arguments: {
                "group_id": controller.group.groupId,
                "group_name": controller.group.groupName,
                "id_list": controller.groupMembersIdList,
                "name_list": controller.groupMemberList,
              });
        },
      ),
      body: controller.obx(
        (groupBills) => groupBills!.isEmpty
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
                  itemCount: groupBills.length,
                  itemBuilder: (context, index) {
                    var self = false;
                    num amt = groupBills[index].amount!, bal = 0;
                    bool settled = false;
                    BillModel bill = groupBills[index];
                    String? paidBy = bill.paidBy;
                    for (var u in bill.usersSplit!) {
                      if (bill.paidBy ==
                          Get.find<DashboardController>().appUser.uid) {
                        self = true;
                        bal = bill.amount! - u.amt!;
                        settled = bill.usersSplit!
                            .every((element) => element.settled == true);
                      } else {
                        paidBy = controller.groupMembersIdList.contains(paidBy!)
                            ? controller.groupMemberList[
                                controller.groupMembersIdList.indexOf(paidBy)]
                            : paidBy;
                        bal = bill.amount!;
                        if (u.id ==
                            Get.find<DashboardController>().appUser.uid) {
                          amt = u.amt!;
                          settled = u.settled!;
                        }
                      }
                    }
                    return GroupPaymentCard(
                      desc: bill.desc!,
                      paidBy: paidBy!,
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

class GroupPaymentCard extends StatelessWidget {
  final num amount;

  final bool self;
  final String desc;
  final num toGive;
  final bool settled;
  final String billId;
  final String paidBy;

  const GroupPaymentCard({
    Key? key,
    required this.amount,
    this.self = false,
    required this.desc,
    required this.toGive,
    this.settled = false,
    required this.billId,
    required this.paidBy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        margin: EdgeInsets.fromLTRB(self ? 100 : 20, 20, self ? 20 : 100, 20),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.black,
          boxShadow: [
            BoxShadow(
              color: settled ? Colors.grey.withOpacity(0.5) : Colors.redAccent,
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  self ? "You Lent" : "You Borrowed",
                  style: const TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.w700),
                ),
                self && !settled
                    ? IconButton(
                        onPressed: () {
                          Get.find<ChatGroupController>().deleteBill(billId);
                        },
                        icon: const Icon(Icons.delete_rounded))
                    : const SizedBox()
              ],
            ),
            const SizedBox(height: 10.0),
            Text(
              desc,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Rs ${amount.toStringAsFixed(2)}',
              style:
                  const TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            self
                ? const SizedBox()
                : Text(
                    "Rs ${toGive.toStringAsFixed(2)} paid by $paidBy",
                    style: const TextStyle(fontSize: 16.0),
                  ),
            self ? const SizedBox() : const SizedBox(height: 10),
            self
                ? Text(
                    settled
                        ? "Balances Settled"
                        : "Rs ${toGive.toStringAsFixed(2)} is to be paid to you",
                    style: const TextStyle(fontSize: 16.0),
                  )
                : settled
                    ? const Text(
                        "Your Balances Settled",
                        style: TextStyle(fontSize: 16.0),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          Get.find<ChatGroupController>()
                              .settleGroupBalance(billId);
                        },
                        style: const ButtonStyle(),
                        child: const Text('Pay Now'),
                      ),
          ],
        ),
      ),
    );
  }
}
