import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/driver_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static const routeName = '/profile-screen';
  @override
  Widget build(BuildContext context) {
    final driverData = Provider.of<DriverProvider>(context, listen: false);
    final driver = driverData.driver;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ListTile(
                onTap: () {
                  print('View Profile');
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: Theme.of(context).primaryColorDark.withOpacity(0.6),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                leading: Image.asset('assets/images/user_icon.png'),
                title: Text(
                  driver.name!,
                  style: Theme.of(context).textTheme.headline3,
                ),
                subtitle: Text(
                  driver.mobile.toString(),
                  style: Theme.of(context).textTheme.headline1,
                ),
                trailing: Icon(
                  Icons.edit,
                  color: Color(0xffB8AAA3),
                ),
              ),
              SizedBox(height: 40),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: Icon(
                  Icons.money,
                  color: Color(0xff6D5D54),
                ),
                title: Text(
                  'Payments Methods',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                onTap: () {
                  // Navigator.of(context).pushReplacementNamed(PaymentMethodsScreen.routeName);
                },
              ),
              Divider(color: Color(0xff6D5D54)),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: Icon(
                  Icons.history,
                  color: Color(0xff6D5D54),
                ),
                title: Text(
                  'History',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                onTap: () {
                  // Navigator.of(context)
                  //     .pushReplacementNamed(HistoryScreen.routeName);
                },
              ),
              Divider(color: Color(0xff6D5D54)),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: Icon(
                  Icons.info,
                  color: Color(0xff6D5D54),
                ),
                title: Text(
                  'About',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                onTap: () {
                  // Navigator.of(context)
                  //     .pushReplacementNamed(AboutScreen.routeName);
                },
              ),
              Divider(color: Color(0xff6D5D54)),
              Expanded(child: Container()),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: Icon(
                  Icons.logout,
                  color: Color(0xff6D5D54),
                ),
                title: Text(
                  'Logout',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                onTap: () {
                  Provider.of<Auth>(context, listen: false).logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
