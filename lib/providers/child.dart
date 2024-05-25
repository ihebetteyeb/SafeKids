class Child {
  final String name;
  final String imageUrl;

  Child({required this.name, required this.imageUrl});
  factory Child.fromMap(Map<String, dynamic> data) {
    return Child(
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}