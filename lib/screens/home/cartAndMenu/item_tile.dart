import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:readyvendor/models/item.dart';
import 'package:readyvendor/models/user.dart';
import 'package:readyvendor/shared/constants.dart';
import 'package:readyvendor/services/database.dart';
import 'package:flutter_counter/flutter_counter.dart';

class ItemTile extends StatefulWidget {
  final Item item;
  ItemTile({ this.item });

  @override
  _ItemTileState createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {

  num _defaultValue = 0;
  num _counter = 0;

  @override
  Widget build(BuildContext context) {
    double sum = 0.0;
    _defaultValue = widget.item.quantity;
    _counter = widget.item.quantity;
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
            leading: CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.brown[200],
              //backgroundImage: AssetImage('assets/coffee_icon.png'),
            ),
            title: Text(widget.item.name),
            subtitle: Text('Cost: ₹${widget.item.cost} '),
        ),
      ),
    );
  }
}