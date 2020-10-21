import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rypr/bloc/login.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

class ValidarCodigo extends StatefulWidget {
  @override
  _ValidarCodigoState createState() => _ValidarCodigoState();
}

class _ValidarCodigoState extends State<ValidarCodigo> {
  TextEditingController _smsCodeController = new TextEditingController();
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          margin: EdgeInsets.only(
              top: size.height * 0.30,
              left: size.width * 0.1,
              right: size.width * 0.1),
          child: Column(
            children: [
              Container(
                child: TextFormField(
                  autovalidate: _autoValidate,
                  controller: _smsCodeController,
                  decoration: InputDecoration(labelText: "SMS code"),
                  keyboardType: TextInputType.number,
                  validator: _validator,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: size.height * 0.1),
                child: RaisedButton(
                  child: Text("Enviar"),
                  onPressed: () {
                    if (_validator(_smsCodeController.text) == null) {
                      _validarCodigo();
                    } else {
                      setState(() {
                        _autoValidate = true;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _validator(value) {
    return value.length < 6 ? "Código inválido" : null;
  }

  _validarCodigo() {
    LoginBloc bloc = BlocProvider.getBloc<LoginBloc>();

    bloc.signInWithPhoneNumber(_smsCodeController.text, context);
  }
}
