import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:windowpane/main.dart';
import 'package:intl/intl.dart';
import '/process_photo.dart';

late double latitude;
late double longitude;

class NewPhoto extends StatefulWidget {
  NewPhoto(
      {super.key,
      required this.camera,
      required this.location,
      required this.weather,
      required this.temp});
  final CameraDescription camera;
  final String location;
  final String weather;
  final int temp;

  @override
  NewPhotoState createState() => NewPhotoState();
}

class NewPhotoState extends State<NewPhoto> {
  late CameraController _controller;
  late Future<void> _cameraReady;

  Future<void> _initCamera() async {
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _cameraReady = _controller.initialize();
    return _cameraReady;
  }

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take a new Photo'),
      ),
      body: Center(
        child: FutureBuilder(
            future: _cameraReady,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done)
                return CircularProgressIndicator();

              return Wrap(
                alignment: WrapAlignment.center,
                direction: Axis.horizontal,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CameraPreview(_controller),
                  ),
                  FilledButton(
                      child: Text('Take a picture'),
                      onPressed: () async {
                        try {
                          await _cameraReady;
                          final image = await _controller.takePicture();

                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) { 
                                date = getDate();

                                return ProcessImage(
                                  image: image,
                                  location: loc,
                                  weather: wthr,
                                  dateTime: date,
                                  temp: temp,);
                              }
                            ),
                          );
                        } catch (e) {
                          print(e);
                        }
                      }),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text(loc),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Icon(Icons.cloud_outlined),
                      title: Text(
                        !isFarenheit ? '$wthr at ${temp}F' : '$wthr at ${((temp - 32) * 5 / 9).round()}C'
                      ),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }

  ////////////////////
  //   DATE/TIME CALL
  ////////////////////
  String getDate() {
    DateTime now = DateTime.now();
    return now.toIso8601String();
  }
}