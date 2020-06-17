import 'package:flutter/material.dart';
import 'package:readyvendor/services/auth.dart';
import 'package:readyvendor/shared/constants.dart';
import 'package:readyvendor/shared/loading.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({ this.toggleView });
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  bool forgotPassword = false;

  @override
  bool passwordvisible;
  void initState(){
    passwordvisible=true;
  }
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Sign in to Ready'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Register'),
            onPressed: () => widget.toggleView(),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'email'),
                validator: (val) {
                  if(val.isEmpty)
                    return 'Please Enter your Email';
                  Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regex = new RegExp(pattern);
                  if(!regex.hasMatch(val))
                    return 'Enter Valid Email';
                  else
                    return null;
                },
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20.0),
              !forgotPassword ? TextFormField(
                obscureText: passwordvisible,
                decoration: textInputDecoration.copyWith(hintText: 'password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        passwordvisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          passwordvisible = !passwordvisible;
                        });
                      },
                    )
                ),
                validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ):Text("Enter Email to send password reset link"),
            FlatButton(
              child: !forgotPassword
                  ? new Text('Forgot password?',
                  style: new TextStyle(fontSize: 15.0, fontWeight: FontWeight.w300))
                  : new Text('Go Back to Sign In',
                  style:
                  new TextStyle(fontSize: 15.0, fontWeight: FontWeight.w300)),
              onPressed: () => setState(() {
                forgotPassword = !forgotPassword;
              }),
            ),
              SizedBox(height: 20.0),
              RaisedButton(
                  color: Colors.pink[400],
                  child: Text(
                    !forgotPassword?'Sign In':'Send Link to Reset',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if(_formKey.currentState.validate()){
                      setState(() => loading = true);
                      if(!forgotPassword){
                        dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                        if(result == null) {
                          setState(() {
                            loading = false;
                            error = 'Could not sign in with those credentials';
                          });
                        }
                      }else{
                        await _auth.resetPassword(email);
                        setState(() {
                          loading = false;
                          forgotPassword = !forgotPassword;
                        });
                        /*
                        final snackBar = SnackBar(
                          content: Text('Link Sent!'),
                        );
                        Scaffold.of(context).showSnackBar(snackBar);

                         */
                      }
                    }
                  }
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}