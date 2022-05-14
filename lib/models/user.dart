class User {
  final String name;
  int? id;
  final String email;

  User({
    required this.name,
    this.id,
    required this.email,
  });

  // Usado para inserir dados no banco de dados
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "name": name,
      "email": email,
    };
  }
}
