// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:bill_split/app/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:get/get.dart';

class DashboardView extends GetView {
  const DashboardView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 55),
        child: FloatingActionButton(
          onPressed: () {},
          child: Icon(
            Icons.add_card_rounded,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: AmountCard(
                desc: 'Overall',
                amt: '1000.00',
                big: true,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AmountCard(
                  desc: 'Overall',
                  amt: '1000.00',
                  color: Color.fromARGB(255, 113, 193, 155),
                ),
                AmountCard(
                  desc: 'Overall',
                  amt: '1000.00',
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
            DashboardGrid(),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 15, bottom: 20),
              child: Text(
                'Groups',
                style: CustomFontStyles.subHeader,
                textAlign: TextAlign.left,
              ),
            ),
            DashboardGrid(),
            SizedBox(height: 60)
          ],
        ),
      ),
    );
  }
}

class DashboardGrid extends StatelessWidget {
  const DashboardGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: 9,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Container(
              child: Text('A', style: CustomFontStyles.btns),
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                    .withOpacity(.5),
                shape: BoxShape.circle,
              ),
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
