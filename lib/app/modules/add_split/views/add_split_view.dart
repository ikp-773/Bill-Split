import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_split_controller.dart';

class AddSplitView extends GetView<AddSplitController> {
  const AddSplitView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AddSplitView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AddSplitView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
