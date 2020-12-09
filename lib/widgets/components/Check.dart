import 'package:flutter/material.dart';

class Check extends StatelessWidget {
  final String label;
  final bool value;
  final Function onChange;

  Check({this.label, this.value, this.onChange});

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text('Mark as $label'),
      value: value,
      contentPadding: EdgeInsets.symmetric(horizontal: 0),
      onChanged: onChange
    );
  }
}

