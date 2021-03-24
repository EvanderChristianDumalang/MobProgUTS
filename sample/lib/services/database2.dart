import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService2{

  final String uid;
  DatabaseService2({this.uid});

  final CollectionReference userPortofolio = FirebaseFirestore.instance.collection('portofolio');

  Future <void> addPortofolio (String kode, String deskripsi,int price, int jumlah) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    String uid = _auth.currentUser.uid.toString();
    userPortofolio.add({'kode': kode, 'deskripsi': deskripsi,'price':price, 'jumlah': jumlah, 'uid': uid});
    return;
  }

  Stream<QuerySnapshot> get portofolio{
    return userPortofolio.snapshots();
  }  
}