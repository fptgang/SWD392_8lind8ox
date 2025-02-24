

class VideoModel{

  final int videoId;
  final int accountId;
  final int orderDetailId;
  final String? url;
  final String? description;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final  bool isVisible;
  final bool? isVerified;
  final int? slotId;

  VideoModel({
    required this.videoId,
    required this.accountId,
    required this.orderDetailId,
    this.url,
    this.description,
    required this.createdAt,
    this.updatedAt,
    required this.isVisible,
    this.isVerified,
    this.slotId,
  });

  List<Object?> get props => [
    videoId,
    accountId,
    orderDetailId,
    url,
    description,
    createdAt,
    updatedAt,
    isVisible,
    isVerified,
    slotId,
  ];
}