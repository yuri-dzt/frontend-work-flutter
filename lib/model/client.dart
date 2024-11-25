class Client {
  final int id;
  final String nome;
  final String sobrenome;
  final String email;
  final int age;
  final String photo;

  Client({
    required this.id,
    required this.nome,
    required this.sobrenome,
    required this.email,
    required this.age,
    required this.photo,
  });

  // Método para converter de JSON para um objeto Client
  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      nome: json['name'],
      sobrenome: json['lastname'],
      email: json['email'],
      age: json['age'],
      photo: json['photo'],
    );
  }

  // Método para converter de um objeto Client para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': nome,
      'lastname': sobrenome,
      'email': email,
      'age': age,
      'photo': photo,
    };
  }
}
