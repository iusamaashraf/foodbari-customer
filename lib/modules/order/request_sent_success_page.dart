import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodbari_deliver_app/modules/main_page/main_page.dart';
import 'package:foodbari_deliver_app/widgets/primary_button.dart';
import 'package:get/get.dart';

class RequestSentSuccessPage extends StatelessWidget {
  const RequestSentSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/images/order_success.svg'),
            SizedBox(
              height: size.height * 0.05,
            ),
            Text(
              'Order Successfully \nPlaced',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: size.height * 0.1,
            ),
            SizedBox(
              width: size.width * 0.5,
              child: PrimaryButton(
                  text: "Back to Home",
                  onPressed: () {
                    Get.offAll(() => MainPage());
                  }),
            )
          ],
        ),
      ),
    );
  }
}
