import 'package:bill_split/app/modules/add_split/bindings/add_split_binding.dart';
import 'package:bill_split/app/modules/add_split/views/split_desc_view.dart';
import 'package:bill_split/app/modules/home/controllers/dashboard_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_split_controller.dart';

class AddSplitView extends GetView<AddSplitController> {
  const AddSplitView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Split a expense with friend')),
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
                          'Search for your friends to split bills with.',
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
                        return ListTile(
                          enableFeedback: true,
                          onTap: () {
                            int userNum = Get.find<DashboardController>()
                                .usersNameList
                                .indexOf(controller.items[index]);

                            Get.to(() => const SplitDescView(),
                                binding: AddSplitBinding(),
                                arguments: {
                                  "id": Get.find<DashboardController>()
                                      .usersIdList[userNum],
                                  "name": Get.find<DashboardController>()
                                      .usersNameList[userNum],
                                });
                          },
                          title: Text(
                            controller.items[index],
                            // style: HomeFontStylesDark.profileTile,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
