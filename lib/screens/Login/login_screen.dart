import 'package:botapp/controllers/auth_controller.dart';
import 'package:botapp/screens/ResetPassword/reset_password_screen.dart';
import 'package:botapp/widgets/app_header.dart';
import 'package:botapp/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends GetWidget<AuthController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: AppHeader(
        key: UniqueKey(),
        hasLogOut: false,
        hasBackButton: true,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.fromLTRB(40, 40, 40, 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Login",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                    child: TextFormField(
                      controller: _emailController,
                      style: TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        hintText: 'Email Address',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      // TODO: Add validation
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Email cannot be empty';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: TextFormField(
                      controller: _passwordController,
                      style: TextStyle(fontSize: 18),
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      // TODO: Add validation
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Password cannot be empty';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    width: size.width,
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Obx(
                          () => PrimaryButton(
                            key: UniqueKey(),
                            text: "Login",
                            isLoading: controller.isLoading.value,
                            widthRatio: 0.4,
                            press: () {
                              if (_formKey.currentState!.validate()) {
                                controller.login(
                                    email: _emailController.text,
                                    password: _passwordController.text);
                              }
                            },
                          ),
                        ),
                        Obx(
                          () => TextButton(
                            child: Text(
                              'Forgot Password ?',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            onPressed: controller.isLoading.value
                                ? null
                                : () {
                                    Get.to(() => ResetPasswordScreen());
                                  },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
