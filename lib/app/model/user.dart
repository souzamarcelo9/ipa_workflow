import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String userImage;
  String name;
  String email;
  String cpf;
  String phone;
  String password;
  String maritalStatus;
  String genre;
  String dtModf;
  String usuarioModf;

  UserModel({
    this.id = '',
    this.userImage = '',
    this.name = '',
    this.email = '',
    this.cpf = '',
    this.phone = '',
    this.password = '',
    this.maritalStatus = '',
    this.genre = '',
    this.dtModf = '',
    this.usuarioModf = ''
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id":id,
      "userImage": userImage,
      "name": name,
      "email": email,
      "cpf": cpf,
      "genre": genre,
      "phone": phone,
      "maritalStatus": maritalStatus,
    };
    return map;
  }

  factory UserModel.fromMap(Map<dynamic, dynamic>? dados) {
    return UserModel(
        id: dados?['id'] ?? '',
      userImage: dados?['imagem_usuario'] ?? '',
      name: dados?['name'] ?? '',
      email: dados?['email'] ?? '',
      cpf: dados?['cpf'] ?? '',
      genre: dados?['sexo'] ?? '',
      phone: dados?['phone'] ?? '',
      maritalStatus: dados?['estado_civil'] ?? '',
      password: dados?['password'] ?? '',
      dtModf: dados?['dtModf'] ?? '',
        usuarioModf:dados?['usuarioModf'] ?? ''
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": cpf,
      "username": name,
      "password": password,
      "age": genre,
      "dob": maritalStatus,
      "validated": maritalStatus,
      //"address": address.toFirestore(),
    };
  }

  factory UserModel.create(
      {required String username,
        required String password,
        required int age,
        required DateTime dob,
        required String endereco}) {
    final id = username + password;
    return UserModel(
      name: username,
      password: password,
      email: username,
      cpf: username,
      phone: endereco,
      genre: username,
    );
  }

  factory UserModel.clean() {
    return UserModel(name: '', email: '',);
  }
  factory UserModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return UserModel(
      userImage: data?['imagem_usuario'],
      name: data?['username'],
      password: data?['password'],
      phone: data?['age'],
      cpf: data?['dob'],
      genre: data?['validated'],
      email: data?['address'],
    );
  }
}
