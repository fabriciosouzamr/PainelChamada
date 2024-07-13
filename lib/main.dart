import 'dart:convert';

import 'package:cli28painelchamada/Repositorio/GerarSenha_API.dart';
import 'package:cli28painelchamada/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'Model/UltimaSenhaChamada.dart';
import 'Repositorio/Empresa_API.dart';
import 'Repositorio/UltimaSenhaChamada_API.dart';
import 'Repositorio/UltimaSenhaGerada_API.dart';
import 'dart:async';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';

// @dart=2.9

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key, this.iDEmpresa, this.bluetoothPrint}) : super(key: key);

  final int? iDEmpresa;
  final BluetoothPrint? bluetoothPrint;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String ultimaSenhaGerada = '';
  String ultimaSenhaChamada = '0';
  String ultimaSenhaChamada_Caixa = ' ';
  String ultimaSenhaChamada_Localizacao = ' ';
  String dsMensagemImpressaoSenha = '';

  late String _now;
  late Timer _everySecond;

  @override
  void initState() {
    super.initState();

    functionEmpresa(widget.iDEmpresa!);

    // sets first value
    _now = DateTime
        .now()
        .second
        .toString();

    // defines a timer
    _everySecond = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        _now = DateTime
            .now()
            .second
            .toString();
        functionUltimaSenhaGerada(widget.iDEmpresa!);
        functionUltimaSenhaChamada(widget.iDEmpresa!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Clínica 28 de Julho - Sistema de Chamadas - V.1.00 - ' +
              (widget.iDEmpresa == 2 ? 'Praça' : 'Avenida')),
          backgroundColor: Colors.orange,
        ),
        backgroundColor: Colors.white,
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/img.png',
                    width: 200,
                  ),
                  const SizedBox(height: 100),
                  TextButton(
                      onPressed: botaoSair,
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.all(10)),
                      child: const Text('Sair'))
                ],
              ),
            ),
            const SizedBox(width: 50),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Seja Bem Vindo(A)!!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 50),
                const Text(
                  'DATA',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                Container(
                  width: 300,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text(
                    functionDataAtual(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'ÚLTIMA SENHA GERADA',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  width: 300,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text(
                    ultimaSenhaGerada,
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'ÚLTIMA SENHA CHAMADA',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  width: 300,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                  ),
                  child: Text(
                    ultimaSenhaChamada,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  width: 300,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                  ),
                  child: Text(
                    'Origem da Chamada: ' + ultimaSenhaChamada_Caixa +
                        '. Localizado no ' + ultimaSenhaChamada_Localizacao,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 50),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      botaoGerarSenha(widget.iDEmpresa!);
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.all(25)),
                    child: const Text(
                      'Gerar Senha',
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ))
              ],
            )
          ])
        ]));
  }

  Future<bool> botaoGerarSenha(int empresa) async {
    bool ret = await GerarSenha_Api.postGerarSenha(empresa);
    String ultimaSenhaGeradaPrint;

    setState(() {
      functionUltimaSenhaGerada(empresa);
    });

    ultimaSenhaGeradaPrint = (ultimaSenhaGerada.trim() == '' ? '1' : (int.parse(ultimaSenhaGerada) + 1).toString());

    Map<String, dynamic> config = Map();
    List<LineText> list = [];

    ByteData data = await rootBundle.load('assets/images/img.png');
    List<int> imageBytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    String base64Image = base64Encode(imageBytes);

    list.add(LineText(type: LineText.TYPE_IMAGE, content: base64Image, align: LineText.ALIGN_CENTER, linefeed: 1));

    list.add(LineText(type: LineText.TYPE_TEXT, content: ' ', weight: 2, align: LineText.ALIGN_LEFT,linefeed: 1));
    list.add(LineText(type: LineText.TYPE_TEXT, content: 'Data: ' + functionDataAtual(), weight: 5, align: LineText.ALIGN_LEFT,linefeed: 1));
    list.add(LineText(type: LineText.TYPE_TEXT, content: 'Senha: ' + ultimaSenhaGeradaPrint, weight: 5, align: LineText.ALIGN_LEFT,linefeed: 1));
    list.add(LineText(type: LineText.TYPE_TEXT, content: 'Unidade: ' + (widget.iDEmpresa == 2 ? 'Praca' : 'Avenida'), weight: 5, align: LineText.ALIGN_LEFT,linefeed: 1));
    list.add(LineText(type: LineText.TYPE_TEXT, content: ' ', weight: 2, align: LineText.ALIGN_LEFT,linefeed: 1));
    list.add(LineText(type: LineText.TYPE_TEXT, content: ' Mensagem: ' + dsMensagemImpressaoSenha, weight: 2, align: LineText.ALIGN_LEFT,linefeed: 1));
    list.add(LineText(linefeed: 1));

    await widget.bluetoothPrint!.printReceipt(config, list);

    return ret;
  }

  void botaoSair() {
    exit(0);
  }

  String functionDataAtual() {
    var now = new DateTime.now();

    return now.day.toString().padLeft(2, '0') +
        '/' +
        now.month.toString().padLeft(2, '0') +
        '/' +
        now.year.toString();
  }

  void functionUltimaSenhaGerada(int empresa) async {
    var _ultimaSenhaGerada =
    await UltimaSenhaGerada_Api.getUltimaSenhaGerada(empresa);

    ultimaSenhaGerada = _ultimaSenhaGerada;
  }

  void functionEmpresa(int empresa) async {
    var _Empresa =
    await Empresa_Api.getEmpresa(empresa);

    dsMensagemImpressaoSenha = _Empresa.dsMensagemImpressaoSenha!;
  }

  void functionUltimaSenhaChamada(int empresa) async {
    UltimaSenhaChamada _ultimaSenhaChamada =
    await UltimaSenhaChamada_Api.getUltimaSenhaChamada(empresa);

    ultimaSenhaChamada = '';
    ultimaSenhaChamada_Caixa = '';
    ultimaSenhaChamada_Localizacao = '';

    if (_ultimaSenhaChamada != []) {
      if (_ultimaSenhaChamada.nrClinicaSenha != null) {
        ultimaSenhaChamada = _ultimaSenhaChamada.nrClinicaSenha.toString();
        ultimaSenhaChamada_Caixa = _ultimaSenhaChamada.noCaixaAtendimento.toString();
        ultimaSenhaChamada_Localizacao = _ultimaSenhaChamada.dsLolizacao.toString();
      }
    }
  }
}