import 'package:botapp/constants.dart';
import 'package:flutter/material.dart';

class HomePageNotificationCard extends StatelessWidget {
  final String title, startTime;
  final IconData icon;
  final Color iconColor;
  const HomePageNotificationCard({
    Key? key,
    required this.title,
    required this.startTime,
    required this.icon,
    this.iconColor = kPrimaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: kPrimaryLightColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(65),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(65),
            bottomRight: Radius.circular(65),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: 20,
            ),
            Text(
              startTime,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 20,
            ),
            Flexible(
              child: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(icon, color: iconColor),
          ],
        ));
  }
}
