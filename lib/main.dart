import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/constants/commom.dart';
import 'app/routes/app_pages.dart';

import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

Future<void> main() async {
  await GetStorage.init();
  var uid = CommonInstances.storage.read(CommonInstances.uid);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MyApp(uid: uid),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    this.uid,
  }) : super(key: key);
  final String? uid;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData.dark(),
      title: "Application",
      initialRoute: uid.isNull ? AppPages.INITIAL : Routes.HOME,
      getPages: AppPages.routes,
    );
  }
}
