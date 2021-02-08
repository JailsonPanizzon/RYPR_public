import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:Hypr/bloc/login.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:Hypr/widget/customButton.dart';

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
                      controller: _smsCodeController,
                      decoration: InputDecoration(
                        labelText: "Código do SMS",
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
                        alignLabelWithHint: true,
                        errorStyle: TextStyle(color: Colors.white),
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      keyboardType: TextInputType.number,
                      validator: _validator,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.1),
                    child: CustomButtom(
                      text: "ENVIAR",
                      textColor: Colors.white,
                      borderColor: Colors.white,
                      color: Colors.transparent,
                      onPress: () {
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
          ],
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
