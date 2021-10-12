import 'package:botapp/widgets/app_header.dart';
import 'package:botapp/widgets/clock/analog_clock.dart';
import 'package:botapp/widgets/clock/model.dart';
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
    return SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        height: size.height,
        width: size.width,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: size.width * 0.32,
                height: size.height * 0.4,
                child: AnalogClock(ClockModel()),
              ),
            ),
            child,
            AppHeader(
                key: key,
                hasLogOut: true,
                hasBackButton: false,
                child: Container()),
          ],
        ),
      ),
    );
  }
}
