import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;



void main() {
  final cntrl = Get.put(ControllerLogin());
 runApp(MyApp());

}


class MyApp extends StatelessWidget {

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CALENDARIO LEZIONI',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home:Login(),
    );
  }
}

class Login extends StatelessWidget {


 //final AuthController controller = Get.find();
  @override
  Widget build(BuildContext context) {
   // Map argumentData = Get.arguments ?? Map();
    // print('argomenti login = $argumentData');
    //if (true) { //se sei autenticato
   //   Future.delayed(Duration(seconds: 5), () {
        // cancella la pagina dopo 5 secondi
     //   Navigator.of(context).pop();
      // });
      //return UserPage();
    //} else { //se non sei autenticato
      return LoginPage();
    //}
  }
}

class UserPage extends StatelessWidget {
  final ControllerLogin controller = Get.find();//pagina utente autenticato
  void logout(){
    print ('logout');

  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagina utente autenticato'),
      ) ,
      body: Center(
        child: Column(
          children:<Widget>[
            Text('Benvenuto ${controller.nomeUtente}'),
            MaterialButton(
                onPressed: () =>logout() ,
              color:Colors.green,
              child: const Text(
                "LOGOUT"
              ),
            )
          ]
        ),
      )
    );
  }
}


class LoginPage extends StatelessWidget {//pagina utente non autenticato, quindi LOGIN
  final ControllerLogin controller = Get.find();
  void login() async{
    print('Non sei autenticato, quindi sei alla pagina di login');
    if (controller.nome.text != '' && controller.password.text != '') {
      print(controller.nome.text);
      print(controller.password.text);
      if (await checkLogin()){
        //vai alla pagina userPage
        controller.messaggio ='Credenziali corrette' ;
        print("fdsfds");
      } else {
        controller.messaggio = 'Credenziali sbagliate';
        print("nop");
      }
    }
  }
  Future<bool> checkLogin() async {
    //TODO inserire le credenziali qui e mandarle all'api
    var risposta = false;
    try {
      //var url = Uri.parse('https://settimogiacomo.github.io/json1/credenziali_utenti.json');
      var url = Uri.parse('http://localhost:3005/check-login');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        print(response.body);
        risposta = true;
      }
      else {
        print('errorejson');
      }

    } catch(e) {
      return risposta;
    }

    return risposta;


  }
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login Page'),
        ) ,
        body: Center(
          child: Column(
              children:<Widget>[
                 const Spacer(),
                const Text('Username'),
                TextField(autofocus: true,
                textAlign: TextAlign.center,
                controller: controller.nome,
                ),
                const Spacer(),
                const Text('Password'),
                TextField(autofocus: false,
                textAlign: TextAlign.center,
                controller: controller.password,
                ),
                const Spacer(),
                MaterialButton(
                  onPressed: () =>login() ,
                  color:Colors.green,
                  child: const Text(
                      "LOGIN"
                  ),
                ),
                const Spacer(),
                Text(controller.messaggio),//TODO capire perchè non aggiorna
                const Spacer(),
              ]
          ),
        )
    );
  }
}

class ControllerLogin extends GetxController{
  var nome = TextEditingController();
  var password = TextEditingController();
  var messaggio = '';
  var nomeUtente = "Ciao".obs;
}


