import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class MessengerModel {
  String id;
  String idUsuario;
  String idMessage;
  String messageContent;
  String messageType;
  int order;
  String status;
  Timestamp dtHora;

  MessengerModel({
    this.id = '',
    this.idUsuario = '',
    this.idMessage = '',
    this.messageContent = '',
    this.messageType = '',
    this.order = 0,
    this.status = '',
    Timestamp? dtHora
  }): dtHora = dtHora ?? Timestamp.now();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "idUsuario": idUsuario,
      "idMessage": idMessage,
      "messageContent": messageContent,
      "messageType": messageType,
      "order": order,
      "status": status,
      "dtHora": dtHora,
    };
    return map;
  }

  factory MessengerModel.fromMap(Map<dynamic, dynamic>? dados,String ?id) {
    return MessengerModel(
        id: id ?? '' ,
        idUsuario: dados?['idUsuario'] ?? '',
        idMessage: dados?['idMessage'] ?? '',
        messageContent: dados?['messageContent'] ?? '',
        messageType: dados?['messageType'] ?? '',
        order: dados?['order'] ?? '',
        status: dados?['status'] ?? '',
        dtHora: dados?['dtHora'] ?? '',
    );
  }

  factory MessengerModel.fromJson(Map<String, dynamic> json) {
    return MessengerModel(
        id: json['id'],
        idUsuario: json['idUsuario'],
        idMessage: json['idMessage'],
        messageContent: json['messageContent'],
        messageType: json['messageType'],
        order: json['order'],
        status: json['status'],
        dtHora: json['dtHora'],
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'idUsuario': idUsuario,
      'idMessage': idMessage,
      "messageContent": messageContent,
      "messageType": messageType,
      "order": order,
      "status": status,
      "dtHora": dtHora,
    };
  }
  factory MessengerModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return MessengerModel(
      id: data!['id'],
      idUsuario: data!['idUsuario'],
      idMessage: data['idMessage'],
      messageContent: data['messageContent'],
      messageType: data['messageType'],
      order: data['order'],
      status: data['status'],
      dtHora: data['dtHora'],
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "idUsuario": idUsuario,
      "idMessage": idMessage,
      "messageContent": messageContent,
      "messageType": messageType,
      "order": order,
      "status": status,
      "dtHora":dtHora,
    };
  }

  factory MessengerModel.clean() {
    return MessengerModel(id: '', idUsuario: '',);
  }
}
