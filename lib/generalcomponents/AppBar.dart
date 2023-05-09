import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

AppBar getAppBar(context, {bool firstPages = false}) {
  List<Widget> nonFirst = [];
  if (!firstPages) {
    nonFirst.add(SizedBox(
      width: MediaQuery.of(context).size.width * 0.2,
    ));
    nonFirst.add(GestureDetector(
      // can also use EdgeInsets.zero                  child: Text(

      child: Icon(
        Icons.logout,
        color: Colors.black,
      ),
      onTap: () {
        print("Clicking");
        Navigator.popUntil(context, (route) => route.isFirst);
      },
    ));
  }

  return AppBar(
      iconTheme: IconThemeData(
        color: Colors.black, // <-- SEE HERE
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Color.fromARGB(255, 253, 164, 59),
          ],
        )),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/Logo.png',
            height: 50,
            width: MediaQuery.of(context).size.width * 0.2,
          ),
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              'MangaLink',
              style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                color: Colors.black,
              )),
            ),
          ),
          ...nonFirst
        ],
      ));
}
