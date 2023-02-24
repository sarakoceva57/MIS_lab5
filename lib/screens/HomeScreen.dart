import 'package:firebase_auth/firebase_auth.dart';
import 'package:novo/screens/GoogleMapScreen.dart';
import '../services/notification_service.dart';
import '../screens/LoginScreen.dart';
import 'calendar.dart';
import '../model/list_item.dart';
import 'dodadi_element.dart';
import 'package:firebase_core/firebase_core.dart';
import '../model/lokacija.dart';
import 'package:flutter/material.dart';
import 'package:nanoid/nanoid.dart';

class HomeScreen extends StatefulWidget {
  static const String idScreen = "mainScreen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final NotificationService service;

  @override
  void initState() {
    service = NotificationService();
    service.initialize();
    super.initState();
  }

  final List<ListItem> _userItems = [
    ListItem(
      id: "T1",
      predmet: "Bazi Na Podatoci",
      datum: DateTime.parse("2022-11-19 10:00:00"),
      location: Location(latitude: 42.0043165, longitude: 21.4096452),
    ),
    ListItem(
      id: "T2",
      predmet: "Veb Programiranje",
      datum: DateTime.parse("2022-11-19 15:00:00"),
      location: Location(latitude: 42.0043165, longitude: 21.4096452),
    ),
    ListItem(
      id: "T3",
      predmet: "Agoritmi i Podatocni Strukturi",
      datum: DateTime.parse("2022-11-21 08:00:00"),
      location: Location(latitude: 38.0043165, longitude: 19.4096452),
    ),
    ListItem(
      id: "T4",
      predmet: "Strukturno Programiranje",
      datum: DateTime.parse("2022-11-22 14:30:00"),
      location: Location(latitude: 38.0043165, longitude: 19.4096452),
    ),
    ListItem(
      id: "T5",
      predmet: "Kalkulus",
      datum: DateTime.parse("2022-11-22 16:00:00"),
      location: Location(latitude: 38.0043165, longitude: 19.4096452),
    ),
  ];

  void _openCalendarFunction(BuildContext ct) {
    showModalBottomSheet(
        context: ct,
        isScrollControlled: true,
        builder: (_) {
          return GestureDetector(
              onTap: () {},
              child: CalendarApp(),
              behavior: HitTestBehavior.opaque);
        });
  }

  void _addItemFunction(BuildContext ct) {
    showModalBottomSheet(
        context: ct,
        builder: (_) {
          return GestureDetector(
              onTap: () {},
              child: DodadiElement(_addNewItemToList),
              behavior: HitTestBehavior.opaque);
        });
  }

  void _addNewItemToList(ListItem item) {
    setState(() {
      _userItems.add(item);
    });
  }

  void _deleteItem(String id) {
    setState(() {
      _userItems.removeWhere((elem) => elem.id == id);
    });
  }

  Widget _createAppBar() {
    return AppBar(title: Text("Lab5-186041"), actions: <Widget>[
      IconButton(
        icon: Icon(Icons.add),
        onPressed: () => _addItemFunction(context),
      ),
      IconButton(
        onPressed: () {
          FirebaseAuth.instance.signOut();
        },
        icon: Icon(Icons.logout),
      ),
    ]);
  }

  Widget _createBody() {
    return Container(
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
      ElevatedButton.icon(
        icon: Icon(
          Icons.notifications,
          size: 30,
        ),
        label: Text(
          "Нотификации",
          style: TextStyle(fontSize: 20),
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(15),
        ),
        onPressed: () async {
          await service.showNotification(
              id: 0,
              title: 'Наскоро имате испити',
              body: 'Проверете во календарот');
        },
      ),
      Center(
        child: _userItems.isEmpty
            ? Text("Nema termini")
            : ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _userItems.length,
                itemBuilder: (ctx, index) {
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 15,
                    ),
                    child: ListTile(
                      title: Text(_userItems[index].predmet),
                      trailing: IconButton(
                        onPressed: () => _deleteItem(_userItems[index].id),
                        icon: Icon(Icons.delete),
                      ),
                    ),
                  );
                },
                //itemCount: _userItems.length,
              ),
      ),
      Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: ElevatedButton.icon(
                icon: Icon(
                  Icons.maps_home_work,
                  size: 30,
                ),
                label: Text(
                  "Мапа",
                  style: TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(10),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MapScreen(_userItems)));
                },
              ),
            )
          ],
        ),
      ),
    ])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: _createAppBar(),
      ),
      body: _createBody(),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.brown,
        onPressed: () {
          _openCalendarFunction(context);
        },
        icon: Icon(Icons.calendar_month),
        label: Text('Календар'),
      ),
    );
  }
}
