import 'package:cloud_firestore/cloud_firestore.dart';

class MaterialModel {
  String id;
  String idObra;
  String obra;
  String produto;
  String quantidade;
  String dtEntrega;
  String unidade;
  String profissional;
  String obs;

  MaterialModel({
    this.id = '',
    this.idObra = '',
    this.obra = '',
    this.produto = '',
    this.quantidade = '',
    this.dtEntrega = '',
    this.unidade = '',
    this.profissional = '',
    this.obs = '',
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "idObra": idObra,
      "obra": obra,
      "produto": produto,
      "quantidade": quantidade,
      "dtEntrega": dtEntrega,
      "unidade": unidade,
      "profissional":profissional,
      "obs": obs,
    };
    return map;
  }

  factory MaterialModel.fromMap(Map<dynamic, dynamic>? dados,String ?id) {
    return MaterialModel(
      id: id ?? '' ,
      idObra: dados?['idObra'] ?? '',
      obra: dados?['obra'] ?? '',
      produto: dados?['produto'] ?? '',
      quantidade: dados?['quantidade'] ?? '',
      dtEntrega: dados?['dtEntrega'] ?? '',
      unidade: dados?['unidade'] ?? '',
      profissional: dados?['profissional'] ?? '',
      obs: dados?['obs'] ?? '',
    );
  }

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      idObra: json['idObra'],
      obra: json['obra'],
      produto: json['produto'],
      quantidade: json['quantidade'],
      dtEntrega: json['dtEntrega'],
      unidade: json['unidade'],
      profissional: json['profissional'],
      obs: json['obs'],
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      //"id": id,
      "idObra": idObra,
      "obra": obra,
      "produto":produto,
      "quantidade": quantidade,
      "dtEntrega": dtEntrega,
      "unidade": unidade,
      "profissional": profissional,
      "obs":obs,
    };
  }

  factory MaterialModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return MaterialModel(
      id: data!['id'],
      profissional: data['profissional'],
      obra: data['obra'],
      idObra: data['idObra'],
      produto: data['produto'],
      quantidade: data['quantidade'],
      unidade: data['unidade'],
      dtEntrega: data['dtEntrega'],
      obs: data['obs'],
    );
  }

  Map<String, Object?> toJson() {
    return {
      'idObra': idObra,
      'obra': obra,
      "produto": produto,
      "quantidade": quantidade,
      "dtEntrega": dtEntrega,
      "unidade": unidade,
      "profissional": profissional,
      "obs": obs,
    };
  }

  factory MaterialModel.create(
      {required String idObra,
        required String obra,
        required String produto,
        required String quantidade,
        required String dtEntrega,
        required String unidade,
        required String profissional,
        required String obs,
        }) {
    return MaterialModel(
        obra: obra,
        idObra: idObra,
        profissional: profissional,
        dtEntrega: dtEntrega,
        produto: produto,
        quantidade: quantidade,
        unidade: unidade,
        obs:obs,
    );
  }

  factory MaterialModel.clean() {
    return MaterialModel(produto: '', id: '',);
  }
}