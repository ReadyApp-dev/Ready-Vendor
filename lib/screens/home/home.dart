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
  bool showVendors = true;
  num drawerItemSelected = 1;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    User user = Provider.of<User>(context);
    userUid = user.uid;
    DatabaseService(uid: userUid).getUserDetails();

    void _showSettingsPanel() {
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
          child: CartWidget(),
        );
      },);
    }

    Future<bool> _onWillPop() async {
      if(widget.drawerItemSelected == 1 && widget.showVendors == false){
        setState(() {
          widget.showVendors = true;
        });
        return false;
      }else if(widget.drawerItemSelected != 1){(await showDialog(
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
      )) ?? false;
      }
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
                    FlatButton.icon(
                      icon: Icon(Icons.shopping_cart),
                      label: Text('cart'),
                      onPressed: () => _showSettingsPanel(),
                    )
                  ],
                ),
                body: Container(
                  color: Colors.brown[100],
                  child: widget.showVendors? StreamProvider<List<Vendor>>.value(
                    value: DatabaseService().vendors,
                    child:VendorList(
                      selectVendor: (){
                        setState(() {
                          print("yes it works");
                          widget.showVendors = false;
                        });
                      },
                    ),
                  ):StreamProvider<List<Item>>.value(
                    value: DatabaseService().items,
                    child:MenuList(),
                  ),
                )
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
                    FlatButton.icon(
                      icon: Icon(Icons.shopping_cart),
                      label: Text('cart'),
                      onPressed: () => _showSettingsPanel(),
                    )
                  ],
                ),
                body: Container(
                  color: Colors.brown[100],
                  child: SettingsForm(),
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
                    FlatButton.icon(
                      icon: Icon(Icons.shopping_cart),
                      label: Text('cart'),
                      onPressed: () => _showSettingsPanel(),
                    )
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