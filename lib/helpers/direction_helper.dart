import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/direction_details.dart';

import 'http_exception.dart';
import 'platform_keys.dart';

class DirectionHelper {
  static Future<DirectionDetails> obtainPlaceDirectionDetails(
    LatLng initialPosition,
    LatLng finalPosition,
  ) async {
    try {
      final apiKey = mapsAPI;
      String url =
          'https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$apiKey';
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);
      if (data['error_message'] != null) {
        throw HttpException(data['error_message']);
      }
      final directionDetail = DirectionDetails.fromJson(data);
      return directionDetail;
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
