// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:foodbari_deliver_app/utils/constants.dart';
// // import 'package:get_it/get_it.dart';
// // import 'package:places_service/places_service.dart';

// class LocationSearch extends StatefulWidget {
//   final GlobalKey<ScaffoldState> scaffoldKey;
//   final Function onSelected;

//   LocationSearch({
//     Key? key,
//     required this.scaffoldKey,
//     required this.onSelected,
//   }) : super(key: key);

//   @override
//   _LocationSearchState createState() => _LocationSearchState();
// }

// // GetIt? getIt = GetIt.instance;

// class _LocationSearchState extends State<LocationSearch> {
//   // final PlacesService _placesService = getIt!<PlacesService>();
//   // // final LocationService _locationService = getIt!<LocationService>();
//   // List<PlacesAutoCompleteResult> _autoCompleteResults = [];
//   // final PlacesService _placesService = getIt!<PlacesService>();
//   final TextEditingController _addressController = TextEditingController();
//   late final GlobalKey<ScaffoldState> homeScaffoldKey;
//   late OverlayEntry? _entry;
//   late FocusNode _focusNode;
//   bool isSearching = false;
//   bool isSearchingLocation = false;
//   // PlacesAutoCompleteResult _selectedPlace = PlacesAutoCompleteResult();

//   @override
//   void initState() {
//     _focusNode = FocusNode();
//     homeScaffoldKey = widget.scaffoldKey;
//     WidgetsBinding.instance?.addPostFrameCallback((_) => showOverlay());
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _focusNode.dispose();
//     _addressController.dispose();
//     super.dispose();
//   }

//   void showOverlay() {
//     final overlay = Overlay.of(context);
//     final renderBox = context.findRenderObject() as RenderBox;
//     final size = renderBox.size;
//     final offset = renderBox.localToGlobal(Offset.zero);
//     _entry = OverlayEntry(
//       builder: (context) => Positioned(
//         left: offset.dx,
//         top: offset.dy + size.height + 5.0,
//         width: size.width,
//         child: buildOverlay(),
//       ),
//     );
//     overlay!.insert(_entry!);
//   }

//   Widget buildOverlay() => _autoCompleteResults.isNotEmpty
//       ? SizedBox(
//           height: MediaQuery.of(context).size.height * 0.25,
//           child: Material(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10.0),
//             ),
//             elevation: 8,
//             child: ListView.builder(
//                 itemCount: _autoCompleteResults.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   PlacesAutoCompleteResult result = _autoCompleteResults[index];
//                   return GestureDetector(
//                     onTap: () {
//                       widget.onSelected(result);
//                       _addressController.clear();
//                       setState(() {
//                         _autoCompleteResults = [];
//                       });
//                       _focusNode.unfocus();
//                     },
//                     child: ListTile(
//                       leading: const Icon(Icons.location_on),
//                       title: Text(result.mainText!),
//                       subtitle: Text(result.secondaryText!),
//                     ),
//                   );
//                 }),
//           ),
//         )
//       : Container();

//   Future<void> _getAutoCompleteResults() async {
//     setState(() {
//       isSearching = true;
//     });
//     try {
//       if (_addressController.text.isNotEmpty) {
//         final results =
//             await _placesService.getAutoComplete(_addressController.text);

//         if (results.isNotEmpty) {
//           setState(() {
//             _autoCompleteResults = results;
//           });
//         }
//       }
//       setState(() {
//         isSearching = false;
//       });
//     } catch (e) {
//       setState(() {
//         isSearching = false;
//       });
//       // ScaffoldMessenger.of(context).showSnackBar(
//       //   SnackBar(
//       //     content: const Text(
//       //       'Trouble retrieving locations',
//       //       style: TextStyle(color: Colors.white),
//       //     ),
//       //     backgroundColor: Colors.red.shade800,
//       //   ),
//       // );
//       // print('Error get Places: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var width = MediaQuery.of(context).size.width;
//     var height = MediaQuery.of(context).size.height;
//     return Container(
//       decoration: BoxDecoration(
//         // color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       width: double.infinity,
//       child: Column(
//         children: [
//           Form(
//             child: Card(
//               elevation: 10,
//               color: Colors.white,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10)),
//               child: TextFormField(
//                 focusNode: _focusNode,
//                 onChanged: (value) => _getAutoCompleteResults(),
//                 controller: _addressController,
//                 decoration: InputDecoration(
//                   fillColor: Colors.transparent,
//                   contentPadding:
//                       const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide.none,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   hintText: ('searchDestination'),
//                   hintStyle: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20,
//                       color: Colors.black),
//                   suffixIcon: _addressController.text.isNotEmpty
//                       ? isSearching
//                           ? Transform.scale(
//                               scale: 0.5,
//                               child: const CircularProgressIndicator(
//                                 valueColor:
//                                     AlwaysStoppedAnimation(primaryColor),
//                               ),
//                             )
//                           : IconButton(
//                               icon:
//                                   const Icon(Icons.clear, color: Colors.black),
//                               onPressed: () {
//                                 _addressController.clear();
//                                 setState(() {
//                                   _autoCompleteResults = [];
//                                 });
//                                 _focusNode.unfocus();
//                               },
//                             )
//                       : const Icon(
//                           CupertinoIcons.search,
//                         ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _setSelectedPlace(PlacesAutoCompleteResult place) async {
//     setState(() {
//       isSearchingLocation = true;
//     });
//     PlacesDetails placeDetails =
//         await _placesService.getPlaceDetails(place.placeId!);

//     String origin = '28.310350' ',' ' 70.127403';
//     String destination =
//         placeDetails.lat.toString() + ',' + placeDetails.lng.toString();
//     // placeDetails.
//     //directions = await _locationService.getDirections(origin, destination);
//     // destinationPin(placeDetails.lat, placeDetails.lng);
//     // var d = await calculateDistance(
//     //   _currentPosition.latitude,
//     //   _currentPosition.longitude,
//     //   placeDetails.lat,
//     //   placeDetails.lng,
//     // );
//     // rider.set_ride_add(
//     //     _currentPosition.latitude,
//     //     _currentPosition.longitude,
//     //     placeDetails.lat,
//     //     placeDetails.lng,
//     //     _mapLocation.formattedAddress,
//     //     place.secondaryText!,
//     //     d);
//     setState(() {
//       _selectedPlace = place;
//       // _polylineCoordinates = directions.polylinePoints
//       //     .map((e) => LatLng(e.latitude, e.longitude))
//       //     .toList();
//     });
//     setState(() {
//       isSearchingLocation = false;
//     });

//     //selectVehicleBottomSheet(directions: directions);

//     //_showSheet(directions: directions);
//   }
// }
