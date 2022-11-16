// import 'dart:convert';
// import 'dart:io';

// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:foodbari_deliver_app/Controllers/request_controller.dart';
// import 'package:foodbari_deliver_app/modules/order/model/my_product_model.dart';
// import 'package:foodbari_deliver_app/modules/order/new_request.dart';
// import 'package:foodbari_deliver_app/modules/order/product_controller/add_to_cart_controller.dart';
// import 'package:foodbari_deliver_app/modules/order/product_controller/product_controller.dart';
// import 'package:foodbari_deliver_app/modules/order/show_delivery_boy_detail_page.dart';
// import 'package:foodbari_deliver_app/recieved_request/received_request_page.dart';
// import 'package:foodbari_deliver_app/sent_request/sent_request_page.dart';
// import 'package:foodbari_deliver_app/widgets/primary_button.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';
// import '../../router_name.dart';
// import '../../utils/constants.dart';
// import '../../widgets/rounded_app_bar.dart';
// import 'component/cart_item_header.dart';
// import 'component/cart_product_list.dart';
// import 'component/panel_widget.dart';
// import 'model/product_model.dart';

// class OrderDetailsPage extends StatefulWidget {
//   const OrderDetailsPage({
//     Key? key,
//     // required this.productList,
//   }) : super(key: key);
//   // final List<ProductModel> productList;

//   @override
//   State<OrderDetailsPage> createState() => _OrderDetailsPageState();
// }

// class _OrderDetailsPageState extends State<OrderDetailsPage> {
//   final panelController = PanelController();
//   RequestController requestController = Get.put(RequestController());
//   final double height = 145;
//   final headerStyle =
//       const TextStyle(fontSize: 16, fontWeight: FontWeight.w600);

//   @override
//   void initState() {
//     Get.put(RequestController());

//     super.initState();
//   }

//   List<Widget> _pages = [
//     SentRequestPage(),
//     RecievedRequestPage(),
//   ];

//   int selectedIndex = 0;
//   @override
//   Widget build(BuildContext context) {
//     // final width = MediaQuery.of(context).size.width - 40;
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       floatingActionButton: Padding(
//         padding: EdgeInsets.only(bottom: size.height * 0.1),
//         child: GestureDetector(
//           onTap: () {
//             Get.to(() => NewRequestScreen());
//           },
//           child: const CircleAvatar(
//             radius: 25,
//             backgroundColor: redColor,
//             child: Icon(
//               Icons.add,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//       appBar: RoundedAppBar(
//         isLeading: false,
//         titleText: 'Requests',
//       ),
//       body: Column(
//         children: [
//           SizedBox(
//             height: size.height * 0.05,
//           ),
//           Padding(
//             padding:  EdgeInsets.symmetric(horizontal: size.width*0.02),
//             child: Row(
//               children: [
//                 tabs(
//                   'Sent',
//                   0,
//                 ),
//                 tabs('Received', 1),
//               ],
//             ),
//           ),
//           Expanded(
//             child: _pages[selectedIndex],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget tabs(String text, int index) {
//     Size size = MediaQuery.of(context).size;
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedIndex = index;
//         });
//       },
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 400),
//         padding: const EdgeInsets.all(8),
//         // height: size.height * 0.03,
//         width: size.width * 0.48,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.only(
//                 topRight: index == 1
//                     ? const Radius.circular(8)
//                     : const Radius.circular(0),
//                 bottomRight: index == 1
//                     ? const Radius.circular(8)
//                     : const Radius.circular(0),
//                 topLeft: index == 0
//                     ? const Radius.circular(8)
//                     : const Radius.circular(0),
//                 bottomLeft: index == 0
//                     ? const Radius.circular(8)
//                     : const Radius.circular(0)),
//             color:selectedIndex==index? Colors.red:null,
//             border: Border.all(color: Colors.red)),
//         child: Center(
//           child: Text(text,
//               style: Theme.of(context).textTheme.subtitle1!.copyWith(
//                   color: index == selectedIndex ? Colors.white : blackColor)),
//         ),
//       ),
//     );
//   }
// }
