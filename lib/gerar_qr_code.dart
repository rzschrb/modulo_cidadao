import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projetoint_all/paymentpage.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:random_string/random_string.dart';
import 'package:clipboard/clipboard.dart';

class QrCodePage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR CODE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GenerateQRPage(),
    );
  }
}

class GenerateQRPage extends StatefulWidget {
  GenerateQRPage({Key? key}) : super(key: key);
  _GenerateQRPageState createState() => _GenerateQRPageState();}

class _GenerateQRPageState extends State<GenerateQRPage> {

  TextEditingController controller = TextEditingController();
  final String data = (randomAlphaNumeric(35));
  String paste = 'data';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(60),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BackButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => PaymentPage())
                  );
                },
              ),
              QrImage(
                data: data,
                size: 300,
                embeddedImage: const AssetImage('images/logo.png'),
                embeddedImageStyle: QrEmbeddedImageStyle(
                    size: const Size(80,80)

                ),
              ),
              Text("Pix copia e cola:"),


              Row(
                children: [

                  Expanded(child: TextFormField
                    (
                    readOnly: true,
                    initialValue: data,

                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(25),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  ),
                  IconButton(

                    icon: const Icon(Icons.content_copy),
                    onPressed: () async {
                      await FlutterClipboard.copy(data);

                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('✓   Copied to Clipboard')
                          ),
                      );
                    },
                  ),
                ],
              ),
            ],

          ),
        ),

      ),
    );
  }

}










