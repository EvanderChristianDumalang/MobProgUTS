import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sample/services/auth.dart';

class transaction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();
    return SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
            child: Center(
                child: FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('portofolio')
                        .where("uid", isEqualTo: _authService.getCurrentUID())
                        .get(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null)
                        return CircularProgressIndicator();
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot portofolio =
                                snapshot.data.docs[index];
                            return Container(
                                padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                                height: 100,
                                child: Card(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                          margin: EdgeInsets.only(top: 10)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(portofolio['kode'],
                                              style: TextStyle(fontSize: 20)),
                                          Text(portofolio['jumlah'].toString(),
                                              style: TextStyle(fontSize: 20))
                                        ],
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(top: 10)),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(portofolio['deskripsi'],
                                            style: TextStyle(fontSize: 15)),
                                      ),
                                    ],
                                  ),
                                ));
                          });
                    }))));
  }
}
