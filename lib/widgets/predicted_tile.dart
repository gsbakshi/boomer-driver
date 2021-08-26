import 'package:flutter/material.dart';

import '../models/predicted_places.dart';

class PredictedTile extends StatelessWidget {
  const PredictedTile(this.predictedPlace, {Key? key, this.onTap})
      : super(key: key);

  final PredictedPlaces predictedPlace;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ValueKey(predictedPlace.placeId),
      tileColor: Color(0xff6D5D54),
      minLeadingWidth: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onTap: onTap,
      leading: Icon(
        Icons.add_location,
        color: Color(0xffB8AAA3),
      ),
      title: Text(
        predictedPlace.mainText ?? '',
        style: TextStyle(
          color: Color(0xffB8AAA3),
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        predictedPlace.secondaryText ?? '',
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Color(0xffB8AAA3),
        ),
      ),
    );
  }
}
