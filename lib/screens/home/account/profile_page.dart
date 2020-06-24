import 'package:flutter/material.dart';
import 'package:readyvendor/models/vendor.dart';

class ProfilePage extends StatelessWidget {
  final Vendor vendor;
  final Function changeMode;
  ProfilePage({this.vendor, this.changeMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(

      ),
    );
  }
}
