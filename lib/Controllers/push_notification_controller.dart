import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodbari_deliver_app/modules/authentication/controller/customer_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PushNotificationsController extends GetxController {
  void sendPushMessage(String token, String body, String title) async {
    try {
      //POST METHOD FOR PUSH NOTIFICATIONS (FIREBASE CLOUD MESSAGING)
      //THE AUTHORIZATION KEY IS FROM FIREBASE CLOUD MESSAGING SECTION (SERVER KEY)
      await http
          .post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAxAa4P1A:APA91bGsA7nwv-KBW1QUtC9ECeC5x0bfiKLZH2_cBWfOz7XcdYTSo2qDNHJKhUAsMTVIIuWttCnrv4JC3MaGJfk40MqzTaqSOAY8LHPOWYyn1oZ-xYod_yfzlhrguTFO6jqBcvNjjPqO',
        },
        //IT IS GIVING THE NOTIFICATION THE BODY AND TITLE
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
              "sound": "notification.mp3"
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
              'sound': true
            },
            //TOKEN IS UNIQUE FOR EVERY USER DEVICE THROUGH WHICH THE NOTIFICATION COMES
            "to": token,
          },
        ),
      )
          .then((value) {
        print("Successfully Send ${value.body}");
      });
    } catch (e) {
      print("error push notification");
    }
  }

  void sendPushImageMessage(
      String token, String body, String title, String? image) async {
    try {
      //POST METHOD FOR PUSH NOTIFICATIONS (FIREBASE CLOUD MESSAGING)
      //THE AUTHORIZATION KEY IS FROM FIREBASE CLOUD MESSAGING SECTION (SERVER KEY)
      await http
          .post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAdCc8tSI:APA91bHc-zU6VHnBwpACLAynUue5dIraDtkeC4UrKg_DmvViLAwgnKgOgQ5WXozAa6hiYEdISUomZ2qqpRjXzYU6FiCEjSIOAI8EIFN6FN_36B2p_tv1KNoJ54E6zc39COTx78Bm__9M',
        },
        //IT IS GIVING THE NOTIFICATION THE BODY AND TITLE
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
              "image": image,
              "sound": "notification.mp3"
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
              'sound': true
            },
            //TOKEN IS UNIQUE FOR EVERY USER DEVICE THROUGH WHICH THE NOTIFICATION COMES
            "to": token,
          },
        ),
      )
          .then((value) {
        print("Successfully Send ${value.body}");
      });
    } catch (e) {
      print("error push notification");
    }
  }

  //SEND LIKE NOTIFICATION
  Future<void> sendLikeNotification(
      String receiverUID,
      String senderName,
      String senderImage,
      String imgURL,
      bool isTrainer,
      String postTitle) async {
    String notifyBody = "$senderName liked your post";
    if (receiverUID != Get.find<CustomerController>().user!.uid) {
      if (isTrainer) {
        //IF THE POST UPLOADER IS TRAINER
        await FirebaseFirestore.instance
            .collection("Trainers")
            .doc(receiverUID)
            .collection("Notifications")
            .add({
          "Body": notifyBody,
          "View": false,
          "SenderName": senderName,
          "SenderImage": senderImage,
          "PostImage": imgURL,
          "PostTitle": postTitle,
          "Date": DateTime.now().toString()
        }).then((value) {
          FirebaseFirestore.instance
              .collection("Trainers")
              .doc(receiverUID)
              .get()
              .then((value) => sendPushImageMessage(
                  value["FCMtoken"], notifyBody, "BBM fitness", imgURL));
        });
      } else {
        //IF THE POST UPLOADER IS USER

        await FirebaseFirestore.instance
            .collection("Users")
            .doc(receiverUID)
            .collection("Notifications")
            .add({
          "Body": notifyBody,
          "SenderName": senderName,
          "View": false,
          "SenderImage": senderImage,
          "PostImage": imgURL,
          "PostTitle": postTitle,
          "Date": DateTime.now().toString()
        }).then((value) {
          FirebaseFirestore.instance
              .collection("UserTokens")
              .where("UID", isEqualTo: receiverUID)
              .get()
              .then((value) => sendPushImageMessage(
                  value.docs[0]["Token"], notifyBody, "BBM fitness", imgURL));
        });
      }
    } else {
      print("Your own post");
    }
  }

  //SEND COMMENT NOTIFICATIOn
  Future<void> sendCommentNotification(
      String receiverUID,
      String senderName,
      String senderImage,
      String imgURL,
      bool isTrainer,
      String postTitle) async {
    String notifyBody = "$senderName commented on your post";
    if (receiverUID != Get.find<CustomerController>().user!.uid) {
      if (isTrainer) {
        //IF THE POST UPLOADER IS TRAINER
        await FirebaseFirestore.instance
            .collection("Trainers")
            .doc(receiverUID)
            .collection("Notifications")
            .add({
          "Body": notifyBody,
          "SenderName": senderName,
          "SenderImage": senderImage,
          "PostImage": imgURL,
          "PostTitle": postTitle,
          "Date": DateTime.now().toString()
        }).then((value) {
          FirebaseFirestore.instance
              .collection("Trainers")
              .doc(receiverUID)
              .get()
              .then((value) => sendPushImageMessage(
                  value["FCMtoken"], notifyBody, "BBM fitness", imgURL));
        });
      } else {
        //IF THE POST UPLOADER IS USER
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(receiverUID)
            .collection("Notifications")
            .add({
          "Body": notifyBody,
          "SenderName": senderName,
          "SenderImage": senderImage,
          "PostImage": imgURL,
          "PostTitle": postTitle,
          "Date": DateTime.now().toString()
        }).then((value) {
          FirebaseFirestore.instance
              .collection("UserTokens")
              .where("UID", isEqualTo: receiverUID)
              .get()
              .then((value) => sendPushImageMessage(
                  value.docs[0]["Token"], notifyBody, "BBM fitness", imgURL));
        });
      }
    } else {
      print("Your own post");
    }
  }
}
