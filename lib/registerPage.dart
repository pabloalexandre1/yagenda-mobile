import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatelessWidget {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();

  RegisterPage({super.key});

  //define method to show alerts
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

  //definig controllers to catch and manage the inputs
  
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    //super.dispose();
  }

  void registerAccount(BuildContext context) async {
    // seting variables to the request
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    var body = jsonEncode({
      'name': name,
      'email': email,
      'password': password,
    });
    try {
      var response = await http.post(
        Uri.parse('http://192.168.1.102:4000/user/register'),
        body: body,
        headers: {'Content-Type': 'application/json'},
      );
      // if request goes successful

      var jsonResponse = json.decode(response.body);
      String msg = jsonResponse['msg'];
      String message = "Já pode Realizar seu login";

      if(msg == "error"){
        message = jsonResponse["error"];
      }
      
      showAlertDialog(context, msg, message);
      
      
      //showAlertDialog(context, response.body, "Conteúdo do Alerta");
    } catch (e) {
      //if request fails
      print(e);
    }
  }
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Column(children: [
        Container(
          child: Image.asset(
            'assets/images/yawlogo.jpg',
            width: 140
          ),
          margin: EdgeInsets.only(top: 60.0)
        ),
        Container(
          child: Text(
            'Bem vindo! realize seu cadastro abaixo!',
            style: TextStyle(
              fontSize: 20,
              color: Color(0xffbea562),
            ),
                
          ),
          margin: EdgeInsets.only(bottom: 50, top: 18),
        ),
        Container(
              child : TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  //filled: true, // Define que o fundo será preenchido
                  //fillColor: Colors.grey[200], // Define a cor de fundo
                  labelText: "NOME",
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
                controller: _emailController,
                decoration: InputDecoration(
                  //filled: true, // Define que o fundo será preenchido
                  //fillColor: Colors.grey[200], // Define a cor de fundo
                  labelText: "EMAIL",
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
                    registerAccount(context);
                    
                  },
                  child: Text("Register"),
                )
              )
        ),

        
      ],)
      ),
    );
  }
}