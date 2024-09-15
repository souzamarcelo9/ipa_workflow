class FerramentaModel {
  String id;
  String codigo;
  String custo;
  String dtCriacao;
  String dtEntrega;
  String dtModf;
  String dtRetorno;
  String marca;
  String modelo;
  String nome;
  String nomeProfissional;
  String obs;
  String profissional;
  String reciboDevolucao;
  String reciboEntrega;
  String usuario;

  FerramentaModel({
    this.id = '',
    this.codigo = '',
    this.custo = '',
    this.dtCriacao = '',
    this.dtEntrega = '',
    this.dtModf = '',
    this.dtRetorno = '',
    this.marca = '',
    this.modelo = '',
    this.nome = '',
    this.nomeProfissional = '',
    this.obs = '',
    this.profissional = '',
    this.reciboDevolucao = '',
    this.reciboEntrega = '',
    this.usuario = '',
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "codigo": codigo,
      "custo": custo,
      "dtCriacao": dtCriacao,
      "dtEntrega": dtEntrega,
      "dtModf": dtModf,
      "dtRetorno": dtRetorno,
      "marca": marca,
      "modelo": modelo,
      "nome": nome,
      "nomeProfissional": nomeProfissional,
      "obs": obs,
      "profissional": profissional,
      "reciboDevolucao": reciboDevolucao,
      "reciboEntrega": reciboEntrega,
      "usuario": usuario,
    };
    return map;
  }

  factory FerramentaModel.fromMap(Map<dynamic, dynamic>? dados,String ?id) {
    return FerramentaModel(
      id: id ?? '' ,
      codigo: dados?['codigo'] ?? '',
      custo: dados?['custo'] ?? '',
      dtCriacao: dados?['dtCriacao'] ?? '',
      dtEntrega: dados?['dtEntrega'] ?? '',
      dtModf: dados?['dtModf'] ?? '',
      dtRetorno: dados?['dtRetorno'] ?? '',
      nome: dados?['nome'] ?? '',
      marca: dados?['marca'] ?? '',
      modelo: dados?['modelo'] ?? '',
      nomeProfissional: dados?['nomeProfissional'] ?? '',
      obs: dados?['obs'] ?? '',
      profissional: dados?['profissional'] ?? '',
      reciboDevolucao: dados?['reciboDevolucao'] ?? '',
      reciboEntrega: dados?['reciboEntrega'] ?? '',
      usuario: dados?['usuario'] ?? '',
    );
  }

  factory FerramentaModel.fromJson(Map<String, dynamic> json) {
    return FerramentaModel(
      codigo: json['codigo'],
      custo: json['custo'],
      dtCriacao: json['dtCriacao'],
      dtEntrega: json['dtEntrega'],
      dtModf: json['dtModf'],
      dtRetorno: json['dtRetorno'],
      nome: json['nome'],
      marca: json['marca'],
      modelo: json['modelo'],
      nomeProfissional: json['nomeProfissional'],
      obs: json['obs'],
      profissional: json['profissional'],
      reciboDevolucao: json['reciboDevolucao'],
      reciboEntrega: json['reciboEntrega'],
      usuario: json['usuario'],
    );
  }

  Map<String, Object?> toJson() {
    return {
      'codigo': codigo,
      'custo': custo,
      "dtCriacao": dtCriacao,
      "dtEntrega": dtEntrega,
      "dtModf": dtModf,
      "dtRetorno": dtRetorno,
      "nome": nome,
      "marca": marca,
      "modelo": modelo,
      "nomeProfissional": nomeProfissional,
      "obs": obs,
      "profissional": profissional,
      "reciboDevolucao": reciboDevolucao,
      "reciboEntrega": reciboEntrega,
      "usuario": usuario,

    };
  }

  factory FerramentaModel.clean() {
    return FerramentaModel(nome: '', id: '',);
  }
}