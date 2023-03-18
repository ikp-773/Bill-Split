import 'package:bill_split/app/models/bills_model.dart';
import 'package:bill_split/app/modules/add_split/controllers/add_split_controller.dart';
import 'package:bill_split/app/modules/add_split/controllers/split_expense_controller.dart';
import 'package:bill_split/app/modules/add_split/views/split_desc_view.dart';
import 'package:bill_split/app/modules/home/controllers/dashboard_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../add_split/bindings/add_split_binding.dart';
import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.friendUser.name!),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Split an expense',
        child: const Icon(Icons.add_card_rounded),
        onPressed: () {
          Get.to(const SplitDescView(), binding: AddSplitBinding(), arguments: {
            "id": controller.friendUser.uid,
            "name": controller.friendUser.name
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

class PaymentCard extends StatelessWidget {
  final num amount;

  final bool self;
  final String desc;
  final num toGive;
  final bool settled;
  final String billId;

  const PaymentCard({
    Key? key,
    required this.amount,
    this.self = false,
    required this.desc,
    required this.toGive,
    this.settled = false,
    required this.billId,
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
                          Get.find<ChatController>().deleteBill(billId);
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
                ? Text(
                    settled
                        ? "Balances Settled"
                        : "Rs ${toGive.toStringAsFixed(2)} is to be paid by ${Get.find<ChatController>().friendUser.name}",
                    style: const TextStyle(fontSize: 16.0),
                  )
                : settled
                    ? const Text(
                        "Balances Settled",
                        style: TextStyle(fontSize: 16.0),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          Get.find<ChatController>().settleBalance(billId);
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
