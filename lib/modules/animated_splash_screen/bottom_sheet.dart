import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class BottomSheetWidget extends StatelessWidget {
  const BottomSheetWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            TextButton(
                onPressed: () {
                  _showActionSheet(context);
                },
                child: Text('data'))
          ],
        ),
      ),
    );
  }

  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        // title: const Text(''),
        // message: const Text(''),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {},
            child: Row(
              children: const [
                Icon(
                  Icons.image,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 10,
                ),
                Text('Gallery')
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {},
            child: Row(
              children: const [
                Icon(
                  Icons.camera_alt,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 10,
                ),
                Text('Camera')
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {},
            child: Row(
              children: const [
                Icon(
                  Icons.video_collection_rounded,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 10,
                ),
                Text('Video')
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {},
            child: Row(
              children: const [
                Icon(
                  Icons.my_library_books_sharp,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 10,
                ),
                Text('Document')
              ],
            ),
          ),
          CupertinoActionSheetAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as delete or exit and turns
            /// the action's text color to red.
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
