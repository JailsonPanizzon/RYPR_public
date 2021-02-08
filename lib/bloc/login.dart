import 'package:Hypr/view/listarClientes.dart';
import 'package:Hypr/widget/customalert.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Hypr/models/cliente.dart';
import 'package:Hypr/view/home.dart';
import 'package:Hypr/view/login.dart';
import 'package:Hypr/view/validarcodigo.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class LoginBloc implements BlocBase {
  LoginBloc() {
    _initBloc();
  }
  FirebaseAuth firebaseAuth;
  String _actualCode;
  AuthCredential _authCredential;
  FirebaseUser user;
  BuildContext _localcontext;
  void _initBloc() async {
    firebaseAuth = FirebaseAuth.instance;
    user = await firebaseAuth.currentUser();
  }

  logOut(BuildContext context) async {
    _localcontext = context;
    firebaseAuth.signOut();
    Navigator.pushAndRemoveUntil(
        _localcontext, MaterialPageRoute(builder: (context) => Login()), (e) {
      return false;
    });
  }

  sincronizarContatos(BuildContext context) async {
    if (await Permission.contacts.request().isGranted) {
      customAlert(context,
          title: "Sincronizando",
          subtitle: "Adicionando contantos",
          style: "loading", onPress: (bool isConfirm) {
        Navigator.pop(context);
      });
      int contErro = 0;
      int contSucess = 0;
      Iterable<Contact> contacts =
          await ContactsService.getContacts(withThumbnails: false);
      List<Cliente> listClientes = [];
      contacts.forEach((contato) {
        listClientes.add(
          Cliente(
              sexo: "",
              faixaEtaria: "",
              idOwner: user.uid,
              endereco: contato.postalAddresses.length > 0
                  ? contato.postalAddresses?.first?.city
                  : "",
              nome: contato?.displayName,
              telefone: contato.phones.length > 0
                  ? contato?.phones?.first?.value
                  : "",
              email: contato.emails.length > 0
                  ? contato?.emails?.first?.value
                  : ""),
        );
      });
      for (var cliente in listClientes) {
        await Firestore.instance
            .collection('cliente')
            .document()
            .setData(cliente.toJson())
            .catchError((e) {
          contErro += 1;
        }).then((e) {
          contSucess += 1;
        });
      }
      Navigator.pop(context);
      customAlert(context,
          title: "Sucesso",
          subtitle: "$contSucess conatatos adicionados, $contErro falharam",
          style: "success", onPress: (bool isConfirm) {
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ListarClientes()));
      });
    }
  }

  Future<FirebaseUser> getUser() async {
    return firebaseAuth.currentUser();
  }

  getStatusAutentication(BuildContext context) async {
    _localcontext = context;
    user = await firebaseAuth.currentUser();
    if (user != null && user.getIdToken() != null) {
      Navigator.pushAndRemoveUntil(
          _localcontext, MaterialPageRoute(builder: (context) => Home()), (e) {
        return false;
      });
    } else {
      Navigator.pushAndRemoveUntil(
          _localcontext, MaterialPageRoute(builder: (context) => Login()), (e) {
        return false;
      });
    }
  }

  sendPhoneNumber(String phone, BuildContext context) {
    phone = phone.replaceAll(' ', '').replaceAll('(', '').replaceAll(')', '')
      ..replaceAll('-', '');
    _localcontext = context;
    phone = "+55" + phone;
    try {
      customAlert(_localcontext,
          title: "Autenticando",
          subtitle: "Verificando número de telefone",
          style: "loading", onPress: (bool isConfirm) {
        Navigator.pop(context);
      });
      firebaseAuth.verifyPhoneNumber(
          phoneNumber: phone,
          timeout: Duration(seconds: 10),
          verificationCompleted: _verificationCompleted,
          verificationFailed: _verificationFailed,
          codeSent: _codeSent,
          codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout);
    } catch (e) {
      onFailAuthentication(
          "Falha ao realizar login, verifique sua conexão com a internet");
    }
  }

  _codeSent(String verificationId, [int forceResendingToken]) async {
    _actualCode = verificationId;
    Navigator.pop(_localcontext);
    customAlert(_localcontext,
        title: "Autenticando",
        subtitle: "Obtendo código de autenticação",
        style: "loading", onPress: (bool isConfirm) {
      Navigator.pop(_localcontext);
    });
  }

  _codeAutoRetrievalTimeout(String verificationId) {
    _actualCode = verificationId;
    Navigator.pop(_localcontext);
    customAlert(_localcontext,
        title: "Sem acesso aos SMS",
        subtitle:
            "Não foi possivel ter acesso automaticamente ao código enviado por SMS, deseja adicionar manualmente?",
        style: "confirm",
        confirmButtonText: "Sim",
        cancelButtonText: "Não",
        showCancelButton: true, onPress: (bool isConfirm) {
      if (isConfirm) {
        Navigator.push(_localcontext,
            MaterialPageRoute(builder: (context) => ValidarCodigo()));
        return false;
      }
      return true;
    });
  }

  _verificationFailed(AuthException authException) {
    String status = '${authException.message}';
    print(authException.message);
    if (authException.message.contains('not authorized'))
      status = 'Ocorreu um erro, tente novamente mais tarde';
    else if (authException.message.contains('Network'))
      status = 'Verifique sua conexão com a internet';
    else
      status = 'Ocorreu um erro, tente novamente mais tarde';
    onFailAuthentication(status);
  }

  _verificationCompleted(AuthCredential auth) {
    _authCredential = auth;

    firebaseAuth.signInWithCredential(_authCredential).then((AuthResult value) {
      if (value.user != null) {
        onAuthenticationSuccessful();
      } else {
        onFailAuthentication('Código expirado ou inválido');
      }
    }).catchError((error) {
      print(error);
      onFailAuthentication('Ocorreu um erro, tente novamente mais tarde');
    });
  }

  void signInWithPhoneNumber(String smsCode, BuildContext context) async {
    _localcontext = context;
    customAlert(_localcontext,
        title: "Autenticando",
        subtitle: "Validando código",
        style: "loading", onPress: (bool isConfirm) {
      Navigator.pop(context);
    });
    _authCredential = PhoneAuthProvider.getCredential(
        verificationId: _actualCode, smsCode: smsCode);
    try {
      firebaseAuth.signInWithCredential(_authCredential).catchError((error) {
        print(error);
        onFailAuthentication('Ocorreu um erro, tente novamente mais tarde');
      }).then((AuthResult onValue) {
        onAuthenticationSuccessful();
      });
    } catch (e) {
      print(e);
      onFailAuthentication('Ocorreu um erro, tente novamente mais tarde');
    }
  }

  onFailAuthentication(String error) {
    Navigator.pop(_localcontext);
    customAlert(_localcontext, title: "Falha", subtitle: error, style: "error",
        onPress: (bool isConfirm) {
      Navigator.pop(_localcontext);
    });
  }

  onAuthenticationSuccessful() async {
    user = await firebaseAuth.currentUser();
    Navigator.pushAndRemoveUntil(
        _localcontext, MaterialPageRoute(builder: (context) => Home()), (e) {
      return false;
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
