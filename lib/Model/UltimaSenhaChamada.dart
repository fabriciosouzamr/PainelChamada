class UltimaSenhaChamada {
  int? idEmpresa;
  int? nrClinicaSenha;
  String? noCaixaAtendimento;
  String? dsLolizacao;

  UltimaSenhaChamada({
    this.idEmpresa,
    this.nrClinicaSenha,
    this.noCaixaAtendimento,
    this.dsLolizacao });

  UltimaSenhaChamada.fromJson(Map<dynamic, dynamic> json) {
    idEmpresa = json['iD_EMPRESA'];
    nrClinicaSenha = json['nR_CLINICA_SENHA'];
    noCaixaAtendimento = json['nO_CAIXA_ATENDIMENTO'];
    dsLolizacao = json['dS_LOCALIZACAO'];
  }
}