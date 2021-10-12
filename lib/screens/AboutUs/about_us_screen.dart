import 'package:flutter/material.dart';
import 'package:botapp/screens/AboutUs/background.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final topPadding = 50.0;
    return Scaffold(
      body: Background(
        key: UniqueKey(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(20, topPadding, 20, 20),
                child: Text(
                  "You're in good company",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 2 * topPadding, 0, 20),
                width: 0.8 * size.width,
                child: Text(
                  'Robo-companion was created to be a friendly, engaging tabletop' +
                      ' pet for seniors, and a bridge for communication between the' +
                      ' older generation and their family. Being part of the younger' +
                      ' generation, we know how it feels to miss your' +
                      ' parents/grandparents. But checking in with them all the' +
                      ' time can be highly time consuming and simply not feasible.' +
                      ' The pandemic especially has accentuated the importance of' +
                      ' spending quality time and making every memory count.' +
                      ' \n\nNow, you are just a click apart.',
                  textAlign: TextAlign.center,
                ),
              ),
              TextButton(
                child: Text('Contact us for demo'),
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
