import 'package:bill_split/app/models/user.dart';
import 'package:bill_split/app/services/cloud_firestore/read_user.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController with StateMixin<UserModel> {
  List<String> usersNameList = [];
  List<String> usersIdList = [];

  getUserData() async {
    await UserDetFirebase().getUserModel().then((value) async {
      List<UserModel> allUsers = await UserDetFirebase().getAllUsers();
      if (allUsers.isNotEmpty) {
        for (var user in allUsers) {
          usersNameList.add(user.name);
          usersIdList.add(user.uid);
        }
      }
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
