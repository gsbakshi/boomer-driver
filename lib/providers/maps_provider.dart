import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  // ignore: cancel_subscriptions, unused_local_variable
  StreamSubscription<Position>? liveLocationStream;

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
      await Geofire.removeLocation(driverId!);
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
      await Geofire.initialize('available-drivers');
      await Geofire.setLocation(
        driverId!,
        currentPosition.latitude,
        currentPosition.longitude,
      );
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> getLiveLocationUpdates(GoogleMapController mapController) async{
    liveLocationStream = Geolocator.getPositionStream().listen(
      (Position position) {
        _currentPosition = position;
        Geofire.setLocation(driverId!, position.latitude, position.longitude);
        LatLng latLng = LatLng(position.latitude, position.longitude);
        mapController.animateCamera(CameraUpdate.newLatLng(latLng));
      },
    );
  }
}
