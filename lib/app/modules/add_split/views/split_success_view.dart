import 'package:flutter/material.dart';

import 'package:get/get.dart';

class SplitSuccessView extends GetView {
  const SplitSuccessView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SplitSuccessView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SplitSuccessView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}