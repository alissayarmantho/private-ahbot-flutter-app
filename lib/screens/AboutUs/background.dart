import 'package:botapp/widgets/app_header.dart';
import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    required key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = 0.55;
    return Container(
      height: size.height,
      width: size.width,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              height: ratio * size.height,
              width: size.width,
              child: FittedBox(
                fit: BoxFit.cover,
                child: Image.asset(
                  "assets/backgroundbanner.png",
                  width: size.width,
                ),
              ),
            ),
          ),
          child,
          AppHeader(
              key: key,
              hasLogOut: false,
              hasBackButton: true,
              child: Container()),
        ],
      ),
    );
  }
}
