import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import '../model/callerfunctions.dart';

void getPostList(userPosting, variables, query, setState, funcs, titleName,
    preAppend, lists) {
  graphqlQuery(query, variables).then((result) {
    if (result['data'][lists] == null ||
        result['data'][lists]['posts'] == null) {
      return;
    }
    for (var i in result['data'][lists]['posts']) {
      List<Widget> colsss = [];
      colsss.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            ' ' + i['title'],
            style: GoogleFonts.lexend(
                textStyle:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          SizedBox(
              height: 25,
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: 'Rating: ' + i['rating'].toString(),
                      style: GoogleFonts.lexend(
                          textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black))),
                ]),
              ))
        ],
      ));
      colsss.add(Align(
        alignment: Alignment.topLeft,
        child: Text(
          preAppend + i[titleName],
          style: GoogleFonts.lexend(
              textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.deepPurple[900],
          )),
        ),
      ));
      colsss.add(Container(
        margin: EdgeInsets.all(7),
        child: Text(
          i['text'],
          textAlign: TextAlign.justify,
        ),
      ));
      userPosting.add(GestureDetector(
          child: Column(children: colsss),
          onTap: () {
            funcs(i);
          }));
    }

    setState(() {});
  });
}
