import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'LoggedHome.dart';
import 'registerPage.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/constants.dart';
var Constant = new Constants();

// Armazena um valor em shared_preferences
void saveValue(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

// Recupera um valor de shared_preferences
Future<String?> getValue(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

showAlertDialog(BuildContext context, String title, String content) {
    // configura o botão
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () { Navigator.of(context).pop(); },
    );

    // configura o AlertDialog
    AlertDialog alerta = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        okButton,
      ],
    );

    // exibe o dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alerta;
      },
    );
  }

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void executeLogin() async {
    // seting variables to the request
    String email = _emailController.text;
    String password = _passwordController.text;

    var body = jsonEncode({
      'email': email,
      'password': password,
    });
    try {
      var response = await http.post(
        Uri.parse(Constant.apiUrl + '/user/login'),
        body: body,
        headers: {'Content-Type': 'application/json'},
      );
      // if request goes successful

      var jsonResponse = json.decode(response.body);
      String msg = jsonResponse['msg'];
      String message = "Já ";

      if(msg == "error"){
        message = jsonResponse["error"];
        showAlertDialog(context, msg, message);
      }
      if(msg == "success"){
        //showAlertDialog(context, msg, "login realizado com sucesso");
        saveValue('userName', jsonResponse["user"]["name"]);
        saveValue('email', jsonResponse["user"]["email"]);
        saveValue("token", jsonResponse["user"]["token"]);
        
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LoggedHome(),
          ),
        );
      }
      
      //showAlertDialog(context, response.body, "Conteúdo do Alerta");
    } catch (e) {
      //if request fails
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      body: Center(
        
        child: Column(
          children: [
            Container(
              child: Image.asset(
                'assets/images/yawlogo.jpg',
                width: 140
              ),
              margin: EdgeInsets.only(top: 100.0)
            ),
            Container(
              child: Text(
                'Bem Vindo!',
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xffbea562),
                ),
                
              ),
              margin: EdgeInsets.only(bottom: 45, top: 20),
            ),
            
            Container(
              child : TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  //filled: true, // Define que o fundo será preenchido
                  //fillColor: Colors.grey[200], // Define a cor de fundo
                  labelText: "E-mail",
                  labelStyle: TextStyle(
                    color: Color(0xffbea562),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xffbea562),
                    )
                  ),
                  focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xffbea562), // Define a cor da borda inferior quando em foco
                    
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                  
                  ), 
                ),
                cursorColor: Color(0xffbea562),
                style: TextStyle(
                  color: Color(0xffbea562),
                )
                
              ),
              constraints: BoxConstraints(maxWidth: 300),
              color: Colors.black26,
              margin: EdgeInsets.only(bottom: 20)
            ),
            Container(
              child : TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  
                  //filled: true, // Define que o fundo será preenchido
                  //fillColor: Colors.grey[200], // Define a cor de fundo
                  labelText: "Senha",
                  labelStyle: TextStyle(
                    color: Color(0xffbea562),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xffbea562),
                    )
                  ),
                  focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xffbea562), // Define a cor da borda inferior quando em foco
                    
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                  
                  ), 
                ),
                cursorColor: Color(0xffbea562),
                style: TextStyle(
                  color: Color(0xffbea562),
                )
                
              ),
              constraints: BoxConstraints(maxWidth: 300),
              color: Colors.black26
            ),
            Container(
              margin: EdgeInsets.only(top: 25, bottom: 25),
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xffbea562),
                    onPrimary: Color(0xff212121),
                    minimumSize: Size(130, 50),
                  ),
                  onPressed: () {
                    executeLogin();
                  },
                  child: Text("Login"),
                )
              )
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Color(0xff212121),
                  minimumSize: Size(130, 50),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => RegisterPage(),
                    ),
                  );
                },
                child: Text(
                  "Registre-se",
                ),
              )
            ),
            
            
            
            
          ]
          
        ),
      ),
       
    );
  }
}
