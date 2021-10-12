import 'package:flutter/material.dart';
import 'package:botapp/screens/AboutUs/about_us_screen.dart';
import 'package:botapp/screens/Login/login_screen.dart';
import 'package:botapp/screens/Registration/registration_screen.dart';
import 'package:botapp/screens/Launch/background.dart';
import 'package:botapp/widgets/primary_button.dart';
import 'package:botapp/widgets/secondary_button.dart';
import 'package:botapp/constants.dart';
import 'package:get/get.dart';

class LaunchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        key: UniqueKey(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: Image.asset(
                    "assets/sun.png",
                  ),
                ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Text(
                      "Robo-companion",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                      ),
                    ),
                  ),
                  flex: 13,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: SecondaryButton(
                    key: UniqueKey(),
                    text: "Register",
                    widthRatio: 0.25,
                    color: Colors.transparent,
                    borderColor: kPrimaryColor,
                    textColor: kPrimaryColor,
                    press: () {
                      Get.to(() => RegistrationScreen());
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: PrimaryButton(
                    key: UniqueKey(),
                    text: "Login",
                    widthRatio: 0.25,
                    press: () {
                      Get.to(() => LoginScreen());
                    },
                  ),
                ),
              ],
            ),
            TextButton(
              child: Text('Learn More'),
              onPressed: () {
                Get.to(() => AboutUsScreen());
              },
            )
          ],
        ),
      ),
    );
  }
}
