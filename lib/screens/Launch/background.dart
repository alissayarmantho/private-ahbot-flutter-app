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
              height: 0.75 * size.height,
              width: size.width,
              child: FittedBox(
                fit: BoxFit.cover,
                child: Image.asset(
                  "assets/loginbackground.png",
                  width: size.width,
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
