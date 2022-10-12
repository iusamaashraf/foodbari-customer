import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodbari_deliver_app/Models/all_request_model.dart';
import 'package:foodbari_deliver_app/Models/distance_model.dart';
import 'package:foodbari_deliver_app/Models/place_autocomplete_response.dart';
import 'package:foodbari_deliver_app/Models/rating_model.dart';
import 'package:foodbari_deliver_app/modules/authentication/controller/customer_controller.dart';
import 'package:foodbari_deliver_app/modules/authentication/models/customer_model.dart';
import 'package:foodbari_deliver_app/modules/order/model/get_offer_model.dart';
import 'package:foodbari_deliver_app/modules/order/model/rider_data_model.dart';
import 'package:foodbari_deliver_app/modules/order/request_sent_success_page.dart';
import 'package:foodbari_deliver_app/utils/utils.dart';
import 'package:get/get.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:http/http.dart';

class RequestController extends GetxController {
  File? requestImage;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CustomerController customerController = Get.put(CustomerController());

  Rxn<List<GetRequestModel>> getRequestModel = Rxn<List<GetRequestModel>>();
  List<GetRequestModel>? get getRequest => getRequestModel.value;
  Rxn<Distancemodels> distanceModel = Rxn<Distancemodels>();
  final firstore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  CustomerController userController = Get.put(CustomerController());
  RxString token = ''.obs;

/////// getting distance from latlng

  var distances;
  var traveltime;

  distance({pickLat, pickLng, dropLat, dropLng}) async {
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=${pickLat},${pickLng}&destinations=${dropLat},${dropLng}&key=AIzaSyAzr66eCsT-AfdfVw5zoFG0guIHFOeIDr0'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      distances = await response.stream.bytesToString();
      Map<String, dynamic> map = jsonDecode(distances);
      //print("map is here : ${map}");

      distanceModel.value = Distancemodels.fromJson(map);
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> submitRequest({
    context,
    pickAddress,
    dropAddress,
    GeoPoint? pickLocation,
    GeoPoint? dropLocation,
    double? distance,
    double? deliveryFee,
  }) async {
    var url = "";
    var googleGeoCoding =
        Utils.showLoadingDialog(context, text: "Sending Request...");
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('customer-request-images')
          .child(customerController.auth.currentUser!.uid);

      if (requestImage != null) {
        await ref.putFile(requestImage!);
        url = await ref.getDownloadURL();
      }
      Map<String, dynamic> requestData = {
        'request_image': requestImage == null ? '' : url,
        'title': titleController.text,
        'description': descriptionController.text,
        'price': double.parse(priceController.text),
        'status': "",
        "isComplete": false,
        "time": Timestamp.now(),
        "customer_id": customerController.auth.currentUser!.uid,
        "customer_name": customerController.customerModel.value!.name,
        "customer_address": customerController.customerModel.value!.address,
        "customer_location": customerController.customerModel.value!.location,
        "no_of_request": 0,
        "customer_image": customerController
                    .customerModel.value!.profileImage ==
                ""
            ? "https://cdn.techjuice.pk/wp-content/uploads/2015/02/wallpaper-for-facebook-profile-photo-1024x645.jpg"
            : customerController.customerModel.value!.profileImage,
        "delivery_boy_id": "",
        "pickup_address": pickAddress,
        "drop_address": dropAddress,
        "pickup_location": pickLocation,
        "drop_location": dropLocation,
        "distance": distance,
        "delivery_fee": deliveryFee,
      };
      await _firestore.collection('all_requests').add(requestData);
      Get.back();
      Get.to(() => const RequestSentSuccessPage());
      // Utils.showCustomDialog(context,
      //     child: Padding(
      //       padding: const EdgeInsets.all(12.0),
      //       child: SizedBox(
      //         height: 100,
      //         child: Column(
      //           children: [
      //             const Icon(
      //               CupertinoIcons.checkmark_circle_fill,
      //               color: Colors.green,
      //             ),
      //             const Text("Request Send"),
      //             TextButton(
      //                 onPressed: () {
      //                   requestImage = null;
      //                   titleController.clear();
      //                   descriptionController.clear();
      //                   priceController.clear();
      //                   Get.back();
      //                 },
      //                 child: const Text("Ok"))
      //           ],
      //         ),
      //       ),
      //     ));
    } catch (e) {
      Get.back();
      Get.snackbar("Error", e.toString().split("] ").last);
    }
  }

  Rxn<List<AllRequestModel>> offerList = Rxn<List<AllRequestModel>>();
  List<AllRequestModel>? get offers => offerList.value;
  @override
  void onInit() {
    offerList.bindStream(receiveOfferStream());

    //print("active length is:${active!.length}");
    super.onInit();
  }

