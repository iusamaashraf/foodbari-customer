// import 'dart:convert';

// import 'package:http/http.dart' as http;

// class LocationService {
//   // Get Directions from Google Maps API with place_id
//   Future<Directions> getDirections(String origin, String destination) async {
//     Uri url = Uri.parse(
//       'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$googleDirectionsApiKey',
//     );
//     http.Response response = await http.get(url);
//     Map<String, dynamic> jsonResponse = json.decode(response.body);
//     return Directions.fromMap(jsonResponse);
//   }

//   Future<MapLocation> getLocation(double lat, double long) async {
//     Uri uri = Uri.parse(
//         'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$googleMapsApiKey');
//     var response = await http.get(uri);
//     var data = json.decode(response.body);

//     List<dynamic> results = data['results'];

//     MapLocation address = MapLocation(
//       formattedAddress: results[0]['formatted_address'],
//       placeId: results[0]['place_id'],
//       placeName: results[0]['address_components'][1]['long_name'],
//     );

//     return address;
//   }
// }
