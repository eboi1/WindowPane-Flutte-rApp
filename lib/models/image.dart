import 'dart:typed_data';

class ImageModel {
  final int id;
  final String title;
  final String date;
  final String weather;
  final int temp;
  final Uint8List image;
  final String location;

  ImageModel({
    required this.id, 
    required this.title,
    required this.date, 
    required this.weather,
    required this.temp,
    required this.image,
    required this.location,
  });

  // Method to convert map to ImageModel
  factory ImageModel.fromMap(Map<String, dynamic> map) {
    return ImageModel(
      id: map['id'],
      title: map['title'],
      date: map['date'],
      location: map['location'],
      weather: map['weather'],
      temp: map['temp'],
      image: map['image'],
    );
  }
}