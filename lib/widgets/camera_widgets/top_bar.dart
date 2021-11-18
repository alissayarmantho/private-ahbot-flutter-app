import 'package:botapp/widgets/camera_widgets/camera_buttons.dart';
import 'package:flutter/material.dart';

class TopBarWidget extends StatelessWidget {
  final Function onChangeSensorTap;

  const TopBarWidget({
    required Key key,
    required this.onChangeSensorTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              OptionButton(
                key: UniqueKey(),
                icon: Icons.switch_camera,
                onTapCallback: () => onChangeSensorTap?.call(),
              ),
              SizedBox(width: 20.0),
            ],
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
