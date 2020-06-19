import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:readyvendor/models/user.dart';
import 'package:readyvendor/models/vendor.dart';
import 'package:readyvendor/services/database.dart';
import 'package:readyvendor/shared/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on firebase user
  User _userFromFirebaseUser(FirebaseUser user) {
    if(user==null){
      return null;
    }
    firebaseUser = user;
    userUid = user.uid;
    return  User(uid: user.uid);
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
    //.map((FirebaseUser user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      if(user.isEmailVerified){
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isVerified', true);
        isVerified = true;
      }else{
        isVerified = false;
      }
      userUid = user.uid;
      //UserData userData = await DatabaseService(uid: user.uid).userDetails();
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password, String name, String addr1, String addr2, String phoneNo, String upiId) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      isVerified = false;
      FirebaseUser user = result.user;
      user.sendEmailVerification();
      // create a new document for the user with the uid
      userUid = user.uid;
      Vendor userData = Vendor(
        uid: user.uid,
        email: email,
        name: name,
        addr1: addr1,
        addr2: addr2,
        phoneNo: phoneNo,
        upiId: upiId,
      );
      await DatabaseService(uid: user.uid).updateVendorData(userData);
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }




  Future verifyPhone(String mobile, BuildContext context) async{

    _auth.verifyPhoneNumber(
        phoneNumber: mobile,
        timeout: Duration(seconds: 600),
        verificationCompleted:  (AuthCredential _authCredential) async{
              print("works");
              await firebaseUser.linkWithCredential(_authCredential).then((value) => firebaseUser=value.user);
              print(firebaseUser);
          },

        verificationFailed: null,
        codeSent: null,
        codeAutoRetrievalTimeout: null
    );}

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future resetPassword(String emailTarget) async {
    try {
      return await _auth.sendPasswordResetEmail(email: emailTarget);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

}