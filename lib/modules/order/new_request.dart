import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:math' show cos, sqrt, asin;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodbari_deliver_app/Controllers/request_controller.dart';
import 'package:foodbari_deliver_app/Models/autocomplete_prediction.dart';
import 'package:foodbari_deliver_app/utils/constants.dart';
import 'package:foodbari_deliver_app/widgets/location_list_tile.dart';
import 'package:foodbari_deliver_app/widgets/network_utility.dart';
import 'package:foodbari_deliver_app/widgets/primary_button.dart';
import 'package:foodbari_deliver_app/widgets/rounded_app_bar.dart';
import 'package:get/get.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:image_picker/image_picker.dart';

import '../../Models/place_autocomplete_response.dart';

class NewRequestScreen extends StatefulWidget {
  const NewRequestScreen({Key? key}) : super(key: key);

  @override
  State<NewRequestScreen> createState() => _NewRequestScreenState();
}

class _NewRequestScreenState extends State<NewRequestScreen> {
  GlobalKey<FormState> key = GlobalKey<FormState>();

  // <<<<<<< ======================= for auto suggestion location picker ========================>>>>>>>>>>>>>>
  List<AutocompletePrediction> placePredictions = [];
  TextEditingController pickController = TextEditingController();
  TextEditingController dropController = TextEditingController();
  var pickLat;
  var dropLat = 0.0;
  var pickLng = 0.0;
  var dropLng = 0.0;
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

  LatLon pickLatLong = LatLon(0.0, 0.0);
  RequestController requestController = Get.put(RequestController());
  Future<Image> convertFileToImage(File picture) async {
    List<int> imageBase64 = picture.readAsBytesSync();
    String imageAsString = base64Encode(imageBase64);
    Uint8List uint8list = base64.decode(imageAsString);
    var image = Image.memory(uint8list);
    setState(() {
      requestController.requestImage = image as File;
    });
    // print('MY image is $myImage');
    return image;
  }

  Future pickImage(ImageSource sr) async {
    try {
      final image = await ImagePicker().pickImage(source: sr);
      if (image == null) {}
      final imageTemporary = File(image!.path);
      setState(() {
        requestController.requestImage = imageTemporary;
        (File(image.path));
        print('The image is${(File(image.path))}');
      });
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print('failed to pick image: $e');
    }
  }

  showOptionDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          //for picking video functionality
          SimpleDialogOption(
            onPressed: () {
              pickImage(ImageSource.gallery);
              Get.back();
            },
            child: Row(
              children: [
                const Icon(Icons.image, color: Colors.grey),
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Text('Gallery',
                      style: Theme.of(context).textTheme.subtitle1!),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              pickImage(ImageSource.camera);
              Get.back();
            },
            child: Row(
              children: [
                const Icon(Icons.camera_alt, color: Colors.grey),
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Text('Camera',
                      style: Theme.of(context).textTheme.subtitle1!),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Get.back(),
            child: Row(
              children: [
                const Icon(Icons.cancel, color: Colors.grey),
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Text('Cancel',
                      style: Theme.of(context).textTheme.subtitle1!),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  bool isPick = false;
  bool ishowPrediction = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: RoundedAppBar(titleText: 'New Request', isLeading: true),
      body: SizedBox(
        height: size.height,
        child: SingleChildScrollView(
            child: Form(
                key: key,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        TextFormField(
                          controller: requestController.titleController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter Title';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Please Enter Title',
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        TextFormField(
                            maxLines: 5,
                            controller: requestController.descriptionController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Discription';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                hintText: 'Enter Discription...')),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: requestController.priceController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Price';
                            } else if (!GetUtils.isNum(value)) {
                              return "Invalid Price";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Enter Price (i.e 200.50)',
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        TextFormField(
                          controller: pickController,
                          onChanged: (value) async {
                            isPick = true;
                            ishowPrediction = true;
                            placeAutoComplete(value);
                            final geocoding = GoogleMapsGeocoding(
                                apiKey:
                                    'AIzaSyAzr66eCsT-AfdfVw5zoFG0guIHFOeIDr0');
                            final response = await geocoding
                                .searchByPlaceId(placePredictions[0].placeId!);
                            var result = response.results[0];
                            pickLat = result.geometry.location.lat;
                            pickLng = result.geometry.location.lng;
                          },
                          textInputAction: TextInputAction.search,
                          decoration: const InputDecoration(
                            hintText: "Pick location",
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        TextFormField(
                          controller: dropController,
                          onChanged: (value) async {
                            isPick = false;
                            ishowPrediction = true;
                            placeAutoComplete(value);
                            final geocoding = GoogleMapsGeocoding(
                                apiKey:
                                    'AIzaSyAzr66eCsT-AfdfVw5zoFG0guIHFOeIDr0');
                            final response = await geocoding
                                .searchByPlaceId(placePredictions[0].placeId!);
                            var result = response.results[0];
                            dropLat = result.geometry.location.lat;
                            dropLng = result.geometry.location.lng;
                            // print(
                            //     "getting latlng: ${result.geometry.location.lat}");
                            // GoogleGeocoding(
                            //     'AIzaSyAzr66eCsT-AfdfVw5zoFG0guIHFOeIDr0');

                            // var result =
                            //     googleGeoCoding.geocoding.get(value, []);

                            // var addresses = await Geocoder.local
                            //     .findAddressesFromQuery(result);
                            // print("object: $result");
                            //  pickLatLong=LatLon(result, longitude);
                          },
                          textInputAction: TextInputAction.search,
                          decoration: const InputDecoration(
                            hintText: "Drop location",
                          ),
                        ),
                        ishowPrediction
                            ? SizedBox(
                                // height: size.height * 0.1,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: placePredictions.length,
                                  itemBuilder: (context, index) =>
                                      LocationListTile(
                                    press: () {
                                      if (isPick == true) {
                                        pickController.text =
                                            placePredictions[index]
                                                .description!;
                                      } else {
                                        dropController.text =
                                            placePredictions[index]
                                                .description!;
                                      }

                                      ishowPrediction = false;
                                      setState(() {});
                                    },
                                    location:
                                        placePredictions[index].description!,
                                  ),
                                ),
                              )
                            : SizedBox(),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        GestureDetector(
                          onTap: () {
                            showOptionDialog(context);
                          },
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(15),
                            color: redColor,
                            strokeWidth: 2,
                            child: SizedBox(
                              height: size.height * 0.17,
                              width: size.width - 30,
                              child: requestController.requestImage != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.file(
                                        requestController.requestImage!,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    )
                                  : Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            CupertinoIcons.add_circled_solid,
                                            color: redColor,
                                          ),
                                          SizedBox(
                                            width: size.width * 0.02,
                                          ),
                                          const Text("Select Image")
                                        ],
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        PrimaryButton(
                            text: "Submit Request",
                            onPressed: () {
                              if (key.currentState!.validate()) {
                                var totalDistance = calculateDistance(
                                    pickLat, pickLng, dropLat, dropLng);
                                double price = 0.0;
                                if (totalDistance <= 1.0) {
                                  price = 10.0;
                                } else if (totalDistance > 1.0 &&
                                    totalDistance < 5.0) {
                                  price = 30.0;
                                } else {
                                  price = 50.0;
                                }
                                requestController.submitRequest(
                                  context: context,
                                  pickAddress: pickController.text,
                                  dropAddress: dropController.text,
                                  pickLocation: GeoPoint(pickLat, pickLng),
                                  dropLocation: GeoPoint(dropLat, dropLng),
                                  distance: totalDistance,
                                  deliveryFee: price,
                                );
                              }
                              // if (requestController.requestImage != null) {

                              // } else {
                              //   Get.snackbar("Alert",
                              //       "Please Select image of your product");
                              // }
                            })
                      ],
                    ),
                  ),
                ))),
      ),
    );
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
