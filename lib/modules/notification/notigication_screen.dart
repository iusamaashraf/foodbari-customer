import 'package:flutter/material.dart';
import '../../dummy_data/all_dymmy_data.dart';
import '../../utils/constants.dart';
import '../../widgets/rounded_app_bar.dart';
import 'component/empty_notification.dart';
import 'component/notification_list.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RoundedAppBar(
        isLeading: true,
        // bgColor: Colors.white,
        titleText: 'Notification',
        textColor: blackColor,
      ),

      ///dumy dala list notificationList
      body: notificationList.isEmpty
          ? const EmptyNotification()
          : NotificationList(notificationList: notificationList),
    );
  }
}
