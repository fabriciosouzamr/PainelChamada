import 'package:cli28painelchamada/Classes/Declaracao.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cli28painelchamada/Model/Empresa.dart';
import 'dart:core';

class Empresa_Api {
  static Future<Empresa> getEmpresa(int empresa) async {
    Empresa retjson = new Empresa();
    Empresa ret = new Empresa();

    try {
      String url =
      Declaracao.api_address('empresas');
      var response = await http.get(Uri.parse(url),
          headers: {
            "Accept": "application/json",
            "Access-Control_Allow_Origin": "*"
          });

      if (response.statusCode == 200) {
        List mapResponse = json.decode(response.body);

        for (Map mapa in mapResponse) {
          retjson = Empresa.fromJson(mapa);

          if (retjson.idEmpresa == empresa) {
            ret = retjson;
            break;
          }
        }
      }
    } on Exception catch (e) {
      print(e);
    }

    if (ret.noEmpresa == null) {
      return new Empresa();
    } else {
      return ret;
    }
  }
}
