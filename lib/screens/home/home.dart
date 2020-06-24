import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:readyvendor/models/item.dart';
import 'package:readyvendor/models/user.dart';
import 'package:readyvendor/models/vendor.dart';
import 'package:readyvendor/screens/home/account/edit_account.dart';
import 'package:readyvendor/screens/home/drawer_list.dart';
import 'package:readyvendor/screens/home/cartAndMenu/menu_list.dart';
import 'package:readyvendor/screens/home/orderHistory/order_list.dart';
import 'package:readyvendor/services/auth.dart';
import 'package:readyvendor/services/database.dart';
import 'package:readyvendor/shared/constants.dart';
import 'package:readyvendor/shared/contact_page.dart';
import 'package:readyvendor/shared/loading.dart';

class Home extends StatefulWidget {
  num drawerItemSelected = 1;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  String itemName = "";
  double itemCost = 0.0;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  _register() {
    _firebaseMessaging.getToken().then((token) {
      print(token+"end");
      vendorToken = token;
      vendorUid = userUid;
      DatabaseService(uid: vendorUid).updateTokenData(vendorToken);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMessage();
  }

  void getMessage(){
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print('on message $message');
          //setState(() => _message = message["notification"]["title"]);
        }, onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
      //setState(() => _message = message["notification"]["title"]);
    }, onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
      //setState(() => _message = message["notification"]["title"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    User user = Provider.of<User>(context);
    userUid = user.uid;
    currentVendor = userUid;

    Future<bool> _onPopExit() async {
      await showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('Do you want to exit an App'),
          actions: <Widget>[
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            new FlatButton(
              onPressed: () => SystemNavigator.pop(),
              child: new Text('Yes'),
            ),
          ],
        ),
      ) ?? false;
    }

    Future<bool> _onPopHome() async {
      setState(() {
        widget.drawerItemSelected = 1;
      });
      //return true;
    }

    switch(widget.drawerItemSelected){
      case 1: {
        return new WillPopScope(
            onWillPop: _onPopExit,
            child:  Scaffold(
              drawer: Drawer(
                child: DrawerList((int i){
                  print(i);
                  setState(() {
                    widget.drawerItemSelected = i;
                    Navigator.of(context).pop();
                  });
                }),
              ),
                backgroundColor: Colors.brown[50],
                appBar: AppBar(
                  title: Text('Ready',
                  style: new TextStyle(
                    color: Colors.black,
                  ),),
                  iconTheme: new IconThemeData(color: Colors.black),
                  backgroundColor: appBarColor,
                  elevation: 0.0,
                  actions: <Widget>[
                    FlatButton.icon(
                      icon: Icon(Icons.person),
                      label: Text('logout'),
                      onPressed: () async {
                        await _auth.signOut();
                      },
                    ),
                  ],
                ),
                body: Container(
                  color: backgroundColor,
                  child: StreamProvider<List<Item>>.value(
                    value: DatabaseService().items,
                    child:FutureBuilder<bool>(
                      future: DatabaseService(uid: userUid).getCurrentVendorDetails(userUid),
                      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        print("1");
                        if(snapshot.data == null) return Loading();
                        print(snapshot.data);
                        print("works here");
                        _register();
                        return FutureBuilder(
                            future: Geolocator().getCurrentPosition(
                                desiredAccuracy: LocationAccuracy.best),
                            builder: (BuildContext context,
                                AsyncSnapshot<Position> snapshot) {
                              if (snapshot.data == null) return Loading();
                              print("works here too");
                              Position pos = snapshot.data;
                              vendorLatitude = pos.latitude;
                              vendorLongitude = pos.longitude;
                              Vendor userData = new Vendor(
                                uid: vendorUid,
                                email: vendorEmail,
                                name: vendorName,
                                addr1: vendorAddr1,
                                addr2: vendorAddr2,
                                phoneNo: vendorPhoneNo,
                                upiId: vendorUpiId,
                                longitude: vendorLongitude,
                                latitude: vendorLatitude,
                                isAvailable: true,
                              );
                              DatabaseService(uid: userUid).updateVendorData(
                                  userData);
                              print("works here too now");
                              return MenuList();
                            }
                        );
                      }
                    ),
                  ),
                ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: appBarColor,
                  child: Text(
                      "Add Item",
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () async{
                    double heightContainer = MediaQuery.of(context).size.height * 0.25;
                    print(heightContainer);
                    await showDialog(
                      context: context,
                      builder: (context) => StatefulBuilder(
                        builder: (context, setState) {
                          return AlertDialog(
                            title: new Text('Enter New Item'),
                            content: Form(
                              key: _formKey,
                              child: Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.2,
                                height: heightContainer,
                                child: ListView(
                                  children: <Widget>[
                                    TextFormField(
                                      decoration: textInputDecorationSecond
                                          .copyWith(hintText: 'Item Name'),
                                      validator: (val) =>
                                      val.isEmpty
                                          ? 'Enter item name'
                                          : null,
                                      onChanged: (val) {
                                        setState(() => itemName = val);
                                      },
                                    ),
                                    SizedBox(height: 20.0),
                                    TextFormField(
                                      decoration: textInputDecorationSecond.copyWith(hintText: 'Cost'),
                                      validator: (val) =>  null,
                                      onChanged: (val) {
                                        setState(() => itemCost = double.parse(val));
                                      },
                                    ),
                                    SizedBox(height: 20.0),
                                    RaisedButton(
                                      color: buttonColor,
                                      onPressed: () async {
                                        //return SystemNavigator.pop();
                                        if (_formKey.currentState.validate()) {
                                          print("works");
                                          Item item = new Item(name: itemName,cost: itemCost,quantity: 0);
                                          DatabaseService(uid: vendorUid).addItemToMenu(item);
                                          Navigator.of(context).pop();
                                          final snackBar = SnackBar(
                                            content: Text('Added!'),
                                          );

                                          // Find the Scaffold in the widget tree and use
                                          // it to show a SnackBar.
                                          Scaffold.of(context).showSnackBar(snackBar);
                                          //setState(() => loading = true);
                                        } else {
                                          setState(() {
                                            heightContainer = MediaQuery
                                                .of(context)
                                                .size
                                                .height * 0.3;
                                            print("yes");
                                          });
                                        }
                                      },
                                      child: new Text(
                                        'Add Item',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            )
        );
      }
      break;
      case 2: {
        return new WillPopScope(
            onWillPop: _onPopHome,
            child:  Scaffold(
                drawer: Drawer(
                  child: DrawerList((int i){
                    print(i);
                    setState(() {
                      widget.drawerItemSelected = i;
                      Navigator.of(context).pop();
                    });
                  }),
                ),
                backgroundColor: backgroundColor,
                appBar: AppBar(
                  title: Text('Ready',
                    style: new TextStyle(
                      color: Colors.black,
                    ),),
                  iconTheme: new IconThemeData(color: Colors.black),
                  backgroundColor: appBarColor,

                  elevation: 0.0,
                  actions: <Widget>[
                    FlatButton.icon(
                      icon: Icon(Icons.person),
                      label: Text('logout'),
                      onPressed: () async {
                        await _auth.signOut();
                      },
                    ),
                  ],
                ),
                body: Container(
                  color: backgroundColor,
                  child: EditAccount(),
                )
            )
        );
      }
      break;
      case 3: {
        return new WillPopScope(
            onWillPop: _onPopHome,
            child:  Scaffold(
                drawer: Drawer(
                  child: DrawerList((int i){
                    print(i);
                    setState(() {
                      widget.drawerItemSelected = i;
                      Navigator.of(context).pop();
                    });
                  }),
                ),
                backgroundColor: backgroundColor,
                appBar: AppBar(
                  title: Text('Ready',
                    style: new TextStyle(
                      color: Colors.black,
                    ),),
                  iconTheme: new IconThemeData(color: Colors.black),
                  backgroundColor: appBarColor,
                  elevation: 0.0,
                  actions: <Widget>[
                    FlatButton.icon(
                      icon: Icon(Icons.person),
                      label: Text('logout'),
                      onPressed: () async {
                        await _auth.signOut();
                      },
                    ),
                  ],
                ),
                body: Container(
                  color: backgroundColor,
                  child: OrderWidget(),
                )
            )
        );
      }
      break;
      case 4: {
        return new WillPopScope(
            onWillPop: _onPopHome,
            child:  Scaffold(
                drawer: Drawer(
                  child: DrawerList((int i){
                    print(i);
                    setState(() {
                      widget.drawerItemSelected = i;
                      Navigator.of(context).pop();
                    });
                  }),
                ),
                backgroundColor: backgroundColor,
                appBar: AppBar(
                  title: Text('Ready',
                    style: new TextStyle(
                      color: Colors.black,
                    ),),
                  iconTheme: new IconThemeData(color: Colors.black),
                  backgroundColor: appBarColor,
                  elevation: 0.0,
                  actions: <Widget>[
                    FlatButton.icon(
                      icon: Icon(Icons.person),
                      label: Text('logout'),
                      onPressed: () async {
                        await _auth.signOut();
                      },
                    ),
                  ],
                ),
                body: Container(
                  color: backgroundColor,
                  child: ContactUs(),
                )
            )
        );
      }
      break;
    }
  }
}