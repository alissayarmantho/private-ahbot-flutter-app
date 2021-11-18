import 'package:botapp/widgets/camera_widgets/camera_buttons.dart';
import 'package:flutter/material.dart';

class BottomBarWidget extends StatelessWidget {
  final Function onZoomInTap;
  final Function onZoomOutTap;

  const BottomBarWidget({
    required Key key,
    required this.onZoomOutTap,
    required this.onZoomInTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 70,
        child: Stack(
          children: [
            Container(
              color: Colors.black12,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    OptionButton(
                      key: UniqueKey(),
                      icon: Icons.zoom_out,
                      onTapCallback: () => onZoomOutTap?.call(),
                    ),
                    OptionButton(
                      key: UniqueKey(),
                      icon: Icons.zoom_in,
                      onTapCallback: () => onZoomInTap?.call(),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
