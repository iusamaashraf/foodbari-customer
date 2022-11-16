import 'package:flutter/material.dart';
import 'package:foodbari_deliver_app/Controllers/request_controller.dart';
import 'package:foodbari_deliver_app/modules/authentication/controller/customer_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../router_name.dart';
import '../../../utils/constants.dart';
import '../../../utils/k_images.dart';
import '../../../widgets/custom_image.dart';

class ProfileAppBar extends StatefulWidget {
  final double height;

  ProfileAppBar({Key? key, this.height = 174}) : super(key: key);

  @override
  State<ProfileAppBar> createState() => _ProfileAppBarState();
}

class _ProfileAppBarState extends State<ProfileAppBar> {
  CustomerController controller = Get.put(CustomerController());

  RequestController orderController = Get.put(RequestController());
  // @override
  // void initState() {
  //   orderController.activeFunc();
  //   orderController.pendingFunc();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SizedBox(
        height: widget.height,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _buildUserInfo(context),
            Positioned(
              top: -37,
              left: 30,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white.withOpacity(.09),
              ),
            ),
            Positioned(
              top: -10,
              left: -50,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white.withOpacity(.09),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 20,
              right: 20,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xff333333).withOpacity(.18),
                        blurRadius: 70),
                  ],
                ),
                child: Container(
                  alignment: Alignment.center,
                  height: 100,
                  child: Obx(
                    () => Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _headerItem(
                          orderController.activeList.value!.length.toString(),
                          'Active',
                          () {},
                        ),
                        _headerItem(
                          orderController.pending!.length.toString(),
                          'Pending',
                          () {},
                        ),
                        _headerItem(
                          orderController.cancelList.value!.length.toString(),
                          'Cancelled',
                          () {},
                        ),
                        _headerItem(
                          orderController.compList.value!.length.toString(),
                          'Delivered',
                          () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _headerItem(String icon, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              color: const Color(0xffE8EEF2),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: FittedBox(
                child: Text(
                  icon,
                  style: GoogleFonts.roboto(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: redColor,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(text)
        ],
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    final statusbar = MediaQuery.of(context).padding.top;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      height: widget.height - 62,
      decoration: const BoxDecoration(
        color: redColor,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(25),
        ),
      ),
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          SizedBox(height: statusbar),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             
              Obx(
                () => Row(
                  children: [
                    Text(
                      controller.customerModel.value!.name!,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, RouteNames.profileEditScreen);
                      },
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.transparent,
                        backgroundImage: controller
                                    .customerModel.value!.profileImage !=
                                ""
                            ? NetworkImage(
                                controller.customerModel.value!.profileImage!)
                            : const NetworkImage(
                                "https://cdn.techjuice.pk/wp-content/uploads/2015/02/wallpaper-for-facebook-profile-photo-1024x645.jpg"),
                      ),
                      // CircleAvatar(
                      //   radius: 24,
                      //   backgroundColor: Colors.transparent,
                      //   backgroundImage: NetworkImage(
                      //       controller.customerModel.value!.profileImage!),
                      // ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
