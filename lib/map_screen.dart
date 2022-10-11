// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:foodbari_deliver_app/modules/authentication/controller/customer_controller.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';

// class MapScreen extends StatefulWidget {
//   const MapScreen({
//     Key? key,
//     required this.destinationLat,
//     required this.destinationLng,
//   }) : super(key: key);
//   final double destinationLat;
//   final double destinationLng;

//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }

// LocationData? currentLocation;
// final customerController = Get.put(CustomerController());

// class _MapScreenState extends State<MapScreen> {
//   final Completer<GoogleMapController> _controller = Completer();
//   static LatLng sourceLocation =
//       LatLng(currentLocation!.latitude!, currentLocation!.longitude!);

//   List<LatLng> polylineCoordinates = [];

//   Future<void> getCurrentLocation() async {
//     Location location = Location();

//     location.getLocation().then(
//       (location) {
//         currentLocation = location;
//       },
//     );

//     GoogleMapController googleMapController = await _controller.future;
//     location.onLocationChanged.listen(
//       (newLoc) {
//         currentLocation = newLoc;
//         googleMapController.animateCamera(
//           CameraUpdate.newCameraPosition(
//             CameraPosition(
//               zoom: 13.5,
//               target: LatLng(newLoc.latitude!, newLoc.longitude!),
//             ),
//           ),
//         );
//         setState(() {});
//       },
//     );
//   }

//   LatLng? destination;
//   Future<void> getPolyPoints() async {
//     destination = LatLng(widget.destinationLat, widget.destinationLng);
//     PolylinePoints polylinePoints = PolylinePoints();
//     // PolylinePoints polylinePoints = PolylinePoints();
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//         // APIClass().API,
//         'AIzaSyB3obNU-etSFBmOde_ZLDCeSk3QFngjBVk',
//         PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
//         PointLatLng(widget.destinationLat, widget.destinationLng));
//     print(result.points);
//     // PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//     //   APIClass().API,
//     //   PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
//     //   PointLatLng(destination.latitude, destination.longitude),
//     // );
//     print(
//         'Lattitude:${PointLatLng(sourceLocation.latitude, sourceLocation.longitude)}');
//     if (result.points.isNotEmpty) {
//       print('it is working');
//       // ignore: avoid_function_literals_in_foreach_calls
//       result.points.forEach((PointLatLng point) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//         FirebaseFirestore.instance
//             .collection("Customer")
//             .doc(customerController.auth.currentUser!.uid)
//             .update({'location': GeoPoint(point.latitude, point.longitude)});
//       });

//       setState(() {});
//     }
//   }

// @override
// void initState() {
//   getCurrentLocation();
//   getPolyPoints();
//   super.initState();
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: currentLocation == null
//           ? const Center(child: Text("Loading"))
//           : FutureBuilder(
//               future: getCurrentLocation(),
//               builder: (context, snapshot) {
//                 return GoogleMap(
//                   initialCameraPosition: CameraPosition(
//                       target: LatLng(currentLocation!.latitude!,
//                           currentLocation!.longitude!),
//                       zoom: 12.5),
//                   polylines: {
//                     Polyline(
//                         polylineId: const PolylineId("route"),
//                         points: polylineCoordinates,
//                         color: Colors.green,
//                         width: 6),
//                   },
//                   markers: {
//                     Marker(
//                       markerId: const MarkerId("currentLocation"),
//                       position: LatLng(currentLocation!.latitude!,
//                           currentLocation!.longitude!),
//                     ),
//                     Marker(
//                       markerId: const MarkerId("source"),
//                       position: sourceLocation,
//                     ),
//                     Marker(
//                       markerId: MarkerId("destination"),
//                       position: destination!,
//                     ),
//                   },
//                   onMapCreated: (mapController) {
//                     _controller.complete(mapController);
//                   },
//                 );
//               }),
//     );
//   }
// }

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:foodbari_deliver_app/modules/authentication/controller/customer_controller.dart';
import 'package:foodbari_deliver_app/modules/main_page/main_page.dart';
import 'package:foodbari_deliver_app/utils/constants.dart';
import 'package:foodbari_deliver_app/widgets/app_bar_leading.dart';
import 'package:foodbari_deliver_app/widgets/primary_button.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    Key? key,
    required this.destinationLat,
    required this.destinationLng,
  }) : super(key: key);
  final double destinationLat;
  final double destinationLng;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

// LocationData? currentLocation;
final authController = Get.put(CustomerController());

class _MapScreenState extends State<MapScreen> {
  // static LatLng sourceLocation = LatLng(authController.deliveryBoyLat.value,
  //     authController.deliveryBoyLong.value);

  List<LatLng> polylineCoordinates = [];

  // Future<void> getCurrentLocation() async {
  //   Location location = Location();

  //   location.getLocation().then(
  //     (location) {
  //       currentLocation = location;
  //     },
  //   );

  //   location.onLocationChanged.listen(
  //     (newLoc) {
  //       currentLocation = newLoc;
  //       googleMapController.animateCamera(
  //         CameraUpdate.newCameraPosition(
  //           CameraPosition(
  //             zoom: 13.5,
  //             target: LatLng(newLoc.latitude!, newLoc.longitude!),
  //           ),
  //         ),
  //       );
  //       setState(() {});
  //     },
  //   );
  // }

