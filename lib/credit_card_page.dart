import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:projetoint_all/paymentpage.dart';
import 'package:projetoint_all/widget/button_widget.dart';
import 'firebase_options.dart';
import 'variables.dart' as globalVars;

Future <void>Payment() async{

  String cardNumber = '';
  String expiryDate= '';
  String nomeCartao = '';
  String cvvCode= '';
  String placa = globalVars.placa;
  String doc = globalVars.doc;
  bool isCvvFocused = false;

  var data = {
    "holder": nomeCartao.toUpperCase(),
    "validade": expiryDate,
    "numeroCartao": cardNumber,
    "cvv": cvvCode,
    "cpf": doc,
    "placa": placa,
  };

  final result = await FirebaseFunctions
      .instanceFor(region: "southamerica-east1")
      .httpsCallable('payment')
      .call(data);
  setState(() {
    _result = result.data["message"];

    if(_result == "Sucesso"){
      Navigator.push(context,
        MaterialPageRoute(builder: builder)
      )
    }
  });

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
              child:
              BackButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => PaymentPage())
                  );
                },
              ),
            ),
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: nomeCartao,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              obscureCardNumber: true,
              obscureCardCvv: true,),
            Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CreditCardForm(cardNumber: cardNumber,
                        expiryDate: expiryDate,
                        cardHolderName: nomeCartao,
                        cvvCode: cvvCode,
                        onCreditCardModelChange: onCreditCardModelChange,
                        themeColor: Colors.black12,
                        formKey: formKey,
                        cardNumberDecoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Numero do cartão',
                            hintText: 'xxxx xxxx xxxx xxxx'
                        ),
                        expiryDateDecoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Vencimento',
                            hintText: 'xx/xx'
                        ),
                        cvvCodeDecoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'CVV',
                            hintText: 'xxx'
                        ),
                        cardHolderDecoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nome no cartão',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                        child: BtnGradient(
                          width: 200,
                          onPressed: () {
                            if(formKey.currentState!.validate()){
                              print(doc);
                              print(placa);
                              print('valido');
                            }
                            else{
                              print('Não valido');
                            }
                          },
                          borderRadius: BorderRadius.circular(30),
                          child: const Text(
                            'Pagar',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel){
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      nomeCartao = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}

