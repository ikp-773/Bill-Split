import 'package:get/get.dart';

import 'package:bill_split/app/modules/add_split/controllers/split_expense_controller.dart';

import '../controllers/add_split_controller.dart';

class AddSplitBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplitExpenseController>(
      () => SplitExpenseController(),
    );
    Get.lazyPut<AddSplitController>(
      () => AddSplitController(),
    );
  }
}
