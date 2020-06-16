import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readyvendor/models/vendor.dart';
import 'package:readyvendor/screens/home/vendors/vendor_tile.dart';
import 'package:readyvendor/shared/loading.dart';

class VendorList extends StatefulWidget {
  final Function selectVendor;
  VendorList({ this.selectVendor });

  @override
  _VendorListState createState() => _VendorListState();
}

class _VendorListState extends State<VendorList> {
  @override
  Widget build(BuildContext context) {

    final vendors = Provider.of<List<Vendor>>(context) ?? [];
    if(vendors == []) return Loading();
    return ListView.builder(
      itemCount: vendors.length,
      itemBuilder: (context, index) {
        return VendorTile(
          vendor: vendors[index],
          selectVendor: widget.selectVendor,
        );
      },
    );
  }
}