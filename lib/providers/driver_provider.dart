import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/firebase_utils.dart';
import '../helpers/http_exception.dart';

import '../models/driver.dart';
import '../models/car.dart';

import 'auth.dart';

class DriverProvider with ChangeNotifier {
  void update(Auth auth) {
    authToken = auth.token;
    driverId = auth.driverId;
    cars;
  }

  late String? authToken;
  late String? driverId;

  late String _name;
  late String _email;
  late String _mobile;

  String get name => _name;
  String get email => _email;
  String get mobile => _mobile;

  List<Car> _cars = [];

  List<Car> get cars {
    return [..._cars];
  }

  late Driver _driver;

  Driver get driver => _driver;

  bool _status = false;

  bool get status => _status;

  Future<void> fetchDriverDetails() async {
    try {
      final url = '${DBUrls.drivers}/$driverId.json?auth=$authToken';
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);
      if (data == null) {
        return;
      }
      _name = data['name'];
      _email = data['email'];
      _mobile = data['mobile'];
      final carsData = data['cars'];
      final List<Car> loadedCars = [];
      if (carsData != null) {
        carsData.forEach((carId, carData) {
          loadedCars.insert(
            0,
            Car(
              id: carId,
              carMake: carData['car_make'],
              carModel: carData['car_model'],
              carNumber: carData['car_number'],
              carColor: carData['car_color'],
            ),
          );
        });
      }
      _cars = loadedCars;
      _driver = Driver(
        id: driverId,
        name: name,
        email: email,
        mobile: int.tryParse(mobile),
        cars: cars,
      );
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Car findAddressById(String id) {
    return _cars.firstWhere((car) => car.id == id);
  }

  Future<void> addCar({
    String? carMake,
    String? carModel,
    String? carNumber,
    String? carColor,
  }) async {
    try {
      final url = '${DBUrls.drivers}/$driverId/cars.json?auth=$authToken';
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'car_make': carMake,
          'car_model': carModel,
          'car_number': carNumber,
          'car_color': carColor,
        }),
      );
      final newCar = Car(
        id: json.decode(response.body)['name'],
        carMake: carMake,
        carModel: carModel,
        carNumber: carNumber,
        carColor: carColor,
      );
      _cars.insert(0, newCar);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> deleteCar(String id) async {
    final url = '${DBUrls.drivers}/$driverId/cars/$id.json?auth=$authToken';
    final existingCarIndex = _cars.indexWhere((car) => car.id == id);
    Car? existingCar = _cars[existingCarIndex];
    _cars.removeAt(existingCarIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _cars.insert(existingCarIndex, existingCar);
      notifyListeners();
      throw HttpException('Could not delete car.');
    }
    existingCar = null;
  }

  Future<void> changeWorkMode(bool value) async {
    _status = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('status', _status);
    notifyListeners();
  }

  Future<void> tryStatus() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('status')) {
      _status = true;
    }
    final extractedValue = prefs.getBool('status')!;
    _status = extractedValue;
    notifyListeners();
  }
}
