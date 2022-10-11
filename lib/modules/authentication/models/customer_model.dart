import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerModel {
  String? id;
  String? name;
  String? email;
  String? phone;
  GeoPoint? location;
  String? address;
  String? profileImage;
  String? tokenId;
  CustomerModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.location,
    this.profileImage,
    this.address,
    this.tokenId,
  });

  CustomerModel.fromSnapshot(DocumentSnapshot data) {
    id = data.id;
    address = data["address"] ?? '';
    name = data['name'] ?? '';
    email = data['email'] ?? '';
    phone = data['phone'] ?? '';
    location = data['location'] ?? const GeoPoint(0, 0);
    profileImage = data['profileImage'] ?? '';
    // tokenId = data['tokenId'] ?? '';
  }
}
//import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerDetailModel {
  String? id;
  String? name;
  String? email;
  String? phone;
  GeoPoint? location;
  String? address;
  String? profileImage;
  String? deliveryBoyId;
  String? status;
  Timestamp? time;
  String? customerId;

  CustomerDetailModel({
    this.customerId,
    this.time,
    this.status,
    this.deliveryBoyId,
    this.address,
    this.id,
    this.name,
    this.email,
    this.phone,
    this.location,
    this.profileImage,
  });
  CustomerDetailModel.fromSnapshot(DocumentSnapshot data) {
    id = data.id;

    customerId = data['customer_Id'] ?? "";
    deliveryBoyId = data['delivery_boy_id'] ?? "";
    status = data['status'] ?? "";
    time = data["time"] ?? "";
    name = data['name'] ?? '';
    email = data['email'] ?? '';
    phone = data['phone'] ?? '';
    location = data['location'] ?? '';
    address = data['address'] ?? '';
    profileImage = data['profileImage'] ?? '';
  }
}
