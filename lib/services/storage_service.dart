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
    await _secureStorage.write(
      key: newItem.key,
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

  Future<List<StorageItem>> readSecureDataWithPrefix(
      List<String> prefixes) async {
    debugPrint("Reading secure data with prefixes: $prefixes");
    var allData = await _secureStorage.readAll(aOptions: _getAndroidOptions());
    List<StorageItem> filteredList = [];

    for (var entry in allData.entries) {
      for (var prefix in prefixes) {
        if (entry.key.startsWith(prefix)) {
          var keyParts = entry.key.split('_');
          if (keyParts.isNotEmpty) {
            var lastValueKey = keyParts.last;
            filteredList.add(StorageItem(lastValueKey, entry.value));
          }
          break;
        }
      }
    }

    return filteredList;
  }

  Future<void> deleteSecureData(StorageItem item) async {
    String key=item.key;
    String deleteKey="DEV_OPS_$key";
    await _secureStorage.delete(
      key: "TXT",
      aOptions: _getAndroidOptions(),
    );
  }
}
