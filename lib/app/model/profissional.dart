import 'package:cloud_firestore/cloud_firestore.dart';

class ProfissionalModel {
  String id;
  String cidade;
  String dtFim;
  String dtInicio;
  String email;
  String endereco;
  String estado;
  String flgAdm;
  String nome;
  String obs;
  String  pais;
  String paradaAlmoco;
  String profissao;
  String status;
  String tbProd;
  String telefone;
  String tmpAlmoco;
  String usuario;
  num vlrHora;
  int idTipoProfissional;


  ProfissionalModel({
    this.id = '',
    this.cidade = '',
    this.dtFim = '',
    this.email = '',
    this.dtInicio = '',
    this.endereco = '',
    this.estado = '',
    this.flgAdm = '',
    this.nome = '',
    this.obs = '',
    this.pais = '',
    this.paradaAlmoco = '',
    this.profissao = '',
    this.status = '',
    this.tbProd = '',
    this.telefone = '',
    this.tmpAlmoco = '',
    this.usuario = '',
    this.vlrHora = 0.0,
    this.idTipoProfissional = 0
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "cidade": cidade,
      "dtFim": dtFim,
      "email": email,
      "dtInicio": dtInicio,
      "endereco": endereco,
      "estado": estado,
      "nome": nome,
      "flgAdm": flgAdm,
      "obs": obs,
      "pais": pais,
      "paradaAlmoco": paradaAlmoco,
      "profissao": profissao,
      "status": status,
      "tbProd": tbProd,
      "telefone": telefone,
      "tmpAlmoco": tmpAlmoco,
      "usuario": usuario,
      "vlrHora":vlrHora,
      "idTipoProfissional":idTipoProfissional

    };
    return map;
  }

  factory ProfissionalModel.fromMap(Map<dynamic, dynamic>? dados,String ?id) {
    return ProfissionalModel(
      id: id ?? '' ,
      cidade: dados?['cidade'] ?? '',
      dtFim: dados?['dtFim'] ?? '',
      email: dados?['email'] ?? '',
      dtInicio: dados?['dtInicio'] ?? '',
      endereco: dados?['endereco'] ?? '',
      estado: dados?['estado'] ?? '',
      nome: dados?['nome'] ?? '',
      flgAdm: dados?['flgAdm'] ?? '',
        obs: dados?['obs'] ?? '',
        pais: dados?['pais'] ?? '',
        paradaAlmoco: dados?['paradaAlmoco'] ?? '',
        profissao: dados?['profissao'] ?? '',
        status: dados?['status'] ?? '',
        tbProd: dados?['tbProd'] ?? '',
       telefone: dados?['telefone'] ?? '',
      tmpAlmoco: dados?['tmpAlmoco'] ?? '',
      usuario: dados?['usuario'] ?? '',
      vlrHora: dados?['vlrHora'] ?? 0.0,
      idTipoProfissional: dados?['idTipoProfissional'] ?? 0,
    );
  }

  factory ProfissionalModel.fromJson(Map<String, dynamic> json) {
    return ProfissionalModel(
      cidade: json['cidade'],
      dtFim: json['dtFim'],
      email: json['email'],
      dtInicio: json['dtInicio'],
      endereco: json['endereco'],
      estado: json['estado'],
      nome: json['nome'],
      flgAdm: json['flgAdm'],
      pais: json['pais'],
      profissao: json['profissao'],
        status: json['status'],
      tbProd: json['tbProd'],
      tmpAlmoco: json['tmpAlmoco'] ,
      usuario: json['usuario'],
      vlrHora: json['vlrHora'],
        idTipoProfissional: json['idTipoProfissional']
    );
  }

  Map<String, Object?> toJson() {
    return {
      'cidade': cidade,
      'dtFim': dtFim,
      "email": email,
      "dtInicio": dtInicio,
      "endereco": endereco,
      "estado": estado,
      "nome": nome,
      "flgAdm": flgAdm,
      "obs": obs,
      "pais": pais,
      "paradaAlmoco": paradaAlmoco,
      "profissao": profissao,
      "status": status,
      "tbProd": tbProd,
      "telefone": telefone,
      "tmpAlmoco": tmpAlmoco,
      "usuario": usuario,
      "vlrHora": vlrHora,
      "idTipoProfissional": idTipoProfissional
    };
  }
  factory ProfissionalModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return ProfissionalModel(
      cidade: data!['cidade'],
      dtFim: data['dtFim'],
      email: data['email'],
      dtInicio: data['dtInicio'],
      endereco: data['endereco'],
      estado: data['estado'],
      nome: data['nome'],
      flgAdm: data['flgAdm'],
      obs: data['obs'],
      pais: data['pais'],
      paradaAlmoco: data['paradaAlmoco'],
      profissao: data['profissao'],
      status: data['status'],
      tbProd: data['tbProd'],
      telefone: data['telefone'],
      tmpAlmoco: data['tmpAlmoco'],
      usuario: data['usuario'],
      vlrHora: data['vlrHora'],
      idTipoProfissional: data['idTipoProfissional'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "cidade": cidade,
      "dtFim": dtFim,
      "email": email,
      "dtInicio":dtInicio,
      "endereco": endereco,
      "estado": estado,
      "nome": nome,
      "flgAdm": flgAdm,
      "obs":obs,
      "pais":pais,
      "pais":pais,
      "paradaAlmoco":paradaAlmoco,
      "profissao":profissao,
      "status":status,
      "tbProd":tbProd,
      "telefone":telefone,
      "tmpAlmoco":tmpAlmoco,
      "usuario":usuario,
      "vlrHora":vlrHora,
      "idTipoProfissional":idTipoProfissional,
    };
  }

  factory ProfissionalModel.clean() {
    return ProfissionalModel(nome: '', email: '',);
  }
}
