import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sample/services/auth.dart';


class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _pass = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  
  final AuthService _authService = AuthService();

  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(140.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0.0,
          flexibleSpace: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            Center(
              child: Text('Sign In', style: TextStyle(color: Colors.black, fontSize: (50)),
                ),
              ),
            ],
          )
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _form,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: "Enter Email",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),
                    //fillColor: Colors.green
                  ),
                  validator: (val) {
                    if (val.isEmpty) {
                      return "Email cannot be empty";
                    } 
                      return null;
                  },
                  onChanged: (val) {
                    setState(() => email = val.trim());
                  },
                  keyboardType: TextInputType.emailAddress,
                  style: new TextStyle(
                    fontFamily: "Poppins",
                  ),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction, 
                  obscureText: true,
                  decoration: new InputDecoration(
                    labelText: "Enter Password",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),
                    //fillColor: Colors.green
                  ),
                  controller: _pass,
                  validator: (val) {
                    if (val.length == 0) {
                      return "Password cannot be empty";
                    } 
                    if (val.length < 8){
                      return "Password cannot be less than 8 character";
                    }
                      return null;
                  },
                  onChanged: (val) {
                    setState(() => password = val.trim());
                  }, 
                  keyboardType: TextInputType.visiblePassword,
                  style: new TextStyle(
                    fontFamily: "Poppins",
                  ),
                ),
                SizedBox(height: 20.0),
                Text(error, style: TextStyle(color: Colors.red, fontSize: 14),
                ),
                SizedBox(height: 20),
                TextButton(
                onPressed: () async {
                try{
                  setState(() => loading = true);
                  if (_form.currentState.validate()){
                    setState(() => loading = true);
                    // ignore: unused_local_variable
                    dynamic result = await _authService.signInWithEmailAndPassword(email, password);
                  }
                }
                on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    setState(() => error = 'No user exists with this email');
                  } 
                  else if (e.code == 'wrong-password') {
                    setState(() => error = 'Incorrect Password  ');
                  }
                }
                }, 
                child: 
                Text ("Log In", style: TextStyle(color: Colors.white)), 
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 15, horizontal: 100)),
                    textStyle: MaterialStateProperty.all(TextStyle(fontSize: 30)),
                    backgroundColor: MaterialStateProperty.all(Colors.teal[300])
                  )
                ),
                SizedBox(height: 20.0),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [ 
                  Text("Don't have an account ?",style: TextStyle(fontSize: 20)),
                  TextButton(
                  onPressed: () {
                  widget.toggleView();
                  },
                  child: Text('Sign Up', style: TextStyle(fontSize: 20),),
                  )
                  ],
                )
              ],
            ),
          )
        ),
      ),
    );
  }
}