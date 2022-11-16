import 'package:cloud_firestore/cloud_firestore.dart';

class GetRequestModel {
  String? id;
  String? address;
  // ignore: non_constant_identifier_names
  String? delivery_boy_id;
  String? email;
  String? image;
  GeoPoint? location;
  String? name;
  // ignore: non_constant_identifier_names
  String? offer_id;
  String? phone;
  String? offerDiscription;
  String? offerPrice;

  GetRequestModel({
    this.id,
    this.address,
    // ignore: non_constant_identifier_names
    this.delivery_boy_id,
    this.email,
    this.image,
    this.location,
    this.name,
    // ignore: non_constant_identifier_names
    this.offer_id,
    this.phone,
    this.offerDiscription,
    this.offerPrice,
  });
  GetRequestModel.fromSnapshot(DocumentSnapshot data) {
    print("Delivery boy id is:${data['delivery_boy_id']}");
    id = data.id;
    address = data['address'] ?? '';
    delivery_boy_id = data['delivery_boy_id'] ?? '';
    email = data['email'] ?? '';
    image = data['image'] ?? '';
    location = data['location'] ?? '';
    name = data['name'] ?? '';
    offer_id = data['offer_id'] ?? '';
    phone = data['phone'] ?? '';
    offerDiscription = data['offerDiscription'] ?? '';
    offerPrice = data['offerPrice'] ?? '';
    //  print("Delivery boy id is:$address");
  }
}
