import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newproject/HomePage.dart';
import 'signup.dart';
import 'model/callerfunctions.dart';
import 'HomeBar.dart';
import 'generalcomponents/AppBar.dart';

const String query = '''
query(\$username: String!, \$password: String!){
  login(username: \$username, password: \$password){
    user{
      ids, 
      username,
      password, 
      data
    }
    success
  }
}
''';
void main() {
  runApp(MyApp());
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final userController = TextEditingController();
  final passController = TextEditingController();
  bool showPassword = false;
  @override
  void dispose() {
    super.dispose();
    userController.dispose();
    passController.dispose();
  }

  void logins() {
    var userText = userController.text;
    var passText = passController.text;
    Map<String, dynamic> variables = {
      'username': userText,
      'password': passText
    };
    graphqlQuery(query, variables).then((result) {
      if (result['data']['login']['success']) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyHomePage(
                      title: 'MangaLink',
                      userData: result['data']['login'],
                    )));
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Failed'),
              content: Text('Login Failed!'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, firstPages: true),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.white,
              Color.fromARGB(255, 253, 164, 59),
            ],
          )),
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    'LOGIN',
                    style: GoogleFonts.lexend(
                        textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                    )),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 35,
                  ),
                  Text(
                    'Username',
                    style: GoogleFonts.lexend(
                        textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    )),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 55,
                width: 359,
                child: TextField(
                  onSubmitted: (s) {
                    logins();
                  },
                  controller: userController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 35,
                  ),
                  Text(
                    'Password',
                    style: GoogleFonts.lexend(
                        textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    )),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 55,
                width: 359,
                child: TextField(
                  onSubmitted: (s) {
                    logins();
                  },
                  controller: passController,
                  obscureText: !showPassword,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                      )),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                width: 359,
                child: ElevatedButton(
                  onPressed: () async {
                    logins();
                  },
                  child: Text(
                    'SIGN IN',
                    style: GoogleFonts.lexend(
                        textStyle: const TextStyle(
                      fontSize: 36,
                    )),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.orange)),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                height: 1,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.orange,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'or',
                style: GoogleFonts.lexend(
                    textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                )),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 35,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 35,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Signup()));
                    },
                    child: Text(
                      "Don't have an account yet? Sign up Here",
                      style: GoogleFonts.lexend(
                          textStyle: const TextStyle(
                        color: Color.fromARGB(255, 62, 114, 191),
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                      )),
                    ),
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Login(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.orange),
      ),
    );
  }
}
