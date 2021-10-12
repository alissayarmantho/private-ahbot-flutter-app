import 'package:botapp/widgets/home_page_notification_card.dart';
import 'package:flutter/material.dart';
import 'package:botapp/screens/CaregiverHomePage/background.dart';
import 'package:botapp/widgets/custom_icon_button.dart';

class CaregiverHomePage extends StatelessWidget {
  const CaregiverHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var notificationList = [];
    return Scaffold(
      body: Background(
        key: UniqueKey(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 70,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                CustomIconButton(
                  key: UniqueKey(),
                  hasTitle: true,
                  hasDescription: true,
                  title: "45",
                  description: "mins",
                  svgAssetPath: 'assets/icons/music.svg',
                  press: () {
                    // Get.to(() => MusicPlayerScreen());
                  },
                ),
                CustomIconButton(
                  key: UniqueKey(),
                  hasTitle: true,
                  hasDescription: true,
                  title: "1.5",
                  description: "hours",
                  svgAssetPath: 'assets/icons/photos.svg',
                  press: () {
                    // Get.to(() => GalleryScreen());
                  },
                ),
                CustomIconButton(
                  key: UniqueKey(),
                  hasTitle: true,
                  hasDescription: true,
                  title: "21",
                  description: "hours",
                  svgAssetPath: 'assets/icons/contact.svg',
                  press: () {
                    // launch('tel:0');
                  },
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Flexible(
              child: ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [Colors.transparent, Colors.black],
                  ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                },
                blendMode: BlendMode.dstIn,
                child: Container(
                  // TODO: Should probably use ListBuilder if there is pagination
                  padding: EdgeInsets.only(left: 40, right: 40),
                  child: notificationList.length == 0
                      ? HomePageNoticationCard(
                          startTime: "😊",
                          title: "There is no notification for today",
                          icon: Icons.celebration,
                        )
                      : (ListView(
                          shrinkWrap: true,
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
                          children: [
                            HomePageNoticationCard(
                              startTime: "1.00 PM",
                              title: "Appointment with Doctor",
                              icon: Icons.calendar_today,
                            ),
                            HomePageNoticationCard(
                              startTime: "7.00 AM",
                              title: "Call with Jenna",
                              icon: Icons.call,
                            ),
                            HomePageNoticationCard(
                              startTime: "6.30 PM",
                              title: "Reminder to eat medicine",
                              icon: Icons.medication,
                            ),
                            HomePageNoticationCard(
                              startTime: "7.30 PM",
                              title: "Son's birthday",
                              icon: Icons.cake,
                            ),
                            HomePageNoticationCard(
                              startTime: "8.30 PM",
                              title: "Reminder to take blood pressure medicine",
                              icon: Icons.medication,
                            ),
                          ],
                        )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
