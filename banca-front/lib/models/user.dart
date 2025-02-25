class UserModel {
  final String id;
  final String name;
  final String email;
  final double balance;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.balance,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      name: json['name'],
      email: json['email'],
      balance: double.tryParse(json['balance'].toString()) ?? 0.0,
    );
  }
}
