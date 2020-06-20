import 'package:flutter/material.dart';
import 'package:readyvendor/models/item.dart';
import 'package:readyvendor/models/order.dart';
import 'package:readyvendor/services/database.dart';
import 'package:readyvendor/shared/constants.dart';
import 'package:upi_india/upi_india.dart';


class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Future<UpiResponse> _transaction;
  UpiIndia _upiIndia = UpiIndia();
  List<UpiApp> apps;

  @override
  void initState() {
    _upiIndia.getAllUpiApps().then((value) {
      setState(() {
        apps = value;
      });
    });
    super.initState();
  }

  Future<UpiResponse> initiateTransaction(String app) async {
    return _upiIndia.startTransaction(
      app: app,
      receiverUpiId: '9455851989@ybl',
      receiverName: 'Shashwat Pandey',
      transactionRefId: 'TestingUpiIndiaPlugin',
      transactionNote: 'Not actual. Just an example.',
      amount: 5.00,
    );
  }

  Widget displayUpiApps() {
    if (apps == null)
      return Center(child: CircularProgressIndicator());
    else if (apps.length == 0)
      return Center(child: Text("No apps found to handle transaction."));
    else
      return Center(
        child: Wrap(
          children: apps.map<Widget>((UpiApp app) {
            return GestureDetector(
              onTap: () {
                _transaction = initiateTransaction(app.app);
                setState(() {});
              },
              child: Container(
                height: 100,
                width: 100,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.memory(
                      app.icon,
                      height: 60,
                      width: 60,
                    ),
                    Text(app.name),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      );
  }

  Future<void> _removeLoading() async {
    await Future.delayed(Duration(seconds: 10));
    setState(() {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    //DatabaseService(uid: userUid).clearCart();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Text('Payment'),
      ),
      body: Column(
        children: <Widget>[
          displayUpiApps(),
          Expanded(
            flex: 2,
            child: FutureBuilder(
              future: _transaction,
              builder: (BuildContext context,
                  AsyncSnapshot<UpiResponse> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  //_removeLoading();
                  if (snapshot.hasError) {
                    return Center(child: Text('An Unknown error has occured'));
                  }
                  UpiResponse _upiResponse;
                  _upiResponse = snapshot.data;
                  if (_upiResponse.error != null) {
                    print("object");

                  }
                  String txnId = _upiResponse.transactionId;
                  String resCode = _upiResponse.responseCode;
                  String txnRef = _upiResponse.transactionRefId;
                  String status = _upiResponse.status;
                  String approvalRef = _upiResponse.approvalRefNo;


                  Map<String, dynamic> myMap = new Map();
                  myMap = Map.fromIterable(myCart, key: (e) => e.id, value: (e) => {'cost':e.cost,'quantity':e.quantity, 'name':e.name});
                  print(myMap);
                  List<Item> out = [];
                  myMap.forEach((key, value) => out.add(new Item(id: key, cost: value['cost'], quantity: value['quantity'], name: value['name'])));
                  print(out);

                  switch (status) {
                    case UpiPaymentStatus.SUCCESS:
                      print('Transaction Successful');
                      Order order = new Order(
                        cart:  myMap?? '',
                        status: "Order Placed",
                        totalCost: userCartVal ?? '0.0',
                        user: userUid ?? '0',
                        vendor: userCartVendor ?? '0',
                      );
                      //DatabaseService(uid: userUid).addOrderData(order);
                      //DatabaseService(uid: userUid).addOrderDataVendor(order);
                      return AlertDialog(
                        title: new Text('Success!'),
                        content: new Text('Order placed successfully'),
                        actions: <Widget>[
                          new FlatButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              //await DatabaseService(uid: userUid).clearCart();
                              userCartVal = 0.0;
                              userCartVendor = '';
                            },
                            child: new Text('OK'),
                          ),
                        ],
                      );
                      break;
                    case UpiPaymentStatus.SUBMITTED:
                      print('Transaction Submitted');
                      break;
                    case UpiPaymentStatus.FAILURE:
                      print('Transaction Failed');
                      Order order = new Order(
                        cart:  myMap?? '',
                        status: "Order Failed",
                        totalCost: userCartVal ?? '0.0',
                        user: userUid ?? '0',
                        vendor: userCartVendor ?? '0',
                      );
                      //DatabaseService(uid: userUid).addOrderData(order);

                      return AlertDialog(
                          title: new Text('Error!'),
                          content: new Text('Your transaction failed'),
                          actions: <Widget>[
                            new FlatButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                //await DatabaseService(uid: userUid).clearCart();
                              },
                              child: new Text('OK'),
                            ),
                          ],
                        );
                      break;
                    default:
                      print('Received an Unknown transaction status');
                  }
                  return Container();
                } else
                  return Text(' ');
              },
            ),
          )
        ],
      ),
    );
  }
}