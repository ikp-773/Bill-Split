import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ActivityView extends GetView {
  const ActivityView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ActivityView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ActivityView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
