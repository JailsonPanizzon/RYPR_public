import 'package:flutter/material.dart';

customAlert(context,
    {String title,
    String subtitle,
    String style,
    Function onPress,
    String confirmButtonText,
    String cancelButtonText,
    bool showCancelButton = false}) {
  List<Widget> actions = <Widget>[
    new FlatButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        width: 80,
        height: 40,
        child: Center(
          child: Text(
            confirmButtonText != null ? confirmButtonText : "Ok",
            style: Theme.of(context)
                .textTheme
                .button
                .copyWith(color: Colors.white),
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onPressed: () {
        onPress(true);
      },
    ),
  ];
  if (showCancelButton) {
    actions.add(
      FlatButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          width: 80,
          height: 40,
          child: Center(
            child: Text(
              cancelButtonText != null ? cancelButtonText : "Cancel",
              style: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(color: Colors.white),
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: () {
          Navigator.pop(context);
          onPress(false);
        },
      ),
    );
  }
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: new Center(
            child: Column(
              children: [
                style == "loading"
                    ? SizedBox(
                        child: CircularProgressIndicator(),
                        height: 75.0,
                        width: 75.0,
                      )
                    : style == "confirm"
                        ? Icon(Icons.warning, size: 75, color: Colors.orange)
                        : style == "error"
                            ? Icon(Icons.error_outline,
                                size: 75, color: Colors.red)
                            : Icon(Icons.check, size: 75, color: Colors.green),
                SizedBox(
                  height: 15,
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.body1,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style:
                      Theme.of(context).textTheme.body1.copyWith(fontSize: 14),
                )
              ],
            ),
          ),
          actions: style != "loading" ? actions : []);
    },
  );
}
