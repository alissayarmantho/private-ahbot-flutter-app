import 'package:botapp/widgets/logout_button.dart';
import 'package:flutter/material.dart';
import 'package:battery_indicator/battery_indicator.dart';

class AppHeader extends StatelessWidget {
  final Widget child;
  final bool hasLogOut;
  final bool hasBackButton;

  const AppHeader({
    required key,
    required this.hasLogOut,
    required this.hasBackButton,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final widthRatio = hasLogOut ? 1 : 0.5;
    return Container(
      height: size.height,
      width: size.width,
      child: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            child,
            Positioned(
              top: 0,
              right: 20,
              child: SizedBox(
                height: 1 / 7 * size.height,
                width: widthRatio * 1 / 8 * size.width,
                child: Row(
                  children: <Widget>[
                    if (this.hasLogOut)
                      Expanded(
                        child: LogoutButton(),
                      ),
                    Expanded(
                      child: BatteryIndicator(
                        style: BatteryIndicatorStyle.values[0],
                        colorful: true,
                        showPercentNum: true,
                        showPercentSlide: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (hasBackButton) Positioned(top: 0, left: 0, child: BackButton()),
          ],
        ),
      ),
    );
  }
}
