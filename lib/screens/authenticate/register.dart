import 'package:flutter/material.dart';
import 'package:readyvendor/services/auth.dart';
import 'package:readyvendor/shared/constants.dart';
import 'package:readyvendor/shared/loading.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({ this.toggleView });

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String name = '';
  String addr1 = '';
  String addr2 = '';
  String phoneNo = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Sign up to Ready'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Sign In'),
            onPressed: () => widget.toggleView(),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'E-Mail'),
                validator: (val) => val.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Password'),
                obscureText: true,
                validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Name'),
                validator: (val) => val.isEmpty ? 'Enter your' : null,
                onChanged: (val) {
                  setState(() => name = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Address Line 1'),
                validator: (val) => val.isEmpty ? 'Enter your Address' : null,
                onChanged: (val) {
                  setState(() => addr1 = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Address Line 2'),
                validator: (val) => val.isEmpty ? 'Enter your Address' : null,
                onChanged: (val) {
                  setState(() => addr2 = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Phone Number'),
                validator: (val) => val.length < 10 ? 'Enter a valid phone Number' : null,
                onChanged: (val) {
                  setState(() => phoneNo = val);
                },
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                  color: Colors.pink[400],
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if(_formKey.currentState.validate()){
                      setState(() => loading = true);
                      dynamic result = await _auth.registerWithEmailAndPassword(email, password, name, addr1, addr2, phoneNo);
                      if(result == null) {
                        setState(() {
                          loading = false;
                          error = 'Please supply a valid email';
                        });
                      }
                    }
                  }
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}