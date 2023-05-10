// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newproject/MangaSummary.dart';
import 'package:newproject/Profile.dart';
import 'model/callerfunctions.dart';
import 'MakeReview.dart';
import 'generalcomponents/AppBar.dart';
import 'generalcomponents/ReviewList.dart';

class PageReview extends StatefulWidget {
  PageReview(
      {super.key,
      required this.id,
      required this.title,
      required this.description,
      required this.coverArt,
      required this.tags,
      required this.userData});

  String id;
  String title;
  String description;
  String coverArt;
  String tags;
  dynamic userData;

  @override
  State<PageReview> createState() => _PageReviewState();
}

String query3 = '''
query(\$anime: String!, \$startAt: Int!, \$endAt: Int!){
  postlist(anime:\$anime, startAt: \$startAt, endAt: \$endAt){
    posts{
      username, 
      text, 
      rating,
      title
    }
  }
}
''';

String possibleQuery = '''
query(\$anime: String!, \$username: String!){
  getuserpost(anime: \$anime, username: \$username){
    post{
      text,
      title,
      rating
    },
    success
  }
}
''';

class _PageReviewState extends State<PageReview> {
  double ratings = 0;
  List<Widget> tags = [
    Text("Tags: ", style: TextStyle(color: Colors.deepPurple[900])),
  ];

  List<Widget> userPosting = [];
  void generalFuncs(i) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Profile(
                userData: widget.userData,
                frozen: true,
                lookAt: i['username'],
              )),
    );
  }

  @override
  void initState() {
    super.initState();
    userPosting = [];
    Map<String, dynamic> variables = {
      'anime': widget.id,
      'startAt': 0,
      'endAt': 20,
    };
    getPostList(userPosting, variables, query3, setState, generalFuncs,
        'username', '  By User: ', "postlist");
    for (String vars in widget.tags.split(",")) {
      tags.add(Text(
        vars,
        style: TextStyle(
          color: Colors.deepPurple[900],
          fontSize: 16,
        ),
      ));
      tags.add(Padding(
          padding: EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 5)));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchStatistics(widget.id).then((result) {
        ratings = result['statistics'][widget.id]['rating']['average'] / 2;
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> numOfStars = [];
    for (int i = 0; i < ratings.round() - 1; i++) {
      numOfStars.add(Icon(
        Icons.star,
        size: 14,
        color: Colors.deepPurple[900],
      ));
    }
    return Scaffold(
      appBar: getAppBar(context),
      body: SingleChildScrollView(
          child: Container(
        height: MediaQuery.of(context).size.height - 100,
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
                padding: EdgeInsets.only(
                    left: 0,
                    bottom: 0,
                    top: MediaQuery.of(context).size.height * 0.01,
                    right: 0)),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 275,
                    width: MediaQuery.of(context).size.width * 0.45,
                    margin: EdgeInsets.fromLTRB(2.0, 0.0, 0.0, 0.0),
                    decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.circular(16.0),
                        image: DecorationImage(
                            image: NetworkImage(widget.coverArt),
                            fit: BoxFit.cover)),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          left: 0,
                          bottom: 0,
                          top: 0,
                          right: MediaQuery.of(context).size.width * 0.025)),
                  Flexible(
                    child: Column(
                      children: [
                        Flexible(
                            child: Text(
                          widget.title,
                          style: GoogleFonts.lexend(
                              textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                        )),
                        Wrap(
                          children: [
                            ...tags,
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.only(right: 5),
                            height: 135,
                            child: SingleChildScrollView(
                              child: Text(
                                widget.description,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: 'Overall Rating: ',
                                      style: GoogleFonts.lexend(
                                          textStyle:
                                              TextStyle(color: Colors.black))),
                                  WidgetSpan(
                                    child: Row(
                                      children: [
                                        ...numOfStars,
                                        Text(ratings.toStringAsFixed(2),
                                            style: GoogleFonts.lexend(
                                                textStyle: TextStyle(
                                                    color: Colors.black)))
                                      ],
                                    ),
                                  )
                                ]),
                              )),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Flexible(
                            child: SizedBox(
                                height: 30,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MangaSummary(
                                                  id: widget.id,
                                                  description:
                                                      widget.description,
                                                  title: widget.title,
                                                  coverArt: widget.coverArt,
                                                  tags: widget.tags,
                                                  userData: widget.userData,
                                                )));
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.orange[900])),
                                  child: Text('Chapters',
                                      style: GoogleFonts.lexend(
                                          textStyle: TextStyle(
                                        fontSize: 20,
                                      ))),
                                ))),
                        const SizedBox(
                          height: 10,
                        ),
                        Flexible(
                            child: SizedBox(
                                height: 30,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    String startingTitle = ' ';
                                    String startingDescription = ' ';
                                    String startingRating = '1';
                                    Map<String, dynamic> variables = {
                                      'username': widget.userData['user']
                                          ['username'],
                                      'anime': widget.id,
                                    };

                                    graphqlQuery(possibleQuery, variables)
                                        .then((result) {
                                      if (result['data']['getuserpost']
                                          ['success']) {
                                        startingTitle = result['data']
                                                    ['getuserpost']['post']
                                                ['title'] ??
                                            ' ';
                                        startingDescription = result['data']
                                                    ['getuserpost']['post']
                                                ['text'] ??
                                            ' ';
                                        startingRating = (result['data']
                                                        ['getuserpost']['post']
                                                    ['rating'] ??
                                                1)
                                            .toString();
                                      }
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MakeReview(
                                                  seriesTitle: widget.title,
                                                  startingDescription:
                                                      startingDescription,
                                                  startingTitle: startingTitle,
                                                  seriesId: widget.id,
                                                  userData: widget.userData,
                                                  startingRating:
                                                      startingRating,
                                                )),
                                      ).then((val) {
                                        print(val);
                                        if (val == null) {
                                          userPosting = [];
                                          Map<String, dynamic> variables = {
                                            'anime': widget.id,
                                            'startAt': 0,
                                            'endAt': 20,
                                          };
                                          getPostList(
                                              userPosting,
                                              variables,
                                              query3,
                                              setState,
                                              (i) {},
                                              'username',
                                              '  By User: ',
                                              "postlist");
                                        }
                                      });
                                    });
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.deepPurple[900])),
                                  child: Text('Review',
                                      style: GoogleFonts.lexend(
                                          textStyle: TextStyle(
                                        fontSize: 20,
                                      ))),
                                ))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Reviews',
                  style: GoogleFonts.lexend(
                      textStyle: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.black)),
                ),
              ),
            ),

            //Pwede gawin function nalang ang hassle pala nito WHAHAHA
            Flexible(
              child: Container(
                margin: EdgeInsets.only(left: 5, right: 5),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 240, 239, 240),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Colors.black,
                    // Sets border color to red
                    // Sets border width to 2.0 pixels
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: userPosting,
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
