import 'package:flutter/material.dart';

import 'custom_button.dart';
import 'custom_textfield.dart';

class AddNewAddress extends StatefulWidget {
  const AddNewAddress({
    Key? key,
    required this.addAddress,
    required this.label,
    required this.getLocationAddress,
  }) : super(key: key);

  final Function addAddress;
  final String getLocationAddress;
  final String label;

  @override
  _AddNewAddressState createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final _addressController = TextEditingController();

  final _tagController = TextEditingController();

  Map<String, String> _addressData = {
    'address': '',
    'tag': '',
    'label': '',
  };

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    widget.addAddress(
      _addressData['address'],
      _addressData['tag'],
      _addressData['label'],
    );
    Navigator.of(context).pop();
  }

  void _getCurrentLocation() {
    setState(() {
      _addressController.text = widget.getLocationAddress;
    });
  }

  @override
  void initState() {
    super.initState();
    _tagController.text = widget.label;
  }

  @override
  void dispose() {
    _addressController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add New Address',
            style: Theme.of(context).textTheme.headline4,
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 30, top: 10, right: 160),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).primaryColorLight,
                  width: 2,
                ),
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  tileColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onTap: _getCurrentLocation,
                  leading: Icon(
                    Icons.gps_fixed_rounded,
                    color: Color(0xffB8AAA3),
                  ),
                  title: Text(
                    'Use Current Location',
                    style: TextStyle(color: Color(0xffB8AAA3)),
                  ),
                  minLeadingWidth: 0,
                ),
                SizedBox(height: 10),
                CustomTextField.underline(
                  label: 'Address',
                  controller: _addressController,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Field is empty';
                    }
                  },
                  onSaved: (value) {
                    _addressData['address'] = value!;
                  },
                ),
                SizedBox(height: 10),
                CustomTextField.underline(
                  label: 'Label',
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Field is empty';
                    }
                  },
                  onSaved: (value) {
                    _addressData['label'] = value!;
                  },
                ),
                SizedBox(height: 10),
                CustomTextField.underline(
                  label: 'Tag',
                  controller: _tagController,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Field is empty';
                    }
                  },
                  onSaved: (value) {
                    _addressData['tag'] = value!;
                  },
                ),
                SizedBox(height: 36),
                CustomButton(
                  label: 'Save Address',
                  onTap: _submit,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
