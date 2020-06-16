import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readyvendor/models/user.dart';
import 'package:readyvendor/screens/authenticate/authenticate.dart';
import 'package:readyvendor/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    // return either the Home or Authenticate widget
    if (user == null){
      return Authenticate();
    } else {
      return Home();
    }

  }
}