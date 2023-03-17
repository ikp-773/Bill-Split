import 'package:bill_split/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../constants/commom.dart';

class ProfileController extends GetxController {
  signOut() async {
    CommonInstances.storage.remove(CommonInstances.uid);
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(Routes.AUTH);
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
