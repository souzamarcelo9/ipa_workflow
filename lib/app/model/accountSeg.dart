import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:viska_erp_mobile/app/model/tbInsuladora.dart';
import 'package:viska_erp_mobile/app/model/tbProducao.dart';

class AccountSegModel {
  String id;
  String profissional;
  String data;
  num docNumber;
  String refkey;
  String urlImagem;
  String tpDoc;
  num wrbtr;
  String status;
  int ano;
  int mes;
  String grupo;
  String hkont;
  String augdt;
  String fornecedor;
  String history;
  String vencimento;
  String waers;

  AccountSegModel({
    this.id = '',
    this.profissional = '',
    this.data = '',
    this.docNumber = 0,
    this.refkey = '',
    this.tpDoc = '',
    this.urlImagem = '',
    this.wrbtr = 0,
    this.status = '',
    this.ano = 0,
    this.mes = 0,
    this.grupo = '',
    this.hkont = '',
    this.augdt = '',
    this.fornecedor = '',
    this.history = '',
    this.vencimento = '',
    this.waers = ''
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "profissional": profissional,
      "data": data,
      "doc_number": docNumber,
      "refkey": refkey,
      "tpDoc": tpDoc,
      "urlImagem": urlImagem,
      "wrbtr":wrbtr,
      "status": status,
      "ano": ano,
      "mes": mes,
      "grupo": grupo,
      "hkont": hkont,
      "augdt": augdt,
      "fornecedor": fornecedor,
      "history":history,
      "vencimento":vencimento,
      "waers":waers
    };
    return map;
  }

  factory AccountSegModel.fromMap(Map<dynamic, dynamic>? dados,String ?id) {
    return AccountSegModel(
      id: id ?? '' ,
      profissional: dados?['profissional'] ?? '',
      data: dados?['data'] ?? '',
      docNumber: dados?['doc_number'] ?? 0,
      refkey: dados?['refkey'] ?? '',
      tpDoc: dados?['tpDoc'] ?? '',
      urlImagem: dados?['urlImagem'] ?? '',
      wrbtr: dados?['wrbtr'] ?? 0,
      status: dados?['status'] ?? [],
      mes: dados?['mes'] ?? 0,
      ano: dados?['ano'] ?? 0,
      grupo: dados?['grupo'] ?? '',
      hkont: dados?['hkont'] ?? '',
      augdt: dados?['augdt'] ?? '',
      fornecedor: dados?['fornecedor'] ?? '',
      history: dados?['history'] ?? '',
      vencimento: dados?['vencimento'] ?? '',
      waers: dados?['waers'] ?? '',
    );
  }
  factory AccountSegModel.create(
      {
        required String profissional,
        required String data,
        required num docNumber,
        required String refkey,
        required String tpDoc,
        required String urlImagem,
        required num wrbtr ,
        required String status,
        required int ano,
        required int mes,
        required String grupo,
        required String hkont,
        required String augdt,
        required String fornecedor,
        required String history,
        required String vencimento,
        required String waers
      }) {
    return AccountSegModel(
        profissional: profissional,
        data: data,
        docNumber: docNumber,
        refkey: refkey,
        tpDoc: tpDoc,
        urlImagem: urlImagem,
        wrbtr: wrbtr,
        status:status,
        ano: ano,
        mes: mes,
        grupo: grupo,
        hkont: hkont,
        augdt: augdt,
        fornecedor: fornecedor,
        history: history,
        vencimento: vencimento,
        waers: waers,
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      //"id": id,
      "profissional": profissional,
      "data": data,
      "doc_number":docNumber,
      "refkey": refkey,
      "tpDoc": tpDoc,
      "urlImagem": urlImagem,
      "wrbtr":wrbtr,
      "status":status,
      "ano":ano,
      "mes":mes,
      "grupo":grupo,
      "hkont":hkont,
      "augdt":augdt,
      "fornecedor":fornecedor,
      "history":history,
      "vencimento":vencimento,
      "waers":waers,
    };
  }
  factory AccountSegModel.fromJson(Map<String, dynamic> json) {
    return AccountSegModel(
      id: json['id'],
      profissional: json['profissional'],
      data: json['data'],
      docNumber: json['doc_number'],
      refkey: json['refkey'],
      tpDoc: json['tpDoc'],
      urlImagem: json['urlImagem'],
      wrbtr: json['wrbtr'],
      status:json['status'],
      ano: json['ano'],
      mes: json['mes'],
      grupo: json['grupo'],
      hkont: json['hkont'],
      augdt: json['augdt'],
      fornecedor: json['fornecedor'],
      history: json['history'],
      vencimento: json['vencimento'],
      waers: json['waers'],
    );
  }
  factory AccountSegModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return AccountSegModel(
      id: data!['id'],
      profissional: data['profissional'],
      data: data['data'],
      docNumber: data['doc_number'],
      refkey: data['refkey'],
      tpDoc: data['tpDoc'],
      urlImagem: data['urlImagem'],
      wrbtr: data['wrbtr'],
      status: data['status'],
      ano: data['ano'],
      mes: data['mes'],
      grupo: data['grupo'],
      hkont: data['hkont'],
      augdt: data['augdt'],
      fornecedor: data['fornecedor'],
      history: data['history'],
      vencimento: data['vencimento'],
      waers: data['waers'],
    );
  }

  factory AccountSegModel.clean() {
    return AccountSegModel(id: '', docNumber: 0,);
  }
}
