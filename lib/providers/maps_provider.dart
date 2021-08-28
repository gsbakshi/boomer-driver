import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../helpers/platform_keys.dart';
import '../helpers/http_exception.dart';

import '../models/address.dart';
import '../models/predicted_places.dart';

class MapsProvider with ChangeNotifier {
  late Position _currentPosition;

  late String _countryCode;

  late List<PredictedPlaces> _predictedList;

  late Address _dropofflocation;

  late Address _geocodedAddress;

  Position get currentPosition => _currentPosition;

  String get countryCode => _countryCode;

  List<PredictedPlaces> get predictedList => _predictedList;

  Address get dropoffLocation => _dropofflocation;

  Address get geocodedAddress => _geocodedAddress;

  Future<String> _reverseGeocode(Position position) async {
    try {
      String address = '';
      final apiKey = mapsAPI;
      final url =
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey';
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);
      if (data['error_message'] != null) {
        throw HttpException(data['error_message']);
      }

      String street = data['results'][0]['address_components'][0]['long_name'];
      String road = data['results'][0]['address_components'][1]['long_name'];
      String locality =
          data['results'][0]['address_components'][2]['long_name'];
      String state = data['results'][0]['address_components'][4]['long_name'];
      _countryCode =
          (data['results'][0]['address_components'][7]['short_name'] as String)
              .toLowerCase();
      address = street + ', ' + road + ' ' + locality + ', ' + state;
      return address;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> _getMapPosition(GoogleMapController mapController) async {
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
  }

  Future<void> locatePosition(
    GoogleMapController mapController,
    // TextEditingController textController,
  ) async {
    try {
      await _getMapPosition(mapController);
      // String address = await _reverseGeocode(_currentPosition);
      // textController.text = address;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> geocode(String input) async {
    try {
      String address = '';
      final apiKey = mapsAPI;
      final url =
          'https://maps.googleapis.com/maps/api/geocode/json?address=$input,+CA&key=$apiKey';
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);
      if (data['error_message'] != null) {
        throw HttpException(data['error_message']);
      }

      double latitude = data['results'][0]['geometry']['location']['lat'];
      double longitude = data['results'][0]['geometry']['location']['lng'];
      String placeId = data['results'][0]['place_id'];

      String street = data['results'][0]['address_components'][0]['long_name'];
      String road = data['results'][0]['address_components'][1]['long_name'];
      String locality =
          data['results'][0]['address_components'][2]['short_name'];
      String state = data['results'][0]['address_components'][4]['long_name'];
      address = street + ', ' + road + ', ' + locality + ', ' + state;

      _geocodedAddress = Address(
        id: placeId,
        address: input,
        name: address,
        latitude: latitude,
        longitude: longitude,
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> getLatLng(
    String value,
    GoogleMapController mapController,
  ) async {
    try {
      await geocode(value);
      LatLng latLngPosition = LatLng(
        _geocodedAddress.latitude!,
        _geocodedAddress.longitude!,
      );
      CameraPosition cameraPosition = new CameraPosition(
        target: latLngPosition,
        zoom: 14,
      );
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition),
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> findPlace(String address) async {
    try {
      final apiKey = mapsAPI;
      final components = 'components=country:$_countryCode';
      final url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$address&key=$apiKey&sessiontoken=1234567890&$components';
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);
      if (data['error_message'] != null) {
        throw HttpException(data['error_message']);
      }
      final predictions = data['predictions'];
      final placesList = (predictions as List)
          .map((place) => PredictedPlaces.fromJson(place))
          .toList();
      _predictedList = placesList;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> getPlaceDetails(String placeId) async {
    try {
      final apiKey = mapsAPI;
      final url =
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey';
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);
      if (data['error_message'] != null) {
        throw HttpException(data['error_message']);
      }
      final address = Address(
        id: placeId,
        name: data['result']['name'],
        address: data['result']['formatted_address'],
        latitude: data['result']['geometry']['location']['lat'],
        longitude: data['result']['geometry']['location']['lng'],
      );
      _dropofflocation = address;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
