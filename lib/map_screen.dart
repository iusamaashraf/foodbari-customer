import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:foodbari_deliver_app/Controllers/request_controller.dart';
import 'package:foodbari_deliver_app/Models/all_request_model.dart';
import 'package:foodbari_deliver_app/modules/authentication/controller/customer_controller.dart';
import 'package:foodbari_deliver_app/modules/authentication/models/customer_model.dart';
import 'package:foodbari_deliver_app/modules/main_page/main_page.dart';
import 'package:foodbari_deliver_app/modules/order/model/rider_data_model.dart';
import 'package:foodbari_deliver_app/utils/constants.dart';
import 'package:foodbari_deliver_app/widgets/app_bar_leading.dart';
import 'package:foodbari_deliver_app/widgets/primary_button.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:url_launcher/url_launcher_string.dart';
import 'dart:ui' as ui;

class MapScreen extends StatefulWidget {
  MapScreen({
    Key? key,
    required this.pickLat,
    required this.pickLng,
    required this.dropLat,
    required this.dropLng,
    // required this.orderId,
    required this.modelData,
    required this.rating,
    // required this.destinationLng,
  }) : super(key: key);
  double pickLat;
  double pickLng;
  double dropLat;
  double dropLng;
  // String orderId;
  RiderDataModel modelData;
  double rating;
  //final double destinationLng;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

// LocationData? currentLocation;
GoogleMapController? googleMapController;
final authController = Get.put(CustomerController());
final requestController = Get.put(RequestController());

class _MapScreenState extends State<MapScreen> {
  // static LatLng sourceLocation = LatLng(authController.deliveryBoyLat.value,
  //     authController.deliveryBoyLong.value);

  List<LatLng> polylineCoordinates = [];

  LatLng? destination;
  LatLng? origin;
  Future<void> getPolyPoints() async {
    destination = LatLng(widget.dropLat, widget.dropLng);
    origin = LatLng(widget.pickLat, widget.pickLng);

    PolylinePoints polylinePoints = PolylinePoints();
    // PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        // APIClass().API,
        'AIzaSyAzr66eCsT-AfdfVw5zoFG0guIHFOeIDr0',
        PointLatLng(widget.pickLat, widget.pickLng),
        PointLatLng(widget.dropLat, widget.dropLng));
    print("result points is: ${result.points}");

    // print(
    //     'Lattitude:${PointLatLng(authController.currentLocation!.latitude!, authController.currentLocation!.longitude!)}');
    if (result.points.isNotEmpty) {
      print('it is working');
      // ignore: avoid_function_literals_in_foreach_calls
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        print('print :$polylineCoordinates');
        // FirebaseFirestore.instance
        //     .collection("delivery_boy")
        //     .doc(FirebaseAuth.instance.currentUser!.uid)
        //     .update({'location': GeoPoint(point.latitude, point.longitude)});
        setState(() {});
      });

