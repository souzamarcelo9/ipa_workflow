class VeiculoModel {
  String id;
  String alocado;
  String ano;
  String dtModf;
  String imgUrlDoc;
  String imgUrlVeiculo;
  String impostos;
  String nome;
  String  nomeDoc;
  String  nomeProfissional;
  String  obs;
  String placa;
  String renavam;
  String rota;
  String  seguradora;
  String  status;
  String  tpCombustivel;
  String  usuario;

  VeiculoModel({
    this.id = '',
    this.alocado = '',
    this.ano = '',
    this.dtModf = '',
    this.imgUrlDoc = '',
    this.imgUrlVeiculo = '',
    this.impostos = '',
    this.nome = '',
    this.nomeDoc = '',
    this.nomeProfissional = '',
    this.obs = '',
    this.placa = '',
    this.renavam = '',
    this.rota = '',
    this.seguradora = '',
    this.status = '',
    this.tpCombustivel = '',
    this.usuario = '',
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "alocado": alocado,
      "ano": ano,
      "dtModf": dtModf,
      "imgUrlDoc": imgUrlDoc,
      "imgUrlVeiculo": imgUrlVeiculo,
      "impostos": impostos,
      "nome": nome,
      "nomeDoc": nomeDoc,
      "nomeProfissional": nomeProfissional,
      "obs": obs,
      "placa": placa,
      "renavam": renavam,
      "rota": rota,
      "seguradora": seguradora,
      "status": status,
      "tpCombustivel": tpCombustivel,
      "usuario": usuario,
    };
    return map;
  }

  factory VeiculoModel.fromMap(Map<dynamic, dynamic>? dados,String ?id) {
    return VeiculoModel(
      id: id ?? '' ,
      alocado: dados?['alocado'] ?? '',
      ano: dados?['ano'] ?? '',
      dtModf: dados?['dtModf'] ?? '',
      imgUrlDoc: dados?['imgUrlDoc'] ?? '',
      imgUrlVeiculo: dados?['imgUrlVeiculo'] ?? '',
      impostos: dados?['impostos'] ?? '',
      nome: dados?['nome'] ?? '',
      nomeDoc: dados?['nomeDoc'] ?? '',
      nomeProfissional: dados?['nomeProfissional'] ?? '',
      obs: dados?['obs'] ?? '',
      placa: dados?['placa'] ?? '',
      renavam: dados?['renavam'] ?? '',
      rota: dados?['rota'] ?? '',
      seguradora: dados?['seguradora'] ?? '',
      status: dados?['status'] ?? '',
      tpCombustivel: dados?['tpCombustivel'] ?? '',
      usuario: dados?['usuario'] ?? '',
    );
  }

  factory VeiculoModel.fromJson(Map<String, dynamic> json) {
    return VeiculoModel(
      alocado: json['alocado'],
      ano: json['ano'],
      dtModf: json['dtModf'],
      imgUrlDoc: json['imgUrlDoc'],
      imgUrlVeiculo: json['imgUrlVeiculo'],
      impostos: json['impostos'],
      nome: json['nome'],
      nomeDoc: json['nomeDoc'],
      nomeProfissional: json['nomeProfissional'],
      obs: json['obs'],
      placa: json['placa'],
      renavam: json['renavam'],
      rota: json['rota'],
      seguradora: json['seguradora'],
      status: json['status'],
      tpCombustivel: json['tpCombustivel'],
      usuario: json['usuario'],
    );
  }

  Map<String, Object?> toJson() {
    return {
      'alocado': alocado,
      'ano': ano,
      "dtModf": dtModf,
      "nomeDoc": nomeDoc,
      "imgUrlDoc": imgUrlDoc,
      "imgUrlVeiculo": imgUrlVeiculo,
      "impostos": impostos,
      "nomeProfissional": nomeProfissional,
      "nome": nome,
      "obs": obs,
      "placa": placa,
      "renavam": renavam,
      "rota": rota,
      "status": status,
      "tpCombustivel": tpCombustivel,
      "seguradora": seguradora,
      "usuario": usuario,

    };
  }

  factory VeiculoModel.clean() {
    return VeiculoModel(nome: '', id: '',);
  }
}