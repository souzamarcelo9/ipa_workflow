class ProducaoModel {
  String idProducao;
  String drywall;
  int psqt;
  double usEmpresa;
  double usProfissional;

  ProducaoModel({
    this.idProducao = '',
    this.drywall = '',
    this.psqt = 0,
    this.usEmpresa = 0,
    this.usProfissional = 0,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "idProducao": idProducao,
      "drywall": drywall,
      "psqt": psqt,
      "usEmpresa": usEmpresa,
      "usProfissional": usProfissional,
    };
    return map;
  }

  factory ProducaoModel.fromMap(Map<dynamic, dynamic>? dados) {
    return ProducaoModel(
      idProducao: dados?['idProducao'] ?? '',
      drywall: dados?['drywall'] ?? '',
      psqt: dados?['psqt'] ?? 0,
      usEmpresa: dados?['usEmpresa'] ?? 0,
      usProfissional: dados?['usProfissional'] ?? 0,
    );
  }

  factory ProducaoModel.clean() {
    return ProducaoModel(idProducao: '', drywall: '',);
  }
}
