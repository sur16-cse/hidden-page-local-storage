import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HiddenPage extends StatefulWidget {
  static const routeName = '/hidden-page';

  const HiddenPage({Key? key}) : super(key: key);

  @override
  _HiddenPageState createState() => _HiddenPageState();
}

class _HiddenPageState extends State<HiddenPage> {
  List<Map<String, dynamic>> switchItems = [
    {"name": "staging", "value": false},
    {"name": "Production", "value": false},
    {"name": "debug", "value": false},
  ];

  @override
  void initState() {
    super.initState();
    loadSwitchValues();
  }

  void loadSwitchValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      switchItems.forEach((item) {
        if (prefs.containsKey(item['name'])) {
          item['value'] = prefs.getBool(item['name'])!;
        } else {
          prefs.setBool(item['name'], item['value']);
        }
      });
    });
  }

  void saveSwitchValue(String name, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(name, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hidden Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ...switchItems.map((item) {
            return SwitchListTile(
              title: Text(item["name"]),
              value: item['value'],
              onChanged: (bool value) {
                setState(() {
                  item['value'] = value;
                  saveSwitchValue(item['name'], value);
                });
              },
            );
          }).toList(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                // optional flex property if flex is 1 because the default flex is 1
                flex: 1,
                child: TextField(
                  decoration: InputDecoration(
                      labelText: 'Key',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(
                          color: Colors.grey[400]
                      )
                  ),
                ),
              ),
              SizedBox(width: 10.0),
              Expanded(
                // optional flex property if flex is 1 because the default flex is 1
                flex: 1,
                child: TextField(
                  decoration: InputDecoration(
                      labelText: 'Value',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(
                          color: Colors.grey[400]
                      )
                  ),
                ),
              ),
            ],
          ),
          ElevatedButton(onPressed: (){}, child: Text("ADD"))
        ],
      ),
    );
  }
}

