import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Bill Split',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
      ),
      bottomNavigationBar: FluidNavBar(
        icons: [
          FluidNavBarIcon(icon: Icons.home_rounded),
          // FluidNavBarIcon(icon: Icons.notifications_active_rounded),
          FluidNavBarIcon(icon: Icons.person_rounded),
        ],
        animationFactor: .2,
        onChange: (selectedIndex) {
          controller.currentIndex.value = selectedIndex;
        },
      ),
      extendBody: true,
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: controller.screens,
        ),
      ),
    );
  }
}
