class User {
  final String id;
  final String fullname;
  final String email;
  final String businessName;

  User(
      {required this.id,
      required this.fullname,
      required this.email,
      required this.businessName});

  factory User.fromMap(Map<String, dynamic> m) => User(
        id: m['id'] ?? m['_id'] ?? '',
        fullname: m['fullname'] ?? '',
        email: m['email'] ?? '',
        businessName: m['businessName'] ?? '',
      );
}
