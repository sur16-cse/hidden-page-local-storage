import 'package:flutter/material.dart';
import 'package:hidden_local_storage/storage_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HiddenPage extends StatefulWidget {
  static const routeName = '/hidden-page';

  const HiddenPage({Key? key}) : super(key: key);

  @override
  _HiddenPageState createState() => _HiddenPageState();
}

class _HiddenPageState extends State<HiddenPage> {
  //initialising secure storage
  final _secureStorage = const FlutterSecureStorage();
  //list to store and display storage data
  final List<StorageData> _storageData = [];
  // switch items


  //controller for initialise component
  final TextEditingController _newKeyController = TextEditingController();
  final TextEditingController _newValueController = TextEditingController();

  //write in secure storage
  Future<void> writeSecureData(StorageData newItem) async {
    await _secureStorage.write(key: newItem.key, value: newItem.value);
  }

  //read from secure storage
  Future<void> readSecureData() async {
    final allKeys = await _secureStorage.readAll();
    setState(() {
      _storageData.clear();
      allKeys.forEach((key, value) {
        _storageData.add(StorageData(key: key, value: value));
      });
    });
  }

  //delete from secure storage
  Future<void> deleteSecureData(String key) async {
    await _secureStorage.delete(key: key);
    setState(() {
      _storageData.removeWhere((data) => data.key == key);
    });
  }

  // add new storage data after + click
  void _addNewStorageData(String key, String value) {
    final newSt = StorageData(key: key, value: value);
    setState(() {
      _storageData.add(newSt);
    });
    writeSecureData(newSt);
  }

  @override
  void initState() {
    super.initState();
    readSecureData();
  }


  Widget _buildStorageDataRow(StorageData storageData) {
    final TextEditingController _keyController = TextEditingController();
    final TextEditingController _valueController = TextEditingController();

    _keyController.text = storageData.key;
    _valueController.text = storageData.value;

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
                deleteSecureData(storageData.key);
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
                    controller: _newKeyController,
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
                    controller: _newValueController,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    final key = _newKeyController.text;
                    final value = _newValueController.text;

                    _addNewStorageData(key, value);

                    _newKeyController.clear();
                    _newValueController.clear();
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
