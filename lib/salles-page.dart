import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mini_projet_flutter/globalVariables.dart';

import 'globalVariables.dart';

class SallesPage extends StatefulWidget {
  dynamic cinema;
  SallesPage(this.cinema);
  @override
  _SallesPageState createState() => _SallesPageState();
}

class _SallesPageState extends State<SallesPage> {
  late List<dynamic> listSalles;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Salles de cinéma ${widget.cinema['name']}"),
      ),
      body: Center(
          child: this.listSalles == null
              ? CircularProgressIndicator()
              : ListView.builder(
                  itemCount:
                      (this.listSalles == null) ? 0 : this.listSalles.length,
                  itemBuilder: (context, index) {
                    return Card(
                        color: Colors.white70,
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  color: Colors.redAccent,
                                  child: Text(this.listSalles[index]['name'],
                                      style: TextStyle(color: Colors.white)),
                                  onPressed: () {
                                    loadProjections(this.listSalles[index]);
                                  },
                                ),
                              ),
                            ),
                            if (this.listSalles[index]['projections'] != null)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.network(
                                      GlobalData.host +
                                          "/imageFilm/${this.listSalles[index]['currentProjection']['film']['id']}",
                                      width: 150,
                                    ),
                                    Column(
                                      children: [
                                        ...(this.listSalles[index]
                                                    ['projections']
                                                as List<dynamic>)
                                            .map((projection) {
                                          return RaisedButton(
                                            color: (this.listSalles[index][
                                                            'currentProjection']
                                                        ['id'] ==
                                                    projection['id'])
                                                ? Colors.deepPurple
                                                : Colors.blueGrey,
                                            child: Text(
                                              "${projection['seance']['heureDebut']}(${projection['film']['duree']},Prix=${projection['prix']})",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                            onPressed: () {
                                              loadTickets(projection,
                                                  this.listSalles[index]);
                                            },
                                          );
                                        })
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            if (this.listSalles[index]['currentProjection'] !=
                                    null &&
                                this.listSalles[index]['currentProjection']
                                        ['listTickets'] !=
                                    null &&
                                this
                                        .listSalles[index]['currentProjection']
                                            ['listTickets']
                                        .length >
                                    0)
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                          "Nombre de places disponible:${this.listSalles[index]['currentProjection']['nombrePlacesDisponibles']}")
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
                                    child: TextField(
                                      decoration: InputDecoration(
                                          hintText: 'Your name'),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
                                    child: TextField(
                                      decoration: InputDecoration(
                                          hintText: 'Code payemant'),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
                                    child: TextField(
                                      decoration: InputDecoration(
                                          hintText: 'Nombre de Tickets'),
                                    ),
                                  ),
                                  Container(
                                      width: double.infinity,
                                      child: RaisedButton(
                                        color: Colors.redAccent,
                                        child: Text(
                                          "Réserver les places",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () {},
                                      )),
                                  Wrap(
                                    children: [
                                      ...listSalles[index]['currentProjection']
                                              ['listTickets']
                                          .map((ticket) {
                                        if (ticket['reservee'] == false)
                                          return Container(
                                            width: 50,
                                            padding: EdgeInsets.all(2),
                                            child: RaisedButton(
                                              color: Colors.blueAccent,
                                              child: Text(
                                                "${ticket['place']['numero']}",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ),
                                              onPressed: () {},
                                            ),
                                          );
                                        else
                                          return Container();
                                      })
                                    ],
                                  )
                                ],
                              ),
                          ],
                        ));
                  })),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadSalles();
  }

  void loadSalles() {
    String url = this.widget.cinema['_links']['salles']['href'];
    //var url = Uri.parse('https://example.com/whatsit/create');
    http.get(Uri.parse(url)).then((resp) {
      setState(() {
        this.listSalles = json.decode(resp.body)['_embedded']['salles'];
      });
    }).catchError((err) {
      print(err);
    });
  }

  void loadProjections(salle) {
    //String url1=GlobalData.host+"/salles/${salle['id']}/projections?projection=p1";
    String url2 = salle['_links']['projections']['href']
        .toString()
        .replaceAll("{?projection}", "?projection=p1");
    //print(url1);
    print(url2);
    //var url2 = Uri.parse('https://example.com/whatsit/create');
    http.get(Uri.parse(url2)).then((resp) {
      setState(() {
        salle['projections'] =
            json.decode(resp.body)['_embedded']['projections'];
        salle['currentProjection'] = salle['projections'][0];
        salle['currentProjection']['listTickets'] = [];
        //print(salle['projections']);
      });
    }).catchError((err) {
      print(err);
    });
  }

  void loadTickets(projection, salle) {
    //String url="http://localhost:8080/projections/1/tickets?projection=ticketProj";
    String url = projection['_links']['tickets']['href']
        .toString()
        .replaceAll("{?projection}", "?projection=p2");
    //var url = Uri.parse('https://example.com/whatsit/create');
    http.get(Uri.parse(url)).then((resp) {
      setState(() {
        projection['listTickets'] =
            json.decode(resp.body)['_embedded']['tickets'];
        salle['currentProjection'] = projection;
        projection['nombrePlacesDisponibles'] =
            nombrePlaceDisponibles(projection);
      });
    }).catchError((err) {
      print(err);
    });
  }

  nombrePlaceDisponibles(projection) {
    int nombre = 0;
    for (int i = 0; i < projection['tickets'].length; i++) {
      if (projection['tickets'][i]['reservee'] == false) ++nombre;
    }
    return nombre;
  }
}
