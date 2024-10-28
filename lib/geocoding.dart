import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';

Future<String> getAddressFromLocation(double latitude, double longitude) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
    Placemark placemark = placemarks[0];
    String address = "${placemark.street}, ${placemark.locality}, ${placemark.country}";
    return address;
  } catch (e) {
    print('Error occurred: $e');
    return 'Address not found';
  }
}
