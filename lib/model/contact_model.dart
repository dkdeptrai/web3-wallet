class Contact {
  final int id;
  final int userId;
  final String name;
  final String publicAddress;

  Contact({
    required this.id,
    required this.userId,
    required this.name,
    required this.publicAddress,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      publicAddress: json['publicAddress'],
    );
  }
}
