import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:foodbari_deliver_app/modules/authentication/authentication_screen.dart';
import 'package:foodbari_deliver_app/modules/authentication/models/customer_model.dart';
import 'package:foodbari_deliver_app/modules/main_page/main_page.dart';
import 'package:foodbari_deliver_app/utils/utils.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

// import 'package:onesignal_flutter/onesignal_f
// lutte
class CustomerController extends GetxController {
  final auth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;
  Rxn<CustomerModel> customerModel = Rxn<CustomerModel>();
  File? customerImage;

  RxDouble customerLat = 0.0.obs;
  RxDouble customerLong = 0.0.obs;
  RxString customerAddress = "".obs;
  RxString customerPlaceName = "".obs;
  var riderLocationCity;

// <<<<<<<<===============For Auto signin  =================>>>>>>>>
  final Rxn<User> _firebaseUser = Rxn<User>();
  User? get user => _firebaseUser.value;
  final firebaseAuth = FirebaseAuth.instance;

  @override
  void onInit() {
    _firebaseUser.bindStream(firebaseAuth.authStateChanges());
    getCurrentLocation();
    super.onInit();
  }

  // <<<<<<<<===============create account function =================>>>>>>>>
  void signUpCustomer(
      {required String name,
      required String email,
      required String password,
      context}) async {
    Utils.showLoadingDialog(context, text: "Registration...");
    // var status = await OneSignal.shared.getDeviceState();
    // String tokenId = status!.userId!;

    Map<String, dynamic> userInfo = {
      'name': name,
      'email': email,
      'location': const GeoPoint(0.0, 0.0),
      'profileImage': "",
      "address": "",
      "phone": "",
      // "tokenId": tokenId,
    };
    await auth
        .createUserWithEmailAndPassword(
            email: email.trim(), password: password.trim())
        .then((value) async {
      await firebaseFirestore
          .collection('Customer')
          .doc(value.user!.uid)
          .set(userInfo)
          .then((value) {
        Get.back();
        Get.offAll(() => const MainPage());
      });
    }).catchError((e) {
      Get.back();
      Get.snackbar('Error', e.toString());
    });
  }

  // <<<<<<<<===============login account function =================>>>>>>>>

  void login(String email, String password, context) async {
    try {
      Utils.showLoadingDialog(context, text: "Login...");
      await auth
          .signInWithEmailAndPassword(
              email: email.trim(), password: password.trim())
          .then((value) {
        Get.back();
        Get.offAll(() => const MainPage());
      });
    } catch (e) {
      Get.back();
      Get.snackbar("Alert", e.toString().split("] ").last);
    }
  }

  // <<<<<<<<===============forgot account function =================>>>>>>>>
  void forgotPassword(String email, context) async {
    Utils.showLoadingDialog(context, text: "Sending verification link...");
    try {
      await auth.sendPasswordResetEmail(email: email.trim()).then((value) {
        Get.snackbar('Link sent succcessfully',
            'Please check your email to reset password');
        Get.to(() => const AuthenticationScreen());
      });
    } catch (e) {
      Get.back();
      Get.snackbar('Error', e.toString().split("] ").last);
    }
  }
  // <<<<<<<<===============Get profile data function =================>>>>>>>>

  Future<CustomerModel> getProfileData() async {
    // ignore: unused_local_variable
    var userData = await firebaseFirestore
        .collection('Customer')
        .doc(auth.currentUser!.uid)
        .get();
    print("id is:${auth.currentUser!.uid}");
    customerModel.value = CustomerModel.fromSnapshot(userData);
    return CustomerModel.fromSnapshot(userData);
    //     .then((doc) {
    //   // if (doc.data() == null) {
    //   //   return null;
    //   // } else {

    //   // }
    // });
  }