  Stream<List<AllRequestModel>> receiveOfferStream() {
    return _firestore
        .collection('all_requests')
        .where("customer_id", isEqualTo: customerController.user!.uid)
        .where("status", isEqualTo: "Pending")
        .snapshots()
        .map((QuerySnapshot query) {
      List<AllRequestModel> retVal = [];

      for (var element in query.docs) {
        retVal.add(AllRequestModel.fromSnapshot(element));
        // print('print${element['address']}');
      }

      return retVal;
    });
  }

// <================== Request that we get from rider after sent request ===========================>
  Future<void> getDetailRider(String id) async {
    getRequestModel.bindStream(receiveOfferDetailStream(id));
  }

  Stream<List<GetRequestModel>> receiveOfferDetailStream(String id) {
    print("receive offer stream funtion ${customerController.user!.uid}");
    return _firestore
        .collection('all_requests')
        .doc(id)
        .collection('received_offer')
        .snapshots()
        .map((QuerySnapshot query) {
      List<GetRequestModel> retVal = [];

      for (var element in query.docs) {
        retVal.add(GetRequestModel.fromSnapshot(element));
        print('offer1${element['address']}');
      }

      return retVal;
    });
  }

  Rxn<List<AllRequestModel>> orderStatusList = Rxn<List<AllRequestModel>>();
  List<AllRequestModel>? get orderStatus => orderStatusList.value;
  void getOrderStatus(String status) {
    orderStatusList.bindStream(orderStatusScreen(status));
    super.onInit();
  }

  Stream<List<AllRequestModel>> orderStatusScreen(String status) {
    return FirebaseFirestore.instance
        .collection('all_requests')
        .where("customer_id",
            isEqualTo: Get.find<CustomerController>().user!.uid)
        .where("status", isEqualTo: status)
        .snapshots()
        .map((QuerySnapshot query) {
      List<AllRequestModel> retVal = [];
      for (var element in query.docs) {
        retVal.add(AllRequestModel.fromSnapshot(element));
      }
      print('status lenght is ${retVal.length}');
      return retVal;
    });
  }

  Future<void> cancelRequest(String id, String deliveryBoyId) async {
    await firstore.collection("all_requests").doc(id).update({
      "status": "Cancelled",
      "delivery_boy_id": deliveryBoyId,
    });
  }

  Future<void> onTheWayRequest(String id, String deliveryBoyId) async {
    try {
      await firstore.collection("all_requests").doc(id).update({
        "status": "On the way",
        "delivery_boy_id": deliveryBoyId,
      });
    } catch (e) {
      print("error getting is:" + e.toString());
    }
  }

  // sendNotification(
  //   String content,
  //   deliveryBoyName,
  //   title,
  // ) async {
  //   // print("tokenId is:${userController.customerModel.value!.tokenId!}");
  //   OneSignal.shared.postNotification(OSCreateNotification(
  //     additionalData: {
  //       "delivery_boy_name": "Dear $deliveryBoyName",
  //       "title": "your request $title has accepted",
  //       "tokenId": userController.customerModel.value!.tokenId!,
  //     },
  //     heading: "Dear $deliveryBoyName",
  //     content: "Hello there ",
  //     playerIds: [userController.customerModel.value!.tokenId!],
  //   ));
  // }

  Rxn<RiderDataModel> customerModel = Rxn<RiderDataModel>();

  Future<void> getRiderDetails(String id) async {
    var doc = await firstore.collection("delivery_boy").doc(id).get();
    customerModel.value = RiderDataModel.fromSnapshot(doc);
  }

  Future<void> completeDelivery(String id) async {
    await firstore
        .collection("all_requests")
        .doc(id)
        .update({"isComplete": false, "status": "Completed"});
  }

  Future<void> cancelOffer(String id) async {
    await firstore.collection("all_requests").doc(id).update({
      "isComplete": false,
    });
  }

  Future<void> giveRatingToRider(
      String riderId, double stars, String reviews, String customerId) async {
    await firstore
        .collection("delivery_boy")
        .doc(riderId)
        .collection("ratting")
        .add({"stars": stars, "reviews": reviews, "customerId": customerId});
  }

  Rxn<List<RatingModel>> ratingList = Rxn<List<RatingModel>>();
  List<RatingModel>? get rating => ratingList.value;

  Future<void> getRating(customerId) async {
    ratingList.bindStream(getRatingStream(customerId));
  }

