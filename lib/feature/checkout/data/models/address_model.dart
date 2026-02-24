class AddressModel {
  final String? id;
  final String city;
  final String street;
  final String phone;
  final String zipCode;

  AddressModel({
    this.id,
    required this.city,
    required this.street,
    required this.phone,
    required this.zipCode,
  });

  factory AddressModel.fromFirestore(Map<String, dynamic> data, String id) {
    return AddressModel(
      id: id,
      city: data['city'] ?? '',
      street: data['street'] ?? '',
      phone: data['phone'] ?? '',
      zipCode: data['zipCode'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() => {
    'city': city,
    'street': street,
    'phone': phone,
    'zipCode': zipCode,
  };
}
