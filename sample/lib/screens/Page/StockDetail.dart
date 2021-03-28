import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:sample/screens/Page/Transaction.dart';
import 'package:sample/services/database2.dart';
import 'package:sample/services/auth.dart';
import 'package:sample/services/database3.dart';

String lowercase(String s) {
  return '${s.toLowerCase()}';
}

class stockdetail extends StatefulWidget {
  const stockdetail({Key key, this.saham}) : super(key: key);
  @override
  _stockdetailState createState() => _stockdetailState();
  final saham;
}

class _stockdetailState extends State<stockdetail> {
  @override
  void initState() {
    super.initState();
    this.chart();
  }

  int balance;
  int hasil;
  List chart2 = [];
  List<double> chart3 = [];
  List porto = [];

  final AuthService _authService = AuthService();
  Future<void> chart() async {
    var symbol = lowercase(widget.saham['nama']);
    var api = await http.get(Uri.parse(
        'https://finnhub.io/api/v1/stock/candle?symbol=${symbol}&resolution=M&from=1600651390&to=2021243390&token=c12t6dv48v6oi2531ibg'));
    if (api.statusCode == 200) {
      var stockapi = jsonDecode(api.body);
      var x = {"data": stockapi['c']};
      chart2 = x['data'];
      for (int i = 0; i < chart2.length; i++) {
        var ubah = double.parse(chart2[i].toString());
        setState(() {
          chart3.add(ubah);
        });
      }
    }
  }

  sellAlertBox(BuildContext context) {
    TextEditingController _jumlah = TextEditingController();

    var _kode = widget.saham['nama'];
    var _deskripsi = widget.saham['description'];
    var _price = widget.saham['price'];
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(widget.saham['nama']),
            content: TextField(
                controller: _jumlah, keyboardType: TextInputType.number),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (hasil != null) {
                      hasil = hasil - int.parse(_jumlah.text);
                      porto.clear();
                      FirebaseFirestore.instance
                          .collection('portofolio')
                          .where('uid', isEqualTo: _authService.getCurrentUID())
                          .get()
                          .then((value) {
                        FirebaseFirestore.instance
                            .collection('portofolio')
                            .where('kode', isEqualTo: _kode)
                            .get()
                            .then((value) {
                          value.docs.forEach((element) {
                            FirebaseFirestore.instance
                                .collection('portofolio')
                                .doc(element.id)
                                .delete()
                                .then((value) {
                              DatabaseService2().addPortofolio(
                                  _kode, _deskripsi, int.parse(_price), hasil);
                            });
                          });
                        });
                      });
                      FirebaseFirestore.instance
                          .collection('balance')
                          .where('uid', isEqualTo: _authService.getCurrentUID())
                          .get()
                          .then((value) {
                        value.docs.forEach((element) {
                          FirebaseFirestore.instance
                              .collection('balance')
                              .doc(element.id)
                              .delete()
                              .then((value) {
                            DatabaseService3().addBalance(balance +
                                int.parse(_jumlah.text) * int.parse(_price));
                          });
                        });
                      });
                    }
                  });

                  Navigator.pop(context);
                },
                child: Text('SELL'),
              ),
            ],
          );
        });
  }

  buyAlertBox(BuildContext context) {
    TextEditingController _jumlah = TextEditingController();

    var _kode = widget.saham['nama'];
    var _deskripsi = widget.saham['description'];
    var _price = widget.saham['price'];
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(widget.saham['nama']),
            content: TextField(
                controller: _jumlah, keyboardType: TextInputType.number),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (hasil == null) {
                      if (balance <
                          (int.parse(_jumlah.text) * int.parse(_price))) {
                        final snackBar =
                            SnackBar(content: Text('Balance limited'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        print("ey");
                      } else {
                        DatabaseService2().addPortofolio(_kode, _deskripsi,
                            int.parse(_price), int.parse(_jumlah.text));
                        hasil = int.parse(_jumlah.text);

                        FirebaseFirestore.instance
                            .collection('balance')
                            .where('uid',
                                isEqualTo: _authService.getCurrentUID())
                            .get()
                            .then((value) {
                          value.docs.forEach((element) {
                            FirebaseFirestore.instance
                                .collection('balance')
                                .doc(element.id)
                                .delete()
                                .then((value) {
                              DatabaseService3().addBalance(balance -
                                  int.parse(_jumlah.text) * int.parse(_price));
                            });
                          });
                        });
                      }
                      porto.clear();
                    } else {
                      hasil = hasil + int.parse(_jumlah.text);
                      porto.clear();
                      FirebaseFirestore.instance
                          .collection('portofolio')
                          .where('uid', isEqualTo: _authService.getCurrentUID())
                          .get()
                          .then((value) {
                        FirebaseFirestore.instance
                            .collection('portofolio')
                            .where('kode', isEqualTo: _kode)
                            .get()
                            .then((value) {
                          value.docs.forEach((element) {
                            FirebaseFirestore.instance
                                .collection('portofolio')
                                .doc(element.id)
                                .delete()
                                .then((value) {
                              DatabaseService2().addPortofolio(
                                  _kode, _deskripsi, int.parse(_price), hasil);
                            });
                          });
                        });
                      });
                      if (balance <
                          (int.parse(_jumlah.text) * int.parse(_price))) {
                        final snackBar =SnackBar(content: Text('Balance limited'));
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        print("ey");
                      } else {
                        FirebaseFirestore.instance
                            .collection('balance')
                            .where('uid',
                                isEqualTo: _authService.getCurrentUID())
                            .get()
                            .then((value) {
                          value.docs.forEach((element) {
                            FirebaseFirestore.instance
                                .collection('balance')
                                .doc(element.id)
                                .delete()
                                .then((value) {
                              DatabaseService3().addBalance(balance -
                                  int.parse(_jumlah.text) * int.parse(_price));
                            });
                          });
                        });
                        print('no');
                        Navigator.pop(context);
                      }
                    }
                  });
                },
                child: Text('BUY'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    if (chart3?.isEmpty ?? true) {
      return Scaffold(
          appBar: AppBar(title: Text(widget.saham['nama'])),
          body: transition());
    } else {
      return Scaffold(
          appBar: AppBar(title: Text(widget.saham['nama'])), body: getBody());
    }
  }

  Widget transition() {
    setState(() => getBody());
  }

  Widget getBody() {
    FirebaseFirestore.instance
        .collection('portofolio')
        .where('uid', isEqualTo: _authService.getCurrentUID())
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        var x = {
          'jumlah': doc['jumlah'],
          'kode': doc['kode'],
          'price': doc['price']
        };
        porto.add(x);
      });
    });
    FirebaseFirestore.instance
        .collection('balance')
        .where('uid', isEqualTo: _authService.getCurrentUID())
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        balance = doc['balance'];
      });
    });
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.fromLTRB(30, 50, 30, 0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(widget.saham['description'],
                  style: TextStyle(fontSize: 20)),
            ),
            Container(margin: EdgeInsets.only(bottom: 10)),
            Align(
              alignment: Alignment.topLeft,
              child:
                  Text(widget.saham['price'], style: TextStyle(fontSize: 20)),
            ),
            Container(margin: EdgeInsets.only(bottom: 40)),
            Container(
                width: 400,
                height: 200,
                child: new Sparkline(
                    data: chart3,
                    lineColor: Color(0xffff6102),
                    pointsMode: PointsMode.all,
                    pointSize: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                )),
            Container(margin: EdgeInsets.only(bottom: 30)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    buyAlertBox(context);
                  },
                  child: Text(
                    'BUY',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    sellAlertBox(context);
                  },
                  child: Text('SELL'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
