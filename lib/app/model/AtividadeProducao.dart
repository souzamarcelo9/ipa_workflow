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
    this.totalSoft = 0
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
    };
  }

  factory AtividadeProducaoModel.clean() {
    return AtividadeProducaoModel(idAtividade: '', drywall: '',);
  }
}
