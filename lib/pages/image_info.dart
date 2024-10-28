import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:windowpane/main.dart';
import 'package:windowpane/models/image.dart';

class ImageInfoCustomWidget extends StatelessWidget{
  const ImageInfoCustomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final info = ModalRoute.of(context)!.settings.arguments as ImageModel;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          children: [
            Center(
              child: Text(
                info.title, 
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Hero(
              tag: info.date, 
              child: Text(
                isTwentyFourClock ? DateFormat('HH:mm MMMM d, y').format(DateTime.parse(info.date)) : DateFormat('hh:mm MMMM d, y').format(DateTime.parse(info.date)), 
              ),
            ),
            Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: SizedBox(
                      width: 228,
                      height: 243,
                      child: Image.memory(info.image),
                    ),
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text(info.location),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(Icons.cloud_outlined),
                    title: Text(
                      !isFarenheit ? '${info.weather} at ${info.temp}F' : '${info.weather} at ${((info.temp - 32) * 5 / 9).round()}C'
                      ),
                  ),
                ),
              ]
            ),
          ],
        ),
      ),
    );
  }
}