import 'package:flutter/material.dart';

class TextBox extends StatelessWidget {
  final String label;
  final String value;
  final bool done;
  final bool multiLine;
  final Function onChange;
  final Function validator;

  TextBox({
    this.label,
    this.value,
    this.onChange,
    this.validator,
    this.multiLine = false,
    this.done = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value ?? '',
      validator: validator,
      onChanged: onChange,
      textInputAction: done ? TextInputAction.done : TextInputAction.next,
      maxLines: multiLine ? null : 1,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
      ),
    );
  }
}
