import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../helpers/http_exception.dart';

import '../providers/maps_provider.dart';
import '../providers/driver_provider.dart';

import '../widgets/floating_appbar_wrapper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _controller = Completer();

  GoogleMapController? newMapController;

  bool _init = true;

  void _snackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: Theme.of(context).primaryColorDark,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
        backgroundColor: Theme.of(context).accentColor,
      ),
    );
  }

  Future<void> locateOnMap() async {
    try {
      final mapProvider = Provider.of<MapsProvider>(context, listen: false);
      await mapProvider.locatePosition(
        newMapController!,
        // _currentLocationInputController,
      );
      // final currentPosition = mapProvider.currentPosition;
      // Address pickupAddress = Address(
      //   longitude: currentPosition.longitude,
      //   latitude: currentPosition.latitude,
      //   address: _currentLocationInputController.text,
      // );
      // Provider.of<UserProvider>(
      //   context,
      //   listen: false,
      // ).updatePickUpLocationAddress(pickupAddress);
    } on HttpException catch (error) {
      var errorMessage = 'Request Failed';
      print(error);
      _snackbar(errorMessage);
    } catch (error) {
      const errorMessage = 'Could not locate you. Please try again later.';
      print(error);
      _snackbar(errorMessage);
    }
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then(
      (_) {
        Provider.of<DriverProvider>(
          context,
          listen: false,
        ).fetchDriverDetails();
      },
    );
  }

  @override
  void dispose() {
    newMapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context).size;
    return Scaffold(
      body: Consumer<DriverProvider>(
        builder: (ctx, driver, _) => FutureBuilder(
          future: driver.tryStatus(),
          builder: (ctx, snapshot) =>  Stack(
                  children: [
                    driver.status
                        ? GoogleMap(
                            myLocationEnabled: true,
                            padding: EdgeInsets.all(12),
                            initialCameraPosition: _kGooglePlex,
                            onMapCreated:
                                (GoogleMapController controller) async {
                              if (_init) {
                                _controller.complete(controller);
                              }
                              newMapController = controller;
                              await locateOnMap();
                            },
                          )
                        : Center(
                            child: Icon(
                              Icons.offline_bolt_rounded,
                              size: query.width * 0.6,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                    Positioned(
                      top: 0,
                      child: FloatingAppBarWrapper(
                        height: query.height * 0.072,
                        width: query.width,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              driver.status ? 'Online Now' : 'Offline',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Switch.adaptive(
                              value: driver.status,
                              onChanged: (value) {
                                final check = _init;
                                setState(() {
                                  if (check) _init = false;
                                  driver.changeWorkMode(value);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
