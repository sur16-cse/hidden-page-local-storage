import 'package:flutter/material.dart';
import 'package:hidden_local_storage/widgets/textfield_decoration.dart';

import '../models/storage_item.dart';
import '../services/storage_service.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({super.key});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  final TextEditingController _keyController = TextEditingController();
  final StorageService _storageService = StorageService();
  List<StorageItem>? _value;

  @override
  Widget build(BuildContext context) {
    // ref.watch(storageServiceProvider.notifier);
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _keyController,
              decoration: textFieldDecoration(hintText: "Enter Filter Key"),
            ),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      _value = await _storageService
                          .filterSecureData(_keyController.text);
                      setState(() {});
                    },
                    child: const Text('Filter Search'))),
          ],
        ),
      ),
    );
  }
}
