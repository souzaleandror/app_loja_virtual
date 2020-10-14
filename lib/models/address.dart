class Address {
  double altitude;
  String number;
  String street;
  String complement;
  String district;
  String zipCode;
  String city;
  String state;
  double latitude;
  double longitude;

  Address(
      {this.altitude,
      this.number,
      this.street,
      this.complement,
      this.district,
      this.zipCode,
      this.city,
      this.state,
      this.latitude,
      this.longitude});

  Map<String, dynamic> toMap() {
    return {
      'altitude': altitude,
      'number': number,
      'street': street,
      'complement': complement,
      'district': district,
      'zipCode': zipCode,
      'city': city,
      'state': state,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  Address.fromMap(Map<String, dynamic> map) {
    street = map['street'] as String;
    number = map['number'] as String;
    complement = map['complement'] as String;
    district = map['district'] as String;
    zipCode = map['zipCode'] as String;
    city = map['city'] as String;
    state = map['state'] as String;
    latitude = map['latitude'] as double;
    longitude = map['longitude'] as double;
  }

  @override
  String toString() {
    return 'Address{altitude: $altitude, number: $number, street: $street, complement: $complement, district: $district, zipCode: $zipCode, city: $city, state: $state, latitude: $latitude, longitude: $longitude}';
  }
}
