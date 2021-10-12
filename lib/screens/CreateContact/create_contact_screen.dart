import 'package:botapp/controllers/contact_controller.dart';
import 'package:botapp/controllers/user_controller.dart';
import 'package:botapp/models/user.dart';
import 'package:botapp/widgets/app_header.dart';
import 'package:botapp/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//TODO: Support multiple elders choice. Currently a caregiver is assumed
// to only have one elder attached to him
class CreateContactScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _numberController = TextEditingController();
  final _countryCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final User currentUser = Get.find<UserController>().currentUser.value;
    final ContactController contactController =
        Get.put<ContactController>(ContactController());
    final ratio = 0.43;

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
                        "Create Contact",
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
                          controller: _countryCodeController,
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                            hintText: 'Country Code',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Country code cannot be empty';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: TextFormField(
                          controller: _numberController,
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                            hintText: 'Phone Number',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Phone number cannot be empty';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Obx(
                          () => PrimaryButton(
                            key: UniqueKey(),
                            text: "Create",
                            isLoading: contactController.isLoading.value,
                            widthRatio: 1,
                            press: () {
                              contactController.createContact(
                                  name: _firstNameController.text +
                                      " " +
                                      _lastNameController.text,
                                  number: _numberController.text,
                                  countryCode: _countryCodeController.text,
                                  elderId: currentUser.elderIds.length > 0
                                      ? currentUser.elderIds[0]
                                      // This will trigger an error as there is
                                      // no elder linked to the current caregiver
                                      // Currently it will default to creating contact
                                      // for potato
                                      : "61547e49adbc3d0023ab129c");
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
