import 'package:flutter/material.dart';
import 'package:botapp/constants.dart';
import 'package:flutter_svg/svg.dart';

class SVGButton extends StatelessWidget {
  final String svgAssetPath;
  final VoidCallback press;
  final double size;
  final Color color, splashColor;

  const SVGButton({
    required Key key,
    required this.svgAssetPath,
    required this.press,
    // Button size cannot be 0, so 0 will cause the svg to go to its default size
    this.size = 0,
    this.color = kPrimaryColor,
    this.splashColor = kPrimaryLightColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(100),
      color: color,
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        splashColor: splashColor,
        onTap: press,
        child: SizedBox(
          width: size == 0 ? null : size,
          height: size == 0 ? null : size,
          child: SvgPicture.asset(svgAssetPath),
        ),
      ),
    );
  }
}
