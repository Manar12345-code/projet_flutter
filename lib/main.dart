import 'package:flutter/material.dart';
import 'package:mini_projet_flutter/setting-page.dart';
import 'package:mini_projet_flutter/villes-page.dart';

void main() => runApp(
      MaterialApp(
        theme: ThemeData(appBarTheme: AppBarTheme(color: Colors.orange)),
        home: MyApp(),
      ),
    );

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final menus = [
    {'title': 'Home', 'icon': Icon(Icons.home), 'page': VillePage}
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cinema Page"),
      ),
      body: Center(
        child: Text("Home Cinema..."),
      ),
      drawer: Drawer(
        //specifir un menu
        child: ListView(
          children: [
            DrawerHeader(
              child: Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage("./images/profile.jpg"),
                  radius: 30,
                ),
              ),
              decoration: BoxDecoration(
                  gradient:
                      LinearGradient(colors: [Colors.white, Colors.black])),
            ),
            Divider(
              color: Colors.black,
            ),
            ListTile(
              title: Text("Home"),
              leading: Icon(Icons.home),
              trailing: Icon(Icons.arrow_right),
              onTap: () {
                Navigator.pop(context); //fermer menu page courante
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => new VillePage()));
              },
            ),
            Divider(
              color: Colors.black,
            ),
            ListTile(
              title: Text("Setting"),
              leading: Icon(Icons.settings),
              trailing: Icon(Icons.arrow_right),
              onTap: () {
                Navigator.pop(context); //fermer menu page courante
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => new SettingPage()));
              },
            )
          ],
        ),
      ),
    );
  }
}
