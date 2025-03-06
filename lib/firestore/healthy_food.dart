class HealthyFood {
  final String name;
  final String imageUrl;
  final String about;
  final String benefits;
  final String nutritionalValue;
  final String bgImageUrl;
  

  HealthyFood({
    required this.name,
    required this.imageUrl,
    required this.about,
    required this.benefits,
    required this.nutritionalValue,
    required this.bgImageUrl,
  });

  // Update the factory method to handle a key and a map directly
  factory HealthyFood.fromFirestore(String key, Map<String, dynamic> data) {
    return HealthyFood(
      name: data['name'] ?? key, // Use key if name is not available
      imageUrl: data['imageUrl'].toString() ?? '',
      about: data['about'].toString() ?? '',
      benefits: data['benefits'].toString() ?? '',
      nutritionalValue: data['nutritionalValue'].toString() ?? '',
      bgImageUrl: data['bgImageUrl'].toString() ?? '',
    );
  }
}
