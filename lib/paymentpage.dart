import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'credit_card_page.dart';
import 'gerar_qr_code.dart';
import 'main.dart';
import 'widget/button_widget.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class PaymentPage extends StatelessWidget {
  static final String title = 'TextFormField';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    theme: ThemeData(primaryColor: Colors.red),
    home: PaymentHome(title: title),
  );
}

class PaymentHome extends StatefulWidget {
  final String title;

  const PaymentHome({
    required this.title,
  });

  @override
  _PaymentHomeState createState() => _PaymentHomeState();
}

class _PaymentHomeState extends State<PaymentHome> {
  final formKey = GlobalKey<FormState>();
  String placa = '';
  String doc = '';
  String valor = '';

  List<String> items = ['1h - R\$2,10', '2h - \$4,20'];
  String selecteditems = '1h - R\$2,10';

  //void setValorFinal () {
  //  if (valor == '1h - R\$2,10') {
  //    setState(() {
//      valorFinal = 1;
//   });
  //  } else {
  //    setState(() {
//      valorFinal = 2;
//    });
//  }
  //}

  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color.fromARGB(255, 44, 83, 100), Color.fromARGB(255, 32, 58, 67), Color.fromARGB(255, 15, 32, 39)])),
    child: Scaffold(
      backgroundColor: Colors.transparent,
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
              child: BackButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => MyApp())
                    );
                  },
                ),
            ),
            buildPlaca(),
            const SizedBox(height: 16),
            buildDOC(),
            const SizedBox(height: 32),
            Center(
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)
                  )
                ),
                value: selecteditems,
                items: items
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(fontSize: 24),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selecteditems = newValue!;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
              child: BtnGradient(
                width: 200,
                onPressed: () {
                  final isValid = formKey.currentState!.validate();
                  if (isValid) {
                    formKey.currentState!.save();

                    final message = 'placa: $placa\ndoc: $doc';
                    final snackBar = SnackBar(
                      content: Text(
                        message,
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => QrCodePage())
                    );

                  }
                },
                borderRadius: BorderRadius.circular(30),
                child: const Text(
                  'PAGAR COM PIX',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
              child: BtnGradient(
                width: 200,
                onPressed: () {
                  final isValid = formKey.currentState!.validate();
                  if (isValid) {
                    formKey.currentState!.save();

                    final message = 'placa: $placa\ndoc: $doc';
                    final snackBar = SnackBar(
                      content: Text(
                        message,
                        style: TextStyle(fontSize: 10),
                      ),
                      backgroundColor: Colors.green,
                    );
                    int valorFinal = int.parse(selecteditems[0]);
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => CreditCardPage(placa : placa, doc : doc, valorFinal : valorFinal))
                    );
                  }
                },
                borderRadius: BorderRadius.circular(30),
                child: const Text(
                  'PAGAR COM CARTÃO',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );



  Widget buildPlaca() => TextFormField(
    onChanged: (text){
      placa = text;
    },
    decoration: const InputDecoration(
      labelText: 'Placa',
      labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      border: OutlineInputBorder(),
    ),
    validator: (value) {
      final pattern = r'(^[a-zA-Z]{3}[0-9]{1}[a-zA-Z 0-9]{1}[0-9]{2}$)';
      final regExp = RegExp(pattern);
      if (value!.length < 7) {
        return 'Informe a placa do veiculo';
      } else if (!regExp.hasMatch(value)){
        return 'Informe uma placa valida';
      }
      else {
        return null;
      }
    },
    maxLength: 07,
    onSaved: (value) => setState(() => placa = value!),
  );

  Widget buildDOC() => TextFormField(
    onChanged: (text){
      doc = text;
    },
    decoration: InputDecoration(
      labelText: 'CPF',
      labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      border: OutlineInputBorder(),
    ),
    validator: (value) {
      if (value!.isEmpty) {
        return 'Informe o seu CPF';
      } else if(value.length<11){
        return 'Informe um CPF válido';
      } else {
        return null;
      }
    },
    maxLength: 11,
    onSaved: (value) => setState(() => doc = value!),
  );





}
