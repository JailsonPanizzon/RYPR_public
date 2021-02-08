import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:Hypr/models/cliente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Hypr/bloc/login.dart';
import 'package:Hypr/widget/customalert.dart';

class ListarClientesBloc implements BlocBase {
  ListarClientesBloc() {
    _initBloc();
  }
  BuildContext _localcontext;

  StreamController<List<Cliente>> _clientes =
      new StreamController<List<Cliente>>();
  Stream<QuerySnapshot> value;
  Stream get listaClientes => _clientes.stream;
  void _initBloc() async {}

  int filtro = 0;

  Stream<QuerySnapshot> getClientes(BuildContext context) {
    FirebaseUser user = BlocProvider.getBloc<LoginBloc>().user;

    switch (filtro) {
      case 1: //por sexo
        return Firestore.instance
            .collection('cliente')
            .where("idOwner", isEqualTo: user.uid)
            .where("sexo", isEqualTo: "Masculino")
            .snapshots();
        break;
      case 2: //por sexo
        return Firestore.instance
            .collection('cliente')
            .where("idOwner", isEqualTo: user.uid)
            .where("sexo", isEqualTo: "Feminino")
            .snapshots();
        break;
      case 3: //por sexo
        return Firestore.instance
            .collection('cliente')
            .where("idOwner", isEqualTo: user.uid)
            .where("sexo", isEqualTo: "Outro")
            .snapshots();
        break;
      case 4: //por faixa etária
        return Firestore.instance
            .collection('cliente')
            .where("idOwner", isEqualTo: user.uid)
            .where("faixaEtaria", isEqualTo: "Até 25 anos")
            .snapshots();
        break;
      case 5: //por faixa etária
        return Firestore.instance
            .collection('cliente')
            .where("idOwner", isEqualTo: user.uid)
            .where("faixaEtaria", isEqualTo: "25 anos à 45 anos")
            .snapshots();
        break;
      case 6: //por faixa etária
        return Firestore.instance
            .collection('cliente')
            .where("idOwner", isEqualTo: user.uid)
            .where("faixaEtaria", isEqualTo: "45 anos ou mais")
            .snapshots();
        break;
      case 7: //por sexo e faixa etária Até 25 anos
        return Firestore.instance
            .collection('cliente')
            .where("idOwner", isEqualTo: user.uid)
            .where("sexo", isEqualTo: "Masculino")
            .where("faixaEtaria", isEqualTo: "Até 25 anos")
            .snapshots();
        break;
      case 8: //por sexo e faixa etária Até 25 anos
        return Firestore.instance
            .collection('cliente')
            .where("idOwner", isEqualTo: user.uid)
            .where("sexo", isEqualTo: "Feminino")
            .where("faixaEtaria", isEqualTo: "Até 25 anos")
            .snapshots();
        break;
      case 9: //por sexo e faixa etária Até 25 anos
        return Firestore.instance
            .collection('cliente')
            .where("idOwner", isEqualTo: user.uid)
            .where("sexo", isEqualTo: "Outro")
            .where("faixaEtaria", isEqualTo: "Até 25 anos")
            .snapshots();
        break;
      case 10: //por sexo e faixa etária 25 anos à 45 anos
        return Firestore.instance
            .collection('cliente')
            .where("idOwner", isEqualTo: user.uid)
            .where("sexo", isEqualTo: "Masculino")
            .where("faixaEtaria", isEqualTo: "25 anos à 45 anos")
            .snapshots();
        break;
      case 11: //por sexo e faixa etária 25 anos à 45 anos
        return Firestore.instance
            .collection('cliente')
            .where("idOwner", isEqualTo: user.uid)
            .where("sexo", isEqualTo: "Feminino")
            .where("faixaEtaria", isEqualTo: "25 anos à 45 anos")
            .snapshots();
        break;
      case 12: //por sexo e faixa etária 25 anos à 45 anos
        return Firestore.instance
            .collection('cliente')
            .where("idOwner", isEqualTo: user.uid)
            .where("sexo", isEqualTo: "Outro")
            .where("faixaEtaria", isEqualTo: "25 anos à 45 anos")
            .snapshots();
        break;
      case 13: //por sexo e faixa etária 45 anos ou mais
        return Firestore.instance
            .collection('cliente')
            .where("idOwner", isEqualTo: user.uid)
            .where("sexo", isEqualTo: "Masculino")
            .where("faixaEtaria", isEqualTo: "45 anos ou mais")
            .snapshots();
        break;
      case 14: //por sexo e faixa etária 45 anos ou mais
        return Firestore.instance
            .collection('cliente')
            .where("idOwner", isEqualTo: user.uid)
            .where("sexo", isEqualTo: "Feminino")
            .where("faixaEtaria", isEqualTo: "45 anos ou mais")
            .snapshots();
        break;
      case 15: //por sexo e faixa etária 45 anos ou mais
        return Firestore.instance
            .collection('cliente')
            .where("idOwner", isEqualTo: user.uid)
            .where("sexo", isEqualTo: "Outro")
            .where("faixaEtaria", isEqualTo: "45 anos ou mais")
            .snapshots();
        break;
      default:
        return Firestore.instance
            .collection('cliente')
            .where("idOwner", isEqualTo: user.uid)
            .snapshots();
    }
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
    return clienteList;
  }

  deleteSelecteds(List<Cliente> selectedList, BuildContext context) {
    _localcontext = context;
    customAlert(context,
        title: "Confirmar",
        subtitle:
            "Tem certeza que deseja excluir ${selectedList.length > 1 ? selectedList.length.toString() + "clientes" : selectedList[0].nome} da sua lista",
        style: "confirm",
        showCancelButton: true,
        cancelButtonText: "Cancelar",
        confirmButtonText: "Excluir", onPress: (bool isConfirm) {
      if (isConfirm) {
        Navigator.pop(_localcontext);

        _deleteList(selectedList);
      }
      return true;
    });
  }

  _deleteList(List<Cliente> selectedList) {
    selectedList.forEach((element) {
      Firestore.instance
          .collection('cliente')
          .document(element.idDoc)
          .delete()
          .catchError((e) {
        print(e);
      });
    });
    Navigator.pop(_localcontext);
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
