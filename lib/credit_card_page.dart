import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projetoint_all/paymentpage.dart';
import 'package:projetoint_all/widget/button_widget.dart';
import 'firebase_options.dart';
import 'variables.dart' as globalVars;

import 'main.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(CreditCardPage());
}

class CreditCardPage extends StatelessWidget {
  CreditCardPage({Key? key, required this.placa, required this.doc, required this.valorFinal}) : super(key: key);

  String placa;
  String doc;
  int valorFinal;

  final Future<FirebaseApp> _fbApp = Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCnIlwUAq_j3oRpAodah_EsZPF5ZJxT9eg",
          authDomain: "learn4real-ea66e.firebaseapp.com",
          projectId: "learn4real-ea66e",
          storageBucket: "learn4real-ea66e.appspot.com",
          messagingSenderId: "749916163342",
          appId: "1:749916163342:web:1edfe88bbac107c1d25b5f"
      )
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zona Azul Pagamento',
      home: FutureBuilder(
          future: _fbApp,
          builder: (context, snapshot){
            if(snapshot.hasError){
              print('Error: ${snapshot.error.toString()}');
              return Text("Something Went wrong!");
            } else if(snapshot.hasData){
              return CreditCardHome(placa: placa, doc: doc, valorFinal: valorFinal);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }
      ),
    );
  }
}

class CreditCardHome extends StatefulWidget {
  CreditCardHome({Key? key, required this.placa, required this.doc, required this.valorFinal}) : super(key: key);

  String placa;
  String doc;
  int valorFinal;


  @override
  _CreditCardPageState createState() => _CreditCardPageState(placa, doc, valorFinal);

}

class _CreditCardPageState extends State<CreditCardHome> {

  String cardNumber = '';
  String expiryDate= '';
  String nomeCartao = '';
  String cvvCode= '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String placa;
  String doc;
  int valorFinal;

  _CreditCardPageState(this.placa, this.doc, this.valorFinal);

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
                              Payment();
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

  Future<void> Payment() async{
    var data = {
      "placa": placa,
      "cardNumber": cardNumber,
      "validade": expiryDate,
      "holder": nomeCartao,
      "cvv": cvvCode,
      "doc": doc
    };

    final result = await FirebaseFunctions
        .instanceFor(region: "southamerica-east1")
        .httpsCallable("payment")
        .call(data);

    setState(() {
      var _result = result.data["message"];

      print(_result);

      if (_result == "Sucesso") {
        print("Success");

        Navigator.push(
            context,

            // TODO: Trocar TicketPage para o nome da pagina escrito
            MaterialPageRoute(builder: (context) => PaymentPage())
        );
      } else {
        print("Falhei");
      }
    });
  }
}