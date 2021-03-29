import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample/services/auth.dart';
import 'screens/wrapper.dart';
import 'package:sample/models/user.dart';

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // ignore: missing_required_param
    return StreamProvider<MyUser>.value(
       value: AuthService().user,
       child: MaterialApp(
       home: Wrapper(),
      )
    );
  }
}

// Email: Evansimba666@gmail.com
// Password: asdasdasd