import 'car.dart';

class Driver {
  Driver({
    this.cars,
    this.email,
    this.mobile,
    this.name,
    this.id,
  });

  final List<Car>? cars;
  final String? email;
  final int? mobile;
  final String? name;
  final String? id;


  @override
  String toString() {
    return 'Driver(cars: $cars, email: $email, mobile: $mobile, name: $name, id: $id)';
  }
}
