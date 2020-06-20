import 'package:flutter/material.dart';
import 'package:readyvendor/models/item.dart';

class OrderedItemTile extends StatelessWidget {
  Item item;
  OrderedItemTile({this.item});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 20.0,
            backgroundColor: Colors.brown[200],
            //backgroundImage: AssetImage('assets/coffee_icon.png'),
          ),
          title: Text(item.name),
          subtitle: Text('Cost: ₹${item.cost} '),
          trailing: Text(' ${item.quantity}'),
        ),
      ),
    );
  }
}

