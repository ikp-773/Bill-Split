import 'package:bill_split/app/constants/text_styles.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/chat_group_controller.dart';

class GroupSummaryView extends GetView<ChatGroupController> {
  const GroupSummaryView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Summary - ${controller.group.groupName}'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(25, 50, 25, 30),
        itemCount: controller.summaryList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.bubble_chart),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.summaryList[index].name,
                  style: CustomFontStyles.btns,
                ),
                Text(
                  'Rs ${controller.summaryList[index].amount.abs().toStringAsFixed(2)}',
                  style: CustomFontStyles.btns,
                ),
              ],
            ),
            subtitle: controller.summaryList[index].amount.isNegative
                ? const Text(
                    'You Owe',
                    style: TextStyle(color: Colors.red),
                  )
                : const Text(
                    'Owes You',
                    style: TextStyle(color: Colors.green),
                  ),
          );
        },
      ),
    );
  }
}
