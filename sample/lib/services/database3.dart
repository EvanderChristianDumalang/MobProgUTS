import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService3{

  final String uid;
  DatabaseService3({this.uid});

  final CollectionReference userBalance = FirebaseFirestore.instance.collection('balance');

  Future <void> addBalance (int balance) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    String uid = _auth.currentUser.uid.toString();
    userBalance.add({'balance':balance, 'uid': uid});
    return;
  }

  Stream<QuerySnapshot> get portofolio{
    return userBalance.snapshots();
  }
}