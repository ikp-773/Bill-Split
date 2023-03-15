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
                      padding: EdgeInsets.only(left: 5),
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
                    AdjustSplit(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 25, 40, 30),
                      child: ElevatedButton(
                        onPressed: controller.addSplit,
                        style: CustomButtonStyles.elevButtonStyle,
                        child: const Text(
                          'Add Expense',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class AdjustSplit extends StatelessWidget {
  const AdjustSplit({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column();
  }
}
