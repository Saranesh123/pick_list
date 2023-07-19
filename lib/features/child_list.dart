import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pick_list/features/child.dart';

class ChildList extends StatefulWidget {
  const ChildList({super.key, required this.listTileName});
  final String listTileName;

  @override
  State<ChildList> createState() => _ChildListState();
}

class _ChildListState extends State<ChildList> {
  List<Map<String, dynamic>> childData = [];
  List<Map<String, dynamic>> filteredItemList = [];

  @override
  void initState() {
    super.initState();
    fetchChildTable(widget.listTileName);
  }

  Future<void> fetchChildTable(String parent) async {
    const url =
        'http://192.168.68.104:8003/api/method/negentropy.negentropy_integrations.flutter_integrations.api.pick_list_item';

    final body = {'parent': parent};

    final response = await http.post(Uri.parse(url), body: body);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        childData = List<Map<String, dynamic>>.from(jsonResponse['message']);
        filteredItemList = childData;
      });
    }
  }

  bool isTextFieldVisible = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.listTileName),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
              onPressed: () {
                if (mounted) {
                  if (isTextFieldVisible) {
                    setState(() {
                      isTextFieldVisible = false;
                      filteredItemList = childData;
                    });
                  } else {
                    setState(() {
                      isTextFieldVisible = true;
                    });
                  }
                }
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (isTextFieldVisible) ...[
              TextField(
                  decoration: const InputDecoration(labelText: "Search"),
                  onChanged: (value) {
                    setState(() {
                      filteredItemList = childData
                          .where((item) => item['item_code']
                              .toString()
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                    });
                  }),
            ],
            ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: filteredItemList.length,
              itemBuilder: (context, int index) {
                final item = filteredItemList[index]['item_code'];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    title: Text(item),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChildDataDisplay(
                                  name: filteredItemList[index]['name'],
                                  woNumber: filteredItemList[index]['wo_number'],
                                  woQty: filteredItemList[index]['wo_qty'],
                                  itemCode: filteredItemList[index]['item_code'],
                                  description: filteredItemList[index]['description'],
                                  qty: filteredItemList[index]['qty'],
                                  batch: filteredItemList[index]['batch'],
                                  location: filteredItemList[index]['location'],
                                  opeartion: filteredItemList[index]['operation'],)));
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
