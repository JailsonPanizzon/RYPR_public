import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rypr/bloc/login.dart';
import 'package:rypr/models/cliente.dart';
import 'package:sweetalert/sweetalert.dart';
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
    SweetAlert.show(_localcontext,
        title: "Salvando",
        subtitle: "Adicionando o cliente a  sua lista",
        style: SweetAlertStyle.loading, onPress: (bool isConfirm) {
      return true;
    });
    FirebaseUser user =
        await BlocProvider.getBloc<LoginBloc>().firebaseAuth.currentUser();
    cliente.idOwner = user.uid;
    Firestore.instance
        .collection('cliente')
        .document()
        .setData(cliente.toJson())
        .then((value) {
      SweetAlert.show(_localcontext,
          title: "Sucesso",
          subtitle: "Cliente adicionado a sua lista",
          style: SweetAlertStyle.success, onPress: (bool isConfirm) {
        return true;
      });
    }).catchError((a) {
      SweetAlert.show(_localcontext,
          title: "Erro",
          subtitle: "Erro ao adicionar o cliente a sua lista",
          style: SweetAlertStyle.error, onPress: (bool isConfirm) {
        return true;
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
