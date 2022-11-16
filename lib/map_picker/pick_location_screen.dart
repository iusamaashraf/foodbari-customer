import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodbari_deliver_app/Controllers/request_controller.dart';
import 'package:foodbari_deliver_app/Models/autocomplete_prediction.dart';
import 'package:foodbari_deliver_app/Models/place_autocomplete_response.dart';
import 'package:foodbari_deliver_app/utils/constants.dart';
import 'package:foodbari_deliver_app/widgets/location_list_tile.dart';
import 'package:foodbari_deliver_app/widgets/network_utility.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:map_picker/map_picker.dart';

// ignore: must_be_immutable
class PickLocationScreen extends StatefulWidget {
  PickLocationScreen({
    Key? key,
    required this.pickLatlong,
    required this.dropLatlong,
    required this.isPick,
  }) : super(key: key);
  LatLng pickLatlong;
  LatLng dropLatlong;
  bool isPick;

  @override
  _PickLocationScreenState createState() => _PickLocationScreenState();
}

class _PickLocationScreenState extends State<PickLocationScreen> {
  final _controller = Completer<GoogleMapController>();

  RequestController requestController = Get.put(RequestController());
  MapPickerController mapPickerController = MapPickerController();
  // TextEditingController pickController = TextEditingController();
  // TextEditingController dropController = TextEditingController();
  bool isPick = false;
  bool ishowPrediction = false;
  var pickLng = 0.0;
  var pickLat;
  List<AutocompletePrediction> placePredictions = [];
  void placeAutoComplete(String query) async {
    Uri uri =
        Uri.https("maps.googleapis.com", 'maps/api/place/autocomplete/json', {
      "input": query,
      "key": apiKey,
    });
    String? response = await NetworkUtilitiy.fetchUrl(uri);

    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parseAutocompleteResult(response);

      if (result.predictions != null) {
        setState(() {
          // print(response);
          PlaceAutocompleteResponse result =
              PlaceAutocompleteResponse.parseAutocompleteResult(response);
          if (result != null) {
            setState(() {
              placePredictions = result.predictions!;
            });
          }
        });
      }
    }
  }

  // var textController = TextEditingController();
  late GoogleMapController mapController;
  assignController() async {
    mapController = await _controller.future;
  }

  @override
  void initState() {
    assignController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition cameraPosition = CameraPosition(
      target: widget.pickLatlong,
      zoom: 14.4746,
    );
    setState(() {});
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          MapPicker(
            // pass icon widget
            iconWidget: SvgPicture.asset(
              "assets/icons/location_icon.svg",
              height: 40,
            ),
            //add map picker controller
            mapPickerController: mapPickerController,
            child: GoogleMap(
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              // hide location button
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              //  camera position
              initialCameraPosition: cameraPosition,

              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onCameraMoveStarted: () {
                // notify map is moving
                mapPickerController.mapMoving!();
                widget.isPick
                    ? requestController.pickLocationController.text =
                        "Please Wait ..."
                    : requestController.dropLocationController.text;
                _controller.complete;
              },
              onCameraMove: (camPosition) {
                cameraPosition = camPosition;
              },
              onCameraIdle: () async {
                // notify map stopped moving
                mapPickerController.mapFinishedMoving!();
                //get address name from camera position
                List<Placemark> placemarks = await placemarkFromCoordinates(
                  widget.isPick
                      ? cameraPosition.target.latitude
                      : cameraPosition.target.latitude,
                  widget.isPick
                      ? cameraPosition.target.longitude
                      : cameraPosition.target.longitude,
                );
                widget.isPick
                    ? requestController.pickLatLng = LatLng(
                        cameraPosition.target.latitude,
                        cameraPosition.target.longitude)
                    : requestController.dropLatLng = LatLng(
                        cameraPosition.target.latitude,
                        cameraPosition.target.longitude);
                print("now lat is new: ${cameraPosition.target.latitude}");
                print("now lng is new :${cameraPosition.target.longitude}");
                // update the ui with the address
                widget.isPick
                    ? requestController.pickLocationController.text =
                        '${placemarks.first.name}, ${placemarks.first.administrativeArea}, ${placemarks.first.country}'
                    : requestController.dropLocationController.text =
                        '${placemarks.first.name}, ${placemarks.first.administrativeArea}, ${placemarks.first.country}';
                // requestController.pickLocationController.text =
                //     cameraPosition.target.latitude.toString();
              },
            ),
          ),

          // =================================== TextField =================================================
          Positioned(
            top: MediaQuery.of(context).viewPadding.top + 60,
            width: MediaQuery.of(context).size.width - 50,
            child: TextFormField(
              onTap: () {
                // Get.to(() => const PickLocationScreen())!.then((value) {
                //   setState(() {});
                // });
              },
              controller: widget.isPick
                  ? requestController.pickLocationController
                  : requestController.dropLocationController,
              // readOnly: true,
              onChanged: (value) async {
                // widget.isPick = true;
                ishowPrediction = true;
                placeAutoComplete(value);
                final geocoding = GoogleMapsGeocoding(
                    apiKey: 'AIzaSyAzr66eCsT-AfdfVw5zoFG0guIHFOeIDr0');
                final response = await geocoding
                    .searchByPlaceId(placePredictions[0].placeId!);
                var result = response.results[0];
                pickLat = result.geometry.location.lat;
                pickLng = result.geometry.location.lng;
                widget.isPick
                    ? requestController.pickLatLng = LatLng(
                        result.geometry.location.lat,
                        result.geometry.location.lng)
                    : requestController.dropLatLng = LatLng(
                        result.geometry.location.lat,
                        result.geometry.location.lng);
              },
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: widget.isPick
                    ? requestController.pickLocationController.text.isNotEmpty
                        ? requestController.pickLocationController.text
                        : requestController.pickLocationController.text
                    : requestController.dropLocationController.text.isNotEmpty
                        ? requestController.dropLocationController.text
                        : requestController.dropLocationController.text,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 1 / 5,
            child: ishowPrediction
                ? Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: placePredictions.length,
                      itemBuilder: (context, index) => LocationListTile(
                        press: () async {
                          final geocoding = GoogleMapsGeocoding(
                              apiKey:
                                  'AIzaSyAzr66eCsT-AfdfVw5zoFG0guIHFOeIDr0');
                          final response = await geocoding.searchByPlaceId(
                              placePredictions[index].placeId!);
                          var result = response.results[index];
                          //   pickLng = result.geometry.location.lng;
                          if (widget.isPick == true) {
                            requestController.pickLocationController.text =
                                placePredictions[index].description!;
                            widget.pickLatlong = LatLng(
                              result.geometry.location.lat,
                              result.geometry.location.lng,
                            );
                            requestController.pickLatLng = LatLng(
                              result.geometry.location.lat,
                              result.geometry.location.lng,
                            );
                            setState(() {});
                            print(
                                "pick screen pick${requestController.pickLatLng!.latitude}");

                            mapController.animateCamera(
                                CameraUpdate.newLatLngZoom(
                                    LatLng(result.geometry.location.lat,
                                        result.geometry.location.lng),
                                    14));

                            // final  mPlace = .get(0);
                            FocusScope.of(context).unfocus();
                          } else {
                            requestController.dropLocationController.text =
                                placePredictions[index].description!;
                            widget.dropLatlong = LatLng(
                                result.geometry.location.lat,
                                result.geometry.location.lng);
                            requestController.dropLatLng = LatLng(
                              result.geometry.location.lat,
                              result.geometry.location.lng,
                            );
                            print(
                                "pick screen drop${requestController.dropLatLng!.latitude}");
                            setState(() {});

                            mapController.animateCamera(
                                CameraUpdate.newLatLngZoom(
                                    LatLng(result.geometry.location.lat,
                                        result.geometry.location.lng),
                                    14));

                            // final  mPlace = .get(0);
                            FocusScope.of(context).unfocus();
                          }

                          ishowPrediction = false;
                          setState(() {});
                        },
                        location: placePredictions[index].description!,
                      ),
                    ),
                  )
                : SizedBox(),
          ),
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: SizedBox(
              height: 50,
              child: TextButton(
                child: const Text(
                  "Pick Location",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    color: Color(0xFFFFFFFF),
                    fontSize: 19,
                    height: 19 / 19,
                  ),
                ),
                onPressed: () {
                  requestController.lat = cameraPosition.target.latitude;
                  requestController.lng = cameraPosition.target.longitude;
                  print(
                      "New Location ${requestController.lat} ${requestController.lng}");

                  print(
                      "Location ${cameraPosition.target.latitude} ${cameraPosition.target.longitude}");
                  print(
                      "Address: ${requestController.pickLocationController.text}");
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xFFA3080C)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
