import 'package:sample/screens/Page/StockDetail.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart'as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

String changesymbol(String s) {
  return '${s.replaceAll('.JK', '')}';
}

String lowercase(String s) {
  return '${s.toLowerCase()}';
}
List saham=[];
List allstock=[];
class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    this.stocks();
  }

  Future<void>stocks()async{
    var api = await http.get(Uri.parse('https://finnhub.io/api/v1/stock/symbol?exchange=JK&token=c12t6dv48v6oi2531ibg'));
    if(api.statusCode==200){
      var stock=json.decode(api.body);
      setState(() {
        saham=stock;
      });
    }
    for(int i=0;i<10;i++){
      var harga=lowercase(saham[i]['symbol']);
      // ignore: unnecessary_brace_in_string_interps
      var hargaapi = await http.get(Uri.parse('https://finnhub.io/api/v1/quote?symbol=${harga}&token=c12t6dv48v6oi2531ibg'));
      if(hargaapi.statusCode==200){
        var stockharga=json.decode(hargaapi.body);
        var x={
          "price":stockharga['c'].toString(),
          "nama":saham[i]['symbol'],
          "description":saham[i]['description'],
        };
        setState(() {
          allstock.add(x);
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('TRAPP'),actions: <Widget>[IconButton(icon: Icon(Icons.search), onPressed:(){
          showSearch(context: context, delegate: stockSearch());
        }) 
        ],
      ),
      body: getbody(),
    );
  }

  Widget getbody(){
   return ListView.builder(
        itemCount: allstock.length,
        itemBuilder: (context, index) {
          var sahamm = allstock[index];
          return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => stockdetail(saham: sahamm)));
              },
              child: Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                  height: 100,
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Container(margin: EdgeInsets.only(top: 10)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(changesymbol(sahamm['nama'].toString()),
                                style: TextStyle(fontSize: 20)),
                            Text(sahamm['price'],
                                style: TextStyle(fontSize: 20))
                          ],
                        ),
                        Container(margin: EdgeInsets.only(top: 10)),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(sahamm['description'],
                              style: TextStyle(fontSize: 15)),
                        ),
                      ],
                    ),
                  )));
        });
  }
}

// ignore: camel_case_types
class stockSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
   return Center(child:Text(query));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final liststock= query.isEmpty? allstock: allstock.where((p) => p['nama'].startsWith(query.toUpperCase())).toList();
    return liststock.isEmpty? Text("No Stock"): ListView.builder(
        itemCount: liststock.length,
        itemBuilder: (context, index) {
          var sahamm = liststock[index];
          return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => stockdetail(saham: sahamm)));
              },
              child: Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                  height: 100,
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Container(margin: EdgeInsets.only(top: 10)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(changesymbol(sahamm['nama'].toString()),
                                style: TextStyle(fontSize: 20)),
                            Text(sahamm['price'],
                                style: TextStyle(fontSize: 20))
                          ],
                        ),
                        Container(margin: EdgeInsets.only(top: 10)),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(sahamm['description'],
                              style: TextStyle(fontSize: 15)),
                        ),
                      ],
                    ),
                  )));
        });
  }
}