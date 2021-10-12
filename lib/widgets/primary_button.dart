import 'package:flutter/material.dart';
import 'package:botapp/constants.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback press;
  final Color color, textColor, loadingSpinnerColor;
  final double widthRatio;
  final bool isLoading;

  const PrimaryButton({
    required Key key,
    required this.text,
    required this.press,
    required this.widthRatio,
    this.isLoading = false,
    this.color = kPrimaryColor,
    this.textColor = Colors.white,
    this.loadingSpinnerColor = kPrimaryLightColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * widthRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed))
                    return kPrimaryLightColor;
                  return color; // Use the component's default.
                },
              ),
              padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(vertical: 20, horizontal: 40))),
          onPressed: isLoading ? null : press,
          child: isLoading
              ? CircularProgressIndicator(color: loadingSpinnerColor)
              : Text(
                  text,
                  style: TextStyle(color: textColor),
                ),
        ),
      ),
    );
  }
}
