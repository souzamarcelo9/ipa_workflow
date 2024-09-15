class FormamModel {
  String id;
  String cidade;
  String dtModf;
  String email;
  String empresa;
  String endereco;
  String estado;
  String nome;
  String obs;
  String pais;
  String telefone;
  String usuario;

  FormamModel({
    this.id = '',
    this.cidade = '',
    this.dtModf = '',
    this.email = '',
    this.empresa = '',
    this.endereco = '',
    this.estado = '',
    this.nome = '',
    this.obs = '',
    this.pais = '',
    this.telefone = '',
    this.usuario = '',
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "cidade": cidade,
      "dtModf": dtModf,
      "email": email,
      "empresa": empresa,
      "endereco": endereco,
      "estado": estado,
      "nome": nome,
      "obs": obs,
      "pais": pais,
      "telefone": telefone,
      "usuario": usuario,
    };
    return map;
  }

  factory FormamModel.fromMap(Map<dynamic, dynamic>? dados,String ? id) {
    return FormamModel(
      id: id ?? '' ,
      cidade: dados?['cidade'] ?? '',
      dtModf: dados?['dtModf'] ?? '',
      email: dados?['email'] ?? '',
      empresa: dados?['empresa'] ?? '',
      endereco: dados?['endereco'] ?? '',
      estado: dados?['estado'] ?? '',
      nome: dados?['nome'] ?? '',
      obs: dados?['obs'] ?? '',
      pais: dados?['pais'] ?? '',
      telefone: dados?['telefone'] ?? '',
      usuario: dados?['usuario'] ?? '',
    );
  }

  factory FormamModel.fromJson(Map<String, dynamic> json) {
    return FormamModel(
      cidade: json['cidade'],
      dtModf: json['dtFim'],
      email: json['email'],
      empresa: json['empresa'],
      endereco: json['endereco'],
      estado: json['estado'],
      nome: json['nome'],
      obs: json['obs'],
      pais: json['pais'],
      telefone: json['telefone'],
      usuario: json['usuario'],
    );
  }

  Map<String, Object?> toJson() {
    return {
      'cidade': cidade,
      'dtModf': dtModf,
      "email": email,
      "empresa": empresa,
      "endereco": endereco,
      "estado": estado,
      "nome": nome,
      "obs": obs,
      "obs": obs,
      "pais": pais,
      "telefone": telefone,
      "usuario": usuario,

    };
  }

  factory FormamModel.clean() {
    return FormamModel(nome: '', email: '',);
  }
}
