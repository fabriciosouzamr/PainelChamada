import 'package:cli28painelchamada/Classes/Declaracao.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cli28painelchamada/Model/UltimaSenhaGerada.dart';
import 'dart:core';

class UltimaSenhaGerada_Api {
  static Future<String> getUltimaSenhaGerada(int empresa) async {
    UltimaSenhaGerada retjson = new UltimaSenhaGerada();
    UltimaSenhaGerada ret = new UltimaSenhaGerada();

    try {
      String url =
          Declaracao.api_address('VW_CLINICA_SENHA_ULTIMA_SENHA_GERADA_HOJE');
      ///var response = await http.get(Uri.parse(url), headers: <String, String>{'Content-Type': 'application/json'});
      var response = await http.get(Uri.parse(url),headers: {"Accept":"application/json"});

      if (response.statusCode == 200) {
        List mapResponse = json.decode(response.body);

        for (Map mapa in mapResponse) {
          retjson = UltimaSenhaGerada.fromJson(mapa);

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
      return '';
    } else {
      return ret.nrClinicaSenha.toString();
    }
  }
}
