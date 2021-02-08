import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:Hypr/bloc/login.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:Hypr/widget/customButton.dart';

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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/fundo.png"), fit: BoxFit.cover),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: size.height * 0.30,
                  left: size.width * 0.1,
                  right: size.width * 0.1),
              child: Column(
                children: [
                  Container(
                    child: TextFormField(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.center,
                      autovalidate: _autoValidate,
                      validator: _validator,
                      controller: _numberController,
                      inputFormatters: [_numberMaskFormatter],
                      decoration: InputDecoration(
                        labelText: "Telefone",
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 2.0),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 2.0),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 2.0),
                        ),
                        errorStyle: TextStyle(color: Colors.white),
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.1),
                    child: CustomButtom(
                      text: "LOGIN",
                      textColor: Colors.white,
                      borderColor: Colors.white,
                      color: Colors.transparent,
                      onPress: () {
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
          ],
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
