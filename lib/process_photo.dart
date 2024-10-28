import 'package:intl/intl.dart';

import 'new_photo.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:windowpane/database/db.dart';
import 'package:windowpane/main.dart';
import 'package:path_provider/path_provider.dart';
import '../database/db.dart' as db;

late String? newTitle;

class ProcessImage extends StatelessWidget {
  final dynamic image;
  final String weather;
  final String dateTime;
  final String location;
  final int temp;

  const ProcessImage(
      {super.key,
      required this.image,
      required this.weather,
      required this.dateTime,
      required this.location,
      required this.temp});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Title')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onSubmitted: _onSubmit,
              decoration: InputDecoration(
                label: Text('Description'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(Icons.date_range_sharp),
              title: Text(
                isTwentyFourClock ? DateFormat('HH:mm MMMM d, y').format(DateTime.parse(dateTime)) : DateFormat('hh:mm MMMM d, y').format(DateTime.parse(dateTime)), 
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 228,
              height: 243,
              child: Image.file(File(image.path)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(Icons.location_on),
              title: Text(location),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(Icons.cloud_outlined),
              title: Text(
                !isFarenheit ? '$weather at ${temp}F' : '$weather at ${((temp - 32) * 5 / 9).round()}C'
              ),
            ),
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                if (newTitle != null) {
                  await addToTable();
                  Navigator.of(context).pushReplacementNamed('/');
                } else {
                  AlertDialog(
                      title: Text('Alert Dialog Title'),
                      content: Text('This is the content of the alert dialog.'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Enter a title'),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                        )
                      ]);
                }
              },
              child: Text('Save'),
            ),
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                newTitle = null;
                Navigator.of(context).pushReplacementNamed('/');
              },
              child: Text('Discard'),
            ),
          ),
        ],
      ),
    );
  }

  _onSubmit(String text) async {
    newTitle = text;
  }

  addToTable() async {
    final int8ListImage = await File(image.path).readAsBytes();

    await insertImageData(
        newTitle!, weather, location, dateTime, int8ListImage, temp);
  }
}
