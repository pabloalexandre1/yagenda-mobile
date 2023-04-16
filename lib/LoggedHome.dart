// import dependencies
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'myHomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/constants.dart';
import 'dart:convert';
var Constant = new Constants();

//manipulate permanent data
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
final TextEditingController _emailController = TextEditingController();
addServicer(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  var body = jsonEncode({
      'email': _emailController.text,
    });

  var response = await http.post(
    Uri.parse(Constant.apiUrl + '/user/solicitation'),
    body: body,
    headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ' + token.toString(),
    },
  );
  
  var parsedBody = json.decode(response.body);
  print(response.body);

  if(parsedBody["msg"] == "error") {
    showAlertDialog(context, parsedBody["msg"], parsedBody["error"]);
  }
  if(parsedBody["msg"] == "success") {
    showAlertDialog(context, "Sucesso!", "negócio adicionado com sucesso");
  }

}

void saveValue(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

// Recupera um valor de shared_preferences
Future<String?> getValue(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

class LoggedHome extends StatefulWidget {
  const LoggedHome({super.key});
  _LoggedHomeState createState() => _LoggedHomeState();
  
}

class _LoggedHomeState extends State<LoggedHome> {

  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    saveApiInfo();
  }

  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    
    print(token);
    setState(() {
      _isLoggedIn = token != null && token.isNotEmpty;
    });

    //verify if token is valid

    var response = await http.get(
      Uri.parse(Constant.apiUrl + '/verifytoken/' + token.toString()),
      headers: {'Content-Type': 'application/json'},
    );
    
    var jsonResponse = json.decode(response.body);
    
    if(jsonResponse["role"] == "user"){
      _isLoggedIn = true;
    }else{
      _isLoggedIn = false;
    }
    
    
    if (!_isLoggedIn) {
      //showAlertDialog(context, "Erro!", "Esta seção não é válida!");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    }
  }

  //get needed information from the api
  Future<List<dynamic>> fetchServices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var result = await http.get(Uri.parse(Constant.apiUrl + '/user/getservices'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + token.toString(),
      },);
    return json.decode(result.body)["servicers"];
  }

  void saveApiInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print(token.toString());
    var userServices = await http.get(
      Uri.parse(Constant.apiUrl + '/user/getservices'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + token.toString(),
      },
    );
    var parsedServices = json.decode(userServices.body);

    print(userServices.body);
  }

  

  deleteServicer(email, context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print(email);

    var body = jsonEncode({
      'email': email,
    });

    var response = await http.delete(
      Uri.parse(Constant.apiUrl + '/user/servicer'),
      body: body,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + token.toString(),
      },
    );

    var parsedResponse = json.decode(response.body);
    var content = " a";
    if(parsedResponse["msg"] == "success"){
      content = "Negócio deletado com sucesso";
    }else{
      content = parsedResponse["error"];
    }
    await showAlertDialog(context, parsedResponse["msg"] , content);

    setState(() {
      
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        backgroundColor: Color(0xffbea562),
      ),
      body: Column(
          children: [
            Container(
              child: Text(
                "Adicionar Novo Negócio:",
                style: TextStyle(
                  color: Color(0xffbea562),
                  fontSize: 25,
                )
              ),
              margin: EdgeInsets.only(top: 50),
            ),
            Container(
              child : TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  
                  //filled: true, // Define que o fundo será preenchido
                  //fillColor: Colors.grey[200], // Define a cor de fundo
                  labelText: "Email do Negócio:",
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
              margin: EdgeInsets.only(top: 10, bottom: 20,),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 2,
                    color: Color(0xffbea562),
                  ),
                )
              ),
            ),

            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xffbea562),
                  onPrimary: Color(0xff212121),
                  minimumSize: Size(130, 50),
                ),
                onPressed: () {
                  addServicer(context);
                },
                child: Text(
                  "Adicionar",
                ),
              )
            ),
            Container(
              child: Text(
                "Negócios adicionados:",
                style: TextStyle(
                  color: Color(0xffbea562),
                  fontSize: 20,
                ),
                
              ),
              margin: EdgeInsets.only(top: 35),
              
            ),
            
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: fetchServices(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = snapshot.data[index];
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                            child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 2.0, // espessura da borda
                                  color: Color(0xffbea562), // cor da borda
                                ),
                                top: BorderSide(
                                  width: 2.0,
                                  color: Color(0xffbea562),
                                )
                              ),
                              color: Colors.black54,
                              
                            ),
                            child: Column(
                              children: [
                                Center(
                                  child: ListTile(
                                    leading: Icon(Icons.person, color: Color(0xffbea562),),
                                    title: Text(
                                      snapshot.data[index]["name"],
                                      style: TextStyle(color: Color(0xffbea562)),
                                    ),
                                    subtitle: Text(
                                      snapshot.data[index]["email"],
                                      style: TextStyle(color: Color(0xffbea562)),
                                    ),
                                  ),
                                ),
                                
                                
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: ElevatedButton(onPressed: () {}, 
                                        child: Text("Agenda",
                                            style: TextStyle(
                                              color: Color(0xff212121),
                                            )
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xffbea562),
                                        ),
                                        
                                      ),
                                      margin: EdgeInsets.only(left: 10, right: 10),
                                    ),
                                    
                                    Container(
                                      child: ElevatedButton(onPressed: () {
                                        deleteServicer(item["email"], context);
                                      }, 
                                        child: Text("Excluir",
                                            style: TextStyle(
                                              color: Color(0xff212121),
                                            )
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.red,
                                        ),
                                        
                                      ),
                                      margin: EdgeInsets.only(left: 10, right: 10),
                                    ),
                                  ]
                                ),

                                
                                  
                              ],
                            ),
                            
                            margin: EdgeInsets.only(left: 30, right: 30, bottom: 15, top: 15,),
                            padding: EdgeInsets.only(bottom:8,),
                          ),
                        ); 
                         
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            
          ],
        ),
    );
  }
}