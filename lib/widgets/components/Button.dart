import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String label;
  final Function onPress;

  Button({this.label, this.onPress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: RaisedButton(
        onPressed: onPress,
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 14),
          child: Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
