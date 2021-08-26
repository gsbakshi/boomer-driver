import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../helpers/http_exception.dart';
import '../helpers/firebase_utils.dart';

import '../models/user.dart';
import '../models/address.dart';

import 'auth.dart';

class UserProvider with ChangeNotifier {
  void update(Auth auth) {
    authToken = auth.token;
    userId = auth.userId;
    addresses;
  }

  late String? authToken;
  late String? userId;

  late String _name;
  late String _email;
  late String _mobile;

  late User _user;

  late Address? pickupLocation;
  late Address? dropOffLocation;

  List<Address> _addresses = [];

  List<Address> get addresses {
    return [..._addresses];
  }

  String get name => _name;
  String get email => _email;
  String get mobile => _mobile;

  User get user => _user;

  Future<void> fetchUserDetails() async {
    try {
      final url = '${DBUrls.users}/$userId.json?auth=$authToken';
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);
      if (data == null) {
        return;
      }
      _name = data['name'];
      _email = data['email'];
      _mobile = data['mobile'];
      final addressesData = data['addresses'];
      final List<Address> loadedAddresses = [];
      addressesData.forEach((addressId, addressData) {
        loadedAddresses.insert(
          0,
          Address(
            id: addressId,
            address: addressData['address'],
            latitude: addressData['latitude'],
            longitude: addressData['longitude'],
            tag: addressData['tag'],
            name: addressData['name'],
          ),
        );
      });
      _addresses = loadedAddresses;
      _user = User(
        id: userId,
        name: name,
        email: email,
        mobile: int.tryParse(mobile),
        addresses: addresses,
      );
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  void updatePickUpLocationAddress(Address pickupAddress) {
    pickupLocation = pickupAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Address dropOffAddress) {
    dropOffLocation = dropOffAddress;
    notifyListeners();
  }

  void clearLocation() {
    dropOffLocation = null;
    pickupLocation = null;
    notifyListeners();
  }

  bool checkIfAddressExistsByType(String label) {
    final addressListByType =
        _addresses.where((address) => address.tag == label).toList();
    if (addressListByType.isEmpty) {
      return false;
    }
    return true;
  }

  List<Address> addressByType(String label) {
    return _addresses.where((address) => address.tag == label).toList();
  }

  Address findAddressById(String id) {
    return _addresses.firstWhere((address) => address.id == id);
  }

  Future<void> addAddress(Address address) async {
    final url = '${DBUrls.users}/$userId/addresses.json?auth=$authToken';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'address': address.address,
          'latitude': address.latitude,
          'longitude': address.longitude,
          'tag': address.tag,
          'name': address.name,
        }),
      );
      final newAddress = Address(
        id: json.decode(response.body)['name'],
        address: address.address,
        latitude: address.latitude,
        longitude: address.longitude,
        tag: address.tag,
        name: address.name,
      );
      _addresses.insert(0, newAddress);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteAddress(String id) async {
    final url = '${DBUrls.users}/$userId/addresses/$id.json?auth=$authToken';
    final existingAddressIndex =
        _addresses.indexWhere((element) => element.id == id);
    Address? existingAddress = _addresses[existingAddressIndex];
    _addresses.removeAt(existingAddressIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _addresses.insert(existingAddressIndex, existingAddress);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingAddress = null;
  }
}
