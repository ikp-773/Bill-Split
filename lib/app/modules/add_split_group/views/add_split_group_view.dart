import 'package:bill_split/app/modules/add_split_group/views/split_desc_group_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../constants/button_styles.dart';
import '../../home/controllers/dashboard_controller.dart';
import '../bindings/add_split_group_binding.dart';
import '../controllers/add_split_group_controller.dart';

class AddSplitGroupView extends GetView<AddSplitGroupController> {
  const AddSplitGroupView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Group Members')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 20, 30, 34),
              child: SizedBox(
                height: 46,
                child: TextFormField(
                  onChanged: (value) {
                    controller.availUserResults(value);
                  },
                  autofocus: false,
                  controller: controller.searchController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 23),
                    hintText: 'Search',
                    filled: true,
                    hintStyle: const TextStyle(
                      color: Color(0x88f9f9f9),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            Obx(
              () => controller.items.isEmpty
                  ? const SizedBox(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 75, vertical: 50),
                        child: Text(
                          'Search for your people to add to group.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.items.length,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                      itemBuilder: (context, index) {
                        return SelectMemberTile(
                          controller: controller,
                          index: index,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(40, 25, 40, 30),
        child: ElevatedButton(
          onPressed: () {
            print(controller.selUserNameList);
            Get.to(() => const SplitDescGroupView(),
                binding: AddSplitGroupBinding(),
                arguments: {
                  "id_list": controller.selUserIdList,
                  "name_list": controller.selUserNameList,
                });
          },
          style: CustomButtonStyles.elevButtonStyle,
          child: const Text(
            'Add Group Expense',
          ),
        ),
      ),
    );
  }
}

class SelectMemberTile extends StatefulWidget {
  const SelectMemberTile({
    Key? key,
    required this.controller,
    required this.index,
  }) : super(key: key);

  final AddSplitGroupController controller;
  final int index;

  @override
  State<SelectMemberTile> createState() => _SelectMemberTileState();
}

class _SelectMemberTileState extends State<SelectMemberTile> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    isSelected = widget.controller.selUserNameList
        .contains(widget.controller.items[widget.index]);
    return ListTile(
      trailing: isSelected
          ? const Icon(Icons.check_box_rounded)
          : const Icon(Icons.check_box_outline_blank_rounded),
      enableFeedback: true,
      onTap: () {
        setState(() {
          isSelected = !isSelected;

          int userIndex = Get.find<DashboardController>()
              .usersNameList
              .indexOf(widget.controller.items[widget.index]);

          if (isSelected) {
            widget.controller.selUserIdList
                .add(Get.find<DashboardController>().usersIdList[userIndex]);
            widget.controller.selUserNameList
                .add(Get.find<DashboardController>().usersNameList[userIndex]);
          } else {
            widget.controller.selUserIdList
                .remove(Get.find<DashboardController>().usersIdList[userIndex]);
            widget.controller.selUserNameList.remove(
                Get.find<DashboardController>().usersNameList[userIndex]);
          }
        });
      },
      title: Text(
        widget.controller.items[widget.index],
        // style: HomeFontStylesDark.profileTile,
      ),
    );
  }
}
