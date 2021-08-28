import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../helpers/firebase_utils.dart';

import 'auth.dart';

class MapsProvider with ChangeNotifier {
  void update(Auth auth) {
    authToken = auth.token;
    driverId = auth.driverId;
  }

  late String? authToken;
  late String? driverId;

  late Position _currentPosition;

  Position get currentPosition => _currentPosition;

  Future<void> locatePosition(GoogleMapController mapController) async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _currentPosition = position;

      LatLng latLngPosition = LatLng(position.latitude, position.longitude);
      CameraPosition cameraPosition = new CameraPosition(
        target: latLngPosition,
        zoom: 14,
      );

      mapController.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition),
      );
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> goOffline() async {
    try {
      Geofire.removeLocation(driverId!);

      final url = '${DBUrls.drivers}/$driverId/new-ride.json?auth=$authToken';
      await http.delete(
        Uri.parse(url),
        headers: {
          HttpHeaders.acceptHeader: "text/event-stream",
        },
      );
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> goOnline() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _currentPosition = position;

      Geofire.initialize('available-drivers');
      Geofire.setLocation(
        driverId!,
        currentPosition.latitude,
        currentPosition.longitude,
      );
      final url = '${DBUrls.drivers}/$driverId/new-ride.json?auth=$authToken';
      await http.post(
        Uri.parse(url),
        body: json.encode({}),
        headers: {
          HttpHeaders.acceptHeader: "text/event-stream",
        },
      );
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void getLiveLocationUpdates(GoogleMapController mapController, bool status) {
    StreamSubscription<Position> liveLocationStream;
    liveLocationStream = Geolocator.getPositionStream().listen(
      (Position position) {
        _currentPosition = position;
        if (status)
          Geofire.setLocation(driverId!, position.latitude, position.longitude);
        LatLng latLng = LatLng(position.latitude, position.longitude);
        mapController.animateCamera(CameraUpdate.newLatLng(latLng));
      },
    );
    // if (!status) liveLocationStream.cancel();
  }
}
