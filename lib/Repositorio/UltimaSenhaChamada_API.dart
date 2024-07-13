import 'package:cli28painelchamada/Classes/Declaracao.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cli28painelchamada/Model/UltimaSenhaChamada.dart';
import 'dart:core';

class UltimaSenhaChamada_Api {
  static Future<UltimaSenhaChamada> getUltimaSenhaChamada(int empresa) async {
    UltimaSenhaChamada retjson = new UltimaSenhaChamada();
    UltimaSenhaChamada ret = new UltimaSenhaChamada();

    try {
      String url =
      Declaracao.api_address('VW_CLINICA_SENHA_ULTIMA_SENHA_CHAMADA_HOJE');
      var response = await http.get(Uri.parse(url),
          headers: {
            "Accept": "application/json",
            "Access-Control_Allow_Origin": "*"
          });

      if (response.statusCode == 200) {
        List mapResponse = json.decode(response.body);

        for (Map mapa in mapResponse) {
          retjson = UltimaSenhaChamada.fromJson(mapa);

          if (retjson.idEmpresa == empresa) {
            ret = retjson;
            break;
          }
        }
      }
    } on Exception catch (e) {
      print(e);
    }

    if (ret.nrClinicaSenha == null) {
      return new UltimaSenhaChamada();
    } else {
      return ret;
    }
  }
}
