import 'package:flutter/material.dart';

import '../widgets/tap_to_action.dart';
import '../widgets/side_tabbed_title.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);
  static const routeName = '/about';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40),
            SideTabbedTitle('Boomer Driver App'),
            SizedBox(height: 20),
            ListTile(
              title: Text(
                  'An Uber-like application for Drivers made using Flutter.',
                  style: Theme.of(context).textTheme.headline1),
            ),
            SizedBox(height: 40),
            SideTabbedTitle('External Services that app uses'),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(
                Icons.circle,
                color: Color(0xff6D5D54),
              ),
              title: Text(
                'Google Maps SDK for Android',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            Divider(color: Color(0xff6D5D54)),
            ListTile(
              leading: Icon(
                Icons.circle,
                color: Color(0xff6D5D54),
              ),
              title: Text(
                'Google Maps SDK for iOS',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            Divider(color: Color(0xff6D5D54)),
            ListTile(
              leading: Icon(
                Icons.circle,
                color: Color(0xff6D5D54),
              ),
              title: Text(
                'Firebase for authentication and database',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            Divider(color: Color(0xff6D5D54)),
            ListTile(
              leading: Icon(
                Icons.circle,
                color: Color(0xff6D5D54),
              ),
              title: Text(
                'Provider',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            Divider(color: Color(0xff6D5D54)),
            ListTile(
              leading: Icon(
                Icons.circle,
                color: Color(0xff6D5D54),
              ),
              title: Text(
                'Google Maps Flutter',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            Divider(color: Color(0xff6D5D54)),
            ListTile(
              leading: Icon(
                Icons.circle,
                color: Color(0xff6D5D54),
              ),
              title: Text(
                'Google Maps Flutter',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            Divider(color: Color(0xff6D5D54)),
            ListTile(
              leading: Icon(
                Icons.circle,
                color: Color(0xff6D5D54),
              ),
              title: Text(
                'Geolocator',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            Divider(color: Color(0xff6D5D54)),
            ListTile(
              leading: Icon(
                Icons.circle,
                color: Color(0xff6D5D54),
              ),
              title: Text(
                'Animated Text Kit',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            Divider(color: Color(0xff6D5D54)),
            ListTile(
              leading: Icon(
                Icons.circle,
                color: Color(0xff6D5D54),
              ),
              title: Text(
                'Flutter Geofire',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListTile(
                tileColor: Theme.of(context).primaryColorDark.withOpacity(0.6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                title: Text(
                  'This application is only for showcasing purposes.',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              tileColor: Theme.of(context).primaryColorDark,
              contentPadding: const EdgeInsets.all(10),
              title: TapToActionText(
                label: 'Created By ',
                tapLabel: 'Gurmehar Bakshi',
                padding: const EdgeInsets.all(0),
              ),
            ),
            SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}
