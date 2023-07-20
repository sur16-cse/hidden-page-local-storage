import 'package:flutter/material.dart';
import '../models/storage_item.dart';
import '../services/storage_service.dart';
import '../widgets/add_data_dialog.dart';
import '../widgets/vault_card.dart';

class HiddenPage extends StatefulWidget {
  final String title;
  static const routeName = '/hidden-page';
  const HiddenPage({Key? key, required this.title}) : super(key: key);

  @override
  State<HiddenPage> createState() => _HiddenPageState();
}

class _HiddenPageState extends State<HiddenPage> {
  final StorageService _storageService = StorageService();
  late List<StorageItem>? _items;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    initList();
  }

  void initList() async {
    await _refreshData(); // Call the refresh function to get the latest data
    setState(() {
      _loading = false;
    });
  }

  Future<void> _refreshData() async {
    _items = await _storageService.readAllSecureData();
  }

  Future<void> _deleteItem(int index) async {
    await _storageService.deleteSecureData(_items![index]);
    setState(() {
      _items!.removeAt(index); // Remove the item from the list to update the UI
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: _loading
              ? const CircularProgressIndicator()
              // : (_filteredItems!.isEmpty)
              // ?
              : (_items!.isEmpty
                  ? const Text("Add data in secure storage to display here.")
                  : ListView.builder(
                      itemCount: _items!.length,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemBuilder: (_, index) {
                        return Row(
                          children: [
                            Expanded(child: VaultCard(item: _items![index])),
                            IconButton(
                              onPressed: () => _deleteItem(index),
                              icon: Icon(Icons.delete_forever),
                            ),
                          ],
                        );
                      },
                    ))),
      floatingActionButton: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    final StorageItem? newItem = await showDialog<StorageItem>(
                        context: context, builder: (_) => AddDataDialog());
                    if (newItem != null) {
                      _storageService.writeSecureData(newItem).then((value) {
                        setState(() {
                          _loading = true;
                        });
                        initList();
                      });
                    }
                  },
                  child: const Text("Add Data"),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
