import 'package:cloud_firestore/cloud_firestore.dart';

class AtividadeInsuladoraModel {
  String id;
  String idAtividade;
  double usEmpresa;
  double usProfissional;
  int qtdSoftBag;
  int quantidade;
  String tipoBag;
  double totalEmpresa;
  double totalProfissional;
  int  totalSoft;

  AtividadeInsuladoraModel({
    this.id = '',
    this.idAtividade = '',
    this.usEmpresa = 0,
    this.usProfissional = 0,
    this.qtdSoftBag = 0,
    this.quantidade = 0,
    this.tipoBag = '',
    this.totalEmpresa = 0,
    this.totalProfissional = 0,
    this.totalSoft = 0,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "idAtividade": idAtividade,
      "usEmpresa": usEmpresa,
      "usProfissional": usProfissional,
      "qtdSoftBag": qtdSoftBag,
      "quantidade": quantidade,
      "tipoBag": tipoBag,
      "totalEmpresa": totalEmpresa,
      "totalProfissional": totalProfissional,
      "totalSoft": totalSoft,
    };
    return map;
  }

  factory AtividadeInsuladoraModel.fromMap(Map<dynamic, dynamic>? dados,String id) {
    return AtividadeInsuladoraModel(
      id: id,
      idAtividade: dados?['idAtividade'] ?? '',
      usEmpresa: dados?['usEmpresa'] ?? 0,
      usProfissional: dados?['usProfissional'] ?? 0,
      qtdSoftBag: dados?['qtdSoftBag'] ?? 0,
      quantidade: dados?['quantidade'] ?? 0,
      tipoBag: dados?['tipoBag'] ?? '',
      totalEmpresa: dados?['totalEmpresa'] ?? 0,
      totalProfissional: dados?['totalProfissional'] ?? 0,
      totalSoft: dados?['totalSoft'] ?? 0,
    );
  }
  factory AtividadeInsuladoraModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return AtividadeInsuladoraModel(
      id: data?['id'] ?? '',
      idAtividade: data!['idAtividade'],
      usEmpresa: data['usEmpresa'],
      usProfissional: data['usProfissional'],
      qtdSoftBag: data['qtdSoftBag'],
      quantidade: data['quantidade'],
      tipoBag: data['tipoBag'],
      totalEmpresa: data['totalEmpresa'],
      totalProfissional: data['totalProfissional'],
      totalSoft: data['totalSoft'],
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "idAtividade": idAtividade,
      "usEmpresa": usEmpresa,
      "usProfissional": usProfissional,
      "qtdSoftBag": qtdSoftBag,
      "quantidade": quantidade,
      "tipoBag": tipoBag,
      "totalEmpresa":totalEmpresa,
      "totalProfissional":totalProfissional,
      "totalSoft":totalSoft,
    };
  }

  factory AtividadeInsuladoraModel.clean() {
    return AtividadeInsuladoraModel(idAtividade: '', tipoBag: '',);
  }
}