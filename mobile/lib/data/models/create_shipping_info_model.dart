
class CreateShippingInfoModel{
  final String? address;
  final String? ward;
  final String? district;
  final String? city;
  final String? name;
  final String? phoneNumber;


  CreateShippingInfoModel({
    this.address,
    this.ward,
    this.district,
    this.city,
    this.name,
    this.phoneNumber,
  });

  @override
  String toString() {
    return 'CreateShippingInfoModel{name: $name, address: $address, ward: $ward, '
        'district: $district, city: $city, phoneNumber: $phoneNumber';
  }

  List<Object?> get props => [
    address,
    ward,
    district,
    city,
    name,
    phoneNumber,
  ];
}