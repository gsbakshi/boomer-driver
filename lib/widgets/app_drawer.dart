import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/user_provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context, listen: false);
    final username = userData.name;
    return Drawer(
      child: Container(
        color: Theme.of(context).primaryColorDark,
        child: Column(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: GestureDetector(
                onTap: () {
                  print('View Profile');
                },
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/user_icon.png',
                      width: 60,
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          username,
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        SizedBox(height: 2),
                        Text(
                          'View Profile',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(
                Icons.car_rental,
                color: Color(0xff6D5D54),
              ),
              title: Text(
                'Ride Now',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
            Divider(color: Color(0xff6D5D54)),
            ListTile(
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
                //     .pushReplacementNamed(OrdersScreen.routeName);
              },
            ),
            Divider(color: Color(0xff6D5D54)),
            ListTile(
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
                //     .pushReplacementNamed(UserProductsScreen.routeName);
              },
            ),
            Divider(color: Color(0xff6D5D54)),
            Expanded(child: Container()),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Color(0xff6D5D54),
              ),
              title: Text(
                'Logout',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<Auth>(context, listen: false).logout();
              },
            ),
            SizedBox(
              height: 80,
            ),
          ],
        ),
      ),
    );
  }
}
