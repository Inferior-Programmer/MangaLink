import 'package:flutter/material.dart';
import 'model/callerfunctions.dart';
import 'dart:convert';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'ReadPage.dart';
import 'generalcomponents/AppBar.dart';
import 'generalcomponents/DialogShowers.dart';
import 'ReviewSpecPage.dart';

String predictorQuery = '''
query(\$username: String!, \$anime: String){
  prediction(username: \$username, anime: \$anime)
}
''';

class MangaSummary extends StatefulWidget {
  MangaSummary(
      {super.key,
      required this.id,
      required this.title,
      required this.description,
      required this.coverArt,
      required this.tags,
      required this.userData});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  String id;
  String title;
  String description;
  String coverArt;
  String tags;
  dynamic userData;
  @override
  State<MangaSummary> createState() => _MangaSummaryState();
}

class _MangaSummaryState extends State<MangaSummary> {
  bool loaded = false;
  List<Widget> chapterNames = [];
  String predictedVals = "-1";
  List<Widget> tags = [
    Text(
      "Tags: ",
      style: TextStyle(
        color: Colors.deepPurple[900],
        fontSize: 16,
      ),
    )
  ];
  List<dynamic> chapters = [];
  @override
  void initState() {
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
      Map<String, dynamic> variables = {
        "username": widget.userData['user']['username'],
        "anime": widget.id
      };
      await graphqlQuery(predictorQuery, variables).then((result) async {
        if (result['data'] != null && result['data']['prediction'] != null) {
          predictedVals = result['data']['prediction'];
        }
      });
      await fetchChapters(widget.id, offset: 0, limit: 100).then((val) async {
        List<dynamic> data = jsonDecode(val.body)['data'];
        dynamic lastchapter = -1;
        dynamic lastvolume = -1;
        for (var i in data) {
          String userId = "";
          if (i['attributes']['externalUrl'] != null) {
            continue;
          }
          if (lastvolume != i['attributes']['volume'] ||
              lastchapter != i['attributes']['chapter']) {
            chapters.add({
              'id': i['id'],
              'title': i['attributes']['title'],
              'chapter': i['attributes']['chapter'],
              'volume': i['attributes']['volume'],
            });
            lastchapter = i['attributes']['chapter'];
            lastvolume = i['attributes']['volume'];
          }
        }
      });
      await fetchChapters(widget.id, offset: 100, limit: 100).then((val) async {
        List<dynamic> data = jsonDecode(val.body)['data'];
        dynamic lastchapter = -1;
        dynamic lastvolume = -1;
        for (var i in data) {
          String userId = "";
          if (i['attributes']['externalUrl'] != null) {
            continue;
          }
          if (lastvolume != i['attributes']['volume'] ||
              lastchapter != i['attributes']['chapter']) {
            chapters.add({
              'id': i['id'],
              'title': i['attributes']['title'],
              'chapter': i['attributes']['chapter'],
              'volume': i['attributes']['volume'],
            });
            lastchapter = i['attributes']['chapter'];
            lastvolume = i['attributes']['volume'];
          }
        }
      });
      int countingCounter = 0;
      for (var i in chapters) {
        String wholeString = "";
        if (i['volume'] != null) {
          wholeString += "Volume: " + i['volume'].toString() + " ";
        }
        if (i['chapter'] != null) {
          wholeString += "Chapter: " + i['chapter'].toString() + " ";
        }
        if (i['title'] != null) {
          wholeString += " " + i['title'].toString() + " ";
        }
        int copies = countingCounter;
        chapterNames.add(GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Read(
                            chapters: chapters,
                            initialIndex: copies,
                          )));
            },
            child: Text(wholeString,
                style: TextStyle(color: Colors.black, fontSize: 16))));
        countingCounter += 1;
      }
      setState(() {
        loaded = true;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.white,
              const Color(0xFFFDA43B),
            ],
          )),
          child: Center(
              child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(
                Colors.blue), //choose your own color
          )));
    }
    return Scaffold(
        appBar: getAppBar(context),
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.white,
                const Color(0xFFFDA43B),
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
                              right:
                                  MediaQuery.of(context).size.width * 0.025)),
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
                              children: [...tags],
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
                            const SizedBox(
                              height: 5,
                            ),
                            Flexible(
                                child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                'Predicted User Rating: ' +
                                    predictedVals.substring(
                                        0, min(4, predictedVals.length)),
                                style: GoogleFonts.lexend(
                                    textStyle: const TextStyle(
                                  color: Colors.black,
                                )),
                              ),
                            )),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: double
                                  .infinity, // Set the width to fill all available horizontal space
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.deepPurple[
                                          900]), // Set the background color
                                ),
                                onPressed: () {
                                  if (chapterNames.length == 0) {
                                    showDialogs(
                                        context,
                                        "No Available Chapters",
                                        "Manga has no available chapters");
                                    return;
                                  }
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Read(
                                                chapters: chapters,
                                                initialIndex: 0,
                                              )));
                                },
                                child: Text('Read',
                                    style: GoogleFonts.lexend(
                                        textStyle: const TextStyle(
                                      fontSize: 20,
                                    ))),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: double
                                  .infinity, // Set the width to fill all available horizontal space
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.orange[
                                          900]), // Set the background color
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PageReview(
                                                id: widget.id,
                                                description: widget.description,
                                                title: widget.title,
                                                coverArt: widget.coverArt,
                                                tags: widget.tags,
                                                userData: widget.userData,
                                              )));
                                },
                                child: Text('Reviews',
                                    style: GoogleFonts.lexend(
                                        textStyle: const TextStyle(
                                      fontSize: 20,
                                    ))),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: FractionallySizedBox(
                    widthFactor: 0.95, // Set width as 90% of parent's width
                    heightFactor: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 240, 239, 240),
                        border: Border.all(
                          color: Colors.black, // Sets border color to red
                          width: 2.0, // Sets border width to 2.0 pixels
                        ),
                      ),
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: chapterNames,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }
}
