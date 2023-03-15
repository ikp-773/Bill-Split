// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:bill_split/app/constants/text_styles.dart';
import 'package:bill_split/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'dart:math' as math;

import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 55),
        child: ExpandableFab(
          distance: 70,
          collapsedFabSize: ExpandableFabSize.regular,
          child: Icon(Icons.add_card_rounded),
          type: ExpandableFabType.up,
          expandedFabSize: ExpandableFabSize.small,
          children: [
            FloatingActionButton(
              tooltip: 'Split among friends',
              child: Icon(Icons.person_add_alt_1_rounded),
              onPressed: () {
                Get.toNamed(Routes.ADD_SPLIT);
              },
            ),
            FloatingActionButton(
              tooltip: 'Split among group',
              child: Icon(Icons.group_add_rounded),
              onPressed: () {
                Get.toNamed(Routes.ADD_SPLIT);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: controller.obx(
          (data) {
            var userModel = data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: AmountCard(
                    desc: 'Overall',
                    amt:
                        'Rs ${(userModel.owed - userModel.lent).toStringAsFixed(2)}',
                    big: true,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AmountCard(
                      desc: 'Owed',
                      amt: userModel.owed.toStringAsFixed(2),
                      color: Color.fromARGB(255, 113, 193, 155),
                    ),
                    AmountCard(
                      desc: 'Lent',
                      amt: userModel.lent.toStringAsFixed(2),
                      color: Colors.redAccent,
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 15, bottom: 20),
                  child: Text(
                    'Friends',
                    style: CustomFontStyles.subHeader,
                    textAlign: TextAlign.left,
                  ),
                ),
                DashboardGrid(
                  list: userModel.friends,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 15, bottom: 20),
                  child: Text(
                    'Groups',
                    style: CustomFontStyles.subHeader,
                    textAlign: TextAlign.left,
                  ),
                ),
                DashboardGrid(
                  list: userModel.groups,
                ),
                SizedBox(height: 60)
              ],
            );
          },
        ),
      ),
    );
  }
}

class DashboardGrid extends StatelessWidget {
  const DashboardGrid({
    Key? key,
    required this.list,
  }) : super(key: key);
  final List list;

  @override
  Widget build(BuildContext context) {
    return list.isEmpty
        ? Center(
            child: Text('No data'),
          )
        : GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: list.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
            ),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color:
                          Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                              .withOpacity(.5),
                      shape: BoxShape.circle,
                    ),
                    child: Text('A', style: CustomFontStyles.btns),
                  ),
                  Text('name os')
                ],
              );
            },
          );
  }
}

class AmountCard extends StatelessWidget {
  const AmountCard({
    Key? key,
    required this.desc,
    required this.amt,
    this.color = Colors.black38,
    this.big = false,
  }) : super(key: key);
  final String desc;
  final String amt;
  final Color color;
  final bool big;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 12),
      height: 100,
      width: big ? Get.width / 1.8 : Get.width / 2.6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            desc,
            style: CustomFontStyles.cardDesc,
          ),
          Text(
            'Rs $amt',
            style: CustomFontStyles.cardAmt,
          ),
        ],
      ),
    );
  }
}
