import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/storage_item.dart';

class StorageService {
  final _secureStorage = const FlutterSecureStorage();

  AndroidOptions _getAndroidOptions() =>
      const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  Future<void> writeSecureData(StorageItem newItem) async {
    debugPrint("Writing new data having key ${newItem.key}");
    String key=newItem.key;
    String deleteKey="DEV_OPS_$key";
    await _secureStorage.write(
      key: deleteKey,
      value: newItem.value,
      aOptions: _getAndroidOptions(),
    );
  }

  Future<String?> readSecureData(String key) async {
    debugPrint("Reading data having key $key");
    var readData = await _secureStorage.read(
      key: key,
      aOptions: _getAndroidOptions(),
    );
    return readData;
  }


  Future<List<StorageItem>> readAllSecureData() async {
    debugPrint("Reading all secured data");
    var allData = await _secureStorage.readAll(aOptions: _getAndroidOptions());

    List<StorageItem> list = [];
    for(var entry in allData.entries){
      print(entry.key);
    }
    for (var entry in allData.entries) {
      var key = entry.key;
      // Trim the "DEV_OPS_" prefix from the key
      if (key.startsWith("DEV_OPS_")) {
        key = key.substring("DEV_OPS_".length);
      }

      // Create a new StorageItem object with the trimmed key and the value
      list.add(StorageItem(key, entry.value));
    }

    return list;
  }

  Future<void> deleteSecureData(StorageItem item) async {
    String key=item.key;
    print(item.key);
    String deleteKey="DEV_OPS_$key";
    await _secureStorage.delete(
      key: deleteKey,
      aOptions: _getAndroidOptions(),
    );
  }
}
