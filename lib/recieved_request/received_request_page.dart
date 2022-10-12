import 'package:flutter/material.dart';
import 'package:foodbari_deliver_app/Controllers/push_notification_controller.dart';
import 'package:foodbari_deliver_app/Controllers/request_controller.dart';
import 'package:foodbari_deliver_app/modules/authentication/controller/customer_controller.dart';
import 'package:foodbari_deliver_app/modules/authentication/models/customer_model.dart';
import 'package:foodbari_deliver_app/modules/order/new_request.dart';
import 'package:foodbari_deliver_app/modules/order/show_delivery_boy_detail_page.dart';
import 'package:foodbari_deliver_app/utils/constants.dart';
import 'package:foodbari_deliver_app/widgets/primary_button.dart';
import 'package:foodbari_deliver_app/widgets/rounded_app_bar.dart';
import 'package:get/get.dart';
import 'package:google_place/google_place.dart';

class RecievedRequestPage extends StatefulWidget {
  const RecievedRequestPage({Key? key}) : super(key: key);

  @override
  State<RecievedRequestPage> createState() => _RecievedRequestPageState();
}

class _RecievedRequestPageState extends State<RecievedRequestPage> {
  RequestController requestController = Get.put(RequestController());
  CustomerController customerController = Get.put(CustomerController());
  @override
  void initState() {
    Get.put(RequestController());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final width = MediaQuery.of(context).size.width - 40;
    final size = MediaQuery.of(context).size;
    return Scaffold(
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: size.height * 0.1),
          child: GestureDetector(
            onTap: () {
              Get.to(() => NewRequestScreen());
            },
            child: const CircleAvatar(
              radius: 25,
              backgroundColor: redColor,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ),
        // appBar: RoundedAppBar(
        //   isLeading: false,
        //   titleText: 'New Requests',
        //   // actionButtons: [
        //   //   InkWell(
        //   //     onTap: () {
        //   //       Navigator.pushNamed(context, RouteNames.orderTrackingScreen);
        //   //     },
        //   //     child: const CircleAvatar(
        //   //       radius: 14,
        //   //       backgroundColor: Colors.white,
        //   //       child: Icon(
        //   //         Icons.delivery_dining_outlined,
        //   //         size: 20,
        //   //         color: blackColor,
        //   //       ),
        //   //     ),
        //   //   ),
        //   //   const SizedBox(width: 20),
        //   // ],
        // ),
        body: GetX<RequestController>(
            init: Get.put<RequestController>(RequestController()),
            builder: (RequestController controller) {
              if (controller.offers == null || controller.offers!.isEmpty) {
                return SizedBox(
                  // height: size.height * 0.4,
                  width: size.width * 1,
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.15,
                      ),
                      Image.asset(
                        "assets/images/no_data.png",
                        height: size.height * 0.2,
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      Text("No received offer found yet ...",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600)),
                    ],
                  ),
                );
              } else {
                return ListView.builder(
                    padding: EdgeInsets.only(
                        top: size.height * 0.00, bottom: size.height * 0.1),
                    itemCount: controller.offers!.length,
                    itemBuilder: (context, index) {
                      var offer = controller.offers![index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 3,
                          child: ListTile(
                            onTap: () async {
                              await controller.getDetailRider(offer.id!);
                              // Get.to(() => ShowDeliveryBoyDetail());
                            },
                            // trailing: CircleAvatar(
                            //   radius: size.height * 0.015,
                            //   backgroundColor: redColor,
                            //   child: Center(
                            //     child: Text(
                            //       offer.noOfRequest!.toString(),
                            //       style: const TextStyle(color: Colors.white),
                            //     ),
                            //   ),
                            // ),
                            title: Text(offer.title!.capitalizeFirst!),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(offer.description!),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                        child: SizedBox(
                                      height: 40,
                                      child: PrimaryButton(
                                          grediantColor: const [
                                            Colors.green,
                                            Colors.green
                                          ],
                                          text: 'Accept',
                                          onPressed: () async {
                                            await controller
                                                .getDetailRider(offer.id!);

                                            await requestController
                                                .onTheWayRequest(
                                                    offer.id!,
                                                    requestController
                                                        .getRequest![index]
                                                        .delivery_boy_id!);
                                            print(
                                                'offer id is:${requestController.getRequest![index].id!}');
                                            // Get.put(PushNotificationsController())
                                            //     .sendPushMessage(
                                            //         // requestController.token.value,
                                            //         'cgpiBvqjR6yhwUOEUUpMNf:APA91bECJnhPaTWUDg9md7MFNlSXyqwS8AU-FWEQg89dUTReLS3sUpRBP54VunW7HbxaOVeQbVuzXd61Ztypm04Hsxyj0S0A-Rf2iC5EIlLTe7qRxlMqIcRNhkYCVqqyRCRyQZexg1wx',
                                            //         requestController
                                            //             .getRequest![index]
                                            //             .email!,
                                            //         requestController
                                            //             .getRequest![index]
                                            //             .email!);
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
                                            await controller
                                                .getDetailRider(offer.id!);
                                            await requestController
                                                .cancelRequest(
                                                    offer.id!,
                                                    controller
                                                        .getRequest![index]
                                                        .delivery_boy_id!);
                                            print("Document id:${offer.id}");
                                            print(
                                                "Delivery id:${requestController.getRequest![index].delivery_boy_id!}");
                                          }),
                                    )),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                            leading: CircleAvatar(
                              backgroundImage: offer.request_image!.isNotEmpty
                                  ? NetworkImage(offer.request_image!)
                                  : const NetworkImage(
                                      'https://img.freepik.com/free-vector/way-concept-illustration_114360-1191.jpg?w=2000&t=st=1665469064~exp=1665469664~hmac=f18cfd14cfdc7389b9238600501c87cd28798d2e6fbb6058d4b699309ebce3b9',
                                    ),
                            ),
                          ),
                        ),
                      );
                    });
              }
            })
        //   productModelData = controller.product![index];

        //           return Padding(
        //             padding: const EdgeInsets.only(
        //               top: 8,
        //               left: 8,
        //               bottom: 8,
        //             ),
        //             child: Column(
        //               children: [
        //                 Row(
        //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                   children: [
        //                     Container(
        //                       decoration: const BoxDecoration(
        //                         border: Border(
        //                             right: BorderSide(color: borderColor)),
        //                       ),
        //                       height: height - 2,
        //                       width: width / 2.7,
        //                       child: ClipRRect(
        //                         borderRadius: const BorderRadius.horizontal(
        //                             left: Radius.circular(4)),
        //                         child: Image.network(
        //                             controller.product![index].productImage!),
        //                       ),
        //                     ),
        //                     const SizedBox(width: 12),
        //                     Column(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       children: [
        //                         Text(
        //                           controller.product![index].productName!,
        //                           maxLines: 1,
        //                           overflow: TextOverflow.ellipsis,
        //                           style: const TextStyle(
        //                               fontSize: 14,
        //                               fontWeight: FontWeight.w600),
        //                         ),
        //                         Text(
        //                           controller.product![index].productPrice!
        //                               .toString(),
        //                           style: const TextStyle(
        //                               color: redColor,
        //                               fontSize: 16,
        //                               fontWeight: FontWeight.w600),
        //                         ),
        //                       ],
        //                     ),
        //                     const Spacer(),
        //                     GestureDetector(
        //                       onTap: () {
        //                         productController.removeFromCart(
        //                           controller.product![index].productId!,
        //                           controller.product![index],
        //                         );
        //                       },
        //                       child: const Icon(
        //                         CupertinoIcons.delete,
        //                       ),
        //                     ),
        //                     const SizedBox(width: 10),
        //                   ],
        //                 ),
        //               ],
        //             ),
        //           );
        //         },
        //       );
        //     }
        //   },
        // ),

        // SlidingUpPanel(
        //   controller: panelController,
        //   borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        //   // panel: const PanelComponent(),
        //   panelBuilder: (sc) => PanelComponent(
        //     controller: sc,
        //   ),
        //   minHeight: height,
        //   maxHeight: 350,
        //   backdropEnabled: true,
        //   backdropTapClosesPanel: true,
        //   parallaxEnabled: false,
        //   backdropOpacity: 0.0,
        //   collapsed: PannelCollapsComponent(height: height),
        //   body: Container(
        //     margin: const EdgeInsets.only(top: 10, bottom: 150),
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(4),
        //       border: Border.all(color: borderColor),
        //       color: Colors.white,
        //     ),
        //     child:

        //   ),
        // body: _buildBody(),
        );
  }
}
