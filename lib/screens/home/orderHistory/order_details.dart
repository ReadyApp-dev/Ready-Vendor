import 'package:flutter/cupertino.dart';
import 'package:readyvendor/models/item.dart';
import 'package:readyvendor/models/order.dart';
import 'package:readyvendor/screens/home/orderHistory/ordered_item.dart';
import 'package:readyvendor/screens/home/orderHistory/write_review.dart';
import 'package:readyvendor/services/database.dart';
import 'package:readyvendor/shared/constants.dart';
import 'package:readyvendor/shared/loading.dart';
import 'package:flutter/material.dart';

class OrderDetails extends StatelessWidget {

  Order order;
  OrderDetails({this.order});
  bool recieved = false;

  @override
  Widget build(BuildContext context) {
    List<Item> out = [];
    order.cart.forEach((key, value) => out.add(new Item(id: key, cost: value['cost'], quantity: value['quantity'], name: value['name'])));
    print(out);

    if (out == null) return Loading();
    return Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(
            color: Colors.black
        ),
        title: Text(
          'Order Details',
          style: new TextStyle(
              color: Colors.black
          ),
        ),
        backgroundColor: appBarColor,
        elevation: 0.0,
      ),
      body: Container(
      color: backgroundColor,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Scrollbar(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: out.length,
                  itemBuilder: (context, index) {
                    return OrderedItemTile(
                      item: out[index],
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Text(
                    "Total Order Value:\n $userCartVal",
                    style: TextStyle(
                      color: buttonColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(width: 20,),
                  Text(
                    "Payment Method:\n ${order.paymentMethod}",
                    style: TextStyle(
                      color: buttonColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height:10.0),

            RaisedButton(
              color: buttonColor,
              child: Text(
                "Press if You Got what you wanted",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: (){
                order.status = 'Completed';
                //DatabaseService(uid: userUid).updateOrderData(order);
                DatabaseService(uid: userUid).updateOrderDataVendor(order);
              },
            ),
            SizedBox(height: 10),
            RaisedButton(
              color: buttonColor,
              child: Text(
                "Write Review",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () async {
                Navigator.push(context, CupertinoPageRoute(builder: (context) => WriteReview(order: order)));
              },
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}