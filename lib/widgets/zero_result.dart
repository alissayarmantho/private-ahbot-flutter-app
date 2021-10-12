import 'package:flutter/material.dart';

class ZeroResult extends StatelessWidget {
  final String text;
  const ZeroResult({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 0.4 * size.width,
            height: 0.4 * size.height,
            child: Image.asset(
              'assets/cutefaces/owo.png',
            ),
          ),
          SizedBox(
            height: 0.05 * size.height,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
            child: Text(
              text,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
