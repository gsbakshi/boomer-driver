import 'address.dart';

class User {
  User({
    this.addresses,
    this.email,
    this.mobile,
    this.name,
    this.id,
  });

  final List<Address>? addresses;
  final String? email;
  final int? mobile;
  final String? name;
  final String? id;

  @override
  String toString() {
    return 'User(addresses: $addresses, email: $email, mobile: $mobile, name: $name, id: $id)';
  }
}
