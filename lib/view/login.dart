import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rypr/bloc/login.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  MaskTextInputFormatter _numberMaskFormatter = new MaskTextInputFormatter(
      mask: '(##) # ####-####', filter: {"#": RegExp(r'[0-9]')});
  TextEditingController _numberController = new TextEditingController();
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
                  validator: _validator,
                  controller: _numberController,
                  inputFormatters: [_numberMaskFormatter],
                  decoration: InputDecoration(labelText: "Telefone"),
                  keyboardType: TextInputType.number,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: size.height * 0.1),
                child: RaisedButton(
                  child: Text("Login"),
                  onPressed: () {
                    if (_validator(_numberController.text) == null) {
                      _login();
                    }
                    {
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
    return value.length < 15 ? "Número inválido" : null;
  }

  void _login() {
    LoginBloc bloc = BlocProvider.getBloc<LoginBloc>();

    bloc.sendPhoneNumber(_numberController.text, context);
  }
}
