import 'package:flutter/material.dart';
import 'package:hidden_local_storage/storage_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HiddenPage extends StatefulWidget {
  static const routeName = '/hidden-page';

  const HiddenPage({Key? key}) : super(key: key);

  @override
  _HiddenPageState createState() => _HiddenPageState();
}

class _HiddenPageState extends State<HiddenPage> {
  final List<StorageData> _storageData = [];
  List<Map<String, dynamic>> switchItems = [
    {"name": "staging", "value": false},
    {"name": "Production", "value": false},
    {"name": "debug", "value": false},
  ];

  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSwitchValues();
  }

  void _addNewStorageData(String key, dynamic value) {
    final newSt = StorageData(key: key, value: value);
    setState(() {
      _storageData.add(newSt);
    });
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

  Widget _buildStorageDataRow(StorageData storageData) {
    return Container(
      padding: EdgeInsets.only(left: 2, top: 4, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Key',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
              controller: _keyController,
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            flex: 1,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Value',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
              controller: _valueController,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _storageData.remove(storageData);
              });
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
    );
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
          ..._storageData.map((data) => _buildStorageDataRow(data)).toList(),
          Container(
            padding: EdgeInsets.only(left: 2, top: 4, bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Key',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(
                        color: Colors.grey[400],
                      ),
                    ),
                    controller: _keyController,
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  flex: 1,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Value',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(
                        color: Colors.grey[400],
                      ),
                    ),
                    controller: _valueController,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    final key = _keyController.text;
                    final value = _valueController.text;

                    _addNewStorageData(key, value);

                    _keyController.clear();
                    _valueController.clear();
                  },
                  icon: Icon(Icons.add),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
