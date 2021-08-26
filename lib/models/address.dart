class Address {
  Address({
    this.id,
    this.name,
    this.address,
    this.latitude,
    this.longitude,
    this.tag,
  });

  final String? id;
  final String? name;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? tag;

  @override
  String toString() {
    return 'Address(id: $id, address: $address, latitude: $latitude, longitude: $longitude, name: $name, tag: $tag)';
  }
}
