class User {
  int? id;
  final String name;
  final String imageUrl;
  final String email;

  User({
    this.name = "",
    this.imageUrl = "https://cdn.pixabay.com/photo/2016/03/31/19/57/avatar-1295404_960_720.png",
    this.id,
    this.email = "",
  });

  // Usado para inserir dados no banco de dados
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "name": name,
      "imageUrl": imageUrl,
      "email": email,
    };
  }
}
