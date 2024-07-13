import 'package:flutter/material.dart';
import 'main.dart';
import 'dart:async';

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;

  bool _connected = false;
  BluetoothDevice _device = BluetoothDevice();
  String tips = 'no device connect';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) => initBluetooth());
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initBluetooth() async {
    bluetoothPrint.startScan(timeout: Duration(seconds: 4));

    bool? isConnected=await bluetoothPrint.isConnected;

    bluetoothPrint.state.listen((state) {
      print('cur device status1: $state');

      switch (state) {
        case BluetoothPrint.CONNECTED:
          setState(() {
            _connected = true;
            tips = 'connect success';
          });
          break;
        case BluetoothPrint.DISCONNECTED:
          setState(() {
            _connected = false;
            tips = 'disconnect success';
          });
          break;
        default:
          break;
      }
    });

    if (!mounted) return;

    if(isConnected!) {
      setState(() {
        _connected=true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () { botaoAvenida(context, bluetoothPrint); },
                style: TextButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.all(5)),
                child: const Text(
                  'Avenida',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                )),
            const SizedBox(height: 20),
            TextButton(
                onPressed: () { botaoPraca(context, bluetoothPrint); },
                style: TextButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.all(5)),
                child: const Text(
                  'Praça',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                )),
            RefreshIndicator(
              onRefresh: () => bluetoothPrint.startScan(timeout: Duration(seconds: 4)),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          child: Text(tips),
                        ),
                      ],
                    ),
                    Divider(),
                    StreamBuilder<List<BluetoothDevice>>(
                      stream: bluetoothPrint.scanResults,
                      initialData: [],
                      builder: (c, snapshot) => Column(
                        children: snapshot.data!.map((d) => ListTile(
                          title: Text(d.name??''),
                          onTap: () async {
                            setState(() {
                              _device = d;
                            });
                          },
                          trailing: _device!=null && _device.address == d.address?Icon(
                            Icons.check,
                            color: Colors.green,
                          ):null,
                        )).toList(),
                      ),
                    ),
                    Divider(),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              OutlinedButton(
                                child: Text('connect'),
                                onPressed:  _connected?null:() async {
                                  if(_device!=null && _device.address !=null){
                                    await bluetoothPrint.connect(_device);
                                  }else{
                                    setState(() {
                                      tips = 'please select device';
                                    });
                                    print('please select device');
                                  }
                                },
                              ),
                              SizedBox(width: 10.0),
                              OutlinedButton(
                                child: Text('disconnect'),
                                onPressed:  _connected?() async {
                                  await bluetoothPrint.disconnect();
                                }:null,
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}

Future botaoAvenida(BuildContext context, BluetoothPrint bluetoothPrint) async {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(iDEmpresa: 229818, bluetoothPrint: bluetoothPrint),
      ));
}

Future botaoPraca(BuildContext context, BluetoothPrint bluetoothPrint) async {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(iDEmpresa: 2, bluetoothPrint: bluetoothPrint),
      ));
}
