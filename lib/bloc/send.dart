import 'package:bloc_pattern/bloc_pattern.dart';

import 'package:rypr/models/cliente.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

class SendBloc implements BlocBase {
  SendBloc() {
    _initBloc();
  }
  void _initBloc() async {}
  final HttpsCallable callable =
      CloudFunctions.instance.getHttpsCallable(functionName: "sendEmail ");

  sendMsg(
      List<Cliente> clientes, String msg, Map<String, bool> meiosEnvio) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String token = (await user.getIdToken()).toString();
    if (meiosEnvio["email"]) {
      clientes.forEach((cliente) {
        sendEmail(cliente, msg, token);
      });
    }
    if (meiosEnvio["whatsapp"]) {
      clientes.forEach((cliente) {
        sendWhatsApp(cliente, msg, token);
      });
    }
    if (meiosEnvio["sms"]) {
      clientes.forEach((cliente) {
        sendMsgSms(cliente, msg, token);
      });
    }
  }

  sendWhatsApp(Cliente cliente, String msg, String token) async {
    var url =
        'https://us-central1-marketingmicroservice-73941.cloudfunctions.net/sendWhatsApp';

    print(
      "+55" +
          cliente.telefone
              .replaceAll(' ', '')
              .replaceAll('(', "")
              .replaceAll(")", '')
              .replaceAll('-', ''),
    );
    Map<String, dynamic> data = {
      'telefone': "55" +
          cliente.telefone
              .replaceAll(' ', '')
              .replaceAll('(', "")
              .replaceAll(")", '')
              .replaceAll('-', ''),
      'text': msg,
      'nome': cliente.nome
    };
    await http.post(
      url,
      headers: {HttpHeaders.authorizationHeader: token},
      body: data,
    );
  }

  sendMsgSms(Cliente cliente, String msg, String token) async {
    var url =
        'https://us-central1-marketingmicroservice-73941.cloudfunctions.net/sendSms';

    print(
      "+55" +
          cliente.telefone
              .replaceAll(' ', '')
              .replaceAll('(', "")
              .replaceAll(")", '')
              .replaceAll('-', ''),
    );
    Map<String, dynamic> data = {
      'telefone': "55" +
          cliente.telefone
              .replaceAll(' ', '')
              .replaceAll('(', "")
              .replaceAll(")", '')
              .replaceAll('-', ''),
      'text': msg,
      'nome': cliente.nome
    };
    await http.post(
      url,
      headers: {HttpHeaders.authorizationHeader: token},
      body: data,
    );
  }

  sendEmail(Cliente cliente, String msg, String token) async {
    var url =
        'https://us-central1-marketingmicroservice-73941.cloudfunctions.net/sendEmail';

    Map<String, dynamic> data = {
      'email': cliente.email,
      'mensagem': msg,
      'nome': cliente.nome
    };
    var response = await http.post(
      url,
      headers: {HttpHeaders.authorizationHeader: token},
      body: data,
    );
    print(response.body);
  }

  @override
  void dispose() {}

  @override
  void addListener(listener) {}

  @override
  bool get hasListeners => null;

  @override
  void notifyListeners() {}

  @override
  void removeListener(listener) {}
}