  // <<<<<<<<===============update Profile data function =================>>>>>>>>
  void updateProfile({
    required String name,
    required String phone,
    // required String image,

    required context,
  }) async {
    Utils.showLoadingDialog(context, text: "Updating...");
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('customer-profile-image')
          .child(auth.currentUser!.uid);
      await ref.putFile(customerImage!);
      final url = await ref.getDownloadURL();
      Map<String, dynamic> userInfo = {
        'phone': phone,
        'name': name,
        // 'profileImage': customerImage == null ? image : url,
      };
      await firebaseFirestore
          .collection('Customer')
          .doc(auth.currentUser!.uid)
          .update(userInfo);
      await getProfileData();
      Get.back();
      Get.snackbar("Success", "Profile updated");
    } catch (e) {
      Get.back();
      Get.snackbar('Error', e.toString().split("] ").last);
    }
  }
  // <<<<<<<<===============get user location data function =================>>>>>>>>

  // Future getCurrentLocation() async {
  //   Location location = Location();

  //   bool _serviceEnabled;
  //   PermissionStatus _permissionGranted;
  //   LocationData _locationData;

  //   _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) {
  //       return;
  //     }
  //   }

  //   _permissionGranted = await location.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await location.requestPermission();
  //     if (_permissionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }
  //   _locationData = await location.getLocation();
  //   customerLat.value = _locationData.latitude!;
  //   customerLong.value = _locationData.longitude!;
  //   List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
  //       _locationData.latitude!, _locationData.longitude!);
  //   var shopAddress = placemarks.first;

  //   // customerAddress.value = shopAddress.subLocality!;
  //   customerAddress.value = "${shopAddress.subLocality}"
  //       " ${shopAddress.street}"
  //       ", ${shopAddress.locality}"
  //       ", ${shopAddress.subLocality}"
  //       ", ${shopAddress.subAdministrativeArea}"
  //       ", ${shopAddress.administrativeArea}"
  //       ", ${shopAddress.thoroughfare}"
  //       ", ${shopAddress.country}";
  //   customerPlaceName.value = shopAddress.locality!;
  //   return shopAddress;
  // }

  LocationData? currentLocation;
  //final Completer<GoogleMapController> controllerCompleter = Completer();
  GoogleMapController? googleMapController;

  Future getCurrentLocation() async {
    print("Callllled");
    //googleMapController = await controllerCompleter.future;
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    print("services: $_serviceEnabled");

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    print("granted: $_permissionGranted");
    _locationData =
        await location.getLocation().then((loc) => currentLocation = loc);
    print("Current location: $currentLocation");
    location.onLocationChanged.listen(
      (newLoc) {
        currentLocation = newLoc;
        googleMapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 16.5,
              target: LatLng(newLoc.latitude!, newLoc.longitude!),
            ),
          ),
        );
        Future.delayed(const Duration(minutes: 5), () {
          FirebaseFirestore.instance
              .collection("Customer")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update(
                  {'location': GeoPoint(newLoc.latitude!, newLoc.longitude!)});
        });
      },
    );

    customerLat.value = _locationData.latitude!;
    customerLong.value = _locationData.longitude!;
    List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
        _locationData.latitude!, _locationData.longitude!);
    var shopAddress = placemarks.first;
    customerAddress.value = "${shopAddress.subLocality}"
        " ${shopAddress.street}"
        ", ${shopAddress.locality}"
        ", ${shopAddress.subLocality}"
        ", ${shopAddress.subAdministrativeArea}"
        ", ${shopAddress.administrativeArea}"
        ", ${shopAddress.thoroughfare}"
        ", ${shopAddress.country}";
    customerPlaceName.value = shopAddress.subLocality!;
    return shopAddress;
  }

// <<<<<<<<===============For location update data function =================>>>>>>>>
  Future<void> updateLocation() async {
    try {
      await firebaseFirestore
          .collection("Customer")
          .doc(auth.currentUser!.uid)
          .update({
        'address': customerAddress.value,
        "location": GeoPoint(customerLat.value, customerLong.value)
      });
      await getProfileData();
    } catch (e) {
      print(e);
      // Get.snackbar("Error", e.toString());
    }
  }

// <<<<<<<<===============Signout app function =================>>>>>>>>
  Future<void> signOut() async {
    await auth
        .signOut()
        .then((value) => {Get.offAll(() => const AuthenticationScreen())});
  }
//
  ///
  //////
  ///
  ///
  // <<<<<<<<<<<<<<<======================= One Signal configuration =============================>>>>>>>>>>>>

