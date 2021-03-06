import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'cinema-page.dart';

class VillePage extends StatefulWidget {
  const VillePage({Key? key}) : super(key: key);

  @override
  _VillePageState createState() => _VillePageState();
}

class _VillePageState extends State<VillePage> {
  late List<dynamic> listVilles;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Villes'),
      ),
      body: Center(
          child: this.listVilles == null
              ? CircularProgressIndicator()
              : ListView.builder(
                  itemCount:
                      (this.listVilles == null) ? 0 : this.listVilles.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.green,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          color: Colors.white,
                          child: Text(this.listVilles[index]['name'],
                              style: TextStyle(color: Colors.blue)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        new CinemasPage(listVilles[index])));
                          },
                        ),
                      ),
                    );
                  })),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadVilles();
  }

  void loadVilles() {
    String url = "http://172.17.152.1:8081/villes";
    //var url = Uri.parse("http://192.168.56.1:8000/villes");
    http.get(Uri.parse(url)).then((resp) {
      setState(() {
        this.listVilles = json.decode(resp.body)['_embedded']['villes'];
      });
    }).catchError((err) {
      print(err);
    });
  }
}
