import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart';
import 'model/callerfunctions.dart';
import 'generalcomponents/AppBar.dart';

String query = '''
query(\$username: String!, \$password: String!){
  signup(username: \$username, password: \$password){
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

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _LoginState();
}

class _LoginState extends State<Signup> {
  final userController = TextEditingController();
  final passController = TextEditingController();
  final passTwoController = TextEditingController();

  @override
  void dispose() {
    userController.dispose();
    passController.dispose();
    passTwoController.dispose();
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
                    'SIGN UP',
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
                  controller: passController,
                  obscureText: true,
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
                    'Confirm Password',
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
                  controller: passTwoController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                width: 359,
                child: ElevatedButton(
                  onPressed: () {
                    var userText = userController.text;
                    var passOne = passController.text;
                    var passTwo = passTwoController.text;
                    if (passOne == passTwo) {
                      Map<String, dynamic> variables = {
                        'username': userText,
                        'password': passOne
                      };
                      graphqlQuery(query, variables).then((result) {
                        if (result['data']['signup']['success']) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('SignUp Success'),
                                content: Text('Signing Up Success!'),
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
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Username taken"),
                                content: Text('Username is already taken!'),
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
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('SignUp Error'),
                            content: Text("Passwords Don't Match"),
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
                  },
                  child: Text(
                    'SIGN UP',
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
                  InkWell(
                    onTap: () {},
                    child: Text(
                      'Forgot Password?',
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: Text(
                      "Have an account? Login Here",
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