//   Future configOneSignel() async {
//     DateTime now = DateTime.now();
//     String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
//     print("onedignal congigured");
//     OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

//     OneSignal.shared.setAppId("73ec5ec6-22ef-4984-9ed5-7ed256034f36");

// // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
//     // OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
//     //   print("Accepted permission: $accepted");
//     // });
//     OneSignal.shared.setNotificationWillShowInForegroundHandler(
//         (OSNotificationReceivedEvent event) async {
//       // print("my event data is ${event.notification.additionalData}");
//       //eventCreatorId = event.notification.additionalData["eventCreatorId"];
//       //chatID = event.notification.additionalData["broadCastChatID"];

//       //print("Notificaiton Received");
//       // if (event.notification.additionalData["isNotificationforPermission"] ==
//       //     true) {
//       // print(
//       //     "this notification is for approvr ${event.notification.additionalData!["tokanId"]}");

//       // print("user id ${event.notification.additionalData!["productId"]}");

//       // for (int i = 0; i < allShopController.tokenIdList.value.length; i++) {
//       // print("is customer: ${event.notification.additionalData!["isCustomer"]}");
//       // print("shop Uid: ${event.notification.additionalData!["shopUid"]}");
//       // if (event.notification.additionalData!["isCustomer"]) {
//       //   await firebaseFirestore
//       //       .collection("vendors")
//       //       .doc(event.notification.additionalData!["shopUid"])
//       //       .collection("Notifications")
//       //       .add({
//       //     "productId": event.notification.additionalData!["productId"],
//       //     // "notificationBody": event.notification.body,
//       //     "time": formattedDate,
//       //     "title": event.notification.additionalData!["title"],
//       //     "subtitle": event.notification.additionalData!["subtitle"],
//       //     "tokenId": event.notification.additionalData!["tokenId"]
//       //   });
//       // } else {
//       // await firebaseFirestore
//       //     .collection("Customer")
//       //     .doc(firebaseAuth.currentUser!.uid)
//       //     .collection("Notifications")
//       //     .add({
//       //   "delivery_boy_name":
//       //       event.notification.additionalData!["delivery_boy_name"],
//       //   "title": event.notification.additionalData!["title"],
//       //   // "tokenId": event.notification.additionalData!["tokenId"]
//       // });
//       //  }
//       //  }
//       // else {
//       // }

//       //   firestore
//       //       .collection("Users")
//       //       .doc(users.uid)
//       //       .collection("Notifications")
//       //       .doc(event.notification.additionalData["broadCastChatID"])
//       //       .set({
//       //     "notificationBody": event.notification.body,
//       //     "notificationtitle": event.notification.title,
//       //     "responders": 0,
//       //     "date": formattedDate,
//       //     "eventCreatorId": event.notification.additionalData["eventCreatorId"],
//       //     "chatID": event.notification.additionalData["broadCastChatID"]
//       //   });
//       // }
//       //Get.to(() => ConfirmClients());
//       // Will be called whenever a notification is received in foreground
//       // Display Notification, pass null param for not displaying the notification
//       event.complete(event.notification);
//     });
//     OneSignal.shared.setNotificationOpenedHandler(
//         (OSNotificationOpenedResult result) async {
//       await firebaseFirestore
//           .collection("Customer")
//           .doc(firebaseAuth.currentUser!.uid)
//           .collection("Notifications")
//           .add({
//         "delivery_boy_name":
//             result.notification.additionalData!["delivery_boy_name"],
//         "title": result.notification.additionalData!["title"],
//         "tokenId": result.notification.additionalData!["tokenId"]
//       });
//       // print("setNotificationOpenedHandler");
//       // print(
//       //     "Is customer: ${result.notification.additionalData!["isCustomer"]}");
//       // print(
//       //     "shop Uid result: ${result.notification.additionalData!["shopUid"]}");
//       // if (result.notification.additionalData!["isCustomer"]) {
//       //   await firebaseFirestore
//       //       .collection("vendors")
//       //       .doc(result.notification.additionalData!["shopUid"])
//       //       .collection("Notifications")
//       //       .doc(result.notification.additionalData!["productId"])
//       //       .set({
//       //     "productId": result.notification.additionalData!["productId"],
//       //     // "notificationBody": event.notification.body,
//       //     "time": formattedDate,
//       //     "title": result.notification.additionalData!["title"],
//       //     "subtitle": result.notification.additionalData!["subtitle"],
//       //     "tokenId": result.notification.additionalData!["tokenId"]
//       //   });
//       // } else {
//       //   await firebaseFirestore
//       //       .collection("vendors")
//       //       .doc(firebaseAuth.currentUser!.uid)
//       //       .collection("Notifications")
//       //       .doc(result.notification.additionalData!["productId"])
//       //       .set({
//       //     "productId": result.notification.additionalData!["productId"],
//       //     // "notificationBody": event.notification.body,
//       //     "time": formattedDate,
//       //     "title": result.notification.additionalData!["title"],
//       //     "subtitle": result.notification.additionalData!["subtitle"],
//       //     "tokenId": result.notification.additionalData!["tokenId"]
//       //   });
//       // }
//       // eventCreatorId = result.notification.additionalData["eventCreatorId"];
//       //chatID = result.notification.additionalData["broadCastChatID"];
//       // if (result.notification.additionalData["isNotificationforPermission"] ==
//       //     true) {
//       //   print(
//       //       "this notification is for approvr ${result.notification.additionalData}");
//       //   print(
//       //       "this notification is for approvr ${result.notification.additionalData["tokanId"]}");

