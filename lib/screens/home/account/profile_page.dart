import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readyvendor/models/vendor.dart';
import 'package:readyvendor/screens/home/account/verify_phone.dart';
import 'package:readyvendor/shared/constants.dart';

class ProfilePage extends StatelessWidget {
  final Vendor vendor;
  final Function changeMode;
  ProfilePage({this.vendor, this.changeMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Card(
            color: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
            child: ListTile(
              leading: Icon(
                Icons.account_circle,
                color: Colors.teal[900],
              ),
              title: Text(
                vendor.name,
                style: TextStyle(fontSize: 15.0, fontFamily: 'Neucha'),
              ),
            ),
          ),
          Card(
            color: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
            child: ListTile(
              leading: Icon(
                Icons.mail,
                color: Colors.teal[900],
              ),
              title: Text(
                vendor.addr1,
                style: TextStyle(fontSize: 15.0, fontFamily: 'Neucha'),
              ),
            ),
          ),
          Card(
            color: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
            child: ListTile(
              leading: Icon(
                Icons.mail,
                color: Colors.teal[900],
              ),
              title: Text(
                vendor.addr2,
                style: TextStyle(fontSize: 15.0, fontFamily: 'Neucha'),
              ),
            ),
          ),
          Card(
            color: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
            child: ListTile(
              leading: Icon(
                Icons.phone,
                color: Colors.teal[900],
              ),
              title: Text(
                vendor.phoneNo,
                style: TextStyle(fontSize: 15.0, fontFamily: 'Neucha'),
              ),
            ),
          ),
          Card(
            color: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
            child: ListTile(
              leading: Icon(
                Icons.payment,
                color: Colors.teal[900],
              ),
              title: Text(
                vendor.upiId,
                style: TextStyle(fontSize: 15.0, fontFamily: 'Neucha'),
              ),
            ),
          ),
          RaisedButton(
            color: buttonColor,
            child: Text(
              'Edit Profile',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0
              ),
            ),
            onPressed: changeMode,
          ),
          !phoneVerified ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 20.0,
                width: 200,
                child: Divider(
                  color: Colors.teal[100],
                ),
              ),
              SizedBox(height: 10.0,),
              Text(
                  "Verify phone to continue using app",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10.0,),
              Card(
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.phone,
                    color: Colors.teal[900],
                  ),
                  title: Text(
                  vendor.phoneNo,
                    style: TextStyle(
                      fontFamily: 'BalooBhai',
                      fontSize: 15.0
                    ),
                  ),
                )
              ),
              RaisedButton(
                color: buttonColor,
                child: Text(
                  'Verify',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0
                  ),
                ),
                onPressed: () async {
                  if(true) {
                    Navigator.push(context, CupertinoPageRoute(
                        builder: (context) => VerifyPhone(phoneNo: vendorPhoneNo, otp: '')));
                  }
                },
              ),
            ],
          ):Container(),
        ],
      ),
    );
  }
}
