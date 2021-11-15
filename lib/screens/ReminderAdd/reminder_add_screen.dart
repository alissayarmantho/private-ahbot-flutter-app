import 'package:botapp/constants.dart';
import 'package:botapp/widgets/app_header.dart';
import 'package:botapp/widgets/zero_result.dart';
import 'package:flutter/material.dart';

class ReminderAddScreen extends StatelessWidget {
  const ReminderAddScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: AppHeader(
        key: UniqueKey(),
        hasLogOut: true,
        hasBackButton: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(50, 15, 0, 10),
                    child: Text(
                      "Notifications",
                      style: TextStyle(
                          fontWeight: FontWeight.w800, color: kPrimaryColor),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 15, 150, 10),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: kPrimaryColor,
                      child: IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 0.05 * size.height,
                  ),
                  ZeroResult(text: "There is no upcoming notifications...")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