//       //   print("user id ${result.notification.additionalData["userId"]}");
//       //   for (int i = 0; i < getadminListforApprove.length; i++) {
//       //     firebaseFirestore
//       //         .collection("Users")
//       //         .doc(getadminListforApprove[i].id)
//       //         .collection("NotificationforApprove")
//       //         .doc(result.notification.additionalData["userId"])
//       //         .set({
//       //       "notificationtitle": result.notification.title,
//       //       "notificationBody": result.notification.body,
//       //       "date": DateTime.now(),
//       //       'userId': result.notification.additionalData["userId"],
//       //       "email": result.notification.additionalData["email"],
//       //       "unitCode": result.notification.additionalData["unitCode"],
//       //       "phoneNumber": result.notification.additionalData["phoneNumber"],
//       //       "role": result.notification.additionalData["role"],
//       //       "assignNumber": result.notification.additionalData["assignNumber"],
//       //       "name": result.notification.additionalData["name"],
//       //       "tokanId": result.notification.additionalData["tokanId"],
//       //       "isaAccountapprove":
//       //           result.notification.additionalData["isaAccountapprove"],
//       //       //"date" : DateTime.now(),
//       //     });
//       //   }
//       // } else {
//       //   DateTime now = DateTime.now();
//       //   String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

//       //   print("i am here");
//       //   firebaseFirestore
//       //       .collection("Users")
//       //       .doc(users.uid)
//       //       .collection("Notifications")
//       //       .doc(result.notification.additionalData["broadCastChatID"])
//       //       .set({
//       //     "notificationBody": result.notification.body,
//       //     "notificationtitle": result.notification.title,
//       //     "responders": 0,
//       //     "date": formattedDate,
//       //     "eventCreatorId":
//       //         result.notification.additionalData["eventCreatorId"],
//       //     "chatID": result.notification.additionalData["broadCastChatID"]
//       //   }).then((value) {
//       //     Get.to(() => IncidentCallsScreen());
//       //   });
//       // }

//       //Get.to(() => ConfirmClients());
//       // Will be called whenever a notification is opened/button pressed.
//     });
//     OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
//       // Will be called whenever the permission changes
//       // (ie. user taps Allow on the permission prompt in iOS)
//     });
//     OneSignal.shared
//         .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
//       // Will be called whenever the subscription changes
//       // (ie. user gets registered with OneSignal and gets a user ID)
//     });
//     OneSignal.shared.setEmailSubscriptionObserver(
//         (OSEmailSubscriptionStateChanges emailChanges) {
//       // Will be called whenever then user's email subscription changes
//       // (ie. OneSignal.setEmail(email) is called and the user gets registered
//     });
//   }

}
