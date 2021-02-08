import 'package:Hypr/view/listarClientes.dart';
import 'package:Hypr/widget/customalert.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:Hypr/bloc/login.dart';
import 'package:Hypr/models/cliente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CadastroClienteBloc implements BlocBase {
  CadastroClienteBloc() {
    _initBloc();
  }
  BuildContext _localcontext;

  void _initBloc() async {}

  Future<void> saveCliente(Cliente cliente, BuildContext context) async {
    _localcontext = context;
    customAlert(_localcontext,
        title: "Salvando",
        subtitle: "Adicionando o cliente a  sua lista",
        style: "loading", onPress: (bool isConfirm) {
      Navigator.pop(context);
    });
    FirebaseUser user =
        await BlocProvider.getBloc<LoginBloc>().firebaseAuth.currentUser();
    cliente.idOwner = user.uid;
    Firestore.instance
        .collection('cliente')
        .document()
        .setData(cliente.toJson())
        .then((value) {
      Navigator.pop(context);
      customAlert(_localcontext,
          title: "Sucesso",
          subtitle: "Cliente adicionado a sua lista",
          style: "success", onPress: (bool isConfirm) {
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ListarClientes()));
      });
    }).catchError((a) {
      Navigator.pop(context);
      customAlert(_localcontext,
          title: "Erro",
          subtitle: "Erro ao adicionar o cliente a sua lista",
          style: "error", onPress: (bool isConfirm) {
        Navigator.pop(context);
      });
    });
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
