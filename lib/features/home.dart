import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pick_list/features/child_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> apiData = [];
  List<Map<String, dynamic>> filteredItemList = [];

  @override
  void initState() {
    super.initState();
    fetchDocTypeValue();
  }

  Future<void> fetchDocTypeValue() async {
    const url =
        'http://192.168.68.104:8003/api/method/negentropy.negentropy_integrations.flutter_integrations.api.pick_list';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        apiData = List<Map<String, dynamic>>.from(jsonResponse['message']);
        filteredItemList = apiData;
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
        title: const Text("Pick List"),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
              onPressed: () {
                if (mounted) {
                  if (isTextFieldVisible) {
                    setState(() {
                      isTextFieldVisible = false;
                      filteredItemList = apiData;
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
                      filteredItemList = apiData
                          .where((item) => item['name']
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
                final item = filteredItemList[index]['name'];
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
                              builder: (context) => ChildList(
                                    listTileName: item)));
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
