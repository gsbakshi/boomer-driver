import 'dart:convert';

class DirectionDetails {
  final int? distanceValue;
  final int? durationValue;
  final String? distanceText;
  final String? durationText;
  final String? encodedPoints;

  DirectionDetails({
    this.distanceValue,
    this.durationValue,
    this.distanceText,
    this.durationText,
    this.encodedPoints,
  });

  Map<String, dynamic> toJson() => {
        'distanceValue': distanceValue == null ? null : distanceValue,
        'durationValue': durationValue == null ? null : durationValue,
        'distanceText': distanceText == null ? null : distanceText,
        'durationText': durationText == null ? null : durationText,
        'encodedPoints': encodedPoints == null ? null : encodedPoints,
      };

  String toRawJson() => json.encode(toJson());

  factory DirectionDetails.fromJson(Map<String, dynamic> json) =>
      DirectionDetails(
        distanceValue: json['routes'][0]['legs'][0]['distance']['value'] == null ? null : json['routes'][0]['legs'][0]['distance']['value'],
        durationValue: json['routes'][0]['legs'][0]['duration']['value'] == null ? null : json['routes'][0]['legs'][0]['duration']['value'],
        distanceText: json['routes'][0]['legs'][0]['distance']['text'] == null ? null : json['routes'][0]['legs'][0]['distance']['text'],
        durationText: json['routes'][0]['legs'][0]['duration']['text'] == null ? null : json['routes'][0]['legs'][0]['duration']['text'],
        encodedPoints: json['routes'][0]['overview_polyline']['points'] == null ? null : json['routes'][0]['overview_polyline']['points'],
      );

  @override
  String toString() {
    return 'DirectionDetails(distanceValue: $distanceValue, durationValue: $durationValue, distanceText: $distanceText, durationText: $durationText, encodedPoints: $encodedPoints)';
  }
}
