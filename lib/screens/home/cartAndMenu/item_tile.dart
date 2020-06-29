import 'package:flutter/material.dart';
import 'package:readyvendor/models/item.dart';
import 'package:readyvendor/shared/constants.dart';
import 'package:readyvendor/services/database.dart';

class ItemTile extends StatefulWidget {
  final Item item;
  ItemTile({ this.item });

  @override
  _ItemTileState createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.grey,
            //backgroundImage: AssetImage('assets/coffee_icon.png'),
          ),
          title: Text(widget.item.name),
          subtitle: Text('Cost: ₹${widget.item.cost} '),
          trailing: new IconButton(
            icon: new Icon(Icons.delete),
            onPressed: () async{
              DatabaseService(uid: vendorUid).removeItemFromVendor(widget.item);
            },
          ),
        ),
      ),
    );
  }
}