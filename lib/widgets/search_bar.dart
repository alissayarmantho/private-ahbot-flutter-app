import 'package:botapp/interfaces/filterable.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController textController;
  final Filterable controller;

  SearchBar({
    Key? key,
    required this.controller,
    required this.textController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (String value) async {
        // TODO: Implement a better filtering
        controller.filterName.value = value;
        controller.filterByName(name: value);
      },
      controller: textController,
      style: TextStyle(
        fontSize: 18,
      ),
      decoration: InputDecoration(
        hintText: 'Search',
        fillColor: Color.fromRGBO(242, 242, 242, 1),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          borderSide: BorderSide(width: 0, color: Colors.transparent),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
        ),
      ),
    );
  }
}
