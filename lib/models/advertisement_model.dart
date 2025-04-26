class AdvertisementModel {
  final String id;
  final String title;
  final String description;
  final String imagePath;

  AdvertisementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imagePath,
  });

  factory AdvertisementModel.fromMap(String id, Map<String, dynamic> map) {
    return AdvertisementModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imagePath: map['image_path'] ?? '',
    );
  }
}
