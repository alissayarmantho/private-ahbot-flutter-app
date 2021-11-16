import 'package:botapp/controllers/auth_controller.dart';
import 'package:botapp/controllers/registration_controller.dart';
import 'package:botapp/models/auth.dart';
import 'package:botapp/widgets/app_header.dart';
import 'package:botapp/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrationScreen extends GetWidget<AuthController> {
  final accountType = ["caregiver", "elder"];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final ratio = 0.43;
    final RegistrationController regController =
        Get.put(RegistrationController());

    return Scaffold(
      body: AppHeader(
        key: key,
        hasLogOut: false,
        hasBackButton: true,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(40, 40, 40, 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Sign up for an account",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 35),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: size.width * ratio,
                              child: TextFormField(
                                controller: _firstNameController,
                                style: TextStyle(fontSize: 18),
                                decoration: InputDecoration(
                                  hintText: 'First Name',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'First name cannot be empty';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              width: size.width * ratio,
                              child: TextFormField(
                                controller: _lastNameController,
                                style: TextStyle(fontSize: 18),
                                decoration: InputDecoration(
                                  hintText: 'Last Name',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Last name cannot be empty';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                            hintText: 'Create Password',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Password cannot be empty';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                              child: Text("Account Type"),
                            ),
                            Obx(
                              () => DropdownButton(
                                value: regController.selected.value,
                                icon: Icon(Icons.keyboard_arrow_down),
                                items: accountType.map((String item) {
                                  return DropdownMenuItem(
                                      value: item, child: Text(item));
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    regController.setSelected(newValue);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Obx(
                          () => PrimaryButton(
                            key: UniqueKey(),
                            text: "Register",
                            isLoading: controller.isLoading.value,
                            widthRatio: 1,
                            press: () {
                              if (_formKey.currentState!.validate()) {
                                controller.register(
                                    newAccount: Account(
                                        id: "",
                                        firstName: _firstNameController.text,
                                        lastName: _lastNameController.text,
                                        email: _emailController.text,
                                        accountType:
                                            regController.selected.value),
                                    password: _passwordController.text);
                              }
                            },
                          ),
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
    );
  }
}
