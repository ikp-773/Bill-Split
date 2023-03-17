import 'package:bill_split/app/constants/commom.dart';
import 'package:bill_split/app/models/user.dart';
import 'package:bill_split/app/services/cloud_firestore/get_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DashboardController extends GetxController with StateMixin<UserModel> {
  List<String> usersNameList = [];
  List<String> usersIdList = [];
  late UserModel appUser;

  getUserData() async {
    await UserDetFirebase().getSelfUser().then((value) async {
      appUser = value;
      List<UserModel> allUsers = await UserDetFirebase().getAllUsers();
      if (allUsers.isNotEmpty) {
        for (var user in allUsers) {
          usersNameList.add(user.name!);
          usersIdList.add(user.uid!);
        }
      }
      change(value, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  void onRefresh() async {
    await getUserData().then(refreshController.refreshCompleted());
  }

  void onLoading() async {
    // monitor network fetch
    await getUserData().then(refreshController.loadComplete());
    // if failed,use loadFailed(),if no data return,use LoadNodata()
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
