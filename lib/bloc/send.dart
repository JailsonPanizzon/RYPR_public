import 'package:Hypr/widget/customalert.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:Hypr/models/cliente.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Hypr/view/home.dart';

class SendBloc implements BlocBase {
  SendBloc() {
    _initBloc();
  }
  void _initBloc() async {}
  final HttpsCallable callable =
      CloudFunctions.instance.getHttpsCallable(functionName: "sendEmail ");

  sendMsg(List<Cliente> clientes, String msg, Map<String, bool> meiosEnvio,
      BuildContext context) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String token = (await user.getIdToken()).toString();
    customAlert(context,
        title: "Enviando",
        subtitle: "Enviando mensagens",
        style: "loading", onPress: (bool isConfirm) {
      return true;
    });
    if (meiosEnvio["email"]) {
      for (var cliente in clientes) {
        await sendEmail(cliente, msg, token);
      }
    }
    if (meiosEnvio["whatsapp"]) {
      for (var cliente in clientes) {
        await sendWhatsApp(cliente, msg, token);
      }
    }
    if (meiosEnvio["sms"]) {
      for (var cliente in clientes) {
        await sendMsgSms(cliente, msg, token);
      }
    }
    Navigator.pop(context);
    customAlert(context,
        title: "Sucesso",
        subtitle: "Sucesso ao enviar mensagens",
        style: "sucess", onPress: (bool isConfirm) {
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    });
  }

  sendWhatsApp(Cliente cliente, String msg, String token) async {
    var url =
        'https://us-central1-marketingmicroservice-73941.cloudfunctions.net/sendWhatsApp';

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
    await http.post(
      url,
      headers: {HttpHeaders.authorizationHeader: token},
      body: data,
    );
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
