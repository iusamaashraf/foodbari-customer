import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppbarLeading extends StatelessWidget {
  const AppbarLeading({
    Key? key,
    this.isBorder = false,
    this.borderRadius = 15,
  }) : super(key: key);

  final bool isBorder;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: IconButton(
            onPressed: () => Get.back(),
            icon: Image.asset(
              "assets/icons/left-arrow.png",
              height: Get.height * 0.03,
              color: Colors.white,
            )));
  }
}
