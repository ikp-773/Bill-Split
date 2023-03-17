import 'package:bill_split/app/models/bills.dart';
import 'package:bill_split/app/modules/add_split/controllers/add_split_controller.dart';
import 'package:bill_split/app/modules/add_split/controllers/split_expense_controller.dart';
import 'package:bill_split/app/modules/add_split/views/split_desc_view.dart';
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
      body: controller.commonBills.isEmpty
          ? const Center(
              child: Text('No splits yet. Add a new split'),
            )
          : ListView.builder(
              itemCount: controller.commonBills.length,
              itemBuilder: (context, index) {
                BillModel bill = controller.commonBills[index];
                return PaymentCard(
                  amount: bill.amount!,
                  onPressed: () {},
                );
              },
            ),
    );
  }
}

class PaymentCard extends StatelessWidget {
  final num amount;
  final Function onPressed;

  const PaymentCard({Key? key, required this.amount, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Amount to be paid:',
            style: TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Rs $amount',
            style: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            child: const Text('Pay Now'),
          ),
        ],
      ),
    );
  }
}
