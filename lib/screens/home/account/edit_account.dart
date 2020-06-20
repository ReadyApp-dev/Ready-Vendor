import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:readyvendor/models/user.dart';
import 'package:readyvendor/models/vendor.dart';
import 'package:readyvendor/screens/home/account/verify_phone.dart';
import 'package:readyvendor/services/database.dart';
import 'package:readyvendor/shared/constants.dart';
import 'package:readyvendor/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditAccount extends StatefulWidget {
  @override
  _EditAccountState createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  // text field state
  String email = vendorEmail;
  String password = '';
  String name = vendorName;
  String addr1 = vendorAddr1;
  String addr2 = vendorAddr2;
  String phoneNo = vendorPhoneNo;
  String upiId = vendorUpiId;
  bool isSwitched = vendorIsAvailable;

  @override
  Widget build(BuildContext context) {

    User user = Provider.of<User>(context);

    return StreamBuilder<Vendor>(
        stream: DatabaseService(uid: user.uid).vendorData,
        builder: (context, snapshot) {
          if(snapshot.data == null) return Loading();
          /*
          email = vendorEmail;
          name = vendorName;
          addr1 = vendorAddr1;
          addr2 = vendorAddr2;
          phoneNo = vendorPhoneNo;
          upiId = vendorUpiId;
          */

          Vendor vendor = snapshot.data;
          return  Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: Text('Edit Account'),
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    /*
                    TextFormField(
                      initialValue: vendorEmail,
                      decoration: textInputDecoration.copyWith(hintText: 'E-Mail'),
                      validator: (val) => val.isEmpty ? 'Enter an email' : null,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),

                     */
                    //SizedBox(height: 20.0),
                    TextFormField(
                      initialValue: vendorName,
                      decoration: textInputDecoration.copyWith(hintText: 'Name'),
                      validator: (val) {
                        if(val.length < 3)
                          return 'That is Not your name';
                        Pattern pattern =
                            r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]';
                        RegExp regex = new RegExp(pattern);
                        if (regex.hasMatch(val))
                          return 'That is not your name';
                        else
                          return null;
                      },
                      onChanged: (val) {
                        setState(() => name = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      initialValue: vendorAddr1,
                      decoration: textInputDecoration.copyWith(hintText: 'Address Line 1'),
                      validator: (val) => val.isEmpty ? 'Enter your Address' : null,
                      onChanged: (val) {
                        setState(() => addr1 = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      initialValue: vendorAddr2,
                      decoration: textInputDecoration.copyWith(hintText: 'Address Line 2'),
                      validator: (val) => val.isEmpty ? 'Enter your Address' : null,
                      onChanged: (val) {
                        setState(() => addr2 = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    Container(

                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.055,
                      child: Form(
                        key: _formKey2,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.5,

                              child: TextFormField(
                                initialValue: vendorPhoneNo,
                                decoration: textInputDecoration.copyWith(hintText: 'Phone Number'),
                                validator: (val) {
                                  if(val.length != 10)
                                    return 'Enter a valid phone Number without country code';
                                  Pattern pattern = r'(\+\d{1,2}\s?)?1?\-?\.?\s?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}';
                                  RegExp regex = new RegExp(pattern);
                                  if (!regex.hasMatch(val))
                                    return 'Enter valid Phone number without country code';
                                  else
                                    return null;
                                },
                                onChanged: (val) {
                                  setState(() => phoneNo = val);
                                },
                              ),
                            ),
                            SizedBox(width: 20.0,),
                            RaisedButton(
                              color: Colors.pink[400],
                              child: Text(
                                'Verify',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                if(_formKey.currentState.validate()) {
                                  Navigator.push(context, CupertinoPageRoute(
                                      builder: (context) => VerifyPhone(phoneNo: phoneNo, otp: '')));
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      initialValue: vendorUpiId,
                      decoration: textInputDecoration.copyWith(hintText: 'UPI Id'),
                      validator: (val) {
                        if(val.isEmpty)
                          return 'Enter a valid UPI ID';
                        Pattern pattern = r'[\w\.\-_]{3,}@[a-zA-Z]{3,}';
                        RegExp regex = new RegExp(pattern);
                        if (!regex.hasMatch(val))
                          return 'Enter valid UPI ID';
                        else
                          return null;
                      },
                      onChanged: (val) {
                        setState(() => upiId = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children: <Widget>[
                        Text("Availabilty",
                        style:TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                        )
                        ),
                        SizedBox(width: 20,),
                        Switch(
                          value: isSwitched,
                          onChanged: (value) {
                            setState(() {
                              isSwitched = value;
                              print(isSwitched);
                            });
                          },
                          activeTrackColor: Colors.pinkAccent,
                          activeColor: Colors.pink,
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),

                    RaisedButton(
                        color: Colors.pink[400],
                        child: Text(
                          'Update',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if(_formKey.currentState.validate()){
                            Vendor newVendorData = new Vendor(
                                email:email,
                                uid:vendorUid,
                                name: name,
                                addr1: addr1,
                                addr2: addr2,
                                phoneNo: phoneNo,
                                upiId: upiId,
                                latitude: vendorLatitude,
                                longitude: vendorLongitude,
                                isAvailable: isSwitched,
                            );
                            print(newVendorData.phoneNo);
                            await DatabaseService(uid: userUid).updateVendorData(newVendorData);
                            //await DatabaseService(uid: userUid).getCurrentVendorDetails(vendorUid);
                            vendorEmail = email;
                            vendorName = name;
                            vendorAddr1 = addr1;
                            vendorAddr2 = addr2;
                            vendorPhoneNo = phoneNo;
                            vendorUpiId = upiId;
                            vendorIsAvailable = isSwitched;

                            final snackBar = SnackBar(
                              content: Text('Data Updated!'),
                            );

                            // Find the Scaffold in the widget tree and use
                            // it to show a SnackBar.
                            Scaffold.of(context).showSnackBar(snackBar);
                          }
                        }
                    ),
                    SizedBox(height: 12.0),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}