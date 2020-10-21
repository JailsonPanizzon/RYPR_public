import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

PreferredSizeWidget myAppBar(BuildContext context,
    {String title, Color bgColor, bool disableBack = false}) {
  return PreferredSize(
    preferredSize: Size(double.infinity, 120),
    child: Container(
      height: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 60),
          Row(
            children: <Widget>[
              disableBack
                  ? Icon(
                      Icons.arrow_back_ios,
                      color: Colors.transparent,
                    )
                  : IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
              Text(
                title != null ? title : "",
                style: Theme.of(context).textTheme.title,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
