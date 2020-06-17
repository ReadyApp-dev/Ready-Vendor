import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readyvendor/models/user.dart';
import 'package:readyvendor/screens/authenticate/authenticate.dart';
import 'package:readyvendor/screens/home/home.dart';
import 'package:readyvendor/screens/landing_page.dart';
import 'package:readyvendor/shared/constants.dart';
import 'package:readyvendor/shared/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    // return either the Home or Authenticate widget
    if (user == null){
      return Authenticate();
    } else{
      return FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
          builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot){
          if(snapshot.data == null) return Loading();
          SharedPreferences pref= snapshot.data ;

            isVerified = pref.getBool('isVerified')?? false;
          if(isVerified){
              return Home();
            } else {
              return Landing();
            }
          }
      );
    }








  }
}