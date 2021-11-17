import 'package:botapp/screens/RobotHomePage/robot_home_page.dart';
import 'package:camerawesome/models/capture_modes.dart';
import 'package:camerawesome/models/flashmodes.dart';
import 'package:botapp/widgets/camera_widgets/camera_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TopBarWidget extends StatelessWidget {
  final ValueNotifier<Size> photoSize;
  final AnimationController rotationController;
  final ValueNotifier<CaptureModes> captureMode;
  final ValueNotifier<bool> enableAudio;
  final ValueNotifier<CameraFlashes> switchFlash;
  final Function onResolutionTap;
  final Function onChangeSensorTap;
  final Function onFlashTap;
  final Function onAudioChange;

  const TopBarWidget({
    required Key key,
    required this.captureMode,
    required this.enableAudio,
    required this.photoSize,
    required this.rotationController,
    required this.switchFlash,
    required this.onAudioChange,
    required this.onFlashTap,
    required this.onChangeSensorTap,
    required this.onResolutionTap,
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
              Padding(
                padding: const EdgeInsets.only(right: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    IgnorePointer(
                      ignoring: false,
                      child: Opacity(
                        opacity: 1.0,
                        child: ValueListenableBuilder(
                          valueListenable: photoSize,
                          builder: (context, Size? value, child) => TextButton(
                            key: ValueKey("resolutionButton"),
                            onPressed: () {
                              HapticFeedback.selectionClick();

                              onResolutionTap?.call();
                            },
                            child: Text(
                              '${value?.width.toInt()} / ${value?.height.toInt()}',
                              key: ValueKey("resolutionTxt"),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              OptionButton(
                key: UniqueKey(),
                icon: Icons.switch_camera,
                rotationController: rotationController,
                onTapCallback: () => onChangeSensorTap?.call(),
              ),
              SizedBox(width: 20.0),
              OptionButton(
                key: UniqueKey(),
                rotationController: rotationController,
                icon: _getFlashIcon(),
                onTapCallback: () => onFlashTap?.call(),
              ),
            ],
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }

  IconData _getFlashIcon() {
    switch (switchFlash.value) {
      case CameraFlashes.NONE:
        return Icons.flash_off;
      case CameraFlashes.ON:
        return Icons.flash_on;
      case CameraFlashes.AUTO:
        return Icons.flash_auto;
      case CameraFlashes.ALWAYS:
        return Icons.highlight;
      default:
        return Icons.flash_off;
    }
  }
}
