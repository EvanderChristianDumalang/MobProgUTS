import 'package:flutter/material.dart';
import 'package:sample/models/user.dart';
import 'package:sample/screens/bottomNav.dart';
import 'sign/Authenticate.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);

    if (user == null){
      return Authenticate();
    }
    else {
      return bottomNav();
    }
  }
}