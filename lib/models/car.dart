class Car {
  Car({
    this.id,
    this.carMake,
    this.carModel,
    this.carNumber,
    this.carColor,
  });

  final String? id;
  final String? carMake;
  final String? carModel;
  final String? carNumber;
  final String? carColor;

  @override
  String toString() {
    return 'Car(id: $id, carMake: $carMake, carModel: $carModel, carNumber: $carNumber, carColor: $carColor)';
  }
}
