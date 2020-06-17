import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:readyvendor/models/item.dart';
import 'package:readyvendor/models/user.dart';
import 'package:readyvendor/models/vendor.dart';
import 'package:readyvendor/screens/home/account/edit_account.dart';
import 'package:readyvendor/screens/home/drawer_list.dart';
import 'package:readyvendor/screens/home/cartAndMenu/menu_list.dart';
import 'package:readyvendor/screens/home/orderHistory/order_list.dart';
import 'package:readyvendor/screens/home/vendors/vendor_list.dart';
import 'package:readyvendor/screens/home/cartAndMenu/cart_list.dart';
import 'package:readyvendor/services/auth.dart';
import 'package:readyvendor/services/database.dart';
import 'package:readyvendor/shared/constants.dart';

class Home extends StatefulWidget {
  num drawerItemSelected = 1;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  String itemName = "";
  double itemCost = 0.0;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    User user = Provider.of<User>(context);
    userUid = user.uid;
    currentVendor = userUid;
    DatabaseService(uid: userUid).getCurrentVendorDetails(userUid);
    /*
    void _showSettingsPanel() {
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
          child: CartWidget(),
        );
      },);
    }

     */

    Future<bool> _onWillPop() async {
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

    switch(widget.drawerItemSelected){
      case 1: {
        return new WillPopScope(
            onWillPop: _onWillPop,
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
                  title: Text('Ready'),
                  backgroundColor: Colors.brown[400],
                  elevation: 0.0,
                  actions: <Widget>[
                    FlatButton.icon(
                      icon: Icon(Icons.person),
                      label: Text('logout'),
                      onPressed: () async {
                        await _auth.signOut();
                      },
                    ),
                    /*
                    FlatButton.icon(
                      icon: Icon(Icons.shopping_cart),
                      label: Text('cart'),
                      onPressed: () => _showSettingsPanel(),
                    )

                     */
                  ],
                ),
                body: Container(
                  color: Colors.brown[100],
                  child: StreamProvider<List<Item>>.value(
                    value: DatabaseService().items,
                    child:MenuList(),
                  ),
                ),
              floatingActionButton: FloatingActionButton(
                  child: Text(
                      "Add Item",
                    textAlign: TextAlign.center,
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
                                      decoration: textInputDecorationSecond
                                          .copyWith(hintText: 'Cost'),
                                      validator: (val) =>
                                      val.isEmpty
                                          ? 'Enter cost'
                                          : null,
                                      onChanged: (val) {
                                        setState(() =>
                                        itemCost = val as double);
                                      },
                                    ),
                                    SizedBox(height: 20.0),
                                    RaisedButton(
                                      color: Colors.pink[400],
                                      onPressed: () async {
                                        //return SystemNavigator.pop();
                                        if (_formKey.currentState.validate()) {
                                          print("works");
                                          Navigator.of(context).pop(false);
                                          //setState(() => loading = true);
                                          /*
                                  dynamic result = await _auth.registerWithEmailAndPassword(email, password, name, addr1, addr2, phoneNo,upiId);
                                  if(result == null) {
                                    setState(() {
                                      loading = false;
                                      error = 'Registration Failed';
                                    });
                                  }
                                  */
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
            onWillPop: _onWillPop,
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
                  title: Text('Ready'),
                  backgroundColor: Colors.brown[400],
                  elevation: 0.0,
                  actions: <Widget>[
                    FlatButton.icon(
                      icon: Icon(Icons.person),
                      label: Text('logout'),
                      onPressed: () async {
                        await _auth.signOut();
                      },
                    ),
                    /*
                    FlatButton.icon(
                      icon: Icon(Icons.shopping_cart),
                      label: Text('cart'),
                      onPressed: () => _showSettingsPanel(),
                    )

                     */
                  ],
                ),
                body: Container(
                  color: Colors.brown[100],
                  child: EditAccount(),
                )
            )
        );
      }
      break;
      case 3: {
        return new WillPopScope(
            onWillPop: _onWillPop,
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
                  title: Text('Ready'),
                  backgroundColor: Colors.brown[400],
                  elevation: 0.0,
                  actions: <Widget>[
                    FlatButton.icon(
                      icon: Icon(Icons.person),
                      label: Text('logout'),
                      onPressed: () async {
                        await _auth.signOut();
                      },
                    ),
                    /*
                    FlatButton.icon(
                      icon: Icon(Icons.shopping_cart),
                      label: Text('cart'),
                      onPressed: () => _showSettingsPanel(),
                    )

                     */
                  ],
                ),
                body: Container(
                  color: Colors.brown[100],
                  child: OrderWidget(),
                )
            )
        );
      }
      break;
    }


  }
}