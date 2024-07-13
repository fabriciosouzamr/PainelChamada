class UltimaSenhaGerada {
  int? idEmpresa;
  int? nrClinicaSenha;

  UltimaSenhaGerada({
    this.idEmpresa,
    this.nrClinicaSenha  });

  UltimaSenhaGerada.fromJson(Map<dynamic, dynamic> json) {
    idEmpresa = json['iD_EMPRESA'];
    nrClinicaSenha = json['nR_CLINICA_SENHA'];
  }
}