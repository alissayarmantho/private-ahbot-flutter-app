import 'package:botapp/constants.dart';
import 'package:botapp/controllers/call_analytic_controller.dart';
import 'package:botapp/controllers/contact_controller.dart';
import 'package:botapp/controllers/user_controller.dart';
import 'package:botapp/models/user.dart';
import 'package:botapp/widgets/app_header.dart';
import 'package:botapp/widgets/contact_card.dart';
import 'package:botapp/widgets/numpad.dart';
import 'package:botapp/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

// The numpad breaks in smaller screen, I am not sure why I can't use
// SingleScrollView, it is not necessary for now because the tablet screen
// size is fixed, but it would be nice to fix this.
// TODO: Figure this out
class ContactScreen extends StatelessWidget {
  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final User currentUser = Get.find<UserController>().currentUser.value;
    final Size size = MediaQuery.of(context).size;
    final ContactController contactController =
        Get.put<ContactController>(ContactController());
    Get.put<CallAnalyticController>(CallAnalyticController(
        callType: "voice")); // currently only supports voice call
    contactController.fetchAllContacts(elderId: currentUser.id);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AppHeader(
        key: key,
        hasLogOut: true,
        hasBackButton: true,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Container(
              width: size.width * 0.5,
              padding: EdgeInsets.fromLTRB(40, 80, 40, 80),
              child: Numpad(
                key: UniqueKey(),
                buttonTextSize: 50,
                buttonColor: Colors.white,
                textColor: Colors.black,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(40, 80, 40, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: SvgPicture.asset(
                              'assets/icons/contact_person.svg'),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: SearchBar(
                            controller: contactController,
                            textController: _searchController,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => contactController.isLoading.value
                        ? Expanded(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : contactController.contactList.length == 0
                            ? Container(
                                width: size.width * 0.415,
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                                padding: const EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                  color: kPrimaryLightColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(40),
                                  ),
                                ),
                                child: Text("No contacts available ..."),
                              )
                            : Expanded(
                                child: (ListView.builder(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 20, 20, 80),
                                    itemCount: contactController
                                        .filteredContactList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        child: Center(
                                          child: ContactCard(
                                            name: contactController
                                                .filteredContactList[index]
                                                .name,
                                            number: contactController
                                                .filteredContactList[index]
                                                .number,
                                          ),
                                        ),
                                      );
                                    })),
                              ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
