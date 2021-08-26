import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../helpers/http_exception.dart';
import '../helpers/firebase_utils.dart';

import '../models/user.dart';
import '../models/address.dart';

import 'auth.dart';
import 'user_provider.dart';

class RideProvider with ChangeNotifier {
  void update(Auth auth, UserProvider userData) {
    authToken = auth.token;
    userId = auth.userId;
    user = userData.user;
    pickupLocation = userData.pickupLocation;
    dropOffLocation = userData.dropOffLocation;
  }

  late String? authToken;
  late String? userId;

  late String? rideId;

  late User user;

  late Address? pickupLocation;
  late Address? dropOffLocation;

  Future<void> saveRideRequest() async {
    try {
      final url = '${DBUrls.rideRequest}.json?auth=$authToken';
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'driver_id': null,
            'request_status': 'waiting',
            'payment_method': 'Cash',
            'pickup': {
              'latitude': pickupLocation?.latitude,
              'longitude': pickupLocation?.longitude,
            },
            'dropoff': {
              'latitude': dropOffLocation?.latitude,
              'longitude': dropOffLocation?.longitude,
            },
            'created_at': DateTime.now().toIso8601String(),
            'rider_name': user.name,
            'rider_mobile': user.mobile,
            'pickup_address': pickupLocation?.address,
            'dropoff_address': dropOffLocation?.address,
          },
        ),
      );
      rideId = json.decode(response.body)['name'];
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> cancelRideRequest() async {
    try {
      final url = '${DBUrls.rideRequest}/$rideId.json?auth=$authToken';
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode >= 400) {
        throw HttpException('Could not cancel ride request');
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
