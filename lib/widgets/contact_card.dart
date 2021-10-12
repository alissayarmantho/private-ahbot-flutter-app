import 'package:botapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class ContactCard extends StatelessWidget {
  final String name;
  final String number;
  const ContactCard({
    Key? key,
    required this.name,
    required this.number,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.415,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: kPrimaryLightColor,
        borderRadius: BorderRadius.all(
          Radius.circular(40),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20,
          ),
          Flexible(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color.fromRGBO(130, 130, 130, 1),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(number,
                textAlign: TextAlign.end,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ),
          SizedBox(
            width: 10,
          ),
          IconButton(
              //TODO: Find out why button ripple is not working
              iconSize: 30,
              icon: Icon(Icons.call, color: Color.fromRGBO(111, 207, 151, 1)),
              onPressed: () async {
                //TODO: Decide whether to use the country code or not
                await FlutterPhoneDirectCaller.callNumber(number);
              }),
        ],
      ),
    );
  }
}
