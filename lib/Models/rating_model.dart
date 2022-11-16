import 'package:cloud_firestore/cloud_firestore.dart';

class RatingModel {
  String? reviews;
  double? star;
  String? customerId;
  String? customerName;
  String? customerImage;
  RatingModel({this.customerId, this.reviews, this.star});
  RatingModel.fromSnapshot(DocumentSnapshot data) {
    reviews = data['reviews'] ?? "";
    star = data["stars"] ?? 0.0;
    customerId = data['customerId'];
    customerName = data['customer_name'] ?? '';
    customerImage = data['customer_image'] ?? '';
  }
}
