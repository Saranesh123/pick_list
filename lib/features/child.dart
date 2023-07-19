import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChildDataDisplay extends StatefulWidget {
  const ChildDataDisplay(
      {super.key,
      required this.name,
      required this.woNumber,
      required this.woQty,
      required this.itemCode,
      required this.description,
      required this.qty,
      required this.batch,
      required this.location,
      required this.opeartion});
  final String name;
  final String woNumber;
  final double woQty;
  final String itemCode;
  final String description;
  final double qty;
  final String batch;
  final String location;
  final String opeartion;

  @override
  State<ChildDataDisplay> createState() => _ChildDataDisplayState();
}

class _ChildDataDisplayState extends State<ChildDataDisplay> {
  Map<String, dynamic> keyValuePairs = {};

  @override
  void initState() {
    super.initState();
    keyValuePairs = {
      'Name': widget.name,
      'WO Number': widget.woNumber,
      'WO Qty': widget.woQty,
      'Item Code': widget.itemCode,
      'Description': widget.description,
      'Qty': widget.qty,
      'Batch': widget.batch,
      'Location': widget.location,
      'Operation': widget.opeartion,
    };
  }

  void printmethod() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController stickerController = TextEditingController();
        return CupertinoAlertDialog(
          title: const Text('Enter the No of Stickers'),
          content: Column(
            children: [
              Material(
                child: TextField(
                  decoration: const InputDecoration(),
                  controller: stickerController,
                ),
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Print'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.itemCode),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
              onPressed: () {
                printmethod();
              },
              icon: const Icon(Icons.print)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: keyValuePairs.entries
              .map(
                (entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          color: Colors.red,
                          child: Text(
                            entry.key,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          color: Colors.grey[300],
                          child: Text(
                            entry.value.toString(),
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
