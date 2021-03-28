import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sample/services/auth.dart';
import 'StockDetail.dart';

class Transaction extends StatefulWidget {
  @override
  _TransactionState createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('TRAPP'),actions:  <Widget>[IconButton(icon: Icon(Icons.refresh), onPressed:(){
         Navigator.push( context, MaterialPageRoute( builder: (context) => Transaction()), ).then((value) => setState(() {}));
        }) 
        ],
      ),
      body: getBody(),
    );
  }
List porto=[];
  Widget getBody() {
    final AuthService _authService = AuthService();
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('portofolio')
            .where("uid", isEqualTo: _authService.getCurrentUID())
            .get(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) return CircularProgressIndicator();
          return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                var portofolio = snapshot.data.docs[index];
                var x = {
                        'price': portofolio['price'].toString(),
                        'nama': portofolio['kode'],
                        'description': portofolio['deskripsi'],
                      };
                      porto.add(x);
                return InkWell(
                    onTap: () {
                     
                      
                      if(porto.isNotEmpty){
                      print(porto);}
                      if(porto.isNotEmpty){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  stockdetail(saham: porto[index])));}
                    },
                    child: Container(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                        height: 100,
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              Container(margin: EdgeInsets.only(top: 10)),
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
                              Container(margin: EdgeInsets.only(top: 10)),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(portofolio['deskripsi'],
                                    style: TextStyle(fontSize: 15)),
                              ),
                            ],
                          ),
                        )));
              });
        });
  }
}
