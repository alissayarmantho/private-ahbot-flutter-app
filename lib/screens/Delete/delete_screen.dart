import 'package:botapp/constants.dart';
import 'package:botapp/widgets/app_header.dart';
import 'package:botapp/widgets/zero_result.dart';
import 'package:flutter/material.dart';

class DeleteScreen extends StatelessWidget {
  const DeleteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var mediaList = [];
    return Scaffold(
      body: AppHeader(
        key: UniqueKey(),
        hasLogOut: false,
        hasBackButton: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(50, 15, 0, 10),
                child: Text(
                  "Delete",
                  style: TextStyle(
                      fontWeight: FontWeight.w800, color: kPrimaryColor),
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 0.05 * size.height,
                  ),
                  ZeroResult(text: "You have not uploaded any media...")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
