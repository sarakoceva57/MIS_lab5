import 'package:flutter/material.dart';
import 'package:nanoid/nanoid.dart';
import '../model/list_item.dart';
import '../model/lokacija.dart';

class DodadiElement extends StatefulWidget {
  final Function addItem;

  DodadiElement(this.addItem);
  @override
  State<StatefulWidget> createState() => _DodadiElementState();
}

class _DodadiElementState extends State<DodadiElement> {
  final _naslovController = TextEditingController();
  final _dateController = TextEditingController();
  final _locationController = TextEditingController();

  // late Location location;

  Future? _submitData(BuildContext context) {
    if (_naslovController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _locationController.text.isEmpty) {
      return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Пополнете ги полињата'),
          actions: <Widget>[
            TextButton(
                onPressed: (() {
                  Navigator.of(context).pop();
                }),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text("OK"),
                ))
          ],
        ),
      );
    }
    int check1 = '-'.allMatches(_dateController.text).length;
    int check2 = ':'.allMatches(_dateController.text).length;

    if (_dateController.text.length < 16 || check1 != 2 || check2 != 1) {
      print("Внесете точен формат за датум!");
      return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('Неточен формат!'),
                content: SingleChildScrollView(
                  child: Text("Внесете точен формат за датум."),
                ),
                actions: <Widget>[
                  TextButton(
                      onPressed: (() {
                        Navigator.of(context).pop();
                      }),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Text("OK"),
                      ))
                ],
              ));
    }
    final String stringDate = _dateController.text + ':00';

    DateTime date = DateTime.parse(stringDate);

    final newItem = ListItem(
      id: nanoid(5),
      predmet: _naslovController.text,
      datum: date,
      location: location,
    );
    widget.addItem(newItem);
    Navigator.of(context).pop();
  }

  DateTime dateTime = DateTime(2022, 11, 24, 10, 15);
  Location location = Location(latitude: 42.0043165, longitude: 21.4096452);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: "Ime na predmetot: ",
              border: OutlineInputBorder(),
            ),
            controller: _naslovController,
            textInputAction: TextInputAction.next,
            style: TextStyle(fontSize: 30),
            onSubmitted: (_) => _submitData(context),
          ),
          TextField(
            decoration: InputDecoration(labelText: "Datum:"),
            controller: _dateController,
            onSubmitted: (_) => _submitData(context),
            textInputAction: TextInputAction.next,
          ),
          TextField(
            decoration: InputDecoration(labelText: "Vnesi lokacija:"),
            controller: _locationController,
            onSubmitted: (_) => _submitData(context),
            textInputAction: TextInputAction.next,
          ),
        ],
      ),
    );
  }

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100));
  Future<TimeOfDay?> pickTime() => showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));
}

//

class AdaptiveFlatButton extends StatelessWidget {
  final String text;
  final VoidCallback handler;

  AdaptiveFlatButton(this.text, this.handler);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(text),
      onPressed: handler,
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(
          const TextStyle(fontSize: 50),
        ),
        backgroundColor:
            MaterialStateProperty.all(Color.fromARGB(255, 233, 197, 149)),
      ),
    );
  }
}
