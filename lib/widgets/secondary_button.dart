import 'package:flutter/material.dart';
import 'package:botapp/constants.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback press;
  final Color color, borderColor, textColor;
  final double widthRatio;

  const SecondaryButton({
    required Key key,
    required this.text,
    required this.press,
    required this.widthRatio,
    this.color = Colors.transparent,
    this.borderColor = kPrimaryColor,
    this.textColor = kPrimaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * widthRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
              primary: borderColor,
              backgroundColor: color,
              side: BorderSide(color: borderColor, width: 5),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40)),
          onPressed: press,
          child: Text(
            text,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}
