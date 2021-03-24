import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sample/services/auth.dart';

class Users extends StatefulWidget {
  const Users({Key key, this.saham}) : super(key: key);
  @override
  _UsersState createState() => _UsersState();
  final saham;
}

class _UsersState extends State<Users> {
  int saldo;
  String error = '';
  int saldoo;
  withdrawAletrBox(BuildContext context) {
    TextEditingController custom = TextEditingController();
    TextEditingController custom1 = TextEditingController();
    TextEditingController custom2 = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Deposit"),
            content: SingleChildScrollView(
              child: Form(
                  child: Column(children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("Bank Name:", style: TextStyle(fontSize: 20)),
                ),
                TextField(controller: custom),
                Container(margin: EdgeInsets.only(bottom: 30)),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("Bank Account:", style: TextStyle(fontSize: 20)),
                ),
                TextField(
                    controller: custom1, keyboardType: TextInputType.number),
                Container(margin: EdgeInsets.only(bottom: 30)),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("Rp:", style: TextStyle(fontSize: 20)),
                ),
                TextField(
                    controller: custom2, keyboardType: TextInputType.number),
              ])),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  var ubah = int.parse(custom2.text);
                  try {
                    if (ubah <= saldo) {
                      setState(() {
                        saldo = saldo - ubah;
                      });
                    }
                  } catch (e) {
                    setState(() => error = "Saldo tidak cukup");
                  }
                },
                child: Text('Withdraw'),
              ),
            ],
          );
        });
  }

  depositAlertBox(BuildContext context) {
    TextEditingController custom = TextEditingController();
    TextEditingController custom1 = TextEditingController();
    TextEditingController custom2 = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Deposit"),
            content: SingleChildScrollView(
              child: Form(
                  child: Column(children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("Bank Name:", style: TextStyle(fontSize: 20)),
                ),
                TextField(controller: custom),
                Container(margin: EdgeInsets.only(bottom: 30)),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("Bank Account:", style: TextStyle(fontSize: 20)),
                ),
                TextField(
                    controller: custom1, keyboardType: TextInputType.number),
                Container(margin: EdgeInsets.only(bottom: 30)),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("Rp:", style: TextStyle(fontSize: 20)),
                ),
                TextField(
                    controller: custom2, keyboardType: TextInputType.number),
              ])),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  var ubah = int.parse(custom2.text);
                  if (saldo == null) {
                    setState(() {
                      saldo = ubah;
                    });
                  } else {
                    setState(() {
                      saldo = ubah + saldo;
                    });
                  }
                },
                child: Text('Deposit'),
              ),
            ],
          );
        });
  }

  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('TRAPP'),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
        child: Center(
          child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where("uid", isEqualTo: _authService.getCurrentUID())
                  .get(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) return CircularProgressIndicator();
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      DocumentSnapshot users = snapshot.data.docs[index];
                      return Column(children: [
                        Image.network(
                          'https://cdn4.iconfinder.com/data/icons/small-n-flat/24/user-alt-512.png',
                          width: 170,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await _authService.signOut();
                          },
                          child: Text('Log Out'),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                depositAlertBox(context);
                              },
                              child: Text('Deposit'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                withdrawAletrBox(context);
                              },
                              child: Text('Withdraw'),
                            )
                          ],
                        ),
                        Container(margin: EdgeInsets.only(bottom: 30)),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text("User Info:",
                              style: TextStyle(fontSize: 20)),
                        ),
                        Container(margin: EdgeInsets.only(bottom: 20)),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text("Nama: " + users['name'],
                              style: TextStyle(fontSize: 20)),
                        ),
                        Container(margin: EdgeInsets.only(bottom: 20)),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text("Email: " + users['email'],
                              style: TextStyle(fontSize: 20)),
                        ),
                        Container(margin: EdgeInsets.only(bottom: 20)),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text("Balance:" + saldo.toString(),
                              style: TextStyle(fontSize: 20)),
                        ),
                      ]);
                    });
              }),
        ),
      ),
    );
  }
}
