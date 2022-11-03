import 'package:finalterm/services/product/product_provider.dart';
import 'package:flutter/material.dart';
import 'dart:developer' show log;

import 'package:provider/provider.dart';

class DropDownButton extends StatefulWidget {
  const DropDownButton({super.key, required this.dropdownList});

  final List<DropdownValue> dropdownList;

  @override
  State<DropDownButton> createState() => _DropDownButtonState();
}

class _DropDownButtonState extends State<DropDownButton> {
  
  @override
  Widget build(BuildContext context) {
    final _productProvider = Provider.of<ProductProvider>(context, listen: true);
    return DropdownButton<DropdownValue>(
      value: _productProvider.dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (DropdownValue? value) {
        // This is called when the user selects an item.
        setState(() {
          _productProvider.dropdownValue = value!;
        });
      },
      items: widget.dropdownList.map<DropdownMenuItem<DropdownValue>>((DropdownValue value) {
        return DropdownMenuItem<DropdownValue>(
          value: value,
          child: Text(value.name),
        );
      }).toList(),
    );
  }
}