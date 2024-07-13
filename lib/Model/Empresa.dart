class Empresa {
  int? idEmpresa;
  String? noEmpresa;
  String? dsMensagemImpressaoSenha;

  Empresa({
    this.idEmpresa,
    this.noEmpresa,
    this.dsMensagemImpressaoSenha });

  Empresa.fromJson(Map<dynamic, dynamic> json) {
    idEmpresa = json['iD_EMPRESA'];
    noEmpresa = json['nO_EMPRESA'];
    dsMensagemImpressaoSenha = json['dS_MENSAGEM_IMPRESSAO_SENHA'];
  }
}