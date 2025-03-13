
class ShippingInfoModel{
  final int? shippingInfoId;
  final String? address;
  final String? ward;
  final String? district;
  final String? city;
  final String? name;
  final String? phoneNumber;
  final bool? isVisible;
  final DateTime? createdAt;
  final DateTime? updatedAt;


  ShippingInfoModel({
    this.shippingInfoId,
    this.address,
    this.ward,
    this.district,
    this.city,
    this.name,
    this.phoneNumber,
    this.isVisible = true,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'ShippingInfoModel{name: $name, address: $address, ward: $ward, '
        'district: $district, city: $city, phoneNumber: $phoneNumber, '
        'createdAt: $createdAt}';
  }

  List<Object?> get props => [
    shippingInfoId,
    address,
    ward,
    district,
    city,
    name,
    phoneNumber,
    isVisible,
    createdAt,
    updatedAt,
  ];
}