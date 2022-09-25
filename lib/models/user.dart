class User {
  final String name;
  int? id;
  final String email;

  User({
    this.name = "",
    this.id,
    this.email = "",
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
