// @dart=2.9
//

import 'dart:ui';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:cli28painelchamada/Repositorio/GerarSenha_API.dart';
import 'package:cli28painelchamada/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'Model/UltimaSenhaChamada.dart';
import 'Repositorio/Empresa_API.dart';
import 'Repositorio/Imagem00.dart';
import 'Repositorio/UltimaSenhaChamada_API.dart';
import 'Repositorio/UltimaSenhaGerada_API.dart';
import 'dart:async';
import 'dart:typed_data';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.iDEmpresa, this.bluetoothPrint, this.device}) : super(key: key);

  final int iDEmpresa;
  final BlueThermalPrinter bluetoothPrint;
  final BluetoothDevice device;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String ultimaSenhaGerada = '';
  String ultimaSenhaChamada = '0';
  String ultimaSenhaChamada_Caixa = ' ';
  String ultimaSenhaChamada_Localizacao = ' ';
  String dsMensagemImpressaoSenha = '';

  String _now;
  Timer _everySecond;

  @override
  void initState() {
    super.initState();

    functionEmpresa(widget.iDEmpresa);

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
        functionUltimaSenhaGerada(widget.iDEmpresa);
        functionUltimaSenhaChamada(widget.iDEmpresa);
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
                      botaoGerarSenha(widget.iDEmpresa);
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

    if (widget.bluetoothPrint != null)
    {
      bool isConnected=await widget.bluetoothPrint.isConnected;

      if (isConnected != true)
        {
          widget.bluetoothPrint.connect(widget.device);
        }

      isConnected=await widget.bluetoothPrint.isConnected;

      if (isConnected == true)
      {
        if (int.parse(ultimaSenhaGeradaPrint) < 100)
          {
            if (int.parse(ultimaSenhaGeradaPrint) < 10)
            {
              ultimaSenhaGeradaPrint= "00" + ultimaSenhaGeradaPrint;
            }
            else
              {
                ultimaSenhaGeradaPrint= "0" + ultimaSenhaGeradaPrint;
              }
          }

        ByteData imgLogoTipo = await rootBundle.load('assets/images/LogoApp.png');
        ByteData imgSenha = await rootBundle.load('assets/images/Senha.png');
        ByteData imgSenhaNumero = await rootBundle.load('assets/images/img' + ultimaSenhaGeradaPrint + '.jpg');

        widget.bluetoothPrint.isConnected.then((isConnected) {
          if (isConnected) {
            widget.bluetoothPrint.printImageBytes(imgLogoTipo.buffer.asUint8List(imgLogoTipo.offsetInBytes, imgLogoTipo.lengthInBytes));
            widget.bluetoothPrint.printImageBytes(imgSenha.buffer.asUint8List(imgSenha.offsetInBytes, imgSenha.lengthInBytes));
            widget.bluetoothPrint.printNewLine();
            widget.bluetoothPrint.printImageBytes(imgSenhaNumero.buffer.asUint8List(imgSenhaNumero.offsetInBytes, imgSenhaNumero.lengthInBytes));
            //widget.bluetoothPrint.printCustom('Senha', 3, 1);
            //widget.bluetoothPrint.printCustom(ultimaSenhaGeradaPrint, 3, 1);
            widget.bluetoothPrint.printNewLine();
            widget.bluetoothPrint.printLeftRight('Data: ' + functionDataAtual(), "", 1, format: "%-15s %15s %n");
            widget.bluetoothPrint.printLeftRight('Unidade: ' + (widget.iDEmpresa == 2 ? 'Praca' : 'Avenida'), "", 1, format: "%-15s %15s %n");
            widget.bluetoothPrint.printNewLine();
            if (dsMensagemImpressaoSenha.trim() != "")
              widget.bluetoothPrint.printCustom(dsMensagemImpressaoSenha, 1, 1, charset: "iso-8859-1");
            //widget.bluetoothPrint.printQRcode("Insert Your Own Text to Generate", 200, 200, 1);
            widget.bluetoothPrint.printNewLine();
            widget.bluetoothPrint.printNewLine();
            widget.bluetoothPrint.printNewLine();
            widget.bluetoothPrint.paperCut();
          }
        });
      }
    }

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

    if (_Empresa.dsMensagemImpressaoSenha != null)
    {
      dsMensagemImpressaoSenha = _Empresa.dsMensagemImpressaoSenha;
    }
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