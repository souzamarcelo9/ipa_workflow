import 'package:cloud_firestore/cloud_firestore.dart';

class AtividadeProducaoModel {
  String id;
  String idAtividade;
  String drywall;
  int psqt;
  double usEmpresa;
  double usProfissional;
  int quantidade;
  double totalEmpresa;
  double totalProfissional;
  int totalSoft;
  String nomeProfissional;
  String emailProfissional;
  String url;
  String altura;
  String obra;
  String unidade;
  Timestamp ?dtAtividade;
  String descAtividade;

  AtividadeProducaoModel({
    this.id = '',
    this.idAtividade = '',
    this.drywall = '',
    this.psqt = 0,
    this.usEmpresa = 0,
    this.usProfissional = 0,
    this.quantidade = 0,
    this.totalEmpresa = 0,
    this.totalProfissional = 0,
    this.totalSoft = 0,
    this.nomeProfissional = '',
    this.emailProfissional = '',
    this.url = '',
    this.altura = '',
    this.obra = '',
    this.unidade = '',
    this.dtAtividade,
    this.descAtividade = ''
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
     // "id": id,
      "idAtividade": idAtividade,
      "drywall": drywall,
      "psqt": psqt,
      "usEmpresa": usEmpresa,
      "usProfissional": usProfissional,
      "quantidade": usProfissional,
      "totalEmpresa": totalEmpresa,
      "totalProfissional": totalProfissional,
      "totalSoft": totalSoft,
      "nomeProfissional": nomeProfissional,
      "emailProfissional": emailProfissional,
      "url": url,
      "altura": altura,
      "obra": obra,
      "unidade":unidade,
      "dtAtividade":dtAtividade,
      "descAtividade":descAtividade
    };
    return map;
  }

  factory AtividadeProducaoModel.fromMap(Map<dynamic, dynamic>? dados,String ?id) {
    return AtividadeProducaoModel(
      id: id ?? '' ,
      idAtividade: dados?['idAtividade'] ?? '',
      drywall: dados?['drywall'] ?? '',
      psqt: dados?['psqt'] ?? 0,
      usEmpresa: dados?['usEmpresa'] ?? 0,
      usProfissional: dados?['usProfissional'] ?? 0,
      quantidade: dados?['quantidade'] ?? '',
      totalEmpresa: dados?['totalEmpresa'] ?? '',
      totalProfissional: dados?['totalProfissional'] ?? '',
        totalSoft: dados?['totalSoft'] ?? 0,
      nomeProfissional: dados?['nomeProfissional'] ?? '',
      emailProfissional: dados?['emailProfissional'] ?? '',
      url: dados?['url'] ?? '',
      altura: dados?['altura'] ?? '',
      obra: dados?['obra'] ?? '',
      unidade: dados?['unidade'] ?? '',
      dtAtividade: dados?['dtAtividade'] ?? null,
        descAtividade:dados?['descAtividade'] ?? ''
    );
  }
  factory AtividadeProducaoModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return AtividadeProducaoModel(
      id: data!['id'],
      idAtividade: data['idAtividade'],
      drywall: data['drywall'],
      psqt: data['psqt'],
      usEmpresa: data['usEmpresa'],
      usProfissional: data['usProfissional'],
      quantidade: data['quantidade'],
      totalEmpresa: data['totalEmpresa'],
      totalProfissional: data['totalProfissional'],
      totalSoft: data['totalSoft'],
      nomeProfissional: data['nomeProfissional'],
      emailProfissional: data['emailProfissional'],
      url: data['url'],
      obra: data['obra'],
      unidade: data['unidade'],
      altura: data['altura'],
        dtAtividade: data['dtAtividade'],
        descAtividade:data['descAtividade']
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      //"id": id,
      "idAtividade": idAtividade,
      "drywall": drywall,
      "psqt": psqt,
      "usEmpresa": usEmpresa,
      "usProfissional": usProfissional,
      "quantidade": quantidade,
      "totalEmpresa": totalEmpresa,
      "totalProfissional":totalProfissional,
      "totalSoft":totalSoft,
      "nomeProfissional":nomeProfissional,
      "emailProfissional":emailProfissional,
      "url":url,
      "altura":altura,
      "obra":obra,
      "unidade":unidade,
      "dtAtividade":dtAtividade,
      "descAtividade":descAtividade
    };
  }

  factory AtividadeProducaoModel.clean() {
    return AtividadeProducaoModel(idAtividade: '', drywall: '',);
  }
}
