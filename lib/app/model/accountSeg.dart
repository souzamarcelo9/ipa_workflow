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

  AccountSegModel({
    this.id = '',
    this.profissional = '',
    this.data = '',
    this.docNumber = 0,
    this.refkey = '',
    this.tpDoc = '',
    this.urlImagem = '',
    this.wrbtr = 0,
    this.status = ''
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
        required String status}) {
    return AccountSegModel(
        profissional: profissional,
        data: data,
        docNumber: docNumber,
        refkey: refkey,
        tpDoc: tpDoc,
        urlImagem: urlImagem,
        wrbtr: wrbtr,
        status:status,
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
    );
  }

  factory AccountSegModel.clean() {
    return AccountSegModel(id: '', docNumber: 0,);
  }
}