import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomButtom extends StatelessWidget {
  CustomButtom(
      {this.onPress,
      this.text,
      this.color = Colors.transparent,
      this.borderColor = Colors.black,
      this.textColor = Colors.black});
  final Function onPress;
  final String text;
  final Color color;
  final Color borderColor;
  final Color textColor;
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: EdgeInsets.all(0.0),
      onPressed: onPress,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: borderColor, width: 3),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Text(
            text,
            style:
                Theme.of(context).textTheme.button.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}
