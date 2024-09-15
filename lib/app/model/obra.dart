import 'package:cloud_firestore/cloud_firestore.dart';

class ObraModel {
  String id;
  String cidade;
  String dtCriacao;
  Timestamp dtEntrega;
  String dtModf;
  String empresa;
  String endereco;
  String estado;
  String formam;
  String nome;
  String obs;
  String pais;
  String supervisor;
  String telefone;
  String unidades;
  String usuario;


  ObraModel({
    this.id = '',
    this.cidade = '',
    this.dtCriacao = '',
    this.dtModf = '',
    this.empresa = '',
    this.endereco = '',
    this.estado = '',
    this.formam = '',
    this.nome = '',
    this.obs = '',
    this.pais = '',
    this.supervisor = '',
    this.telefone = '',
    this.unidades = '',
    this.usuario = '',
    Timestamp? dtEntrega
  }): dtEntrega = dtEntrega ?? Timestamp.now();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "cidade": cidade,
      "dtCriacao": dtCriacao,
      "dtEntrega": dtEntrega,
      "dtModf": dtModf,
      "empresa": empresa,
      "endereco": endereco,
      "estado": estado,
      "formam": formam,
      "nome": nome,
      "obs": obs,
      "pais": pais,
      "supervisor": supervisor,
      "telefone": telefone,
      "unidades": unidades,
      "usuario": usuario,
    };
    return map;
  }

  factory ObraModel.fromMap(Map<dynamic, dynamic>? dados,String ?id) {
    return ObraModel(
      id: id ?? '' ,
      cidade: dados?['cidade'] ?? '',
      dtCriacao: dados?['dtCriacao'] ?? '',
      dtEntrega: dados?['dtEntrega'] ?? null,
      dtModf: dados?['dtModf'] ?? '',
      empresa: dados?['empresa'] ?? '',
      endereco: dados?['endereco'] ?? '',
      estado: dados?['estado'] ?? '',
      formam: dados?['formam'] ?? '',
      nome: dados?['nome'] ?? '',
      obs: dados?['obs'] ?? '',
      pais: dados?['pais'] ?? '',
      supervisor: dados?['supervisor'] ?? '',
      telefone: dados?['telefone'] ?? '',
      unidades: dados?['unidades'] ?? '',
      usuario: dados?['usuario'] ?? '',
    );
  }

  factory ObraModel.fromJson(Map<String, dynamic> json) {
    return ObraModel(
      cidade: json['cidade'],
      dtCriacao: json['dtCriacao'],
      dtEntrega: json['dtEntrega'],
      dtModf: json['dtModf'],
      empresa: json['empresa'],
      endereco: json['endereco'],
      estado: json['estado'],
      formam: json['formam'],
      nome: json['nome'],
      obs: json['obs'],
      pais: json['pais'],
      supervisor: json['supervisor'],
      telefone: json['telefone'],
      unidades: json['unidades'],
      usuario: json['usuario'],
    );
  }

  Map<String, Object?> toJson() {
    return {
      'cidade': cidade,
      'dtCriacao': dtCriacao,
      "dtEntrega": dtEntrega,
      "dtModf": dtModf,
      "empresa": empresa,
      "endereco": endereco,
      "estado": estado,
      "formam": formam,
      "nome": nome,
      "obs": obs,
      "pais": pais,
      "supervisor": supervisor,
      "telefone": telefone,
      "usuario": usuario,
      "telefone": telefone,
      "unidades": unidades,
    };
  }

  factory ObraModel.clean() {
    return ObraModel(nome: '');
  }
}
