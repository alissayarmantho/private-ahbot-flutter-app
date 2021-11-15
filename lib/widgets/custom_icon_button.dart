import 'package:flutter/material.dart';
import 'package:botapp/constants.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math';

class CustomIconButton extends StatelessWidget {
  final String svgAssetPath, title, description;
  final VoidCallback press;
  final Color color, splashColor;
  final bool hasDescription, hasTitle, isLoading;

  const CustomIconButton({
    required Key key,
    required this.svgAssetPath,
    required this.press,
    required this.hasTitle,
    required this.hasDescription,
    this.isLoading = false,
    this.title = "",
    this.description = "",
    this.color = kPrimaryColor,
    this.splashColor = kPrimaryLightColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final padding = 40.0;
    final iconRatio = hasDescription || hasTitle ? 0.1 : 0.2;
    final iconSize = min(iconRatio * size.width, iconRatio * size.height);
    return Material(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(65),
        topRight: Radius.circular(20),
        bottomLeft: Radius.circular(65),
        bottomRight: Radius.circular(65),
      ),
      color: color,
      child: InkWell(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(65),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(65),
          bottomRight: Radius.circular(65),
        ),
        splashColor: splashColor,
        onTap: isLoading ? null : press,
        child: Container(
          width: 0.2 * size.width,
          height: 0.21 * size.width,
          padding: hasTitle || hasDescription
              ? EdgeInsets.fromLTRB(30, 20, 30, 5)
              : EdgeInsets.all(padding),
          child: isLoading
              ? Center(child: CircularProgressIndicator(color: Colors.white))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: iconSize,
                      height: iconSize,
                      child: SvgPicture.asset(svgAssetPath),
                    ),
                    if (hasTitle)
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 45,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                    if (hasDescription)
                      SizedBox(
                        height: hasTitle ? 5 : 15,
                      ),
                    if (hasDescription)
                      Expanded(
                        child: Text(
                          description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
