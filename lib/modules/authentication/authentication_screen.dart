import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants.dart';
import '../../../utils/k_images.dart';
import '../../../widgets/custom_image.dart';
import 'widgets/sign_in_form.dart';
import 'widgets/sign_up_form.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
              stops: [.5, 1],
              colors: [Colors.white, Color(0xffFFEFE7)],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  Padding(
                    padding:  EdgeInsets.only(left: Get.width*0.04),
                    child: Image.asset("assets/icons/delivery-boy.png",height: Get.height*0.1,),
                  ),
                  const SizedBox(height: 5),
                  _buildHeader(),
                  const SizedBox(height: 13),
                  _buildTabText(),

                  SizedBox(
                    height: 650,
                    child: PageView(
                      physics: const ClampingScrollPhysics(),
                      controller: _pageController,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      children: const [SigninForm(), SignUpForm()],
                    ),
                  )
                  // _buildSigninForm()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return AnimatedContainer(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.topLeft,
      duration: kDuration,
      child: Text(
        _currentPage == 0 ? 'Welcome back!' : 'Create Account',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
      ),
    );
  }

  Widget _buildTabText() {
    const tabunSelectedtextColor = Color(0xff797979);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              _pageController.animateToPage(0,
                  duration: kDuration, curve: Curves.bounceInOut);
            },
            child: Text(
              'Sign In',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color:
                      _currentPage == 0 ? blackColor : tabunSelectedtextColor),
            ),
          ),
          Container(
            color: borderColor,
            width: 1,
            height: 20,
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
          InkWell(
            onTap: () {
              _pageController.animateToPage(1,
                  duration: kDuration, curve: Curves.bounceInOut);
            },
            child: Text(
              'Sign Up',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color:
                      _currentPage == 1 ? blackColor : tabunSelectedtextColor),
            ),
          ),
        ],
      ),
    );
  }
}
