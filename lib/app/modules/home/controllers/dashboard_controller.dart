import 'package:bill_split/app/modules/auth/models/user.dart';
import 'package:bill_split/app/services/cloud_firestore/read_user.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController with StateMixin<UserModel> {
  getUserData() async {
    await UserDetFirebase().getData().then((value) {
      change(value, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  @override
  void onInit() {
    getUserData();
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