      setState(() {});
    }
  }

  // bool isLoading = false;
  @override
  void initState() {
    Timer(Duration(seconds: 2), () async {
      print("callllllllllllll dictance");
      await calDistance();
      setState(() {});
    });
    getPolyPoints();
    calDistance();

    sourcePick();
    dropLocation();
    currentLocation();
    super.initState();
  }

  sourcePick() async {
    source = await getBytesFromAsset('assets/icons/startingpoint.png', 100);
  }

  dropLocation() async {
    drop = await getBytesFromAsset('assets/icons/pin.png', 100);
  }

  currentLocation() async {
    current = await getBytesFromAsset('assets/icons/delivery.png', 100);
  }

  var source;
  var drop;
  var current;
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  // BitmapDescriptor? source;
  // BitmapDescriptor? destinations;
  // BitmapDescriptor? currentLocation;

  calDistance() {
    Timer.periodic(const Duration(seconds: 10), (timer) {
      print("lattiude value is:${authController.currentLocation!.latitude!}");
      print("logn value is:${authController.currentLocation!.longitude!}");
      print('Drop lat is: ${widget.dropLat}');
      print('Drop lng is: ${widget.dropLng}');
      print("callllllll");
      requestController.distance(
        pickLat: authController.currentLocation!.latitude!,
        pickLng: authController.currentLocation!.longitude!,
        // pickLng: widget.pickLng,
        dropLat: widget.dropLat,
        dropLng: widget.dropLng,
      );
      //  requestController.distanceModel();
    });
    print("URL is:${requestController.distanceModel.value}");
  }

  bool isSelected = true;

  @override
  Widget build(BuildContext context) {
    // getPolyPoints();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SizedBox(
      height: size.height,
      width: size.width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          requestController.distances != null
              ? GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(widget.pickLat, widget.pickLng),
                    zoom: 0.5,
                    tilt: 80,
                  ),
                  polylines: {
                    Polyline(
                        polylineId: const PolylineId("new"),
                        points: polylineCoordinates,
                        color: Colors.red,
                        width: 10),
                  },
                  markers: {
                    Marker(
                      icon: BitmapDescriptor.fromBytes(source),
                      markerId: const MarkerId("source"),
                      position: LatLng(
                        widget.pickLat,
                        widget.pickLng,
                        // widget.pickLng,
                      ),
                    ),
                    Marker(
                        icon: BitmapDescriptor.fromBytes(current),
                        markerId: const MarkerId("currentLocation"),
                        position: LatLng(
                            authController.currentLocation!.latitude!,
                            authController.currentLocation!.longitude!)),
                    Marker(
                      icon: BitmapDescriptor.fromBytes(drop),
                      markerId: const MarkerId("destinations"),
                      position: destination!,
                    ),
                  },
                  onMapCreated: (mapController) {
                    authController.googleMapController = mapController;
                    //  authController.controllerCompleter.complete(mapController);
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
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
                              //  Text(
                              //           requestController
                              //               .distanceModel
                              //               .value!
                              //               .rows![0]
                              //               .elements![0]
                              //               .duration!
                              //               .text!,
                              //           style: Theme.of(context)
                              //               .textTheme
                              //               .subtitle1!
                              //               .copyWith(
                              //                 color: Colors.black,
                              //                 fontWeight: FontWeight.bold,
                              //               )),
                              Obx(() {
                                return requestController.distanceModel.value !=
                                        null
                                    ? Text(
                                        requestController
                                            .distanceModel
                                            .value!
                                            .rows![0]
                                            .elements![0]
                                            .duration!
                                            .text!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1!
                                            .copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ))
                                    : Container(
                                        child: Text('Loading'),
                                      );
                              })
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
                                widget.modelData.profileImage!.isNotEmpty
                                    ? CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(
                                            widget.modelData.profileImage!))
                                    : const CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(
                                            "https://cdn.techjuice.pk/wp-content/uploads/2015/02/wallpaper-for-facebook-profile-photo-1024x645.jpg"),
                                      ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.modelData.rider_name!,
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
                                          size: 20,
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          widget.rating.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1!
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
                                  onTap: () async {
                                    String _sms =
                                        'sms:0030012345678&body= Hi Welcome to foodbari customer';

                                    if (await UrlLauncher.canLaunchUrl(
                                        Uri.parse(_sms))) {
                                      print("entered");
                                      await UrlLauncher.launchUrl(
                                          Uri.parse(_sms));
                                    }

                                    print("Presseeeeeeeeeeeeed");
                                    // launchUrlString(
                                    //     'sms:+92 30012345678?body= Hi Welcome to foodbari customer');
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
                                  onTap: _callNumber,
                                  // onTap: () async {
                                  //   launchUrlString('tel:+92 30012345678');
                                  // },
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
          // here is the time
          Positioned(
            top: size.height * 0.15,
            child: Container(
              padding: EdgeInsets.all(12),
              // height: size.height * 0.05,
              // width: size.width * 0.3,
              decoration: BoxDecoration(
                  color: redColor, borderRadius: BorderRadius.circular(100)),
              child: Center(
                child: Obx(() {
                  return requestController.distanceModel.value != null
                      ? Text(
                          requestController.distanceModel.value!.rows![0]
                              .elements![0].distance!.text!,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                        )
                      : Container(
                          child: Text('Loading'),
                        );
                }),
              ),
            ),
          )
        ],
      ),
    ));
  }

  _callNumber() async {
    const number = '08592119XXXX'; //set the number here
    var res = await FlutterPhoneDirectCaller.callNumber(number);
  }
}
