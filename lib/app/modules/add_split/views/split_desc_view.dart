import 'package:bill_split/app/modules/add_split/controllers/split_expense_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../constants/button_styles.dart';
import '../../../constants/text_styles.dart';
import '../../auth/views/sign_in_view.dart';

class SplitDescView extends GetView<SplitExpenseController> {
  const SplitDescView({Key? key}) : super(key: key);
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
                    textcontroller: controller.descController,
                    hintText: 'Description',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16.0),
                  CTField(
                    textcontroller: controller.amountController,
                    hintText: 'Amount',
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (Get.find<SplitExpenseController>().option == 0) {
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
                  const AdjustSplit(),
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

class AdjustSplit extends StatefulWidget {
  const AdjustSplit({
    Key? key,
  }) : super(key: key);

  @override
  State<AdjustSplit> createState() => _AdjustSplitState();
}

class _AdjustSplitState extends State<AdjustSplit> {
  //0-eq 1-uneq 2-percentage%
  List types = ['Equally', 'Unequally', 'By Percentage'];

  @override
  Widget build(BuildContext context) {
    Get.find<SplitExpenseController>().textControllers!.clear();
    return Column(
      children: [
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: types.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Get.find<SplitExpenseController>().option == index
                    ? const Icon(Icons.radio_button_checked_rounded)
                    : const Icon(Icons.radio_button_off_rounded),
                title: Text(
                  types[index],
                  style: CustomFontStyles.splitTextHead,
                ),
                onTap: () {
                  setState(() {
                    Get.find<SplitExpenseController>().textControllers!.clear();
                    Get.find<SplitExpenseController>().option = index;
                  });
                  if (Get.find<SplitExpenseController>().option == 0) {
                    Get.find<SplitExpenseController>().splitEqually(
                        Get.find<SplitExpenseController>()
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
          itemCount: Get.find<SplitExpenseController>().peopleList.length,
          itemBuilder: (context, index) {
            Get.find<SplitExpenseController>()
                .textControllers!
                .add(TextEditingController());
            return ListTile(
              leading: const Icon(Icons.bubble_chart_rounded),
              title: Text(
                Get.find<SplitExpenseController>().peopleList[index],
                style: CustomFontStyles.splitTextHead,
              ),
              trailing: SizedBox(
                width: 150,
                child: CTField(
                  readOnly: Get.find<SplitExpenseController>().option == 0,
                  isPercent: Get.find<SplitExpenseController>().option == 2,
                  isMoney: Get.find<SplitExpenseController>().option != 2,
                  textcontroller: Get.find<SplitExpenseController>()
                      .textControllers![index],
                  hintText: Get.find<SplitExpenseController>().option == 2
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
