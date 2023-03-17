import 'package:bill_split/app/modules/auth/views/sign_in_view.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../constants/button_styles.dart';
import '../../../constants/text_styles.dart';

import '../controllers/split_expense_group_controller.dart';

class SplitDescGroupView extends GetView<SplitExpenseGroupController> {
  const SplitDescGroupView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  CTField(
                    textcontroller: controller.grpNameController,
                    hintText: 'Group Name',
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 16.0),
                  CTField(
                    textcontroller: controller.descController,
                    hintText: 'Expense Description',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16.0),
                  CTField(
                    textcontroller: controller.amountController,
                    hintText: 'Amount',
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (Get.find<SplitExpenseGroupController>().option == 0) {
                        controller.splitEqually(value);
                      }
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, bottom: 5),
                    child: Text(
                      'Paid By',
                      style: CustomFontStyles.textField,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: SizedBox(
                      width: 300,
                      child: Obx(
                        () => DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            hint: const Text('Paid By'),
                            items: controller.peopleList
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                      ),
                                    ))
                                .toList(),
                            value: controller.dropdownValue.value,
                            onChanged: (value) {
                              print(value);
                              controller.setSelected(value.toString());
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 25, left: 15, bottom: 5),
                    child: Text(
                      'Adjust Split',
                      style: CustomFontStyles.textField,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  AdjustSplitGroup(),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(40, 25, 40, 30),
        child: ElevatedButton(
          onPressed: controller.addSplit,
          style: CustomButtonStyles.elevButtonStyle,
          child: const Text(
            'Split',
          ),
        ),
      ),
    );
  }
}

class AdjustSplitGroup extends StatefulWidget {
  const AdjustSplitGroup({
    Key? key,
  }) : super(key: key);

  @override
  State<AdjustSplitGroup> createState() => _AdjustSplitGroupState();
}

class _AdjustSplitGroupState extends State<AdjustSplitGroup> {
  //0-eq 1-uneq 2-percentage%
  List types = ['Equally', 'Unequally', 'By Percentage'];

  @override
  Widget build(BuildContext context) {
    Get.find<SplitExpenseGroupController>().textControllers!.clear();
    return Column(
      children: [
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: types.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Get.find<SplitExpenseGroupController>().option == index
                    ? const Icon(Icons.radio_button_checked_rounded)
                    : const Icon(Icons.radio_button_off_rounded),
                title: Text(
                  types[index],
                  style: CustomFontStyles.splitTextHead,
                ),
                onTap: () {
                  setState(() {
                    Get.find<SplitExpenseGroupController>()
                        .textControllers!
                        .clear();
                    Get.find<SplitExpenseGroupController>().option = index;
                  });
                  if (Get.find<SplitExpenseGroupController>().option == 0) {
                    Get.find<SplitExpenseGroupController>().splitEqually(
                        Get.find<SplitExpenseGroupController>()
                            .amountController
                            .text);
                  }
                },
              );
            }),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(left: 30),
          itemCount: Get.find<SplitExpenseGroupController>().peopleList.length,
          itemBuilder: (context, index) {
            Get.find<SplitExpenseGroupController>()
                .textControllers!
                .add(TextEditingController());
            return ListTile(
              leading: const Icon(Icons.bubble_chart_rounded),
              title: Text(
                Get.find<SplitExpenseGroupController>().peopleList[index],
                style: CustomFontStyles.splitTextHead,
              ),
              trailing: SizedBox(
                width: 150,
                child: CTField(
                  readOnly: Get.find<SplitExpenseGroupController>().option == 0,
                  isPercent:
                      Get.find<SplitExpenseGroupController>().option == 2,
                  isMoney: Get.find<SplitExpenseGroupController>().option != 2,
                  textcontroller: Get.find<SplitExpenseGroupController>()
                      .textControllers![index],
                  hintText: Get.find<SplitExpenseGroupController>().option == 2
                      ? 'Percent'
                      : 'Amount',
                  keyboardType: TextInputType.number,
                  validator: (String? value) {
                    if (!value!.isNumericOnly) {
                      return;
                    }
                    return null;
                  },
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
