import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';

///A grid of evenly spaced buttons with the numbers 0 through 9, as well as
///back and clear buttons.
///
/// Requires a [NumpadController], which is responsible for parsing and storing
/// this input from this widget.
class Numpad extends StatelessWidget {
  final Key key;

  ///Space between buttons on the numpad grid.
  final double innerPadding;

  ///Size of the text on the buttons in the numpad grid.
  final double buttonTextSize;
  final Color buttonColor;
  final Color textColor;
  final double height;
  final double width;

  Numpad({
    required this.key,
    required this.buttonColor,
    required this.textColor,
    this.innerPadding = 4,
    this.buttonTextSize = 30,
    this.height = double.infinity,
    this.width = double.infinity,
  }) : super(key: key);

  EdgeInsetsGeometry _buttonPadding() {
    return EdgeInsets.all(innerPadding);
  }

  Widget _buildNumButton(
      {required BuildContext context,
      required int displayNum,
      Icon? icon,
      required NumpadController controller}) {
    Widget effectiveChild;
    int passNum = displayNum;
    if (icon != null) {
      effectiveChild = icon;
    } else {
      effectiveChild = Text(
        displayNum.toString(),
        style: TextStyle(fontSize: buttonTextSize, color: textColor),
      );
    }
    return Expanded(
      child: Container(
        padding: _buttonPadding(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: TextButton(
            child: effectiveChild,
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed))
                      return buttonColor;
                    return Colors.white; // Use the component's default.
                  },
                ),
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: 5))),
            onPressed: () => controller.parseInput(passNum),
          ),
        ),
      ),
    );
  }

  Widget _buildNumRow(
      BuildContext context, List<int> numbers, NumpadController controller) {
    List<Widget> buttonList = numbers
        .map((buttonNum) => _buildNumButton(
            context: context, displayNum: buttonNum, controller: controller))
        .toList();
    return Container(
      child: Expanded(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buttonList),
      ),
    );
  }

  Widget _buildSpecialRow(BuildContext context, NumpadController controller) {
    return Expanded(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildNumButton(
                context: context,
                displayNum: -1,
                icon: Icon(
                  Icons.backspace,
                  size: buttonTextSize,
                  color: Colors.black,
                ),
                controller: controller),
            _buildNumButton(
                context: context, displayNum: 0, controller: controller),
            _buildNumButton(
                context: context,
                displayNum: -2,
                controller: controller,
                icon: Icon(
                  Icons.clear,
                  size: buttonTextSize,
                  color: Colors.black,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildNumPad(BuildContext context, BoxConstraints constraints) {
    final Size size = MediaQuery.of(context).size;
    final NumpadController controller = Get.put(NumpadController());
    return Container(
      height: height,
      width: width,
      padding: _buttonPadding(),
      child: LimitedBox(
        maxHeight: size.height * 0.3,
        maxWidth: size.width * 0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 50,
              child: Center(
                child: Obx(
                  () => Text(controller.phoneNumberString.value,
                      style: TextStyle(
                        fontSize: 35,
                      )),
                ),
              ),
            ),
            _buildNumRow(context, [1, 2, 3], controller),
            _buildNumRow(context, [4, 5, 6], controller),
            _buildNumRow(context, [7, 8, 9], controller),
            _buildSpecialRow(context, controller),
            SizedBox(height: 20),
            IconButton(
                iconSize: 50,
                icon: Icon(
                  Icons.call,
                ),
                splashRadius: 40,
                color: Color.fromRGBO(111, 207, 151, 1),
                onPressed: () async {
                  await FlutterPhoneDirectCaller.callNumber(
                      controller.phoneNumberString.value);
                }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: _buildNumPad,
    );
  }
}

class NumpadController extends GetxController {
  var phoneNumberString = "".obs;

  void parseInput(int input) {
    switch (input) {
      case -2: //Clear
        phoneNumberString.value = "";
        break;
      case -1: //Backspace
        if (phoneNumberString.value.length > 1) {
          phoneNumberString.value = phoneNumberString.value
              .substring(0, phoneNumberString.value.length - 1);
        } else {
          phoneNumberString.value = "";
        }
        break;
      default:
        phoneNumberString.value += input.toString();
        break;
    }
  }

  int getPhoneNumber() {
    return int.tryParse(phoneNumberString.value) ?? 0;
  }
}
