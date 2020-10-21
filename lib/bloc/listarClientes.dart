import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rypr/models/cliente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rypr/bloc/login.dart';
import 'package:sweetalert/sweetalert.dart';

class ListarClientesBloc implements BlocBase {
  ListarClientesBloc() {
    _initBloc();
  }
  //BuildContext _localcontext;

  StreamController<List<Cliente>> _clientes =
      new StreamController<List<Cliente>>();
  Stream<QuerySnapshot> value;
  List<Cliente> _listClient;
  Stream get listaClientes => _clientes.stream;
  void _initBloc() async {}

  Stream<QuerySnapshot> getClientes(BuildContext context) {
    FirebaseUser user = BlocProvider.getBloc<LoginBloc>().user;

    return Firestore.instance
        .collection('cliente')
        .where("idOwner", isEqualTo: user.uid)
        .snapshots();
  }

  convert(List<DocumentSnapshot> doc) {
    return mapToList(doc);
  }

  //Convert map to cliente list
  List mapToList(List<DocumentSnapshot> docList) {
    List<Cliente> clienteList = [];
    docList.forEach((document) {
      Map<String, dynamic> cliente = document.data;
      if (cliente != null) {
        Cliente newCliente = Cliente.fromMap(cliente);
        newCliente.idDoc = document.documentID;
        clienteList.add(newCliente);
      }
    });
    _listClient = clienteList;
    return clienteList;
  }

  deleteSelecteds(List<bool> selectedList, BuildContext context) {
    SweetAlert.show(context,
        title: "Confirmar",
        subtitle:
            "Tem certeza que desaja excluir ${selectedList.length} clientes da sua lista",
        style: SweetAlertStyle.confirm,
        showCancelButton: true,
        cancelButtonText: "Cancelar",
        confirmButtonText: "Excluir", onPress: (bool isConfirm) {
      if (isConfirm) {
        _deleteList(selectedList);
      }
      return true;
    });
  }

  _deleteList(List<bool> selectedList) {
    int i = 0;
    selectedList.forEach((element) {
      if (element) {
        Firestore.instance
            .collection('cliente')
            .document(_listClient[i].idDoc)
            .delete()
            .catchError((e) {
          print(e);
        });
      }
      i += 1;
    });
  }

  @override
  void dispose() {
    _clientes.close();
  }

  @override
  void addListener(listener) {}

  @override
  bool get hasListeners => null;

  @override
  void notifyListeners() {}

  @override
  void removeListener(listener) {}
}
