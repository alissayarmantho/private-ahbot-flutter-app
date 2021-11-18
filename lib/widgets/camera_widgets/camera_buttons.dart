import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OptionButton extends StatefulWidget {
  final IconData icon;
  final Function onTapCallback;

  final bool isEnabled;
  const OptionButton({
    required Key key,
    required this.icon,
    required this.onTapCallback,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  _OptionButtonState createState() => _OptionButtonState();
}

class _OptionButtonState extends State<OptionButton>
    with SingleTickerProviderStateMixin {
  double _angle = pi / 2;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.isEnabled,
      child: Opacity(
        opacity: widget.isEnabled ? 1.0 : 0.3,
        child: Transform.rotate(
          angle: _angle,
          child: ClipOval(
            child: Material(
              color: Color(0xFF4F6AFF),
              child: InkWell(
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Icon(
                    widget.icon,
                    color: Colors.white,
                    size: 24.0,
                  ),
                ),
                onTap: () {
                  if (widget.onTapCallback != null) {
                    // Trigger short vibration
                    HapticFeedback.selectionClick();

                    widget.onTapCallback();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
