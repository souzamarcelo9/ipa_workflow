import 'package:cloud_firestore/cloud_firestore.dart';

class FotoObraModel {
  String id;
  String dataUpload;
  String idAtividade;
  String idUsuario;
  String nomeObra;
  String urlPhoto;

  FotoObraModel({
    this.id = '',
    this.dataUpload= '',
    this.idAtividade = '',
    this.idUsuario = '',
    this.nomeObra = '',
    this.urlPhoto = '',
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "dataUpload": dataUpload,
      "idAtividade": idAtividade,
      "idUsuario": idUsuario,
      "nomeObra": nomeObra,
      "urlPhoto": urlPhoto,
    };
    return map;
  }

  factory FotoObraModel.fromMap(Map<dynamic, dynamic>? dados,String ?id) {
    return FotoObraModel(
      id: id ?? '' ,
      dataUpload: dados?['dataUpload'] ?? '',
      idAtividade: dados?['idAtividade'] ?? '',
      idUsuario: dados?['idUsuario'] ?? '',
      nomeObra: dados?['nomeObra'] ?? '',
      urlPhoto: dados?['urlPhoto'] ?? '',
    );
  }

  factory FotoObraModel.fromJson(Map<String, dynamic> json) {
    return FotoObraModel(
      dataUpload: json['dataUpload'],
      idAtividade: json['idAtividade'],
      idUsuario: json['idUsuario'],
      nomeObra: json['nomeObra'],
      urlPhoto: json['urlPhoto'],
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
       "id": id,
      "dataUpload": dataUpload,
      "idAtividade": idAtividade,
      "idUsuario":idUsuario,
      "nomeObra": nomeObra,
      "urlPhoto": urlPhoto,
    };
  }

  factory FotoObraModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return FotoObraModel(
      id: data!['id'],
      dataUpload: data['dataUpload'],
      idAtividade: data['idAtividade'],
      idUsuario: data['idUsuario'],
      nomeObra: data['nomeObra'],
      urlPhoto: data['urlPhoto'],
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'dataUpload': dataUpload,
      "idAtividade": idAtividade,
      "idUsuario": idUsuario,
      "nomeObra": nomeObra,
      "urlPhoto": urlPhoto,
    };
  }

  factory FotoObraModel.create(
      {required String dataUpload,
        required String idAtividade,
        required String idUsuario,
        required String nomeObra,
        required String urlPhoto,
        }) {
    return FotoObraModel(
      dataUpload: dataUpload,
      idAtividade: idAtividade,
      idUsuario: idUsuario,
      nomeObra: nomeObra,
      urlPhoto: urlPhoto,
    );
  }

  factory FotoObraModel.clean() {
    return FotoObraModel(urlPhoto: '', id: '',);
  }
}