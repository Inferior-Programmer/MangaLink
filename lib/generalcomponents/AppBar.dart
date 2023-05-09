import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

AppBar getAppBar(context, {bool firstPages = false}) {
  List<Widget> nonFirst = [];
  if (!firstPages) {
    nonFirst.add(SizedBox(
      width: 10,
    ));
    nonFirst.add(GestureDetector(
      child: Icon(Icons.logout, color: Colors.black),
      onTap: () {
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
            width: 50,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            'MangaLink',
            style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 40,
            )),
          ),
          ...nonFirst
        ],
      ));
}
