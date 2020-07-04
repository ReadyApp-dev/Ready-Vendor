import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readyvendor/models/item.dart';
import 'package:readyvendor/screens/home/cartAndMenu/item_tile.dart';
import 'package:readyvendor/services/database.dart';
import 'package:readyvendor/shared/constants.dart';
import 'package:readyvendor/shared/loading.dart';

class MenuList extends StatefulWidget {
  final String searchresult;
  final bool search;
  MenuList(this.searchresult,this.search);
  @override
  _MenuListState createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  @override
  Widget build(BuildContext context) {
    final items = Provider.of<List<Item>>(context) ?? [];

    return StreamBuilder<List<Item>>(
      stream: DatabaseService(uid: userUid).cart,
      builder: (context, snapshot) {
        List<Item> data = snapshot.data;
        if(data == null) return Loading();
        print(data);
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            if(items[index].name.toLowerCase().contains(widget.searchresult.toLowerCase())) {
              int ind = -1;
              if (data != null) {
                ind =
                    data.indexWhere((element) => element.id == items[index].id);
              }
              if (ind != -1)
                items[index].quantity = data[ind].quantity;
              print(items[index].quantity);

              return ItemTile(
                item: items[index],

              );
            }else{
              return Container(height: 0,width: 0,);
            }
          },
        );
      }
    );
  }
}
