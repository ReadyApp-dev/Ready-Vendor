import 'package:flutter/material.dart';
import 'package:readyvendor/shared/constants.dart';


class ContactUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: backgroundColor,
        child: Column(
          children: <Widget>[
            Card(
              margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.email),
                  SizedBox(width: 3.0,),
                  Text(
                      'ready.app.mnnit@gmail.com',
                  style: new TextStyle(
                    color: Colors.black,
                  ), ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}