  LatLng? destination;
  Future<void> getPolyPoints() async {
    destination = LatLng(widget.destinationLat, widget.destinationLng);
    PolylinePoints polylinePoints = PolylinePoints();
    // PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        // APIClass().API,
        'AIzaSyCdxcIGtCz91p1KHSRqH2FmPKP8-wJwc5c',
        PointLatLng(authController.currentLocation!.latitude!,
            authController.currentLocation!.longitude!),
        PointLatLng(destination!.latitude, destination!.longitude));
    print(result.points);

    print(
        'Lattitude:${PointLatLng(authController.currentLocation!.latitude!, authController.currentLocation!.longitude!)}');
    if (result.points.isNotEmpty) {
      print('it is working');
      // ignore: avoid_function_literals_in_foreach_calls
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        // FirebaseFirestore.instance
        //     .collection("delivery_boy")
        //     .doc(FirebaseAuth.instance.currentUser!.uid)
        //     .update({'location': GeoPoint(point.latitude, point.longitude)});
        setState(() {});
      });

      setState(() {});
    }
  }

  @override
  void initState() {
    getPolyPoints();
    super.initState();
  }

  bool isSelected = true;

  Future<void> CALL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "cannot launch $url";
    }
  }

  launchurl() async {
    const url = 'https://www.youtube.com/channel/UCS3brcF49FE3japE2xM-8gg';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "cannot launch $url";
    }
  }

  launchEmail() async {
    launch(
      'mailto:cp277478@gmail.com?subject=TestEmail&body= Subscribe webfun please',
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SizedBox(
      height: size.height,
      width: size.width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          authController.currentLocation == null
              ? const Center(child: Text("Loading"))
              : FutureBuilder(
                  future: getPolyPoints(),
                  builder: (context, snapshot) {
                    return GoogleMap(
                      initialCameraPosition: CameraPosition(
                          target: LatLng(
                              authController.currentLocation!.latitude!,
                              authController.currentLocation!.longitude!),
                          zoom: 16.5),
                      polylines: {
                        Polyline(
                            polylineId: const PolylineId("route"),
                            points: polylineCoordinates,
                            color: Colors.green,
                            width: 6),
                      },
                      markers: {
                        Marker(
                          markerId: const MarkerId("currentLocation"),
                          position: LatLng(
                            authController.currentLocation!.latitude!,
                            authController.currentLocation!.longitude!,
                          ),
                        ),
                        // Marker(
                        //     markerId: const MarkerId("source"),
                        //     position: LatLng(
                        //         authController.currentLocation!.latitude!,
                        //         authController.currentLocation!.longitude!)),
                        Marker(
                          markerId: const MarkerId("destination"),
                          position: destination!,
                        ),
                      },
                      onMapCreated: (mapController) {
                        authController.googleMapController = mapController;
                        //  authController.controllerCompleter.complete(mapController);
                      },
                    );
                  }),
          AnimatedPositioned(
            curve: Curves.fastOutSlowIn,
            height: isSelected ? size.height * 0.25 : size.height * 0.24,
            width: size.width * 0.9,
            duration: const Duration(
              seconds: 1,
            ),
            bottom: 20,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isSelected = !isSelected;
                });
              },
              child: Container(
                // height: size.height * 0.3,

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tracking Location',
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Delivery Time',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                              Text(
                                '14:32',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      isSelected
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const CircleAvatar(
                                  radius: 25,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'jenny Wilson',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    //rating
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: redColor,
                                          size: 15,
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          '3.9',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    launchUrlString(
                                        'sms:+92 30012345678?body= Hi Welcome to foodbari customer');
                                  },
                                  child: Container(
                                    height: size.height * 0.05,
                                    width: size.width * 0.1,
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: const Center(
                                      child: Icon(
                                        Icons.chat,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    launchUrlString('tel:+92 30012345678');
                                  },
                                  child: Container(
                                    height: size.height * 0.05,
                                    width: size.width * 0.1,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.phone,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 10,
                      ),
                      isSelected
                          ? Align(
                              child: SizedBox(
                                  width: size.width * 0.5,
                                  child: PrimaryButton(
                                      text: 'Go to Home',
                                      onPressed: () {
                                        Get.offAll(() => MainPage());
                                      })),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: size.height * 0.04,
            child: Container(
              height: size.height * 0.1,
              width: size.width * 0.95,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  color: redColor),
            ),
          ),
          // const Positioned(
          //   left: -21,
          //   top: -10,
          //   child: CircleAvatar(
          //     radius: 50,
          //     backgroundColor: redColor,
          //   ),
          // ),
          Positioned(
            left: 40,
            top: -10,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white.withOpacity(0.06),
            ),
          ),
          Positioned(
            left: 20,
            top: 40,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white.withOpacity(0.06),
            ),
          ),
          Positioned(
            left: size.width * 0.05,
            top: size.height * 0.07,
            child: Row(
              children: [
                const AppbarLeading(),
                const SizedBox(
                  width: 10,
                ),
                Text("Order Status",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold))
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
