import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:sample/screens/Page/Transaction.dart';
import 'package:sample/services/database2.dart';

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


  List chart2 = [];
  List<double> chart3 = [];
  Future<void> chart() async {
    var symbol = lowercase(widget.saham['nama']);
    var api = await http.get(Uri.parse('https://finnhub.io/api/v1/stock/candle?symbol=${symbol}&resolution=M&from=1600651390&to=2021243390&token=c12t6dv48v6oi2531ibg'));
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
                onPressed: (){
                    DatabaseService2().addPortofolio(_kode, _deskripsi,int.parse(_price),int.parse(_jumlah.text));
                    Navigator.pop(context);
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
              child: Text(widget.saham['price'], style: TextStyle(fontSize: 20)),
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
                  child: Text('BUY',),
                ),
                ElevatedButton(
                  onPressed: () {},
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
