

class LoginModels {
  int? id;
  String email;
  String password;

  LoginModels({
    this.id,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
    };
  }

  factory LoginModels.fromMap(Map<String, dynamic> map) {
    return LoginModels(
      id: map['id'],
      email: map['email'],
      password: map['password'],
    );
  }
}