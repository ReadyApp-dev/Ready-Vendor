import 'package:flutter/cupertino.dart';
import 'package:readyvendor/models/order.dart';
import 'package:readyvendor/models/user.dart';
import 'package:readyvendor/screens/home/orderHistory/order_tile.dart';
import 'package:readyvendor/services/database.dart';
import 'package:readyvendor/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderWidget extends StatefulWidget {
  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    print(user);
    return StreamBuilder<List<Order>>(
      stream: DatabaseService(uid: user.uid).orderHistory,
      builder: (context, snapshot) {
        if (snapshot.data == null) return Loading();
        List<Order> data = snapshot.data;
        return Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return OrderTile(
                    order: data[index],
                  );
                },
              ),
            ),
            SizedBox(height: 10.0),

          ],
        );
      }
    );
  }
}