  RxDouble ratingValue = 0.0.obs;
  Stream<List<RatingModel>> getRatingStream(customerId) {
    return _firestore
        .collection('delivery_boy')
        .doc(customerId)
        .collection('ratting')
        .snapshots()
        .map((QuerySnapshot query) {
      List<RatingModel> retVal = [];
      ratingValue.value = 0.0;
      for (var element in query.docs) {
        ratingValue.value = element['stars'] + ratingValue.value;
        retVal.add(RatingModel.fromSnapshot(element));
      }
      print("rating value : ${ratingValue.value}");

      debugPrint('rating lenght is ${retVal.length}');
      return retVal;
    });
  }

// <=============================== Getting active orders ==============================>
  void activeFunc() {
    activeList.bindStream(showingActiveStatus());
  }

  Rxn<List<AllRequestModel>> activeList = Rxn<List<AllRequestModel>>();
  List<AllRequestModel>? get active => activeList.value;
  Stream<List<AllRequestModel>> showingActiveStatus() {
    print('Object: ${customerController.user!.uid}');
    return FirebaseFirestore.instance
        .collection('all_requests')
        .where("customer_id",
            isEqualTo: Get.find<CustomerController>().user!.uid)
        .where("status", isEqualTo: 'On the way')
        .snapshots()
        .map((QuerySnapshot query) {
      List<AllRequestModel> retVal = [];
      for (var element in query.docs) {
        retVal.add(AllRequestModel.fromSnapshot(element));
      }
      print("aa length is${retVal.length.toString()}");
      return retVal;
    });
  }

  // <=============================== Getting pending orders ==============================>
  void pendingFunc() {
    pendingList.bindStream(showingPendingStatus());
  }

  Rxn<List<AllRequestModel>> pendingList = Rxn<List<AllRequestModel>>();
  List<AllRequestModel>? get pending => pendingList.value;
  Stream<List<AllRequestModel>> showingPendingStatus() {
    return FirebaseFirestore.instance
        .collection('all_requests')
        .where("customer_id",
            isEqualTo: Get.find<CustomerController>().user!.uid)
        .where("status", isEqualTo: 'Pending')
        .snapshots()
        .map((QuerySnapshot query) {
      List<AllRequestModel> retVal = [];
      for (var element in query.docs) {
        retVal.add(AllRequestModel.fromSnapshot(element));
      }
      print("pending length is${retVal.length.toString()}");
      return retVal;
    });
  }

  // <=============================== Getting completed orders ==============================>
  void completedFunc() {
    compList.bindStream(showingCompletedStatus());
  }

  Rxn<List<AllRequestModel>> compList = Rxn<List<AllRequestModel>>();
  List<AllRequestModel>? get compl => compList.value;
  Stream<List<AllRequestModel>> showingCompletedStatus() {
    return FirebaseFirestore.instance
        .collection('all_requests')
        .where("customer_id",
            isEqualTo: Get.find<CustomerController>().user!.uid)
        .where("status", isEqualTo: 'Completed')
        .snapshots()
        .map((QuerySnapshot query) {
      List<AllRequestModel> retVal = [];
      for (var element in query.docs) {
        retVal.add(AllRequestModel.fromSnapshot(element));
      }
      print("comple length is${retVal.length.toString()}");
      return retVal;
    });
  }

  // <=============================== Getting cancelled orders ==============================>
  void cancelledFunc() {
    cancelList.bindStream(showingCancelledStatus());
  }

  Rxn<List<AllRequestModel>> cancelList = Rxn<List<AllRequestModel>>();
  List<AllRequestModel>? get cancel => cancelList.value;
  Stream<List<AllRequestModel>> showingCancelledStatus() {
    return FirebaseFirestore.instance
        .collection('all_requests')
        .where("customer_id",
            isEqualTo: Get.find<CustomerController>().user!.uid)
        .where("status", isEqualTo: 'Cancelled')
        .snapshots()
        .map((QuerySnapshot query) {
      List<AllRequestModel> retVal = [];
      for (var element in query.docs) {
        retVal.add(AllRequestModel.fromSnapshot(element));
      }
      print("comple length is${retVal.length.toString()}");
      return retVal;
    });
  }

  // <=============================== Getting sending requests ==============================>
  void sendingRequestsFunc() {
    sendingList.bindStream(sendingrequestStatus());
  }

  Rxn<List<AllRequestModel>> sendingList = Rxn<List<AllRequestModel>>();
  List<AllRequestModel>? get sending => sendingList.value;
  Stream<List<AllRequestModel>> sendingrequestStatus() {
    return FirebaseFirestore.instance
        .collection('all_requests')
        .where("customer_id",
            isEqualTo: Get.find<CustomerController>().user!.uid)
        .where("status", isEqualTo: '')
        .snapshots()
        .map((QuerySnapshot query) {
      List<AllRequestModel> retVal = [];
      for (var element in query.docs) {
        retVal.add(AllRequestModel.fromSnapshot(element));
      }
      print("sending length is${retVal.length.toString()}");
      return retVal;
    });
  }
}
