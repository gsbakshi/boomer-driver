import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../providers/maps_provider.dart';
import '../providers/ride_provider.dart';
import '../providers/driver_provider.dart';

import '../helpers/http_exception.dart';

import '../models/direction_details.dart';

import '../widgets/app_drawer.dart';
import '../widgets/add_new_address.dart';
import '../widgets/decorated_wrapper.dart';
import '../widgets/address_list_by_type.dart';
import '../widgets/floating_appbar_wrapper_with_textfield.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Completer<GoogleMapController> _controller = Completer();

  late GoogleMapController newMapController;

  final _currentLocationInputController = TextEditingController();

  DirectionDetails tripDetails = DirectionDetails();

  List<LatLng> plineCoordinates = [];
  Set<Polyline> polylineSet = {};

  Set<Marker> markers = {};
  Set<Circle> circles = {};

  bool _loading = false;
  int _state = 1;

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

  Future<bool> _checkDialog() async => await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text('Are you sure?'),
          content: Text(
            'Do you want to delete this address?',
          ),
          actions: [
            TextButton(
              child: Text(
                'No',
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              onPressed: () {
                Navigator.of(ctx).pop(false);
              },
            ),
            TextButton(
              child: Text(
                'Yes',
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              onPressed: () {
                Navigator.of(ctx).pop(true);
              },
            ),
          ],
        ),
      );

  Future<void> locateOnMap() async {
    try {
      final mapProvider = Provider.of<MapsProvider>(context, listen: false);
      await mapProvider.locatePosition(
        newMapController,
        _currentLocationInputController,
      );
      // final currentPosition = mapProvider.currentPosition;
      // Address pickupAddress = Address(
      //   longitude: currentPosition.longitude,
      //   latitude: currentPosition.latitude,
      //   address: _currentLocationInputController.text,
      // );
      // Provider.of<DriverProvider>(
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

  Future<void> onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    newMapController = controller;
    await locateOnMap();
  }

  void onLocationInput(String value) async {
    try {
      final mapProvider = Provider.of<MapsProvider>(context, listen: false);
      await mapProvider.getLatLng(value, newMapController);
      // final geocodedAddress = mapProvider.geocodedAddress;
      // Provider.of<DriverProvider>(
      //   context,
      //   listen: false,
      // ).updateDropOffLocationAddress(geocodedAddress);
    } on HttpException catch (error) {
      var errorMessage = 'Request Failed';
      print(error);
      _snackbar(errorMessage);
    } catch (error) {
      const errorMessage = 'Could not locate address. Please try again later.';
      print(error);
      _snackbar(errorMessage);
    }
  }

  Future<void> getPlaceDirections() async {
    try {
      // final user = Provider.of<DriverProvider>(context, listen: false);
      // final initialPosition = user.pickupLocation!;
      // final finalPosition = user.dropOffLocation!;

      // final pickupLatLng = LatLng(
      //   initialPosition.latitude!,
      //   initialPosition.longitude!,
      // );
      // final dropoffLatLng = LatLng(
      //   finalPosition.latitude!,
      //   finalPosition.longitude!,
      // );

      // final details = await DirectionHelper.obtainPlaceDirectionDetails(
      //   pickupLatLng,
      //   dropoffLatLng,
      // );

      // final polylinePoints = PolylinePoints();
      // List<PointLatLng> decodedPolylinePointsResult =
      //     polylinePoints.decodePolyline(details.encodedPoints!);

      // plineCoordinates.clear();
      // if (decodedPolylinePointsResult.isNotEmpty) {
      //   decodedPolylinePointsResult.forEach((PointLatLng point) {
      //     plineCoordinates.add(LatLng(point.latitude, point.longitude));
      //   });
      // }

      // late LatLngBounds screenBounds;
      // if (pickupLatLng.latitude > dropoffLatLng.latitude &&
      //     pickupLatLng.longitude > dropoffLatLng.longitude) {
      //   screenBounds = LatLngBounds(
      //     southwest: dropoffLatLng,
      //     northeast: pickupLatLng,
      //   );
      // } else if (pickupLatLng.latitude > dropoffLatLng.latitude) {
      //   screenBounds = LatLngBounds(
      //     southwest: LatLng(dropoffLatLng.latitude, pickupLatLng.longitude),
      //     northeast: LatLng(pickupLatLng.latitude, dropoffLatLng.longitude),
      //   );
      // } else if (pickupLatLng.longitude > dropoffLatLng.longitude) {
      //   screenBounds = LatLngBounds(
      //     southwest: LatLng(pickupLatLng.latitude, dropoffLatLng.longitude),
      //     northeast: LatLng(dropoffLatLng.latitude, pickupLatLng.longitude),
      //   );
      // } else {
      //   screenBounds = LatLngBounds(
      //     southwest: pickupLatLng,
      //     northeast: dropoffLatLng,
      //   );
      // }

      // newMapController.animateCamera(
      //   CameraUpdate.newLatLngBounds(
      //     screenBounds,
      //     120,
      //   ),
      // );

      // Marker pickupMarker = Marker(
      //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      //   infoWindow: InfoWindow(
      //     title: initialPosition.name,
      //     snippet: 'My Location',
      //   ),
      //   position: pickupLatLng,
      //   markerId: MarkerId('Pick Up'),
      // );

      // Marker dropoffMarker = Marker(
      //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      //   infoWindow: InfoWindow(
      //     title: finalPosition.name,
      //     snippet: 'Drop Off Location',
      //   ),
      //   position: dropoffLatLng,
      //   markerId: MarkerId('Drop Off'),
      // );

      // Circle pickupCircle = Circle(
      //   fillColor: Colors.cyan,
      //   center: pickupLatLng,
      //   radius: 12,
      //   strokeWidth: 4,
      //   strokeColor: Colors.cyanAccent,
      //   circleId: CircleId('Pick Up circle'),
      // );
      // Circle dropoffCircle = Circle(
      //   fillColor: Colors.lime,
      //   center: dropoffLatLng,
      //   radius: 12,
      //   strokeWidth: 4,
      //   strokeColor: Colors.limeAccent,
      //   circleId: CircleId('Drop Off circle'),
      // );

      // polylineSet.clear();
      // setState(() {
      //   tripDetails = details;
      //   final polyline = Polyline(
      //     color: Theme.of(context).accentColor,
      //     polylineId: PolylineId('Place Directions'),
      //     jointType: JointType.round,
      //     points: plineCoordinates,
      //     width: 5,
      //     startCap: Cap.roundCap,
      //     endCap: Cap.roundCap,
      //     geodesic: true,
      //   );
      //   polylineSet.add(polyline);
      //   markers.add(pickupMarker);
      //   markers.add(dropoffMarker);
      //   circles.add(pickupCircle);
      //   circles.add(dropoffCircle);
      // });
    } on HttpException catch (error) {
      var errorMessage = 'Request Failed';
      print(error);
      _snackbar(errorMessage);
    } catch (error) {
      const errorMessage = 'Could not get directions. Please try again later.';
      print(error);
      _snackbar(errorMessage);
    }
  }

  Future<void> obtainDirection(dynamic value) async {
    if (value == 'obtainDirection') {
      setState(() {
        _loading = true;
      });
      await getPlaceDirections();
      setState(() {
        _loading = false;
        _state = 2;
      });
    }
  }

  Future<void> _resetApp() async {
    setState(() {
      _loading = true;
    });
    if (_state == 3) {
      try {
        await Provider.of<RideProvider>(
          context,
          listen: false,
        ).cancelRideRequest();
      } on HttpException catch (error) {
        var errorMessage = 'Request Failed';
        print(error);
        _snackbar(errorMessage);
      } catch (error) {
        const errorMessage = 'Could not cancel request.';
        print(error);
        _snackbar(errorMessage);
      }
    }
    // Provider.of<DriverProvider>(context, listen: false).clearLocation();
    setState(() {
      polylineSet.clear();
      markers.clear();
      circles.clear();
      plineCoordinates.clear();
      _currentLocationInputController.clear();
      newMapController.dispose();
      _state = 1;
    });
    await locateOnMap();
    setState(() {
      _loading = false;
    });
  }

  Future<void> _addAddress(String address, String tag, String name) async {
    try {
      // final addressProvider = Provider.of<DriverProvider>(
      //   context,
      //   listen: false,
      // );
      // final pickupLocation = addressProvider.pickupLocation;
      // if (address == pickupLocation!.address) {
      //   final newAddress = Address(
      //     address: pickupLocation.address,
      //     latitude: pickupLocation.latitude,
      //     longitude: pickupLocation.longitude,
      //     tag: tag,
      //     name: name,
      //   );
      //   await addressProvider.addAddress(newAddress);
      // } else {
      //   final mapProvider = Provider.of<MapsProvider>(context, listen: false);
      //   await mapProvider.geocode(address);
      //   final geocodedAddress = mapProvider.geocodedAddress;
      //   final newAddress = Address(
      //     id: geocodedAddress.id,
      //     address: geocodedAddress.name,
      //     name: name,
      //     latitude: geocodedAddress.latitude,
      //     longitude: geocodedAddress.longitude,
      //     tag: tag,
      //   );
      //   addressProvider.addAddress(newAddress);
      // }
    } on HttpException catch (error) {
      var errorMessage = 'Request Failed';
      print(error);
      _snackbar(errorMessage);
    } catch (error) {
      const errorMessage = 'Could not save address. Please try again later.';
      print(error);
      _snackbar(errorMessage);
    }
  }

  void addAddressModalSheet(String label) {
    showModalBottomSheet(
      context: context,
      shape: modalSheetShape,
      builder: (_) => AddNewAddress(
        addAddress: _addAddress,
        label: label,
        getLocationAddress: 
        // Provider.of<DriverProvider>(
        //       context,
        //       listen: false,
        //     ).pickupLocation!.address ??
            '',
      ),
    );
  }

  void _plugNewAddressToAddressByType(String label) {
    Navigator.of(context).pop();
    addAddressModalSheet(label);
  }

  Future<void> _deleteAddress(String id) async {
    try {
      bool confirm = await _checkDialog();
      if (confirm) {
        // await Provider.of<DriverProvider>(context, listen: false)
        //     .deleteAddress(id);
      } else {
        return;
      }
    } catch (error) {
      _snackbar(error.toString());
    }
  }

  void showAddressesByType(String label) async {
    final res = await showModalBottomSheet(
      context: context,
      shape: modalSheetShape,
      builder: (_) => AddressListByType(
        label: label,
        addAddress: () => _plugNewAddressToAddressByType(label),
        deleteAddress: _deleteAddress,
      ),
    );
    await obtainDirection(res);
  }

  double mapBottomPadding(double queryHeight) {
    double bottomPad = 70;
    if (_state == 1) {
      bottomPad = queryHeight * 0.3;
    } else if (_state == 2) {
      bottomPad = queryHeight * 0.42;
    } else if (_state == 3) {
      bottomPad = queryHeight * 0.3;
    }
    return bottomPad;
  }

  final modalSheetShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
  );

  // static final CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 14.4746,
  // );

  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then(
      (_) => Provider.of<DriverProvider>(
        context,
        listen: false,
      ).fetchDriverDetails(),
    );
  }

  @override
  void dispose() {
    _currentLocationInputController.dispose();
    newMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context).size;
    double selectDropOffContainerHeight = query.height * 0.29;
    // double selectRideContainerHeight = query.height * 0.41;
    // double requestingDriverContainerHeight = query.height * 0.29;
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(),
      floatingActionButtonLocation:
          _state == 1 ? null : FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _state == 1
          ? null
          : FloatingActionButton(
              onPressed: _resetApp,
              backgroundColor: Theme.of(context).primaryColorLight,
              child: Icon(Icons.close),
            ),
      body: Stack(
        children: [
          // GoogleMap(
          //   myLocationEnabled: true,
          //   padding: EdgeInsets.only(
          //     bottom: mapBottomPadding(query.height),
          //     right: 16,
          //   ),
          //   polylines: polylineSet,
          //   markers: markers,
          //   circles: circles,
          //   initialCameraPosition: _kGooglePlex,
          //   onMapCreated: onMapCreated,
          // ),
          Positioned(
            top: 0,
            child: FloatingAppBarWrapperWithTextField(
              height: query.height * 0.072,
              width: query.width,
              leadingIcon: Icons.menu,
              onTapLeadingIcon: _openDrawer,
              hintLabel: 'Your Location',
              controller: _currentLocationInputController,
              onSubmitted: onLocationInput,
            ),
          ),
          
          Positioned(
            bottom: 0,
            child: SafeArea(
              child: AnimatedSize(
                duration: Duration(milliseconds: 360),
                vsync: this,
                curve: Curves.easeOut,
                child: Container(
                  height: _state == 1 ? selectDropOffContainerHeight : 0,
                  width: query.width,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DecoratedWrapper(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            'Driver App',
                            style: Theme.of(context).textTheme.headline1,
                          ),
                          // SizedBox(height: 2),
                          // Text(
                          //   'Where to?',
                          //   style: Theme.of(context).textTheme.headline4,
                          // ),
                          // SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_loading)
            Container(
              height: query.height,
              width: query.width,
              color: Colors.black26,
              child: Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
