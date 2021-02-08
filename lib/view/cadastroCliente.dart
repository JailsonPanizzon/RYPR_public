import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:email_validator/email_validator.dart';
import 'package:Hypr/bloc/salvarCliente.dart';
import 'package:Hypr/models/cliente.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:Hypr/widget/customButton.dart';
import 'package:Hypr/widget/myAppBar.dart';
import 'package:Hypr/widget/myBottomNavigator.dart';

class CadastroCliente extends StatefulWidget {
  @override
  _CadastroClienteState createState() => _CadastroClienteState();
}

class _CadastroClienteState extends State<CadastroCliente> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  MaskTextInputFormatter _numberMaskFormatter = new MaskTextInputFormatter(
      mask: '(##) # ####-####', filter: {"#": RegExp(r'[0-9]')});
  TextEditingController _nomeController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _telefoneController = new TextEditingController();
  TextEditingController _enderecoController = new TextEditingController();
  FocusNode _nomeNode = FocusNode();
  FocusNode _emailNode = FocusNode();
  FocusNode _telefoneNode = FocusNode();
  FocusNode _enderecoNode = FocusNode();
  String _sexo = "Masculino";
  String _faixaEtaria;

  CadastroClienteBloc _bloc = BlocProvider.getBloc<CadastroClienteBloc>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _heightField = 90;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: myAppBar(
          context,
          title: "Cadastrar cliente",
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Container(
                    height: _heightField,
                    child: TextFormField(
                      validator: (value) {
                        return value.isEmpty ? "Preencha este campo" : null;
                      },
                      controller: _nomeController,
                      style: TextStyle(color: Colors.black),
                      decoration: new InputDecoration(labelText: "Nome"),
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      focusNode: _nomeNode,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (e) {
                        FocusScope.of(context).requestFocus(_emailNode);
                      },
                    ),
                  ),
                  Container(
                    height: _heightField,
                    child: TextFormField(
                      focusNode: _emailNode,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (e) {
                        FocusScope.of(context).requestFocus(_telefoneNode);
                      },
                      validator: (value) {
                        if (value.isNotEmpty) {
                          return EmailValidator.validate(value)
                              ? null
                              : "Email inválido";
                        }
                        return null;
                      },
                      controller: _emailController,
                      decoration: InputDecoration(labelText: "Email"),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  Container(
                    height: _heightField,
                    child: TextFormField(
                      focusNode: _telefoneNode,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (e) {
                        FocusScope.of(context).requestFocus(_enderecoNode);
                      },
                      validator: (value) {
                        if (value.isNotEmpty) {
                          return value.length < 16 ? "Numero inválido" : null;
                        }
                        return null;
                      },
                      controller: _telefoneController,
                      inputFormatters: [_numberMaskFormatter],
                      decoration: InputDecoration(labelText: "Telefone"),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Container(
                    height: _heightField,
                    child: TextFormField(
                      focusNode: _enderecoNode,
                      controller: _enderecoController,
                      decoration: InputDecoration(labelText: "Endereço"),
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      onFieldSubmitted: (s) {
                        _salvar();
                      },
                    ),
                  ),
                  Container(
                    height: _heightField / 1.5,
                    margin: EdgeInsets.only(bottom: 20),
                    child: new DropdownButtonFormField<String>(
                      value: _sexo,
                      itemHeight: 48,
                      style: Theme.of(context)
                          .inputDecorationTheme
                          .labelStyle
                          .copyWith(fontSize: 16),
                      hint: Text("Sexo"),
                      items: <String>['Masculino', 'Feminino', 'Outro']
                          .map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Container(
                            width: MediaQuery.of(context).size.width - 64,
                            child: Text(value),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _sexo = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    height: _heightField / 1.5,
                    margin: EdgeInsets.only(bottom: 20),
                    child: new DropdownButtonFormField<String>(
                      value: _faixaEtaria,
                      itemHeight: 48,
                      style: Theme.of(context)
                          .inputDecorationTheme
                          .labelStyle
                          .copyWith(fontSize: 16),
                      hint: Text("Faixa etária"),
                      items: <String>[
                        'Até 25 anos',
                        '25 anos à 45 anos',
                        '45 anos ou mais'
                      ].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Container(
                            width: MediaQuery.of(context).size.width - 64,
                            child: Text(value),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _faixaEtaria = value;
                        });
                      },
                    ),
                  ),
                  CustomButtom(
                    text: "Salvar",
                    color: Colors.black,
                    textColor: Colors.white,
                    onPress: () {
                      _salvar();
                    },
                  )
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: MyBottomNavigator(),
      ),
    );
  }

  _salvar() {
    if (_formKey.currentState.validate()) {
      Cliente cliente = Cliente(
          endereco: _enderecoController.text,
          nome: _nomeController.text,
          telefone: _telefoneController.text,
          email: _emailController.text,
          sexo: _sexo,
          faixaEtaria: _faixaEtaria == null ? '' : _faixaEtaria);
      _bloc.saveCliente(cliente, context);
    }
  }
}
