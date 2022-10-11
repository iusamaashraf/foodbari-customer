import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodbari_deliver_app/Controllers/request_controller.dart';
import 'package:foodbari_deliver_app/modules/authentication/controller/customer_controller.dart';
import 'package:foodbari_deliver_app/modules/order/home_screen.dart';
import 'package:foodbari_deliver_app/modules/order/order_details_page.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart' as fcm;

import '../message/chat_list_screen.dart';
import '../order_history/order_history_screen.dart';
import '../profile/profile_screen.dart';
import 'component/bottom_navigation_bar.dart';
import 'main_controller.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _homeController = MainController();

  late List<Widget> pageList;
  var customerController = Get.put(CustomerController());
  var requestController = Get.put(RequestController());
  @override
  void initState() {
    super.initState();

    generatingTokenForUser();
    getTokenId();
    customerController.getProfileData();
    customerController.getCurrentLocation().then((value) async {
      await customerController.updateLocation();
    });
    Get.put(CustomerController()).getProfileData();

    pageList = [
      const HomeScreen(),
      // const ChatListScreen(),
      OrderDetailsPage(),
      ProfileScreen(),
    ];
  }

  fcm.FirebaseMessaging _fcm = fcm.FirebaseMessaging.instance;

  generatingTokenForUser() async {
    //GENERATING A TOKEN FROM FIREBASE MESSAGING
    final fcmToken = await _fcm.getToken();
    //GETTING CURRENTUSER ID
    final uid = Get.find<CustomerController>().user?.uid ?? "Null";
    print("This is the user $uid");
    await FirebaseFirestore.instance.collection("UserTokens").doc(uid).set({
      "CreatedAt": FieldValue.serverTimestamp(),
      "Token": fcmToken,
      "UID": uid
    }).then((value) {
      print("Token successfully");
    });
  }

  Future<void> getTokenId() async {
    await FirebaseFirestore.instance
        .collection("UserTokens")
        .doc(Get.find<CustomerController>().user?.uid)
        .get()
        .then((value) async {
      requestController.token.value = await value.data()!['Token'];
      print("token is here  : ${requestController.token.value}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      // key: _homeController.scaffoldKey,
      // drawer: const DrawerWidget(),
      body: StreamBuilder<int>(
        initialData: 0,
        stream: _homeController.naveListener.stream,
        builder: (context, AsyncSnapshot<int> snapshot) {
          int index = snapshot.data ?? 0;
          return pageList[index];
        },
      ),
      bottomNavigationBar: const MyBottomNavigationBar(),
    );
  }
}
