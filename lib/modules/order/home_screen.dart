import 'dart:async';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:foodbari_deliver_app/Controllers/push_notification_controller.dart';
import 'package:foodbari_deliver_app/Controllers/request_controller.dart';
import 'package:foodbari_deliver_app/map_screen.dart';
import 'package:foodbari_deliver_app/modules/authentication/controller/customer_controller.dart';
import 'package:foodbari_deliver_app/modules/order/model/my_product_model.dart';
import 'package:foodbari_deliver_app/modules/order/product_controller/product_controller.dart';
import 'package:foodbari_deliver_app/modules/order/show_delivery_boy_detail_page.dart';
import 'package:foodbari_deliver_app/router_name.dart';
import 'package:foodbari_deliver_app/utils/k_images.dart';
import 'package:foodbari_deliver_app/utils/utils.dart';
import 'package:foodbari_deliver_app/widgets/custom_image.dart';
import 'package:foodbari_deliver_app/widgets/primary_button.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rating_dialog/rating_dialog.dart';

import '../../dummy_data/all_dymmy_data.dart';
import '../../utils/constants.dart';
import '../../widgets/toggle_button_component.dart';
import 'component/order_app_bar.dart';
import 'component/ordered_list_component.dart';
import 'model/product_order_model.dart';
import 'more_info_rider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var authController = Get.put(CustomerController());
  ProductController productController = Get.put(ProductController());
  RequestController orderController = Get.put(RequestController());
  CustomerController customerController = Get.put(CustomerController());
  @override
  void initState() {
    authController.getCurrentLocation().then((value) async {
      await authController.updateLocation();
      await authController.getProfileData();
      // orderController.getDetailRider(requestController.allRequests![0].id!);
    });
    Get.put(RequestController());
    requestController.sendingRequestsFunc();

    Get.put(ProductController());
    Get.put(RequestController());
    orderController.activeFunc();
    orderController.pendingFunc();
    orderController.completedFunc();
    orderController.cancelledFunc();
    orderController.sendingRequestsFunc();
    orderController.getOrderStatus();
    super.initState();
  }

  var initialLabelIndex = 0;
  final list = [
    'Completed',
    'Pending',
    'On the way',
    'Cancelled',
  ];
  RxDouble rating = 0.0.obs;
  double? pickLat;
  double? pickLng;
  double? dropLat;
  double? dropLng;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    const double appBarHeight = 174;

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("My Delivery Request"),
      // ),
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            collapsedHeight: appBarHeight,
            expandedHeight: appBarHeight,
            systemOverlayStyle:
                const SystemUiOverlayStyle(statusBarColor: redColor),
            flexibleSpace: Container(
              color: Colors.white,
              child: Stack(
                children: [
                  // SizedBox(height: widget.height, width: media.size.width),
                  const Positioned(
                    left: -21,
                    top: -74,
                    child: CircleAvatar(
                      radius: 120,
                      backgroundColor: redColor,
                    ),
                  ),
                  Positioned(
                    left: -31,
                    top: -113,
                    child: CircleAvatar(
                      radius: 105,
                      backgroundColor: Colors.white.withOpacity(0.06),
                    ),
                  ),
                  Positioned(
                    left: -33,
                    top: -156,
                    child: CircleAvatar(
                      radius: 105,
                      backgroundColor: Colors.white.withOpacity(0.06),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // SizedBox(height: 60 - statusbarPadding),
                            _buildappBarButton(context),
                            Row(
                              children: [
                                Flexible(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      boxShadow: [
                                        BoxShadow(
                                            color: const Color(0xff333333)
                                                .withOpacity(.18),
                                            blurRadius: 70),
                                      ],
                                    ),
                                    child: TextFormField(
                                      //  controller:authController. ,
                                      onChanged: (val) {
                                        productController.searchProduct.value =
                                            val;
                                        setState(() {});
                                        //return null;
                                      },
                                      decoration: inputDecorationTheme.copyWith(
                                        prefixIcon: const Icon(
                                            Icons.search_rounded,
                                            color: grayColor,
                                            size: 26),
                                        hintText: 'Search your products',
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  decoration: BoxDecoration(
                                      color: redColor,
                                      borderRadius: BorderRadius.circular(4)),
                                  margin: const EdgeInsets.only(right: 8),
                                  height: 52,
                                  width: 44,
                                  child: const Center(
                                    child: CustomImage(
                                      path: Kimages.menuIcon,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: Obx(
            () => requestController.allRequests == null
                ? Column(
                    children: [
                      Image.asset('assets/images/empty_order.png'),
                      const SizedBox(
                        height: 20,
                      ),
                      Text('Data Not found')
                    ],
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: Get.height * 0.05,
                      ),
                      SizedBox(
                        height: size.height * 0.7,
                        // color: Colors.red,
                        child: GetX<RequestController>(
                            init: Get.put(RequestController()),
                            builder: (RequestController rqstController) {
                              // ignore: unnecessary_null_comparison
                              if (rqstController != null &&
                                  rqstController.allRequests != null) {
                                return ListView.builder(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 5, 10, 100),
                                    itemCount:
                                        rqstController.allRequests!.length,
                                    itemBuilder: ((context, index) {
                                      var request =
                                          rqstController.allRequests![index];

                                      // rqstController.getDetailRider(request.id!);

                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.black12)),
                                          // height: size.height * 0.2,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text("Order Status",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Container(
                                                      height: 25,
                                                      decoration: BoxDecoration(
                                                          color: Colors.grey,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4)),
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 12),
                                                      child: Center(
                                                        child: Text(
                                                            request.status == ""
                                                                ? "Sent"
                                                                : request
                                                                    .status!,
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Align(
                                                  alignment: Alignment.topLeft,
                                                  child: SizedBox(
                                                      height: Get.height * 0.1,
                                                      width: Get.width * 0.2,
                                                      child:
                                                          request.request_image !=
                                                                  ""
                                                              ? ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  child: Image
                                                                      .network(
                                                                    request
                                                                        .request_image!,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                )
                                                              : ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  child: Image
                                                                      .asset(
                                                                    'assets/icons/delivery.png',
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                )),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const Text("Title  ",
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal)),
                                                    Expanded(
                                                        child: Text(
                                                            request.title!,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))),
                                                    // Row(
                                                    //   children: [
                                                    //     const Text('Offer Price: ',
                                                    //         style: TextStyle(
                                                    //           color: Colors.grey,
                                                    //         )),
                                                    //     Text(
                                                    //       rqstController.getRequestModel
                                                    //           .value![index].offerPrice!,
                                                    //       style: const TextStyle(
                                                    //           color: Colors.black,
                                                    //           fontWeight: FontWeight.bold),
                                                    //     )
                                                    //   ],
                                                    // ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const Text("Delivery fee  ",
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal)),
                                                    Expanded(
                                                        child: Text(
                                                            request.deliveryfee
                                                                .toString(),
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)))
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const Text("Pick Address  ",
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal)),
                                                    Expanded(
                                                        child: Text(
                                                            request.pickAddress
                                                                .toString(),
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)))
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const Text("Drop Address  ",
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal)),
                                                    Expanded(
                                                        child: Text(
                                                            request.dropAddress
                                                                .toString(),
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)))
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                request.status == ''
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                              "Received offers   ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal)),
                                                          Text(
                                                              request
                                                                  .noOfRequest
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          const Spacer(),
                                                          TextButton(
                                                              onPressed:
                                                                  () async {
                                                                if (request
                                                                        .noOfRequest ==
                                                                    0) {
                                                                  Get.snackbar(
                                                                      "No offer recieved",
                                                                      "NO offer recieved yet");
                                                                } else {
                                                                  await rqstController
                                                                      .getOffersDetails(
                                                                          request
                                                                              .id!)
                                                                      .then(
                                                                          (value) {
                                                                    Get.bottomSheet(
                                                                      Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                            vertical: Get.height *
                                                                                0.02,
                                                                            horizontal:
                                                                                Get.width * 0.02),
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              Get.height * 0.5,
                                                                          width:
                                                                              Get.width * 0.9,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius:
                                                                                BorderRadius.circular(15),
                                                                          ),
                                                                          child: GetX<RequestController>(
                                                                              init: Get.put<RequestController>(RequestController()),
                                                                              builder: (RequestController rqtController) {
                                                                                return ListView.builder(
                                                                                  itemCount: rqtController.getRequest.length,
                                                                                  itemBuilder: (context, index) {
                                                                                    var received = rqtController.getRequest[index];
                                                                                    return Card(
                                                                                      elevation: 3,
                                                                                      child: Padding(
                                                                                        padding: EdgeInsets.symmetric(vertical: Get.height * 0.02, horizontal: Get.width * 0.02),
                                                                                        child: Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Row(
                                                                                              children: [
                                                                                                CircleAvatar(
                                                                                                  radius: 25,
                                                                                                  backgroundImage: NetworkImage(received.image!),
                                                                                                ),
                                                                                                const SizedBox(
                                                                                                  width: 10,
                                                                                                ),
                                                                                                Column(
                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                  children: [
                                                                                                    Text(received.name!, style: const TextStyle(color: Colors.black)),
                                                                                                    // Text(received.email!, style: const TextStyle(color: Colors.black)),
                                                                                                  ],
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                            const SizedBox(
                                                                                              height: 10,
                                                                                            ),
                                                                                            Row(
                                                                                              children: [
                                                                                                const Text(
                                                                                                  'Offer price:',
                                                                                                  style: TextStyle(color: Colors.grey, fontSize: 16),
                                                                                                ),
                                                                                                Text(
                                                                                                  received.offerPrice!,
                                                                                                  style: const TextStyle(
                                                                                                    color: Colors.red,
                                                                                                    fontWeight: FontWeight.bold,
                                                                                                    fontSize: 16,
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                            const SizedBox(
                                                                                              height: 10,
                                                                                            ),
                                                                                            Row(
                                                                                              children: [
                                                                                                const Text(
                                                                                                  'Offer Description:',
                                                                                                  style: TextStyle(color: Colors.grey, fontSize: 16),
                                                                                                ),
                                                                                                Flexible(
                                                                                                  child: Text(
                                                                                                    received.offerDiscription!,
                                                                                                    style: const TextStyle(
                                                                                                      color: Colors.black,
                                                                                                      fontWeight: FontWeight.bold,
                                                                                                      fontSize: 16,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                            const SizedBox(
                                                                                              height: 10,
                                                                                            ),
                                                                                            Align(
                                                                                              alignment: Alignment.topRight,
                                                                                              child: GestureDetector(
                                                                                                  onTap: () async {
                                                                                                    await rqtController.getRating(received.delivery_boy_id);

                                                                                                    Get.to(() => MoreInfoRiderPage(
                                                                                                          getData: received,
                                                                                                        ));
                                                                                                  },
                                                                                                  child: const Text("More Info", style: TextStyle(decoration: TextDecoration.underline))),
                                                                                            ),
                                                                                            const SizedBox(
                                                                                              height: 10,
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: const EdgeInsets.all(8.0),
                                                                                              child: Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                children: [
                                                                                                  Flexible(
                                                                                                      child: SizedBox(
                                                                                                    height: 40,
                                                                                                    child: PrimaryButton(
                                                                                                        grediantColor: const [Colors.green, Colors.green],
                                                                                                        text: 'Accept',
                                                                                                        onPressed: () async {
                                                                                                          await rqstController.onTheWayRequest(request.id!, received.delivery_boy_id!);
                                                                                                          Get.back();
                                                                                                          // debugPrint(
                                                                                                          //     "offer id is here ${rqstController.getRequest[0].delivery_boy_id}");
                                                                                                          // await rqstController.getDetailRider(request.id!).then((value) async {
                                                                                                          //   setState(() {});

                                                                                                          //   Get.back();
                                                                                                          // });

                                                                                                          // print(
                                                                                                          //     'offer id is:${requestController.getRequest![index].id!}');
                                                                                                        }),
                                                                                                  )),
                                                                                                  const SizedBox(
                                                                                                    width: 10,
                                                                                                  ),
                                                                                                  Flexible(
                                                                                                      child: SizedBox(
                                                                                                    height: 40,
                                                                                                    child: PrimaryButton(
                                                                                                        text: 'Cancel',
                                                                                                        onPressed: () async {
                                                                                                          requestController.cancelRequest(request.id!, received.delivery_boy_id!);
                                                                                                          // await rqstController.getDetailRider(request.id!).then((value) {

                                                                                                          // });

                                                                                                          print("Document id:${request.id}");
                                                                                                          print("Delivery id:${requestController.getRequest[index].delivery_boy_id!}");
                                                                                                          Get.back();
                                                                                                        }),
                                                                                                  )),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                );
                                                                              }),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  });
                                                                }
                                                              },
                                                              child: const Text(
                                                                  "View Offers",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red)))
                                                        ],
                                                      )
                                                    : const SizedBox(),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                request.status == "On the way"
                                                    ? Row(
                                                        children: [
                                                          Flexible(
                                                              child: SizedBox(
                                                            height: 40,
                                                            child:
                                                                PrimaryButton(
                                                                    grediantColor: const [
                                                                  blackColor,
                                                                  blackColor
                                                                ],
                                                                    text:
                                                                        'Details',
                                                                    onPressed:
                                                                        () async {
                                                                      // print(
                                                                      //     "New ID IS${rqstController.getRequestModel.value![0].offerPrice}");
                                                                      print(
                                                                          "Same or not customer id: ${request.id}");
                                                                      await rqstController
                                                                          .getRating(
                                                                              request.delivery_boy_id);
                                                                      await orderController
                                                                          .getRiderDetails(orderController
                                                                              .orderStatus![index]
                                                                              .delivery_boy_id!)
                                                                          // await rqstController
                                                                          //     .getDetailRider(request
                                                                          //         .delivery_boy_id!)
                                                                          .then((value) {
                                                                        Get.bottomSheet(
                                                                            Padding(
                                                                          padding: const EdgeInsets.symmetric(
                                                                              horizontal: 8.0,
                                                                              vertical: 20),
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                Get.height * 0.3,
                                                                            width:
                                                                                Get.width,
                                                                            decoration:
                                                                                BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Column(
                                                                                children: [
                                                                                  Row(
                                                                                    children: [
                                                                                      const Text('Name: ',
                                                                                          style: TextStyle(
                                                                                            color: Colors.grey,
                                                                                          )),
                                                                                      Text(rqstController.customerModel.value!.rider_name!, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                      const Spacer(),
                                                                                      Obx(
                                                                                        () => Row(
                                                                                          children: [
                                                                                            const Icon(
                                                                                              Icons.star,
                                                                                              color: redColor,
                                                                                              size: 20,
                                                                                            ),
                                                                                            Text(
                                                                                              ((rqstController.ratingValue.value) / rqstController.rating!.length).toStringAsFixed(1),
                                                                                              style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    height: 10,
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      const Text('Email: ',
                                                                                          style: TextStyle(
                                                                                            color: Colors.grey,
                                                                                          )),
                                                                                      Text(rqstController.customerModel.value!.rider_email!, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
                                                                                    ],
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    height: 10,
                                                                                  ),
                                                                                  Row(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      const Text('Address: ',
                                                                                          style: TextStyle(
                                                                                            color: Colors.grey,
                                                                                          )),
                                                                                      Expanded(
                                                                                        child: Text(rqstController.customerModel.value!.rider_address!, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    height: 10,
                                                                                  ),

                                                                                  // Row(
                                                                                  //   children: [
                                                                                  //     const Text(
                                                                                  //         'Offer Description: ',
                                                                                  //         style: TextStyle(
                                                                                  //           color: Colors.grey,
                                                                                  //         )),
                                                                                  //     Text(
                                                                                  //         rqstController.getRequestModel.value![0].offerDiscription!,
                                                                                  //         style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
                                                                                  //   ],
                                                                                  // ),
                                                                                  const SizedBox(
                                                                                    height: 10,
                                                                                  ),
                                                                                  // Row(
                                                                                  //   children: [
                                                                                  //     const Text(
                                                                                  //         'Offer Price: ',
                                                                                  //         style: TextStyle(
                                                                                  //           color: Colors.grey,
                                                                                  //         )),
                                                                                  //     Text(
                                                                                  //         rqstController.getRequestModel.value![0].offerPrice!,
                                                                                  //         style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
                                                                                  //   ],
                                                                                  // ),

                                                                                  // Row(
                                                                                  //   children: [
                                                                                  //     const Text(
                                                                                  //         'Offer Price: ',
                                                                                  //         style: TextStyle(
                                                                                  //           color: Colors.grey,
                                                                                  //         )),
                                                                                  //     Text(
                                                                                  //         rqstController.getRequestModel.value == null ? "..." : rqstController.getRequestModel.value![0].offerPrice!,
                                                                                  //         style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
                                                                                  //   ],
                                                                                  // ),
                                                                                  const SizedBox(
                                                                                    height: 10,
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      const Text('Phone: ',
                                                                                          style: TextStyle(
                                                                                            color: Colors.grey,
                                                                                          )),
                                                                                      Text(rqstController.customerModel.value!.rider_phone!.isEmpty ? 'No Contact provided' : rqstController.customerModel.value!.rider_phone!, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
                                                                                    ],
                                                                                  ),

                                                                                  const SizedBox(
                                                                                    height: 10,
                                                                                  ),
                                                                                  // PrimaryButton(
                                                                                  //     text:
                                                                                  //         'More Info',
                                                                                  //     onPressed:
                                                                                  //         () {
                                                                                  //       Get.to(MoreInfoRiderPage(getData: requestController.getRequest[index]));
                                                                                  //     }),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ));

                                                                        // print(
                                                                        //     "tap done : ${rqstController.getRequestModel.value![0].delivery_boy_id}");
                                                                      });
                                                                    }),
                                                          )),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Flexible(
                                                              child: SizedBox(
                                                            height: 40,
                                                            child:
                                                                PrimaryButton(
                                                                    text:
                                                                        'Distance',
                                                                    onPressed:
                                                                        () async {
                                                                      orderController
                                                                          .getOrderStatus();
                                                                      await orderController.getRiderDetails(orderController
                                                                          .orderStatus![
                                                                              index]
                                                                          .delivery_boy_id!);
                                                                      await orderController
                                                                          .getOffersDetails(orderController
                                                                              .orderStatus![index]
                                                                              .delivery_boy_id!)
                                                                          .then(
                                                                        (value) {
                                                                          requestController
                                                                              .distance(
                                                                            pickLat:
                                                                                orderController.orderStatus![index].pickupLocation!.latitude,
                                                                            pickLng:
                                                                                orderController.orderStatus![index].pickupLocation!.longitude,
                                                                            dropLat:
                                                                                orderController.orderStatus![index].dropLocation!.latitude,
                                                                            dropLng:
                                                                                orderController.orderStatus![index].dropLocation!.longitude,
                                                                          );
                                                                          print(
                                                                              'customer id is: ${request.customer_id}');
                                                                          print(
                                                                              "Value is: ${orderController.orderStatus![index].pickupLocation!.longitude}");
                                                                          // print("object:${orderController.orderStatus![index].pickupLocation!.latitude}");
                                                                          // print("object1:${orderController.orderStatus![index].pickupLocation!.longitude}");
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                  builder: (_) => MapScreen(
                                                                                        pickLat: orderController.orderStatus![index].pickupLocation!.latitude,
                                                                                        pickLng: orderController.orderStatus![index].pickupLocation!.longitude,
                                                                                        dropLat: orderController.orderStatus![index].dropLocation!.latitude,
                                                                                        dropLng: orderController.orderStatus![index].dropLocation!.longitude,
                                                                                        modelData: orderController.customerModel.value!,
                                                                                        rating: orderController.ratingValue.value,
                                                                                      )));
                                                                        },
                                                                      );
                                                                    }),
                                                          )),
                                                        ],
                                                      )
                                                    : const SizedBox(),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                //here is accept delivery
                                                request.isCompleted!
                                                    ? request.status ==
                                                            'On the way'
                                                        ? Row(
                                                            children: [
                                                              Flexible(
                                                                child: SizedBox(
                                                                  height: 40,
                                                                  child:
                                                                      PrimaryButton(
                                                                    grediantColor: const [
                                                                      blackColor,
                                                                      blackColor
                                                                    ],
                                                                    text:
                                                                        'Accept Delivery',
                                                                    onPressed:
                                                                        () async {
                                                                      await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              "DeliveryBoyTokens")
                                                                          .doc(orderController
                                                                              .orderStatus![index]
                                                                              .delivery_boy_id)
                                                                          .get()
                                                                          .then((value) {
                                                                        Get.find<PushNotificationsController>().sendPushMessage(
                                                                            value.get("Token"),
                                                                            "Congratulations! your order is verified by ${orderController.orderStatus![index].customer_name}, you earned \$${orderController.orderStatus![index].price}",
                                                                            "Order Verified");
                                                                      }).then((value) async {
                                                                        await FirebaseFirestore
                                                                            .instance
                                                                            .collection("delivery_boy")
                                                                            .doc(orderController.orderStatus![index].delivery_boy_id)
                                                                            .collection("Notifications")
                                                                            .add({
                                                                          "Title":
                                                                              "Order Verified",
                                                                          "Seen":
                                                                              false,
                                                                          "Body":
                                                                              "Congratulations! your order is verified by ${orderController.orderStatus![index].customer_name}, you earned \$${orderController.orderStatus![index].price}",
                                                                          "Date":
                                                                              DateTime.now().toString()
                                                                        });
                                                                      });
                                                                      orderController
                                                                          .completeDelivery(
                                                                              request.id!);
                                                                      Get.back();
                                                                      final _ratingDialog =
                                                                          RatingDialog(
                                                                        starColor:
                                                                            redColor,
                                                                        // ratingColor: Colors.amber,
                                                                        title: const Text(
                                                                            'Feedback to rider'),

                                                                        // onCancelled: () {},
                                                                        onSubmitted:
                                                                            (response) async {
                                                                          print(
                                                                              'rating: ${response.rating}, '
                                                                              'comment: ${response.comment}');
                                                                          await orderController.getRiderDetails(orderController
                                                                              .orderStatus![index]
                                                                              .delivery_boy_id!);
                                                                          orderController
                                                                              .giveRatingToRider(
                                                                            orderController.customerModel.value!.id!,
                                                                            response.rating,
                                                                            response.comment,
                                                                            orderController.customerModel.value!.profileImage!,
                                                                            customerController.customerModel.value!.profileImage!,
                                                                            customerController.customerModel.value!.name!,
                                                                          )
                                                                              .then((value) async {
                                                                            //PUSH NOTIFICATION
                                                                            await FirebaseFirestore.instance.collection("DeliveryBoyTokens").doc(orderController.orderStatus![index].delivery_boy_id).get().then((value) {
                                                                              Get.find<PushNotificationsController>().sendPushMessage(value.get("Token"), "${orderController.orderStatus![index].customer_name} left a review", "Review Recieved");
                                                                            }).then((value) async {
                                                                              await FirebaseFirestore.instance.collection("delivery_boy").doc(orderController.orderStatus![index].delivery_boy_id).collection("Notifications").add({
                                                                                "Title": "Review Recieved",
                                                                                "Body": "${orderController.orderStatus![index].customer_name} left a review",
                                                                                "Seen": false,
                                                                                "Date": DateTime.now().toString()
                                                                              });
                                                                            });
                                                                          });

                                                                          // if (response.rating < 3.0) {
                                                                          //   print('response.rating: ${response.rating}');
                                                                          // } else {
                                                                          //   Container();
                                                                          // }
                                                                        },
                                                                        submitButtonText:
                                                                            'Submit',
                                                                      );
                                                                      showDialog(
                                                                        context:
                                                                            context,
                                                                        barrierDismissible:
                                                                            false,
                                                                        builder:
                                                                            (context) =>
                                                                                _ratingDialog,
                                                                      );
                                                                      await rqstController
                                                                          .getOffersDetails(request
                                                                              .id!)
                                                                          .then(
                                                                              (value) {
                                                                        requestController
                                                                            .completeDelivery(
                                                                          request
                                                                              .id!,
                                                                        );
                                                                      });
                                                                      await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              "DeliveryBoyTokens")
                                                                          .doc(orderController
                                                                              .orderStatus![index]
                                                                              .delivery_boy_id)
                                                                          .get()
                                                                          .then((value) {
                                                                        Get.find<PushNotificationsController>().sendPushMessage(
                                                                            value.get("Token"),
                                                                            "Congratulations! your order is verified by ${orderController.orderStatus![index].customer_name}, you earned \$${orderController.orderStatus![index].price}",
                                                                            "Order Verified");
                                                                      }).then((value) async {
                                                                        await FirebaseFirestore
                                                                            .instance
                                                                            .collection("delivery_boy")
                                                                            .doc(orderController.orderStatus![index].delivery_boy_id)
                                                                            .collection("Notifications")
                                                                            .add({
                                                                          "Title":
                                                                              "Order Verified",
                                                                          "Seen":
                                                                              false,
                                                                          "Body":
                                                                              "Congratulations! your order is verified by ${orderController.orderStatus![index].customer_name}, you earned \$${orderController.orderStatus![index].price}",
                                                                          "Date":
                                                                              DateTime.now().toString()
                                                                        });
                                                                      });
                                                                      // print(
                                                                      //     'offer id is:${requestController.getRequest[index].id!}');
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Flexible(
                                                                child: SizedBox(
                                                                  height: 40,
                                                                  child:
                                                                      PrimaryButton(
                                                                    grediantColor: const [
                                                                      Colors
                                                                          .red,
                                                                      Colors.red
                                                                    ],
                                                                    text:
                                                                        'Decline Delivery',
                                                                    onPressed:
                                                                        () async {
                                                                      await rqstController
                                                                          .getOffersDetails(request
                                                                              .id!)
                                                                          .then(
                                                                              (value) {
                                                                        requestController.cancelRequest(
                                                                            request.id!,
                                                                            rqstController.getRequest[0].delivery_boy_id!);
                                                                      });
                                                                    },
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          )
                                                        : const SizedBox()
                                                    : const SizedBox(),

                                                //ending
                                                request.status == "Pending"
                                                    ? PrimaryButton(
                                                        text: "Offer Details",
                                                        grediantColor: const [
                                                          blackColor,
                                                          blackColor,
                                                        ],
                                                        onPressed: () async {
                                                          await orderController
                                                              .getOffersDetails(
                                                                  request.id!)
                                                              .then((value) {
                                                            Get.bottomSheet(
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child:
                                                                    Container(
                                                                  height:
                                                                      Get.height *
                                                                          0.2,
                                                                  width:
                                                                      Get.width *
                                                                          0.9,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              12)),
                                                                  child: Column(
                                                                    children: [
                                                                      Obx(() => rqstController.getRequest !=
                                                                              null
                                                                          ? Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Row(
                                                                                children: [
                                                                                  const Text('Offer Desription: '),
                                                                                  Obx(() => rqstController.getRequest == null ? const Text('Pending') : Text(rqstController.getRequest == null ? "..." : rqstController.getRequest[0].offerDiscription!, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                                                                                ],
                                                                              ),
                                                                            )
                                                                          : const SizedBox()),
                                                                      Obx(() => rqstController.getRequest !=
                                                                              null
                                                                          ? Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Row(
                                                                                children: [
                                                                                  const Text('Offer Price: '),
                                                                                  Obx(() => rqstController.getRequest == null ? const Text('Pending') : Text(rqstController.getRequest == null ? "..." : rqstController.getRequest[0].offerPrice!, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                                                                                ],
                                                                              ),
                                                                            )
                                                                          : const SizedBox()),
                                                                      const Spacer(),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          });
                                                        })
                                                    : const SizedBox(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }));
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            }),
                      )
                      // Container(
                      //   height: 36,
                      //   //s  width: 120,
                      //   margin: const EdgeInsets.symmetric(horizontal: 20),
                      //   decoration: BoxDecoration(
                      //     border: Border.all(color: borderColor),
                      //     borderRadius: BorderRadius.circular(2),
                      //   ),
                      //   child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.stretch,
                      //     children: [
                      //       _buildSingleBtn(0, list[0]),
                      //       _buildSingleBtn(1, list[1]), //nope
                      //       _buildSingleBtn(2, list[2]),
                      //       _buildSingleBtn(3, list[3])
                      //     ],
                      //   ),
                      // ),

                      // initialLabelIndex == 1
                      //     ? SizedBox(
                      //         width: double.infinity,
                      //         child: GetX<RequestController>(
                      //           init: RequestController(),
                      //           builder: (controller) {
                      //             if (controller.sending == null ||
                      //                 controller.sending!.isEmpty) {
                      //               return Container(
                      //                 // height: size.height * 0.1,
                      //                 width: size.width * 1,
                      //                 // color: Colors.red,
                      //                 child: SingleChildScrollView(
                      //                   child: Column(
                      //                     children: [
                      //                       SizedBox(
                      //                           height: size.height / 1.5,
                      //                           width: size.width,
                      //                           child: GetX<RequestController>(
                      //                               builder: (RequestController
                      //                                   orderController) {
                      //                             if (orderController.orderStatus ==
                      //                                     null ||
                      //                                 orderController
                      //                                     .orderStatus!.isEmpty) {
                      //                               return SizedBox(
                      //                                 height: size.height * 0.2,
                      //                                 width: size.width * 1,
                      //                                 child: Column(
                      //                                   children: [
                      //                                     SizedBox(
                      //                                       height:
                      //                                           size.height * 0.15,
                      //                                     ),
                      //                                     Image.asset(
                      //                                       "assets/images/no_data.png",
                      //                                       height: size.height * 0.2,
                      //                                     ),
                      //                                     SizedBox(
                      //                                       height:
                      //                                           size.height * 0.03,
                      //                                     ),
                      //                                     Text("No Order Found",
                      //                                         style: Theme.of(context)
                      //                                             .textTheme
                      //                                             .subtitle1!
                      //                                             .copyWith(
                      //                                                 color: Colors
                      //                                                     .black,
                      //                                                 fontWeight:
                      //                                                     FontWeight
                      //                                                         .w600)),
                      //                                   ],
                      //                                 ),
                      //                               );
                      //                             } else {
                      //                               return ListView.builder(
                      //                                   physics:
                      //                                       const NeverScrollableScrollPhysics(),
                      //                                   padding:
                      //                                       const EdgeInsets.only(
                      //                                           bottom: 55),
                      //                                   shrinkWrap: true,
                      //                                   itemCount: orderController
                      //                                       .orderStatus!.length,
                      //                                   itemBuilder:
                      //                                       (context, index) {
                      //                                     var orderStatus =
                      //                                         orderController
                      //                                                 .orderStatus![
                      //                                             index];

                      //                                     return Padding(
                      //                                       padding:
                      //                                           const EdgeInsets.all(
                      //                                               8.0),
                      //                                       child: Container(
                      //                                         margin: const EdgeInsets
                      //                                                 .symmetric(
                      //                                             vertical: 10),
                      //                                         padding:
                      //                                             const EdgeInsets
                      //                                                 .all(12),
                      //                                         // height: 200,
                      //                                         decoration:
                      //                                             BoxDecoration(
                      //                                           borderRadius:
                      //                                               BorderRadius
                      //                                                   .circular(6),
                      //                                           border: Border.all(
                      //                                               color:
                      //                                                   borderColor),
                      //                                         ),
                      //                                         child: Column(
                      //                                           crossAxisAlignment:
                      //                                               CrossAxisAlignment
                      //                                                   .start,
                      //                                           children: [
                      //                                             //_buildProductHeader(),
                      //                                             Row(
                      //                                               mainAxisAlignment:
                      //                                                   MainAxisAlignment
                      //                                                       .spaceBetween,
                      //                                               children: [
                      //                                                 Column(
                      //                                                   crossAxisAlignment:
                      //                                                       CrossAxisAlignment
                      //                                                           .start,
                      //                                                   children: const [
                      //                                                     Text(
                      //                                                       'Order Date',
                      //                                                       style: TextStyle(
                      //                                                           height:
                      //                                                               1,
                      //                                                           color:
                      //                                                               redColor),
                      //                                                     ),

                      //                                                     SizedBox(
                      //                                                         height:
                      //                                                             8),
                      //                                                     // InVoiceWidget(text: orderStatus.invoice),
                      //                                                   ],
                      //                                                 ),
                      //                                                 Column(
                      //                                                   crossAxisAlignment:
                      //                                                       CrossAxisAlignment
                      //                                                           .end,
                      //                                                   children: [
                      //                                                     Text(
                      //                                                       Utils.formatDate(orderStatus
                      //                                                           .time!
                      //                                                           .toDate()),
                      //                                                       style: const TextStyle(
                      //                                                           height:
                      //                                                               1,
                      //                                                           color:
                      //                                                               paragraphColor),
                      //                                                     ),
                      //                                                     const SizedBox(
                      //                                                         height:
                      //                                                             1),
                      //                                                   ],
                      //                                                 ),
                      //                                               ],
                      //                                             ),
                      //                                             const SizedBox(
                      //                                                 height: 8),
                      //                                             Row(
                      //                                               mainAxisAlignment:
                      //                                                   MainAxisAlignment
                      //                                                       .spaceBetween,
                      //                                               children: [
                      //                                                 Column(
                      //                                                   crossAxisAlignment:
                      //                                                       CrossAxisAlignment
                      //                                                           .start,
                      //                                                   children: [
                      //                                                     // Row(
                      //                                                     //   children: [
                      //                                                     //     Text(
                      //                                                     //       "Customer Name: "
                      //                                                     //           .toUpperCase(),
                      //                                                     //       style: const TextStyle(
                      //                                                     //           height: 1,
                      //                                                     //           color: paragraphColor),
                      //                                                     //     ),
                      //                                                     //     Text(
                      //                                                     //       orderStatus.customer_name!
                      //                                                     //           .toUpperCase(),
                      //                                                     //       style: const TextStyle(
                      //                                                     //           height: 1,
                      //                                                     //           color: paragraphColor),
                      //                                                     //     ),
                      //                                                     //   ],
                      //                                                     // ),
                      //                                                     const SizedBox(
                      //                                                         height:
                      //                                                             10),
                      //                                                     SizedBox(
                      //                                                       width: Get
                      //                                                               .width *
                      //                                                           0.6,
                      //                                                       child:
                      //                                                           Row(
                      //                                                         crossAxisAlignment:
                      //                                                             CrossAxisAlignment.start,
                      //                                                         children: [
                      //                                                           Text(
                      //                                                             "Title: ",
                      //                                                             style: GoogleFonts.roboto(
                      //                                                                 fontWeight: FontWeight.bold,
                      //                                                                 fontSize: 16,
                      //                                                                 height: 1,
                      //                                                                 color: Colors.grey),
                      //                                                           ),
                      //                                                           Flexible(
                      //                                                             child:
                      //                                                                 Text(
                      //                                                               orderStatus.title.toString(),
                      //                                                               style: GoogleFonts.roboto(fontWeight: FontWeight.w500, fontSize: 18, height: 1, color: redColor),
                      //                                                             ),
                      //                                                           ),
                      //                                                         ],
                      //                                                       ),
                      //                                                     ),
                      //                                                     const SizedBox(
                      //                                                         height:
                      //                                                             10),
                      //                                                     SizedBox(
                      //                                                       width: Get
                      //                                                               .width *
                      //                                                           0.7,
                      //                                                       child:
                      //                                                           Row(
                      //                                                         crossAxisAlignment:
                      //                                                             CrossAxisAlignment.start,
                      //                                                         children: [
                      //                                                           Text(
                      //                                                             "Description: ",
                      //                                                             style: GoogleFonts.roboto(
                      //                                                                 fontWeight: FontWeight.w500,
                      //                                                                 fontSize: 14,
                      //                                                                 height: 1,
                      //                                                                 color: Colors.grey),
                      //                                                           ),
                      //                                                           Flexible(
                      //                                                             child:
                      //                                                                 Text(
                      //                                                               orderStatus.description.toString(),
                      //                                                               style: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 16, height: 1, color: redColor),
                      //                                                             ),
                      //                                                           ),
                      //                                                         ],
                      //                                                       ),
                      //                                                     ),
                      //                                                     const SizedBox(
                      //                                                         height:
                      //                                                             10),
                      //                                                     SizedBox(
                      //                                                       width: Get
                      //                                                               .width *
                      //                                                           0.6,
                      //                                                       child:
                      //                                                           Row(
                      //                                                         children: [
                      //                                                           Text(
                      //                                                             "Price: ",
                      //                                                             style: GoogleFonts.roboto(
                      //                                                                 fontWeight: FontWeight.bold,
                      //                                                                 fontSize: 14,
                      //                                                                 height: 1,
                      //                                                                 color: Colors.grey),
                      //                                                           ),
                      //                                                           // Text(
                      //                                                           //   requestController
                      //                                                           //       .getRequest![index]
                      //                                                           //       .offerPrice
                      //                                                           //       .toString(),
                      //                                                           // ),
                      //                                                           Text(
                      //                                                             "\$ ${orderStatus.price.toString()}",
                      //                                                             style: GoogleFonts.roboto(
                      //                                                                 fontWeight: FontWeight.bold,
                      //                                                                 fontSize: 16,
                      //                                                                 height: 1,
                      //                                                                 color: redColor),
                      //                                                           ),
                      //                                                           // const Spacer(),
                      //                                                         ],
                      //                                                       ),
                      //                                                     ),
                      //                                                   ],
                      //                                                 ),
                      //                                                 orderStatus.request_image !=
                      //                                                         ""
                      //                                                     ? CircleAvatar(
                      //                                                         radius:
                      //                                                             20,
                      //                                                         backgroundImage:
                      //                                                             NetworkImage(orderStatus.customer_image!),
                      //                                                       )
                      //                                                     : const CircleAvatar(
                      //                                                         radius:
                      //                                                             20,
                      //                                                         backgroundImage:
                      //                                                             NetworkImage("https://cdn.techjuice.pk/wp-content/uploads/2015/02/wallpaper-for-facebook-profile-photo-1024x645.jpg"),
                      //                                                       ),
                      //                                                 const SizedBox(
                      //                                                     height: 1),
                      //                                               ],
                      //                                             ),
                      //                                             const SizedBox(
                      //                                               height: 8,
                      //                                             ),
                      //                                             Row(children: [
                      //                                               orderStatus.isCompleted ==
                      //                                                       true
                      //                                                   ? const Icon(
                      //                                                       Icons
                      //                                                           .timelapse_rounded,
                      //                                                       color: Colors
                      //                                                           .yellow,
                      //                                                     )
                      //                                                   : const SizedBox(),
                      //                                               orderStatus.isCompleted ==
                      //                                                       true
                      //                                                   ? const Text(
                      //                                                       "Request for Complete")
                      //                                                   : const SizedBox()
                      //                                             ]),
                      //                                             // Row(
                      //                                             //   mainAxisAlignment:
                      //                                             //       MainAxisAlignment.spaceBetween,
                      //                                             //   children: [
                      //                                             //     const Text(
                      //                                             //       'Customer Address',
                      //                                             //       style: TextStyle(
                      //                                             //           height: 1, color: redColor),
                      //                                             //     ),
                      //                                             //     Text(
                      //                                             //       orderStatus.customer_address!,
                      //                                             //       style: const TextStyle(
                      //                                             //           height: 1,
                      //                                             //           color: Colors.black,
                      //                                             //           fontWeight: FontWeight.bold),
                      //                                             //     ),
                      //                                             //   ],
                      //                                             // ),
                      //                                             const SizedBox(
                      //                                                 height: 14),
                      //                                             // PrimaryButton(
                      //                                             //   minimumSize:
                      //                                             //       const Size(double.infinity, 40),
                      //                                             //   fontSize: 16,
                      //                                             //   grediantColor: const [
                      //                                             //     blackColor,
                      //                                             //     blackColor
                      //                                             //   ],
                      //                                             //   text: 'View Details',
                      //                                             //   onPressed: () async {
                      //                                             //     // orderController
                      //                                             //     //     .getre(orderStatus.id!);
                      //                                             //     // //Get.log("lenght is here  : ${orderController.customerProducts!.length}");
                      //                                             //     // // Navigator.pushNamed(context, RouteNames.orderDetailsPage,
                      //                                             //     // //     arguments: );
                      //                                             //     // Get.to(() => OrderDetailsPage(
                      //                                             //     //       customerModel: orderStatus,
                      //                                             //     //     ));
                      //                                             //   },
                      //                                             // ),

                      //                                             PrimaryButton(
                      //                                                 text:
                      //                                                     "View Detail",
                      //                                                 onPressed:
                      //                                                     () async {
                      //                                                   print(
                      //                                                       "id is here ${orderStatus.delivery_boy_id}");
                      //                                                   await orderController
                      //                                                       .getRiderDetails(
                      //                                                           orderStatus
                      //                                                               .delivery_boy_id!);
                      //                                                   await orderController
                      //                                                       .getRating(
                      //                                                           orderStatus
                      //                                                               .delivery_boy_id!)
                      //                                                       .then(
                      //                                                           (value) {});

                      //                                                   print(
                      //                                                       "now get id${(orderStatus.delivery_boy_id!)}");
                      // Get.bottomSheet(
                      //   Padding(
                      //     padding: EdgeInsets.symmetric(
                      //         horizontal:
                      //             8.0,
                      //         vertical:
                      //             Get.height * 0.05),
                      //     child:
                      //         Container(
                      //       // padding:
                      //       //     EdgeInsets.all(16),
                      //       height: Get.height *
                      //           0.4,
                      //       decoration: BoxDecoration(
                      //           color:
                      //               Colors.white,
                      //           borderRadius: BorderRadius.circular(12)),
                      //       child:
                      //           Padding(
                      //         padding:
                      //             const EdgeInsets.all(8.0),
                      //         child:
                      //             Column(
                      //           crossAxisAlignment:
                      //               CrossAxisAlignment.start,
                      //           children: [
                      //             Row(
                      //               children: [
                      //                 CircleAvatar(
                      //                   radius: 25,
                      //                   backgroundImage: orderController.customerModel.value?.profileImage != "" ? NetworkImage(orderController.customerModel.value!.profileImage!) : const NetworkImage("https://cdn.techjuice.pk/wp-content/uploads/2015/02/wallpaper-for-facebook-profile-photo-1024x645.jpg"),
                      //                 ),
                      //                 const SizedBox(
                      //                   width: 10,
                      //                 ),
                      //                 Column(
                      //                   crossAxisAlignment: CrossAxisAlignment.start,
                      //                   children: [
                      //                     Text(
                      //                       orderController.customerModel.value!.rider_name!,
                      //                       style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.black, fontWeight: FontWeight.w600),
                      //                     ),
                      //                     Text(
                      //                       orderController.customerModel.value!.rider_phone!,
                      //                       style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.grey, fontWeight: FontWeight.normal),
                      //                     ),
                      // Obx(
                      //   () => Row(
                      //     children: [
                      //       const Icon(
                      //         Icons.star,
                      //         color: redColor,
                      //         size: 20,
                      //       ),
                      //       Text(
                      //         ((orderController.ratingValue.value) / orderController.rating!.length).toStringAsFixed(1),
                      //         style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.grey, fontWeight: FontWeight.normal),
                      //       ),
                      //     ],
                      //   ),
                      // )
                      //                   ],
                      //                 ),
                      //               ],
                      //             ),
                      //                                                               Text(
                      //                                                                 orderController.customerModel.value!.rider_email!,
                      //                                                                 style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.grey, fontWeight: FontWeight.normal),
                      //                                                               ),
                      //                                                               Flexible(
                      //                                                                 child: Text(
                      //                                                                   orderController.customerModel.value!.rider_address!,
                      //                                                                   maxLines: 2,
                      //                                                                   overflow: TextOverflow.ellipsis,
                      //                                                                   style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.grey, fontWeight: FontWeight.normal),
                      //                                                                 ),
                      //                                                               ),
                      //                                                               Text(
                      //                                                                 'Full Address State to State',
                      //                                                                 style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.grey, fontWeight: FontWeight.normal),
                      //                                                               ),
                      //                                                               const SizedBox(height: 20),
                      //                                                               initialLabelIndex == 1
                      //                                                                   ? SizedBox(
                      //                                                                       height: size.height * 0.7,
                      //                                                                       child: GetX<RequestController>(
                      //                                                                           init: Get.put<RequestController>(RequestController()),
                      //                                                                           builder: (RequestController controller) {
                      //                                                                             if (controller.offers == null || controller.offers!.isEmpty) {
                      //                                                                               return SizedBox(
                      //                                                                                 // height: size.height * 0.4,
                      //                                                                                 width: size.width * 1,
                      //                                                                                 child: Column(
                      //                                                                                   children: [
                      //                                                                                     SizedBox(
                      //                                                                                       height: size.height * 0.15,
                      //                                                                                     ),
                      //                                                                                     Image.asset(
                      //                                                                                       "assets/images/no_data.png",
                      //                                                                                       height: size.height * 0.2,
                      //                                                                                     ),
                      //                                                                                     SizedBox(
                      //                                                                                       height: size.height * 0.03,
                      //                                                                                     ),
                      //                                                                                     Text("No received offer found yet ...", style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.black, fontWeight: FontWeight.w600)),
                      //                                                                                   ],
                      //                                                                                 ),
                      //                                                                               );
                      //                                                                             } else {
                      //                                                                               return ListView.builder(
                      //                                                                                   padding: EdgeInsets.only(top: size.height * 0.00, bottom: size.height * 0.1),
                      //                                                                                   itemCount: controller.offers!.length,
                      //                                                                                   itemBuilder: (context, index) {
                      //                                                                                     var offer = controller.offers![index];
                      //                                                                                     controller.getDetailRider(offer.id!);
                      //                                                                                     return Padding(
                      //                                                                                       padding: const EdgeInsets.all(8.0),
                      //                                                                                       child: Card(
                      //                                                                                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      //                                                                                         elevation: 3,
                      //                                                                                         child: ListTile(
                      //                                                                                           onTap: () async {
                      //                                                                                             await controller.getDetailRider(offer.id!);
                      //                                                                                             Get.to(() => ShowDeliveryBoyDetail());
                      //                                                                                           },
                      //                                                                                           // trailing: CircleAvatar(
                      //                                                                                           //   radius: size.height * 0.015,
                      //                                                                                           //   backgroundColor: redColor,
                      //                                                                                           //   child: Center(
                      //                                                                                           //     child: Text(
                      //                                                                                           //       offer.noOfRequest!.toString(),
                      //                                                                                           //       style: const TextStyle(color: Colors.white),
                      //                                                                                           //     ),
                      //                                                                                           //   ),
                      //                                                                                           // ),
                      //                                                                                           title: Text(offer.title!.capitalizeFirst!),
                      //                                                                                           subtitle: Column(
                      //                                                                                             crossAxisAlignment: CrossAxisAlignment.start,
                      //                                                                                             children: [
                      //                                                                                               Text(offer.description!),
                      //                                                                                               const SizedBox(
                      //                                                                                                 height: 10,
                      //                                                                                               ),
                      //                                                                                               Row(
                      //                                                                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //                                                                                                 children: [
                      //                                                                                                   Flexible(
                      //                                                                                                       child: SizedBox(
                      //                                                                                                     height: 40,
                      //                                                                                                     child: PrimaryButton(
                      //                                                                                                         grediantColor: const [Colors.green, Colors.green],
                      //                                                                                                         text: 'Accept',
                      // onPressed: () async {
                      //   await controller.getDetailRider(offer.id!).then((value) {
                      //     requestController.onTheWayRequest(offer.id!, requestController.getRequest![index].delivery_boy_id!);
                      //   });

                      //   print('offer id is:${requestController.getRequest![index].id!}');
                      //   // Get.put(PushNotificationsController())
                      //   //     .sendPushMessage(
                      //   //         // requestController.token.value,
                      //   //         'cgpiBvqjR6yhwUOEUUpMNf:APA91bECJnhPaTWUDg9md7MFNlSXyqwS8AU-FWEQg89dUTReLS3sUpRBP54VunW7HbxaOVeQbVuzXd61Ztypm04Hsxyj0S0A-Rf2iC5EIlLTe7qRxlMqIcRNhkYCVqqyRCRyQZexg1wx',
                      //   //         requestController
                      //   //             .getRequest![index]
                      //   //             .email!,
                      //   //         requestController
                      //   //             .getRequest![index]
                      //   //             .email!);
                      // }),
                      //                                                                                                   )),
                      //                                                                                                   const SizedBox(
                      //                                                                                                     width: 10,
                      //                                                                                                   ),
                      //                                                                                                   Flexible(
                      //                                                                                                       child: SizedBox(
                      //                                                                                                     height: 40,
                      //                                                                                                     child: PrimaryButton(
                      //                                                                                                         text: 'Cancel',
                      //                                                                                                         onPressed: () async {
                      // await controller.getDetailRider(offer.id!).then((value) {
                      //   requestController.cancelRequest(offer.id!, controller.getRequest![index].delivery_boy_id!);
                      // });

                      //                                                                                                           print("Document id:${offer.id}");
                      //                                                                                                           print("Delivery id:${requestController.getRequest![index].delivery_boy_id!}");
                      //                                                                                                         }),
                      //                                                                                                   )),
                      //                                                                                                 ],
                      //                                                                                               ),
                      //                                                                                               const SizedBox(
                      //                                                                                                 height: 10,
                      //                                                                                               ),
                      //                                                                                             ],
                      //                                                                                           ),
                      //                                                                                           leading: CircleAvatar(
                      //                                                                                             backgroundImage: offer.request_image!.isNotEmpty
                      //                                                                                                 ? NetworkImage(offer.request_image!)
                      //                                                                                                 : const NetworkImage(
                      //                                                                                                     'https://img.freepik.com/free-vector/way-concept-illustration_114360-1191.jpg?w=2000&t=st=1665469064~exp=1665469664~hmac=f18cfd14cfdc7389b9238600501c87cd28798d2e6fbb6058d4b699309ebce3b9',
                      //                                                                                                   ),
                      //                                                                                           ),
                      //                                                                                         ),
                      //                                                                                       ),
                      //                                                                                     );
                      //                                                                                   });
                      //                                                                             }
                      //                                                                           }),
                      //                                                                     )
                      //                                                                   : const SizedBox(),
                      //                                                               const SizedBox(height: 20),
                      //                                                               const Spacer(),
                      //                                                               orderStatus.isCompleted == true
                      //                                                                   ? SizedBox(
                      //                                                                       child: Column(
                      //                                                                         children: [
                      //                                                                           const Text("Rider has complete the delivery can you confirm that?"),
                      //                                                                           Row(
                      //                                                                             mainAxisAlignment: MainAxisAlignment.end,
                      //                                                                             children: [
                      //                                                                               TextButton(
                      //                                                                                   onPressed: () async {
                      //                                                                                     //PUSH NOTIFICATION
                      //                                                                                     await FirebaseFirestore.instance.collection("DeliveryBoyTokens").doc(orderController.orderStatus![index].delivery_boy_id).get().then((value) {
                      //                                                                                       Get.find<PushNotificationsController>().sendPushMessage(value.get("Token"), "Please make sure you delivered the order on correct place", "Order Canceled");
                      //                                                                                     }).then((value) async {
                      //                                                                                       await FirebaseFirestore.instance.collection("delivery_boy").doc(orderController.orderStatus![index].delivery_boy_id).collection("Notifications").add({
                      //                                                                                         "Title": "Order Cancelled",
                      //                                                                                         "Seen": false,
                      //                                                                                         "Body": "Please make sure you delivered the order on correct place",
                      //                                                                                         "Date": DateTime.now().toString()
                      //                                                                                       });
                      //                                                                                     });
                      //                                                                                     orderController.cancelOffer(orderController.orderStatus![index].id!);
                      //                                                                                     Get.back();
                      //                                                                                   },
                      //                                                                                   child: const Text("Cancel")),
                      //                                                                               TextButton(
                      //                                                                                   onPressed: () async {
                      //   //PUSH NOTIFICATION
                      // await FirebaseFirestore.instance.collection("DeliveryBoyTokens").doc(orderController.orderStatus![index].delivery_boy_id).get().then((value) {
                      //   Get.find<PushNotificationsController>().sendPushMessage(value.get("Token"), "Congratulations! your order is verified by ${orderController.orderStatus![index].customer_name}, you earned \$${orderController.orderStatus![index].price}", "Order Verified");
                      // }).then((value) async {
                      //   await FirebaseFirestore.instance.collection("delivery_boy").doc(orderController.orderStatus![index].delivery_boy_id).collection("Notifications").add({
                      //     "Title": "Order Verified",
                      //     "Seen": false,
                      //     "Body": "Congratulations! your order is verified by ${orderController.orderStatus![index].customer_name}, you earned \$${orderController.orderStatus![index].price}",
                      //     "Date": DateTime.now().toString()
                      //   });
                      // });
                      // orderController.completeDelivery(orderStatus.id!);
                      // Get.back();
                      //   // Utils().showRatingAppDialog(context);
                      //   final _ratingDialog = RatingDialog(
                      //     starColor: redColor,
                      //     // ratingColor: Colors.amber,
                      //     title: const Text('Feedback to rider'),

                      //     // onCancelled: () {},
                      //     onSubmitted: (response) {
                      //       print('rating: ${response.rating}, '
                      //           'comment: ${response.comment}');
                      //       orderController.giveRatingToRider(orderController.customerModel.value!.id!, response.rating, response.comment, orderController.auth.currentUser!.uid).then((value) async {
                      //         //PUSH NOTIFICATION
                      //         await FirebaseFirestore.instance.collection("DeliveryBoyTokens").doc(orderController.orderStatus![index].delivery_boy_id).get().then((value) {
                      //           Get.find<PushNotificationsController>().sendPushMessage(value.get("Token"), "${orderController.orderStatus![index].customer_name} left a review", "Review Recieved");
                      //         }).then((value) async {
                      //           await FirebaseFirestore.instance.collection("delivery_boy").doc(orderController.orderStatus![index].delivery_boy_id).collection("Notifications").add({
                      //             "Title": "Review Recieved",
                      //             "Body": "${orderController.orderStatus![index].customer_name} left a review",
                      //             "Seen": false,
                      //             "Date": DateTime.now().toString()
                      //           });
                      //         });
                      //       });

                      //       // if (response.rating < 3.0) {
                      //       //   print('response.rating: ${response.rating}');
                      //       // } else {
                      //       //   Container();
                      //       // }
                      //     },
                      //     submitButtonText: 'Submit',
                      //   );

                      //   showDialog(
                      //     context: context,
                      //     barrierDismissible: false,
                      //     builder: (context) => _ratingDialog,
                      //   );
                      // },
                      // child: const Text("Verify")),
                      //                                                                             ],
                      //                                                                           ),
                      //                                                                         ],
                      //                                                                       ),
                      //                                                                     )
                      //                                                                   : PrimaryButton(text: "See More", onPressed: () {}),
                      //                                                             ],
                      //                                                           ),
                      //                                                         ),
                      //                                                       ),
                      //                                                     ),
                      //                                                   );
                      //                                                 }),
                      //                                           ],
                      //                                         ),
                      //                                       ),
                      //                                     );
                      //                                   });
                      //                             }
                      //                           })),
                      //                       orderController.orderStatus == null
                      //                           ? Column(
                      //                               children: [
                      //                                 SizedBox(
                      //                                   height: size.height * 0.15,
                      //                                 ),
                      //                                 Image.asset(
                      //                                   "assets/images/no_data.png",
                      //                                   height: size.height * 0.2,
                      //                                 ),
                      //                                 SizedBox(
                      //                                   height: size.height * 0.03,
                      //                                 ),
                      //                                 Text(
                      //                                     "No Sending offer found yet ...",
                      //                                     style: Theme.of(context)
                      //                                         .textTheme
                      //                                         .subtitle1!
                      //                                         .copyWith(
                      //                                             color: Colors.black,
                      //                                             fontWeight:
                      //                                                 FontWeight
                      //                                                     .w600)),
                      //                               ],
                      //                             )
                      //                           : SizedBox(),
                      //                     ],
                      //                   ),
                      //                 ),
                      //               );
                      //             } else {
                      //               return Column(
                      //                 children: [
                      //                   SizedBox(
                      //                     height: 200,
                      //                     child: ListView.builder(
                      //                       padding: const EdgeInsets.only(
                      //                           top: 20, bottom: 100),
                      //                       itemCount:
                      //                           requestController.sending!.length,
                      //                       itemBuilder: (context, index) {
                      //                         print(
                      //                             "length of sent request is:${requestController.sending!.length}");
                      //                         return requestController
                      //                                 .sending!.isNotEmpty
                      //                             ? Padding(
                      //                                 padding:
                      //                                     const EdgeInsets.all(8.0),
                      //                                 child: Column(
                      //                                   children: [
                      //                                     Container(
                      //                                       width:
                      //                                           MediaQuery.of(context)
                      //                                                   .size
                      //                                                   .width *
                      //                                               0.95,
                      //                                       padding:
                      //                                           const EdgeInsets.all(
                      //                                               8),
                      //                                       decoration: BoxDecoration(
                      //                                         color: Colors.white,
                      //                                         borderRadius:
                      //                                             BorderRadius
                      //                                                 .circular(12),
                      //                                         boxShadow: const [
                      //                                           BoxShadow(
                      //                                               color: Colors
                      //                                                   .black12,
                      //                                               blurRadius: 12)
                      //                                         ],
                      //                                       ),
                      //                                       child: Column(
                      //                                         crossAxisAlignment:
                      //                                             CrossAxisAlignment
                      //                                                 .start,
                      //                                         children: [
                      //                                           Row(
                      //                                             crossAxisAlignment:
                      //                                                 CrossAxisAlignment
                      //                                                     .start,
                      //                                             children: [
                      //                                               requestController
                      //                                                       .sending![
                      //                                                           index]
                      //                                                       .request_image!
                      //                                                       .isNotEmpty
                      //                                                   ? Container(
                      //                                                       height:
                      //                                                           100,
                      //                                                       width: 90,
                      //                                                       decoration: BoxDecoration(
                      //                                                           borderRadius: BorderRadius.circular(14),
                      //                                                           border: Border.all(
                      //                                                             color:
                      //                                                                 Colors.black,
                      //                                                             width:
                      //                                                                 2,
                      //                                                           )),
                      //                                                       child:
                      //                                                           ClipRRect(
                      //                                                         borderRadius:
                      //                                                             BorderRadius.circular(12),
                      //                                                         child: Image
                      //                                                             .network(
                      //                                                           requestController
                      //                                                               .sending![index]
                      //                                                               .request_image!,
                      //                                                           // scale: 4,
                      //                                                           height:
                      //                                                               200,
                      //                                                           fit: BoxFit
                      //                                                               .fill,
                      //                                                           // width: double.infinity,
                      //                                                         ),
                      //                                                       ),
                      //                                                     )
                      //                                                   : Container(
                      //                                                       height:
                      //                                                           100,
                      //                                                       width: 90,
                      //                                                       decoration: BoxDecoration(
                      //                                                           borderRadius: BorderRadius.circular(14),
                      //                                                           border: Border.all(
                      //                                                             color:
                      //                                                                 Colors.black,
                      //                                                             width:
                      //                                                                 2,
                      //                                                           )),
                      //                                                       child:
                      //                                                           ClipRRect(
                      //                                                         borderRadius:
                      //                                                             BorderRadius.circular(12),
                      //                                                         child: Image
                      //                                                             .network(
                      //                                                           'https://img.freepik.com/free-vector/way-concept-illustration_114360-1191.jpg?w=2000&t=st=1665469064~exp=1665469664~hmac=f18cfd14cfdc7389b9238600501c87cd28798d2e6fbb6058d4b699309ebce3b9',
                      //                                                           height:
                      //                                                               200,
                      //                                                           fit: BoxFit
                      //                                                               .fill,
                      //                                                         ),
                      //                                                       ),
                      //                                                     ),
                      //                                               const SizedBox(
                      //                                                 width: 20,
                      //                                               ),
                      //                                               Column(
                      //                                                 crossAxisAlignment:
                      //                                                     CrossAxisAlignment
                      //                                                         .start,
                      //                                                 children: [
                      //                                                   Text(
                      //                                                     requestController
                      //                                                         .sending![
                      //                                                             index]
                      //                                                         .title!,
                      //                                                     style: Theme.of(
                      //                                                             context)
                      //                                                         .textTheme
                      //                                                         .subtitle1!
                      //                                                         .copyWith(
                      //                                                             color:
                      //                                                                 Colors.black,
                      //                                                             fontWeight: FontWeight.bold),
                      //                                                   ),
                      //                                                   const SizedBox(
                      //                                                     height: 10,
                      //                                                   ),
                      //                                                   Row(
                      //                                                     mainAxisAlignment:
                      //                                                         MainAxisAlignment
                      //                                                             .spaceBetween,
                      //                                                     children: [
                      //                                                       Text(
                      //                                                         'Price:',
                      //                                                         style: Theme.of(context)
                      //                                                             .textTheme
                      //                                                             .caption!
                      //                                                             .copyWith(color: Colors.grey),
                      //                                                       ),
                      //                                                       const SizedBox(
                      //                                                         width:
                      //                                                             5,
                      //                                                       ),
                      //                                                       Text(
                      //                                                         "\$" +
                      //                                                             requestController.sending![index].price.toString(),
                      //                                                         style: Theme.of(context)
                      //                                                             .textTheme
                      //                                                             .subtitle1!
                      //                                                             .copyWith(
                      //                                                                 color: Colors.red,
                      //                                                                 fontWeight: FontWeight.bold),
                      //                                                       ),
                      //                                                       const SizedBox(
                      //                                                         width:
                      //                                                             15,
                      //                                                       ),
                      //                                                     ],
                      //                                                   ),
                      //                                                   SizedBox(
                      //                                                     width: MediaQuery.of(context)
                      //                                                             .size
                      //                                                             .width *
                      //                                                         0.6,
                      //                                                     child: Text(
                      //                                                       requestController
                      //                                                           .sending![
                      //                                                               index]
                      //                                                           .description!,
                      //                                                       style: Theme.of(
                      //                                                               context)
                      //                                                           .textTheme
                      //                                                           .caption!
                      //                                                           .copyWith(
                      //                                                               color: Colors.grey,
                      //                                                               fontWeight: FontWeight.normal),
                      //                                                     ),
                      //                                                   ),
                      //                                                 ],
                      //                                               ),
                      //                                             ],
                      //                                           ),
                      //                                           const SizedBox(
                      //                                             height: 5,
                      //                                           ),
                      //                                           Column(
                      //                                             crossAxisAlignment:
                      //                                                 CrossAxisAlignment
                      //                                                     .start,
                      //                                             children: [
                      //                                               Row(
                      //                                                 mainAxisAlignment:
                      //                                                     MainAxisAlignment
                      //                                                         .start,
                      //                                                 children: [
                      //                                                   const Icon(
                      //                                                     Icons
                      //                                                         .location_on,
                      //                                                     color: Colors
                      //                                                         .grey,
                      //                                                     size: 15,
                      //                                                   ),
                      //                                                   const SizedBox(
                      //                                                     width: 5,
                      //                                                   ),
                      //                                                   Expanded(
                      //                                                     child: Text(
                      //                                                       requestController
                      //                                                           .sending![
                      //                                                               index]
                      //                                                           .pickAddress!,
                      //                                                       maxLines:
                      //                                                           1,
                      //                                                       overflow:
                      //                                                           TextOverflow
                      //                                                               .ellipsis,
                      //                                                     ),
                      //                                                   )
                      //                                                 ],
                      //                                               ),
                      //                                               const SizedBox(
                      //                                                 height: 5,
                      //                                               ),
                      //                                               ...List.generate(
                      //                                                   5,
                      //                                                   (index) =>
                      //                                                       Padding(
                      //                                                         padding:
                      //                                                             EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.011),
                      //                                                         child:
                      //                                                             Container(
                      //                                                           margin:
                      //                                                               const EdgeInsets.all(1),
                      //                                                           height:
                      //                                                               3,
                      //                                                           width:
                      //                                                               3,
                      //                                                           decoration: const BoxDecoration(
                      //                                                               color: Colors.grey,
                      //                                                               shape: BoxShape.circle),
                      //                                                         ),
                      //                                                       )),
                      //                                               const SizedBox(
                      //                                                 height: 5,
                      //                                               ),
                      //                                               Row(
                      //                                                 children: [
                      //                                                   const Icon(
                      //                                                     Icons
                      //                                                         .location_on,
                      //                                                     color: Colors
                      //                                                         .grey,
                      //                                                     size: 15,
                      //                                                   ),
                      //                                                   const SizedBox(
                      //                                                     width: 5,
                      //                                                   ),
                      //                                                   Expanded(
                      //                                                     child: Text(
                      //                                                       requestController
                      //                                                           .sending![
                      //                                                               index]
                      //                                                           .dropAddress!,
                      //                                                       maxLines:
                      //                                                           1,
                      //                                                       overflow:
                      //                                                           TextOverflow
                      //                                                               .ellipsis,
                      //                                                     ),
                      //                                                   )
                      //                                                 ],
                      //                                               ),
                      //                                             ],
                      //                                           ),
                      //                                           const SizedBox(
                      //                                               height: 5),
                      //                                           Row(
                      //                                             mainAxisAlignment:
                      //                                                 MainAxisAlignment
                      //                                                     .end,
                      //                                             children: [
                      //                                               Text(
                      //                                                 'Estimated Delivery Fee:',
                      //                                                 style: Theme.of(
                      //                                                         context)
                      //                                                     .textTheme
                      //                                                     .caption!
                      //                                                     .copyWith(
                      //                                                         color: Colors
                      //                                                             .grey),
                      //                                               ),
                      //                                               const SizedBox(
                      //                                                 width: 5,
                      //                                               ),
                      //                                               Text(
                      //                                                 "\$" +
                      //                                                     requestController
                      //                                                         .sending![
                      //                                                             index]
                      //                                                         .deliveryfee
                      //                                                         .toString(),
                      //                                                 style: Theme.of(
                      //                                                         context)
                      //                                                     .textTheme
                      //                                                     .subtitle1!
                      //                                                     .copyWith(
                      //                                                         color: Colors
                      //                                                             .red,
                      //                                                         fontWeight:
                      //                                                             FontWeight.bold),
                      //                                               ),
                      //                                             ],
                      //                                           ),
                      //                                         ],
                      //                                       ),
                      //                                     ),
                      //                                   ],
                      //                                 ),
                      //                               )
                      //                             : const Center(
                      //                                 child: Text('No data found'),
                      //                               );
                      //                       },
                      //                     ),
                      //                   ),
                      //                 ],
                      //               );
                      //             }
                      //           },
                      //         ),
                      //       )
                      //     : initialLabelIndex == 2
                      //         ? SizedBox(
                      //             height: size.height * 0.7,
                      //             child: GetX<RequestController>(
                      //                 init: Get.put<RequestController>(
                      //                     RequestController()),
                      //                 builder: (RequestController controller) {
                      //                   if (controller.offers == null ||
                      //                       controller.offers!.isEmpty) {
                      //                     return SizedBox(
                      //                       // height: size.height * 0.4,
                      //                       width: size.width * 1,
                      //                       child: Column(
                      //                         children: [
                      //                           SizedBox(
                      //                             height: size.height * 0.15,
                      //                           ),
                      //                           Image.asset(
                      //                             "assets/images/no_data.png",
                      //                             height: size.height * 0.2,
                      //                           ),
                      //                           SizedBox(
                      //                             height: size.height * 0.03,
                      //                           ),
                      //                           Text(
                      //                               "No received offer found yet ...",
                      //                               style: Theme.of(context)
                      //                                   .textTheme
                      //                                   .subtitle1!
                      //                                   .copyWith(
                      //                                       color: Colors.black,
                      //                                       fontWeight:
                      //                                           FontWeight.w600)),
                      //                         ],
                      //                       ),
                      //                     );
                      //                   } else {
                      //                     return ListView.builder(
                      //                         padding: EdgeInsets.only(
                      //                             top: size.height * 0.00,
                      //                             bottom: size.height * 0.1),
                      //                         itemCount: controller.offers!.length,
                      //                         itemBuilder: (context, index) {
                      //                           var offer = controller.offers![index];
                      //                           controller.getDetailRider(offer.id!);
                      //                           return Padding(
                      //                             padding: const EdgeInsets.all(8.0),
                      //                             child: Card(
                      //                               shape: RoundedRectangleBorder(
                      //                                   borderRadius:
                      //                                       BorderRadius.circular(
                      //                                           20)),
                      //                               elevation: 3,
                      //                               child: ListTile(
                      //                                 onTap: () async {
                      //                                   await controller
                      //                                       .getDetailRider(
                      //                                           offer.id!);
                      //                                   Get.to(() =>
                      //                                       ShowDeliveryBoyDetail());
                      //                                 },
                      //                                 // trailing: CircleAvatar(
                      //                                 //   radius: size.height * 0.015,
                      //                                 //   backgroundColor: redColor,
                      //                                 //   child: Center(
                      //                                 //     child: Text(
                      //                                 //       offer.noOfRequest!.toString(),
                      //                                 //       style: const TextStyle(color: Colors.white),
                      //                                 //     ),
                      //                                 //   ),
                      //                                 // ),
                      //                                 title: Text(offer
                      //                                     .title!.capitalizeFirst!),
                      //                                 subtitle: Column(
                      //                                   crossAxisAlignment:
                      //                                       CrossAxisAlignment.start,
                      //                                   children: [
                      //                                     Text(offer.description!),
                      //                                     const SizedBox(
                      //                                       height: 10,
                      //                                     ),
                      //                                     Row(
                      //                                       mainAxisAlignment:
                      //                                           MainAxisAlignment
                      //                                               .spaceBetween,
                      //                                       children: [
                      //                                         Flexible(
                      //                                             child: SizedBox(
                      //                                           height: 40,
                      //                                           child: PrimaryButton(
                      //                                               grediantColor: const [
                      //                                                 Colors.green,
                      //                                                 Colors.green
                      //                                               ],
                      //                                               text: 'Accept',
                      //                                               onPressed:
                      //                                                   () async {
                      //                                                 debugPrint(
                      //                                                     "offer id is here ${offer.id}");
                      //                                                 await controller
                      //                                                     .getDetailRider(
                      //                                                         offer
                      //                                                             .id!)
                      //                                                     .then(
                      //                                                         (value) async {
                      //                                                   setState(
                      //                                                       () {});
                      //                                                   await requestController.onTheWayRequest(
                      //                                                       offer.id!,
                      //                                                       requestController
                      //                                                           .getRequest![
                      //                                                               index]
                      //                                                           .delivery_boy_id!);
                      //                                                 });

                      //                                                 print(
                      //                                                     'offer id is:${requestController.getRequest![index].id!}');
                      //                                                 // Get.put(PushNotificationsController())
                      //                                                 //     .sendPushMessage(
                      //                                                 //         // requestController.token.value,
                      //                                                 //         'cgpiBvqjR6yhwUOEUUpMNf:APA91bECJnhPaTWUDg9md7MFNlSXyqwS8AU-FWEQg89dUTReLS3sUpRBP54VunW7HbxaOVeQbVuzXd61Ztypm04Hsxyj0S0A-Rf2iC5EIlLTe7qRxlMqIcRNhkYCVqqyRCRyQZexg1wx',
                      //                                                 //         requestController
                      //                                                 //             .getRequest![index]
                      //                                                 //             .email!,
                      //                                                 //         requestController
                      //                                                 //             .getRequest![index]
                      //                                                 //             .email!);
                      //                                               }),
                      //                                         )),
                      //                                         const SizedBox(
                      //                                           width: 10,
                      //                                         ),
                      //                                         Flexible(
                      //                                             child: SizedBox(
                      //                                           height: 40,
                      //                                           child: PrimaryButton(
                      //                                               text: 'Cancel',
                      //                                               onPressed:
                      //                                                   () async {
                      //                                                 await controller
                      //                                                     .getDetailRider(
                      //                                                         offer
                      //                                                             .id!)
                      //                                                     .then(
                      //                                                         (value) {
                      //                                                   requestController.cancelRequest(
                      //                                                       offer.id!,
                      //                                                       controller
                      //                                                           .getRequest![
                      //                                                               index]
                      //                                                           .delivery_boy_id!);
                      //                                                 });

                      //                                                 print(
                      //                                                     "Document id:${offer.id}");
                      //                                                 print(
                      //                                                     "Delivery id:${requestController.getRequest![index].delivery_boy_id!}");
                      //                                               }),
                      //                                         )),
                      //                                       ],
                      //                                     ),
                      //                                     const SizedBox(
                      //                                       height: 10,
                      //                                     ),
                      //                                   ],
                      //                                 ),
                      //                                 leading: CircleAvatar(
                      //                                   backgroundImage: offer
                      //                                           .request_image!
                      //                                           .isNotEmpty
                      //                                       ? NetworkImage(
                      //                                           offer.request_image!)
                      //                                       : const NetworkImage(
                      //                                           'https://img.freepik.com/free-vector/way-concept-illustration_114360-1191.jpg?w=2000&t=st=1665469064~exp=1665469664~hmac=f18cfd14cfdc7389b9238600501c87cd28798d2e6fbb6058d4b699309ebce3b9',
                      //                                         ),
                      //                                 ),
                      //                               ),
                      //                             ),
                      //                           );
                      //                         });
                      //                   }
                      //                 }),
                      //           )
                      //         : SizedBox(
                      //             height: size.height / 1.5,
                      //             width: size.width,
                      //             child: GetX<RequestController>(
                      //                 builder: (RequestController orderController) {
                      //               if (orderController.orderStatus == null ||
                      //                   orderController.orderStatus!.isEmpty) {
                      //                 return SizedBox(
                      //                   height: size.height * 0.2,
                      //                   width: size.width * 1,
                      //                   child: Column(
                      //                     children: [
                      //                       SizedBox(
                      //                         height: size.height * 0.15,
                      //                       ),
                      //                       Image.asset(
                      //                         "assets/images/no_data.png",
                      //                         height: size.height * 0.2,
                      //                       ),
                      //                       SizedBox(
                      //                         height: size.height * 0.03,
                      //                       ),
                      //                       Text("No Order Found",
                      //                           style: Theme.of(context)
                      //                               .textTheme
                      //                               .subtitle1!
                      //                               .copyWith(
                      //                                   color: Colors.black,
                      //                                   fontWeight: FontWeight.w600)),
                      //                     ],
                      //                   ),
                      //                 );
                      //               } else {
                      //                 return ListView.builder(
                      //                     physics:
                      //                         const NeverScrollableScrollPhysics(),
                      //                     padding: const EdgeInsets.only(bottom: 55),
                      //                     shrinkWrap: true,
                      //                     itemCount:
                      //                         orderController.orderStatus!.length,
                      //                     itemBuilder: (context, index) {
                      //                       var orderStatus =
                      //                           orderController.orderStatus![index];

                      //                       return Padding(
                      //                         padding: const EdgeInsets.all(8.0),
                      //                         child: Container(
                      //                           margin: const EdgeInsets.symmetric(
                      //                               vertical: 10),
                      //                           padding: const EdgeInsets.all(12),
                      //                           // height: 200,
                      //                           decoration: BoxDecoration(
                      //                             borderRadius:
                      //                                 BorderRadius.circular(6),
                      //                             border:
                      //                                 Border.all(color: borderColor),
                      //                           ),
                      //                           child: Column(
                      //                             crossAxisAlignment:
                      //                                 CrossAxisAlignment.start,
                      //                             children: [
                      //                               //_buildProductHeader(),
                      //                               Row(
                      //                                 mainAxisAlignment:
                      //                                     MainAxisAlignment
                      //                                         .spaceBetween,
                      //                                 children: [
                      //                                   Column(
                      //                                     crossAxisAlignment:
                      //                                         CrossAxisAlignment
                      //                                             .start,
                      //                                     children: const [
                      //                                       Text(
                      //                                         'Order Date',
                      //                                         style: TextStyle(
                      //                                             height: 1,
                      //                                             color: redColor),
                      //                                       ),

                      //                                       SizedBox(height: 8),
                      //                                       // InVoiceWidget(text: orderStatus.invoice),
                      //                                     ],
                      //                                   ),
                      //                                   Column(
                      //                                     crossAxisAlignment:
                      //                                         CrossAxisAlignment.end,
                      //                                     children: [
                      //                                       Text(
                      //                                         Utils.formatDate(
                      //                                             orderStatus.time!
                      //                                                 .toDate()),
                      //                                         style: const TextStyle(
                      //                                             height: 1,
                      //                                             color:
                      //                                                 paragraphColor),
                      //                                       ),
                      //                                       const SizedBox(height: 1),
                      //                                     ],
                      //                                   ),
                      //                                 ],
                      //                               ),
                      //                               const SizedBox(height: 8),
                      //                               Row(
                      //                                 mainAxisAlignment:
                      //                                     MainAxisAlignment
                      //                                         .spaceBetween,
                      //                                 children: [
                      //                                   Column(
                      //                                     crossAxisAlignment:
                      //                                         CrossAxisAlignment
                      //                                             .start,
                      //                                     children: [
                      //                                       // Row(
                      //                                       //   children: [
                      //                                       //     Text(
                      //                                       //       "Customer Name: "
                      //                                       //           .toUpperCase(),
                      //                                       //       style: const TextStyle(
                      //                                       //           height: 1,
                      //                                       //           color: paragraphColor),
                      //                                       //     ),
                      //                                       //     Text(
                      //                                       //       orderStatus.customer_name!
                      //                                       //           .toUpperCase(),
                      //                                       //       style: const TextStyle(
                      //                                       //           height: 1,
                      //                                       //           color: paragraphColor),
                      //                                       //     ),
                      //                                       //   ],
                      //                                       // ),
                      //                                       const SizedBox(
                      //                                           height: 10),
                      //                                       SizedBox(
                      //                                         width: Get.width * 0.6,
                      //                                         child: Row(
                      //                                           crossAxisAlignment:
                      //                                               CrossAxisAlignment
                      //                                                   .start,
                      //                                           children: [
                      //                                             Text(
                      //                                               "Title: ",
                      //                                               style: GoogleFonts.roboto(
                      //                                                   fontWeight:
                      //                                                       FontWeight
                      //                                                           .bold,
                      //                                                   fontSize: 16,
                      //                                                   height: 1,
                      //                                                   color: Colors
                      //                                                       .grey),
                      //                                             ),
                      //                                             Flexible(
                      //                                               child: Text(
                      //                                                 orderStatus
                      //                                                     .title
                      //                                                     .toString(),
                      //                                                 style: GoogleFonts.roboto(
                      //                                                     fontWeight:
                      //                                                         FontWeight
                      //                                                             .w500,
                      //                                                     fontSize:
                      //                                                         18,
                      //                                                     height: 1,
                      //                                                     color:
                      //                                                         redColor),
                      //                                               ),
                      //                                             ),
                      //                                           ],
                      //                                         ),
                      //                                       ),
                      //                                       const SizedBox(
                      //                                           height: 10),
                      //                                       SizedBox(
                      //                                         width: Get.width * 0.7,
                      //                                         child: Row(
                      //                                           crossAxisAlignment:
                      //                                               CrossAxisAlignment
                      //                                                   .start,
                      //                                           children: [
                      //                                             Text(
                      //                                               "Description: ",
                      //                                               style: GoogleFonts.roboto(
                      //                                                   fontWeight:
                      //                                                       FontWeight
                      //                                                           .w500,
                      //                                                   fontSize: 14,
                      //                                                   height: 1,
                      //                                                   color: Colors
                      //                                                       .grey),
                      //                                             ),
                      //                                             Flexible(
                      //                                               child: Text(
                      //                                                 orderStatus
                      //                                                     .description
                      //                                                     .toString(),
                      //                                                 style: GoogleFonts.roboto(
                      //                                                     fontWeight:
                      //                                                         FontWeight
                      //                                                             .bold,
                      //                                                     fontSize:
                      //                                                         16,
                      //                                                     height: 1,
                      //                                                     color:
                      //                                                         redColor),
                      //                                               ),
                      //                                             ),
                      //                                           ],
                      //                                         ),
                      //                                       ),
                      //                                       const SizedBox(
                      //                                           height: 10),
                      //                                       SizedBox(
                      //                                         width: Get.width * 0.6,
                      //                                         child: Row(
                      //                                           children: [
                      //                                             Text(
                      //                                               "Price: ",
                      //                                               style: GoogleFonts.roboto(
                      //                                                   fontWeight:
                      //                                                       FontWeight
                      //                                                           .bold,
                      //                                                   fontSize: 14,
                      //                                                   height: 1,
                      //                                                   color: Colors
                      //                                                       .grey),
                      //                                             ),
                      //                                             // Text(
                      //                                             //   requestController
                      //                                             //       .getRequest![index]
                      //                                             //       .offerPrice
                      //                                             //       .toString(),
                      //                                             // ),
                      //                                             Text(
                      //                                               "\$ ${orderStatus.price.toString()}",
                      //                                               style: GoogleFonts.roboto(
                      //                                                   fontWeight:
                      //                                                       FontWeight
                      //                                                           .bold,
                      //                                                   fontSize: 16,
                      //                                                   height: 1,
                      //                                                   color:
                      //                                                       redColor),
                      //                                             ),
                      //                                             // const Spacer(),
                      //                                           ],
                      //                                         ),
                      //                                       ),
                      //                                     ],
                      //                                   ),
                      //                                   orderStatus.request_image !=
                      //                                           ""
                      //                                       ? CircleAvatar(
                      //                                           radius: 20,
                      //                                           backgroundImage:
                      //                                               NetworkImage(
                      //                                                   orderStatus
                      //                                                       .customer_image!),
                      //                                         )
                      //                                       : const CircleAvatar(
                      //                                           radius: 20,
                      //                                           backgroundImage:
                      //                                               NetworkImage(
                      //                                                   "https://cdn.techjuice.pk/wp-content/uploads/2015/02/wallpaper-for-facebook-profile-photo-1024x645.jpg"),
                      //                                         ),
                      //                                   const SizedBox(height: 1),
                      //                                 ],
                      //                               ),
                      //                               const SizedBox(
                      //                                 height: 8,
                      //                               ),
                      //                               Row(children: [
                      //                                 orderStatus.isCompleted == true
                      //                                     ? const Icon(
                      //                                         Icons.timelapse_rounded,
                      //                                         color: Colors.yellow,
                      //                                       )
                      //                                     : const SizedBox(),
                      //                                 orderStatus.isCompleted == true
                      //                                     ? const Text(
                      //                                         "Request for Complete")
                      //                                     : const SizedBox()
                      //                               ]),
                      //                               // Row(
                      //                               //   mainAxisAlignment:
                      //                               //       MainAxisAlignment.spaceBetween,
                      //                               //   children: [
                      //                               //     const Text(
                      //                               //       'Customer Address',
                      //                               //       style: TextStyle(
                      //                               //           height: 1, color: redColor),
                      //                               //     ),
                      //                               //     Text(
                      //                               //       orderStatus.customer_address!,
                      //                               //       style: const TextStyle(
                      //                               //           height: 1,
                      //                               //           color: Colors.black,
                      //                               //           fontWeight: FontWeight.bold),
                      //                               //     ),
                      //                               //   ],
                      //                               // ),
                      //                               const SizedBox(height: 14),
                      //                               // PrimaryButton(
                      //                               //   minimumSize:
                      //                               //       const Size(double.infinity, 40),
                      //                               //   fontSize: 16,
                      //                               //   grediantColor: const [
                      //                               //     blackColor,
                      //                               //     blackColor
                      //                               //   ],
                      //                               //   text: 'View Details',
                      //                               //   onPressed: () async {
                      //                               //     // orderController
                      //                               //     //     .getre(orderStatus.id!);
                      //                               //     // //Get.log("lenght is here  : ${orderController.customerProducts!.length}");
                      //                               //     // // Navigator.pushNamed(context, RouteNames.orderDetailsPage,
                      //                               //     // //     arguments: );
                      //                               //     // Get.to(() => OrderDetailsPage(
                      //                               //     //       customerModel: orderStatus,
                      //                               //     //     ));
                      //                               //   },
                      //                               // ),
                      //                               initialLabelIndex == 1
                      //                                   ? const SizedBox()
                      //                                   : PrimaryButton(
                      //                                       text: "View Detail",
                      //                                       onPressed: () async {
                      //                                         await orderController
                      //                                             .getRiderDetails(
                      //                                                 orderStatus
                      //                                                     .delivery_boy_id!);
                      //                                         await orderController
                      //                                             .getRating(orderStatus
                      //                                                 .delivery_boy_id!)
                      //                                             .then((value) {});

                      //                                         print(
                      //                                             "now get id${(orderStatus.delivery_boy_id!)}");
                      //                                         Get.bottomSheet(
                      //                                           Padding(
                      //                                             padding: EdgeInsets
                      //                                                 .symmetric(
                      //                                                     horizontal:
                      //                                                         8.0,
                      //                                                     vertical:
                      //                                                         Get.height *
                      //                                                             0.05),
                      //                                             child: Container(
                      //                                               // padding:
                      //                                               //     EdgeInsets.all(16),
                      //                                               height:
                      //                                                   Get.height *
                      //                                                       0.4,
                      //                                               decoration: BoxDecoration(
                      //                                                   color: Colors
                      //                                                       .white,
                      //                                                   borderRadius:
                      //                                                       BorderRadius
                      //                                                           .circular(
                      //                                                               12)),
                      //                                               child: Padding(
                      //                                                 padding:
                      //                                                     const EdgeInsets
                      //                                                             .all(
                      //                                                         8.0),
                      //                                                 child: Column(
                      //                                                   crossAxisAlignment:
                      //                                                       CrossAxisAlignment
                      //                                                           .start,
                      //                                                   children: [
                      //                                                     Row(
                      //                                                       children: [
                      //                                                         CircleAvatar(
                      //                                                           radius:
                      //                                                               25,
                      //                                                           backgroundImage: orderController.customerModel.value?.profileImage != ""
                      //                                                               ? NetworkImage(orderController.customerModel.value!.profileImage!)
                      //                                                               : const NetworkImage("https://cdn.techjuice.pk/wp-content/uploads/2015/02/wallpaper-for-facebook-profile-photo-1024x645.jpg"),
                      //                                                         ),
                      //                                                         const SizedBox(
                      //                                                           width:
                      //                                                               10,
                      //                                                         ),
                      //                                                         Column(
                      //                                                           crossAxisAlignment:
                      //                                                               CrossAxisAlignment.start,
                      //                                                           children: [
                      //                                                             Text(
                      //                                                               orderController.customerModel.value!.rider_name!,
                      //                                                               style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.black, fontWeight: FontWeight.w600),
                      //                                                             ),
                      //                                                             Text(
                      //                                                               orderController.customerModel.value!.rider_phone!,
                      //                                                               style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.grey, fontWeight: FontWeight.normal),
                      //                                                             ),
                      //                                                             Obx(
                      //                                                               () => Row(
                      //                                                                 children: [
                      //                                                                   const Icon(
                      //                                                                     Icons.star,
                      //                                                                     color: redColor,
                      //                                                                     size: 20,
                      //                                                                   ),
                      //                                                                   Text(
                      //                                                                     ((orderController.ratingValue.value) / orderController.rating!.length).toStringAsFixed(1),
                      //                                                                     style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.grey, fontWeight: FontWeight.normal),
                      //                                                                   ),
                      //                                                                 ],
                      //                                                               ),
                      //                                                             )
                      //                                                           ],
                      //                                                         ),
                      //                                                       ],
                      //                                                     ),
                      //                                                     Text(
                      //                                                       orderController
                      //                                                           .customerModel
                      //                                                           .value!
                      //                                                           .rider_email!,
                      //                                                       style: Theme.of(
                      //                                                               context)
                      //                                                           .textTheme
                      //                                                           .caption!
                      //                                                           .copyWith(
                      //                                                               color: Colors.grey,
                      //                                                               fontWeight: FontWeight.normal),
                      //                                                     ),
                      //                                                     Flexible(
                      //                                                       child:
                      //                                                           Text(
                      //                                                         orderController
                      //                                                             .customerModel
                      //                                                             .value!
                      //                                                             .rider_address!,
                      //                                                         maxLines:
                      //                                                             2,
                      //                                                         overflow:
                      //                                                             TextOverflow.ellipsis,
                      //                                                         style: Theme.of(context)
                      //                                                             .textTheme
                      //                                                             .caption!
                      //                                                             .copyWith(
                      //                                                                 color: Colors.grey,
                      //                                                                 fontWeight: FontWeight.normal),
                      //                                                       ),
                      //                                                     ),
                      //                                                     Text(
                      //                                                       'Full Address State to State',
                      //                                                       style: Theme.of(
                      //                                                               context)
                      //                                                           .textTheme
                      //                                                           .caption!
                      //                                                           .copyWith(
                      //                                                               color: Colors.grey,
                      //                                                               fontWeight: FontWeight.normal),
                      //                                                     ),
                      //                                                     const SizedBox(
                      //                                                         height:
                      //                                                             20),
                      //                                                     initialLabelIndex ==
                      //                                                             2
                      //                                                         ? Row(
                      //                                                             children: [
                      //                                                               const Text('See on map'),
                      //                                                               IconButton(
                      //                                                                 onPressed: () async {
                      //   await orderController.getDetailRider(orderController.orderStatus![index].delivery_boy_id!).then((value) {
                      //     requestController.distance(
                      //       pickLat: orderController.orderStatus![index].pickupLocation!.latitude,
                      //       pickLng: orderController.orderStatus![index].pickupLocation!.longitude,
                      //       dropLat: orderController.orderStatus![index].dropLocation!.latitude,
                      //       dropLng: orderController.orderStatus![index].dropLocation!.longitude,
                      //     );
                      //     // print("object:${orderController.orderStatus![index].pickupLocation!.latitude}");
                      //     // print("object1:${orderController.orderStatus![index].pickupLocation!.longitude}");
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (_) => MapScreen(
                      //                   pickLat: orderController.orderStatus![index].pickupLocation!.latitude,
                      //                   pickLng: orderController.orderStatus![index].pickupLocation!.longitude,
                      //                   dropLat: orderController.orderStatus![index].dropLocation!.latitude,
                      //                   dropLng: orderController.orderStatus![index].dropLocation!.longitude,
                      //                   modelData: orderController.customerModel.value!,
                      //                   rating: orderController.ratingValue.value,
                      //                 )));
                      //   });
                      // },
                      //                                                                 icon: const Icon(Icons.map),
                      //                                                               ),
                      //                                                             ],
                      //                                                           )
                      //                                                         : const SizedBox(),
                      //                                                     const SizedBox(
                      //                                                         height:
                      //                                                             20),
                      //                                                     const Spacer(),
                      //                                                     orderStatus.isCompleted ==
                      //                                                             true
                      //                                                         ? SizedBox(
                      //                                                             child:
                      //                                                                 Column(
                      //                                                               children: [
                      //                                                                 const Text("Rider has complete the delivery can you confirm that?"),
                      //                                                                 Row(
                      //                                                                   mainAxisAlignment: MainAxisAlignment.end,
                      //                                                                   children: [
                      //                                                                     TextButton(
                      //                                                                         onPressed: () async {
                      //                                                                           //PUSH NOTIFICATION
                      //                                                                           await FirebaseFirestore.instance.collection("DeliveryBoyTokens").doc(orderController.orderStatus![index].delivery_boy_id).get().then((value) {
                      //                                                                             Get.find<PushNotificationsController>().sendPushMessage(value.get("Token"), "Please make sure you delivered the order on correct place", "Order Canceled");
                      //                                                                           }).then((value) async {
                      //                                                                             await FirebaseFirestore.instance.collection("delivery_boy").doc(orderController.orderStatus![index].delivery_boy_id).collection("Notifications").add({
                      //                                                                               "Title": "Order Cancelled",
                      //                                                                               "Seen": false,
                      //                                                                               "Body": "Please make sure you delivered the order on correct place",
                      //                                                                               "Date": DateTime.now().toString()
                      //                                                                             });
                      //                                                                           });
                      //                                                                           orderController.cancelOffer(orderController.orderStatus![index].id!);
                      //                                                                           Get.back();
                      //                                                                         },
                      //                                                                         child: const Text("Cancel")),
                      //                                                                     TextButton(
                      //                                                                         onPressed: () async {
                      //                                                                           //PUSH NOTIFICATION
                      //                                                                           await FirebaseFirestore.instance.collection("DeliveryBoyTokens").doc(orderController.orderStatus![index].delivery_boy_id).get().then((value) {
                      //                                                                             Get.find<PushNotificationsController>().sendPushMessage(value.get("Token"), "Congratulations! your order is verified by ${orderController.orderStatus![index].customer_name}, you earned \$${orderController.orderStatus![index].price}", "Order Verified");
                      //                                                                           }).then((value) async {
                      //                                                                             await FirebaseFirestore.instance.collection("delivery_boy").doc(orderController.orderStatus![index].delivery_boy_id).collection("Notifications").add({
                      //                                                                               "Title": "Order Verified",
                      //                                                                               "Seen": false,
                      //                                                                               "Body": "Congratulations! your order is verified by ${orderController.orderStatus![index].customer_name}, you earned \$${orderController.orderStatus![index].price}",
                      //                                                                               "Date": DateTime.now().toString()
                      //                                                                             });
                      //                                                                           });
                      //                                                                           orderController.completeDelivery(orderStatus.id!);
                      //                                                                           Get.back();
                      //                                                                           // Utils().showRatingAppDialog(context);
                      //                                                                           final _ratingDialog = RatingDialog(
                      //                                                                             starColor: redColor,
                      //                                                                             // ratingColor: Colors.amber,
                      //                                                                             title: const Text('Feedback to rider'),

                      //                                                                             // onCancelled: () {},
                      //                                                                             onSubmitted: (response) {
                      //                                                                               print('rating: ${response.rating}, '
                      //                                                                                   'comment: ${response.comment}');
                      //                                                                               orderController.giveRatingToRider(orderController.customerModel.value!.id!, response.rating, response.comment, orderController.auth.currentUser!.uid).then((value) async {
                      //                                                                                 //PUSH NOTIFICATION
                      //                                                                                 await FirebaseFirestore.instance.collection("DeliveryBoyTokens").doc(orderController.orderStatus![index].delivery_boy_id).get().then((value) {
                      //                                                                                   Get.find<PushNotificationsController>().sendPushMessage(value.get("Token"), "${orderController.orderStatus![index].customer_name} left a review", "Review Recieved");
                      //                                                                                 }).then((value) async {
                      //                                                                                   await FirebaseFirestore.instance.collection("delivery_boy").doc(orderController.orderStatus![index].delivery_boy_id).collection("Notifications").add({
                      //                                                                                     "Title": "Review Recieved",
                      //                                                                                     "Body": "${orderController.orderStatus![index].customer_name} left a review",
                      //                                                                                     "Seen": false,
                      //                                                                                     "Date": DateTime.now().toString()
                      //                                                                                   });
                      //                                                                                 });
                      //                                                                               });

                      //                                                                               // if (response.rating < 3.0) {
                      //                                                                               //   print('response.rating: ${response.rating}');
                      //                                                                               // } else {
                      //                                                                               //   Container();
                      //                                                                               // }
                      //                                                                             },
                      //                                                                             submitButtonText: 'Submit',
                      //                                                                           );

                      //                                                                           showDialog(
                      //                                                                             context: context,
                      //                                                                             barrierDismissible: false,
                      //                                                                             builder: (context) => _ratingDialog,
                      //                                                                           );
                      //                                                                         },
                      //                                                                         child: const Text("Verify")),
                      //                                                                   ],
                      //                                                                 ),
                      //                                                               ],
                      //                                                             ),
                      //                                                           )
                      //                                                         : PrimaryButton(
                      //                                                             text:
                      //                                                                 "See More",
                      //                                                             onPressed:
                      //                                                                 () {}),
                      //                                                   ],
                      //                                                 ),
                      //                                               ),
                      //                                             ),
                      //                                           ),
                      //                                         );
                      //                                       }),
                      //                             ],
                      //                           ),
                      //                         ),
                      //                       );
                      //                     });
                      //               }
                      //             })),
                    ],
                  ),
          )
              // : SizedBox(
              //     height: Get.height * 0.5,
              //     width: Get.width,
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: const [
              //         Center(
              //           child: Text("No Offer Found"),
              //         ),
              //       ],
              //     ),
              //   ),
              ),
        ],
      ),
    );
  }

  Widget _buildSingleBtn(int key, String value) {
    return Flexible(
      // flex: 1,
      fit: FlexFit.tight,
      child: InkWell(
        onTap: () => setState(() {
          initialLabelIndex = key;
          orderController.getOrderStatus();
          print("index is here : $initialLabelIndex");
          // widget.onChange(initialLabelIndex);
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: initialLabelIndex == key ? redColor : Colors.white,
            borderRadius: BorderRadius.circular(2),
          ),
          child: FittedBox(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: initialLabelIndex != key ? blackColor : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildappBarButton(BuildContext context) {
    print(
        "Notifications : ${Get.find<CustomerController>().notifyCounter.value}");
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildLocation(),
                // const Spacer(),

                const SizedBox(width: 10),
                Obx(
                  () => InkWell(
                    onTap: () async {
                      Get.find<CustomerController>().notifyCounter.value = 0;

                      Navigator.pushNamed(
                          context, RouteNames.notificationScreen);
                      await FirebaseFirestore.instance
                          .collection("Customer")
                          .doc(Get.find<CustomerController>().user!.uid)
                          .collection("Notifications")
                          .where("Seen", isEqualTo: false)
                          .get()
                          .then((value) {
                        for (int i = 0; i < value.docs.length; i++) {
                          FirebaseFirestore.instance
                              .collection("Customer")
                              .doc(Get.find<CustomerController>().user!.uid)
                              .collection("Notifications")
                              .doc(value.docs[i].id)
                              .update({"Seen": true});
                        }
                      });
                    },
                    child:
                        Get.find<CustomerController>().notifyCounter.value == 0
                            ? const Icon(Icons.notifications,
                                size: 28, color: paragraphColor)
                            : Badge(
                                position: const BadgePosition(top: -5, end: -3),
                                badgeContent: Text(
                                  Get.find<CustomerController>()
                                      .notifyCounter
                                      .value
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: 8, color: Colors.white),
                                ),
                                child: const Icon(Icons.notifications,
                                    size: 28, color: paragraphColor),
                              ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocation() {
    CustomerController customerController = Get.put(CustomerController());
    return Obx(() => GestureDetector(
          onTap: () async {
            // print(
            //     'Location button is pressed:${authController.customerModel.value!.address!}');
            await authController.getCurrentLocation().then((value) async {
              await authController.updateLocation();
            });
          },
          child: Row(
            children: [
              const Icon(
                Icons.my_location_outlined,
                color: Colors.white,
              ),
              const SizedBox(width: 5),
              authController.customerModel.value != null
                  ? Obx(
                      () => authController.customerModel.value!.address ==
                                  null &&
                              authController.customerModel.value!.address == ""
                          ? Text(
                              'Get Location',
                              style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            )
                          : Container(
                              width: 150,
                              child: Text(
                                authController.customerModel.value!.address!,
                                style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                    )
                  : Text(
                      'Get Location',
                      style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
              // const Icon(
              //   Icons.keyboard_arrow_down_outlined,
              //   color: Colors.white,
              // )
            ],
          ),
        ));
  }
}
