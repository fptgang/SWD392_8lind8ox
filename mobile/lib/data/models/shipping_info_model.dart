
class ShippingInfoModel{
  final int shippingInfoId;
  final String? address;
  final String? ward;
  final String? district;
  final String? city;
  final String name;
  final String phoneNumber;
  final bool isVisible;
  final DateTime? createdAt;
  final DateTime? updatedAt;


  ShippingInfoModel({
    required this.shippingInfoId,
    this.address,
    this.ward,
    this.district,
    this.city,
    required this.name,
    required this.phoneNumber,
    this.isVisible = true,
    this.createdAt,
    this.updatedAt,
  });
}