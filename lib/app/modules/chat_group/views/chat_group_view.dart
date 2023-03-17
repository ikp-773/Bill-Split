import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/chat_group_controller.dart';

class ChatGroupView extends GetView<ChatGroupController> {
  const ChatGroupView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatGroupView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ChatGroupView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
