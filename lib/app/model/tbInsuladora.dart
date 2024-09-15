class InsuladoraModel {
  String idInsuladora;
  String tipo;
  double usEmpresa;
  double usProfissional;

  InsuladoraModel({
    this.idInsuladora = '',
    this.tipo = '',
    this.usEmpresa = 0,
    this.usProfissional = 0,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "idInsuladora": idInsuladora,
      "tipo": tipo,
      "usEmpresa": usEmpresa,
      "usProfissional": usProfissional,
    };
    return map;
  }

  factory InsuladoraModel.fromMap(Map<dynamic, dynamic>? dados) {
    return InsuladoraModel(
      idInsuladora: dados?['idInsuladora'] ?? '',
      tipo: dados?['tipo'] ?? '',
      usEmpresa: dados?['usEmpresa'] ?? 0,
      usProfissional: dados?['usProfissional'] ?? 0,
    );
  }

  factory InsuladoraModel.clean() {
    return InsuladoraModel(idInsuladora: '', tipo: '',);
  }
}
