import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onChanged;
  final void Function() onPressed;

  const SearchBar({
    Key? key,
    required this.controller,
    required this.onChanged,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.search),
        title: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
          ),
          onChanged: onChanged,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: onPressed,
        ),
      ),
    ).p8();
  }
}
