import 'package:cloud_firestore/cloud_firestore.dart';

class TipoTabelaProfissionalModel {
  String id;
  int codigo;
  String desc;
  String dtModf;
  String idtTabela;
  String tipo;
  String usuario;

  TipoTabelaProfissionalModel({
    this.id = '',
    this.codigo = 0,
    this.desc = '',
    this.dtModf = '',
    this.idtTabela = '',
    this.tipo = '',
    this.usuario = '',
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "codigo": codigo,
      "desc": desc,
      "dtModf": dtModf,
      "idtTabela": idtTabela,
      "tipo": tipo,
      "usuario": usuario,
    };
    return map;
  }

  factory TipoTabelaProfissionalModel.fromMap(Map<dynamic, dynamic>? dados,String ?id) {
    return TipoTabelaProfissionalModel(
      id: id ?? '' ,
      codigo: dados?['codigo'] ?? 0,
      desc: dados?['desc'] ?? '',
      dtModf: dados?['dtModf'] ?? '',
      idtTabela: dados?['idtTabela'] ?? '',
      tipo: dados?['tipo'] ?? '',
      usuario: dados?['usuario'] ?? '',
    );
  }

  factory TipoTabelaProfissionalModel.clean() {
    return TipoTabelaProfissionalModel(id: '', desc: '',);
  }
}
