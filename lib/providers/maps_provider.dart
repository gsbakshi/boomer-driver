import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'driver_provider.dart';

class MapsProvider with ChangeNotifier {
  void update(DriverProvider driver) {
    driverId = driver.driverId;
    status = driver.status;
  }

  late String? driverId;

  late bool status;

  late Position _currentPosition;

  Position get currentPosition => _currentPosition;

  late GoogleMapController _newMapController;

  GoogleMapController get newMapController => _newMapController;

  Future<void> setMapController(GoogleMapController controller) async {
    try {
      Completer<GoogleMapController> _controller = Completer();
      _controller.complete(controller);
      _newMapController = await _controller.future;
      notifyListeners();
      await locatePosition();
    } catch (error) {
      rethrow;
    }
  }

  // ignore: cancel_subscriptions
  StreamSubscription<Position>? liveLocationStream;

  bool isPermissionsInit = true;

  Future<bool> checkPermissions() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return false;
      }
      isPermissionsInit = false;
      notifyListeners();
      return true;
    } else {
      isPermissionsInit = false;
      notifyListeners();
      return true;
    }
  }

  Future<void> geolocate() async {
    final check = await checkPermissions();
    if (check) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _currentPosition = position;
    }
    notifyListeners();
  }

  Future<void> locatePosition() async {
    try {
      await geolocate();
      LatLng latLngPosition =
          LatLng(currentPosition.latitude, currentPosition.longitude);
      CameraPosition cameraPosition = new CameraPosition(
        target: latLngPosition,
        zoom: 14,
      );
      _newMapController.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition),
      );
      await goOnline();
      await getLiveLocationUpdates();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> goOffline() async {
    try {
      await Geofire.removeLocation(driverId!);
      // _controller = null;
      // liveLocationStream = null;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> goOnline() async {
    try {
      await geolocate();
      await Geofire.initialize('boomer/available-drivers');
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

  Future<void> getLiveLocationUpdates() async {
    liveLocationStream = Geolocator.getPositionStream().listen(
      (Position position) {
        _currentPosition = position;
        if (status)
          Geofire.setLocation(driverId!, position.latitude, position.longitude);
        LatLng latLng = LatLng(position.latitude, position.longitude);
        _newMapController.animateCamera(CameraUpdate.newLatLng(latLng));
      },
    );
    notifyListeners();
  }
}
