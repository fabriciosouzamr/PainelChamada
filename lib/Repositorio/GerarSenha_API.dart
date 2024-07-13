import 'package:cli28painelchamada/Classes/Declaracao.dart';
import 'package:http/http.dart' as http;
import 'dart:core';
import 'dart:async';

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';

class GerarSenha_Api {
  static Future<bool> postGerarSenha(int empresa) async {
    bool ret = false;

    try {
      String url = Declaracao.api_address('ClinicaSenhas') + '?idEmpresa=' + empresa.toString();

      var response = await http.post(Uri.parse(url), headers: <String, String>{'Content-Type': 'application/json'});
      ///var response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        ret = (response.body.toUpperCase().trim() == 'TRUE');
      }
      ;
    } on Exception catch (e) {
      print(e);
    }

    return ret;
  }
}
