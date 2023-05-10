import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart';
import 'model/callerfunctions.dart';
import 'generalcomponents/AppBar.dart';
import 'generalcomponents/DialogShowers.dart';

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

String isPasswordUserNameValid(String password, String username) {
  if (password == null ||
      username == null ||
      password.isEmpty ||
      username.isEmpty) {
    return "Forms cannot be empty";
  }
  if (password.contains(RegExp(r'[^\w@_]+')) ||
      username.contains(RegExp(r'[^\w@_]+'))) {
    return "Characters may only be alphanumeric or @ or _";
  }
  if (password.length < 5 || password.length > 20) {
    return "Password length has to be between 5 and 20 characters";
  }

  if (username.length < 5 || username.length > 20) {
    return "Username length has to be between 5 and 20 characters";
  }
  return "true";
}

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _LoginState();
}

class _LoginState extends State<Signup> {
  final userController = TextEditingController();
  final passController = TextEditingController();
  final passTwoController = TextEditingController();
  bool passwordVisible = false;
  bool passwordVisible2 = false;
  @override
  void dispose() {
    userController.dispose();
    passController.dispose();
    passTwoController.dispose();
  }

  void signups() {
    var userText = userController.text;
    var passOne = passController.text;
    var passTwo = passTwoController.text;

    if (passOne == passTwo) {
      String checkValidity = isPasswordUserNameValid(passOne, userText);

      if (checkValidity.compareTo("true") != 0) {
        showDialogs(context, "SignUp Error", checkValidity);
        return;
      }
      Map<String, dynamic> variables = {
        'username': userText,
        'password': passOne
      };
      graphqlQuery(query, variables).then((result) {
        if (result['data']['signup']['success']) {
          showDialogs(context, "SignUp Success", 'Signing Up Success!');
        } else {
          showDialogs(context, "SignUp Error", "Username is already taken!");
        }
      });
    } else {
      showDialogs(context, 'SignUp Error', "Passwords Don't Match");
    }
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
                  onSubmitted: (s) {
                    signups();
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
                    signups();
                  },
                  controller: passController,
                  obscureText: !passwordVisible,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                      )),
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
                  onSubmitted: (s) {
                    signups();
                  },
                  controller: passTwoController,
                  obscureText: !passwordVisible2,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        passwordVisible2
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          passwordVisible2 = !passwordVisible2;
                        });
                      },
                    ),
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
                    signups();
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
