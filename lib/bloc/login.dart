import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rypr/view/home.dart';
import 'package:rypr/view/login.dart';
import 'package:rypr/view/validarcodigo.dart';
import 'package:sweetalert/sweetalert.dart';

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
      SweetAlert.show(_localcontext,
          title: "Autenticando",
          subtitle: "Verificando número de telefone",
          style: SweetAlertStyle.loading, onPress: (bool isConfirm) {
        return true;
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
    SweetAlert.show(_localcontext,
        title: "Autenticando",
        subtitle: "Obtendo código de autenticação",
        style: SweetAlertStyle.loading, onPress: (bool isConfirm) {
      return true;
    });
  }

  _codeAutoRetrievalTimeout(String verificationId) {
    _actualCode = verificationId;
    SweetAlert.show(_localcontext,
        title: "Sem acesso aos SMS",
        subtitle:
            "Não foi possivel ter acesso automaticamente ao código enviado por SMS, deseja adicionar manualmente?",
        style: SweetAlertStyle.confirm,
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
      onFailAuthentication('Ocorreu um erro, tente novamente mais tarde');
    });
  }

  void signInWithPhoneNumber(String smsCode, BuildContext context) async {
    _localcontext = context;
    SweetAlert.show(_localcontext,
        title: "Autenticando",
        subtitle: "Validando código",
        style: SweetAlertStyle.loading, onPress: (bool isConfirm) {
      return true;
    });
    _authCredential = PhoneAuthProvider.getCredential(
        verificationId: _actualCode, smsCode: smsCode);
    firebaseAuth.signInWithCredential(_authCredential).catchError((error) {
      onFailAuthentication('Ocorreu um erro, tente novamente mais tarde');
    }).then((AuthResult onValue) {
      onAuthenticationSuccessful();
    });
  }

  onFailAuthentication(String error) {
    SweetAlert.show(_localcontext,
        title: "Falha",
        subtitle: error,
        style: SweetAlertStyle.error, onPress: (bool isConfirm) {
      return true;
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
