import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class AtividadeHoraModel {
  String id;
  String obra;
  double valorHora;
  double totalProfissional;
  String dtAtividade;
  Timestamp dtHoraEntrada;
  Timestamp ?dtHoraSaida;
  String profissional;
  String status;
  String idUsuario;

  AtividadeHoraModel({
    this.id = '',
    this.obra = '',
    this.valorHora = 0,
    this.totalProfissional = 0,
    this.dtAtividade = '',
    this.profissional = '',
    this.status = '',
    this.idUsuario = '',
    this.dtHoraSaida,
    Timestamp? dtHoraEntrada
  }): dtHoraEntrada = dtHoraEntrada ?? Timestamp.now();


  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "obra": obra,
      "valorHora": valorHora,
      "totalProfissional": totalProfissional,
      "dtAtividade": dtAtividade,
      "profissional": profissional,
      "status": status,
      "dtHoraEntrada": dtHoraEntrada,
      "dtHoraSaida": dtHoraSaida,
      "idUsuario": idUsuario,
    };
    return map;
  }

  factory AtividadeHoraModel.fromMap(Map<dynamic, dynamic>? dados,String ?id) {
    return AtividadeHoraModel(
      id: id ?? '' ,
      obra: dados?['obra'] ?? '',
      valorHora: dados?['valorHora'] ?? 0,
      totalProfissional: dados?['totalProfissional'] ?? 0,
      dtAtividade: dados?['dtAtividade'] ?? '',
      profissional: dados?['profissional'] ?? '',
      status: dados?['status'] ?? '',
      dtHoraEntrada: dados?['dtHoraEntrada'] ?? '',
      dtHoraSaida: dados?['dtHoraSaida'],
      idUsuario: dados?['idUsuario'] ?? '',
    );
  }
  factory AtividadeHoraModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return AtividadeHoraModel(
      id: data!['id'],
      //idAtividade: data!['idAtividade'],
      obra: data['obra'],
      valorHora: data['valorHora'],
      totalProfissional: data['totalProfissional'],
      dtAtividade: data['dtAtividade'],
      profissional: data['profissional'],
      status: data['status'],
      dtHoraEntrada: data['dtHoraEntrada'],
      dtHoraSaida: data['dtHoraSaida'],
      idUsuario: data['idUsuario'],
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "obra": obra,
      "valorHora": valorHora,
      "totalProfissional": totalProfissional,
      "dtAtividade": dtAtividade,
      "profissional": profissional,
      "status": status,
      "dtHoraEntrada":dtHoraEntrada,
      "dtHoraSaida":dtHoraSaida,
      "idUsuario":idUsuario,
    };
  }

  factory AtividadeHoraModel.clean() {
    return AtividadeHoraModel(id: '', obra: '',);
  }
}
