import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:foodbari_deliver_app/location_picker/location_picker_page.dart';
import 'package:foodbari_deliver_app/location_picker/select_location.dart';
import 'package:foodbari_deliver_app/map_screen.dart';
import 'package:foodbari_deliver_app/root.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../utils/constants.dart';
import '../../utils/k_images.dart';
import '../../widgets/custom_image.dart';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  Future startTime() async {
    var _duration = const Duration(seconds: 4);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    // Get.to(() => LocationSearch(scaffoldKey: _scaffoldkey, onSelected: () {}));
    Get.offAll(() => RootCustomer());
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _init();

    animation.addListener(() {
      if (mounted) setState(() {});
      if (animationController.isCompleted) {
        animationController.repeat();
      }
    });

    animationController.forward();

    startTime();
  }

  void _init() {
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
              top: -size.height * 0.2,
              left: -size.width * 0.2,
              child: CircleAvatar(
                radius: size.width * 0.4,
                backgroundColor: Colors.redAccent,
              )),
          Positioned(
              bottom: -size.height * 0.6,
              // left: -size.width*0.2,
              child: CircleAvatar(
                radius: size.width * 0.8,
                backgroundColor: Colors.redAccent,
              )),
          Positioned(
            top: size.height * 0.2,
            left: size.width * 0,
            right: size.width * 0.1,
            child: Lottie.asset("assets/images/delivery_boy.json"),
          ),
          Positioned(
            top: size.height * 0.65,
            child: AnimatedTextKit(
              animatedTexts: [
                WavyAnimatedText('Delivery app',
                    textStyle: TextStyle(
                        color: Colors.redAccent,
                        fontSize: size.height * 0.03,
                        fontWeight: FontWeight.w500)),
              ],
              isRepeatingAnimation: true,
              onTap: () {
                print("Tap Event");
              },
            ),
          )
        ],
      ),
    );
  }
}
