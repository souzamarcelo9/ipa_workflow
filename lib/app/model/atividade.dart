import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:viska_erp_mobile/app/model/tbInsuladora.dart';
import 'package:viska_erp_mobile/app/model/tbProducao.dart';

class AtividadeModel {
  String id;
  String profissional;
  String obra;
  String nomeObra;
  String data;
  String tabela;
  int unidade;
  String altura;
  Timestamp ?dtModificacao;
  String usuario;
  List<ProducaoModel> tbProducao;
  List<InsuladoraModel> tbInsuladora;
  String status;
  int ano;
  int mes;

  AtividadeModel({
    this.id = '',
    this.profissional = '',
    this.obra = '',
    this.nomeObra = '',
    this.data = '',
    this.tabela = '',
    this.unidade = 0,
    this.altura = '',
    this.usuario = '',
    this.dtModificacao,
    this.tbProducao = const[],
    this.tbInsuladora = const[],
    this.status = '',
    this.ano = 0,
    this.mes = 0
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "profissional": profissional,
      "obra": obra,
      "nomeObra": nomeObra,
      "data": data,
      "email": tabela,
      "unidade": unidade,
      "altura": altura,
      "usuario": usuario,
      "dtModificacao":dtModificacao,
      "tbProducao": tbProducao,
      "tbInsuladora": tbInsuladora,
      "status": status,
      "ano": ano,
      "mes": mes,
    };
    return map;
  }

  factory AtividadeModel.fromMap(Map<dynamic, dynamic>? dados,String ?id) {
    return AtividadeModel(
      id: id ?? '' ,
      profissional: dados?['profissional'] ?? '',
      obra: dados?['obra'] ?? '',
      nomeObra: dados?['nomeObra'] ?? '',
      data: dados?['data'] ?? '',
      tabela: dados?['tabela'] ?? '',
      unidade: dados?['unidade'] ?? 0,
      altura: dados?['altura'] ?? '',
      usuario: dados?['usuario'] ?? '',
      dtModificacao: dados?['dtModificacao'] ?? null,
      tbProducao: dados?['tbProducao'] ?? [],
      tbInsuladora: dados?['tbInsuladora'] ?? [],
      status: dados?['status'] ?? [],
      ano: dados?['ano'] ?? 0,
      mes: dados?['mes'] ?? 0,
    );
  }
  factory AtividadeModel.create(
      {required String obra,
        required String nomeObra,
        required String profissional,
        required String data,
        required String tabela,
        required int unidade,
        required String usuario,
        required Timestamp dtModificacao,
        required String status,
        required String altura,
        required int ano,
        required int mes,
      }) {
    return AtividadeModel(
      obra: obra,
        nomeObra: nomeObra,
      profissional: profissional,
      data: data,
      tabela: tabela,
      unidade: unidade,
      altura: altura,
      usuario:usuario,
      dtModificacao: dtModificacao,
      status:status,
      ano: ano,
      mes: mes
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      //"id": id,
      "profissional": profissional,
      "obra": obra,
      "nomeObra":nomeObra,
      "data": data,
      "tabela": tabela,
      "unidade": unidade,
      "altura": altura,
      "usuario":usuario,
      "dtModificacao":dtModificacao,
      "status":status,
      "ano":ano,
      "mes":mes,
    };
  }
  factory AtividadeModel.fromJson(Map<String, dynamic> json) {
    return AtividadeModel(
      id: json['id'],
      profissional: json['profissional'],
      obra: json['obra'],
        nomeObra: json['nomeObra'],
      data: json['data'],
      tabela: json['tabela'],
      unidade: json['unidade'],
      altura: json['altura'],
      usuario:json['usuario'],
      dtModificacao: json['dtModificacao'],
      status: json['status'],
      ano: json['ano'],
      mes: json['mes'],
    );
  }
  factory AtividadeModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return AtividadeModel(
      id: data!['id'],
      profissional: data['profissional'],
      obra: data['obra'],
      nomeObra: data['nomeObra'],
      data: data['data'],
      tabela: data['tabela'],
      unidade: data['unidade'],
      altura: data['altura'],
      usuario: data['usuario'],
      dtModificacao: data['dtModificacao'],
      status: data['status'],
      ano: data['ano'],
      mes: data['mes']
    );
  }

  factory AtividadeModel.clean() {
    return AtividadeModel(id: '', nomeObra: '',);
  }
}
