import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/driver_provider.dart';

import '../helpers/http_exception.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class CarInfoScreen extends StatefulWidget {
  CarInfoScreen({Key? key}) : super(key: key);

  static const routeName = '/car-info';

  @override
  _CarInfoScreenState createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  bool _isLoading = false;

  Map<String, String> _carInfoData = {
    'carMake': '',
    'carModel': '',
    'carNumber': '',
    'carColor': '',
  };

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<DriverProvider>(
        context,
        listen: false,
      ).addCar(
        carMake: (_carInfoData['carMake'] as String).trim(),
        carModel: _carInfoData['carModel'] as String,
        carNumber: (_carInfoData['carNumber'] as String).trim(),
        carColor: (_carInfoData['carColor'] as String).trim(),
      );
      Navigator.of(context).pop();
    } on HttpException catch (error) {
      var errorMessage = 'Request failed';
      if (error.toString().contains('NETWORK_ERROR')) {
        errorMessage = 'Could not save information.';
      } else if (error.toString().contains('CAR_NUMBER_EXISTS')) {
        errorMessage = 'This car number already exists in our database.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not save car information. Please try again later.';
      _showErrorDialog(errorMessage);
      print(error);
    }
    if (mounted)
      setState(() {
        _isLoading = false;
      });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Enter Car Details'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  label: 'Car Make',
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Field is empty';
                    }
                  },
                  onSaved: (value) {
                    _carInfoData['carMake'] = value!;
                  },
                ),
                SizedBox(height: 24),
                CustomTextField(
                  label: 'Car Model',
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Field is empty';
                    }
                  },
                  onSaved: (value) {
                    _carInfoData['carModel'] = value!;
                  },
                ),
                SizedBox(height: 24),
                CustomTextField(
                  label: 'Car Number',
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Field is empty';
                    }
                  },
                  onSaved: (value) {
                    _carInfoData['carNumber'] = value!;
                  },
                ),
                SizedBox(height: 24),
                CustomTextField(
                  label: 'Car Color',
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Field is empty';
                    }
                  },
                  onSaved: (value) {
                    _carInfoData['carColor'] = value!;
                  },
                ),
                SizedBox(height: 52),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  CustomButton(
                    label: 'Continue',
                    onTap: _submit,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
