import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/place_picker.dart';

class LocationPickerPage extends StatelessWidget {
  LocationPickerPage({Key? key}) : super(key: key);
  final _startSearchFieldController = TextEditingController();
  final _endSearchFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _startSearchFieldController,
                autofocus: false,
                style: TextStyle(fontSize: 24),
                decoration: InputDecoration(
                  hintText: 'Starting Point',
                  hintStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                  ),
                  filled: true,
                  fillColor: Colors.green[200],
                  border: InputBorder.none,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                style: TextStyle(fontSize: 24),
                controller: _endSearchFieldController,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'End Point',
                  hintStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                  ),
                  filled: true,
                  fillColor: Colors.green[200],
                  border: InputBorder.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void showPlacePicker() async {
  //   LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
  //       builder: (context) => PlacePicker(
  //             "YOUR API KEY",
  //             displayLocation: 28.3111, 70.1261,
  //           )));

  //   // Handle the result in your way
  //   print(result);
  // }
}
