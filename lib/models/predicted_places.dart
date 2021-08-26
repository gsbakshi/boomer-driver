// To parse this JSON data, do
//
//     final predictedPlaces = predictedPlacesFromJson(jsonString);

import 'dart:convert';

class PredictedPlaces {
  PredictedPlaces({
    this.placeId,
    this.mainText,
    this.secondaryText,
  });

  final String? placeId;
  final String? mainText;
  final String? secondaryText;

  factory PredictedPlaces.fromRawJson(String str) =>
      PredictedPlaces.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  @override
  String toString() {
    return 'Predicted Place : ${this.placeId}, main text: ${this.mainText}, secondary text: ${this.secondaryText}';
  }

  factory PredictedPlaces.fromJson(Map<String, dynamic> json) =>
      PredictedPlaces(
        placeId: json["place_id"] == null ? null : json["place_id"],
        mainText: json["structured_formatting"]["main_text"] == null
            ? null
            : json["structured_formatting"]["main_text"],
        secondaryText: json["structured_formatting"]["secondary_text"] == null
            ? null
            : json["structured_formatting"]["secondary_text"],
      );

  Map<String, dynamic> toJson() => {
        "place_id": placeId == null ? null : placeId,
        "main_text": mainText == null ? null : mainText,
        "secondary_text": secondaryText == null ? null : secondaryText,
      };
}
