import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:math';
import '../MangaSummary.dart';
import '../ReviewSpecPage.dart';

class MangaPreview extends StatefulWidget {
  MangaPreview(
      {super.key,
      required this.title,
      required this.totalNumberOfCharacters,
      required this.numberOfCharactersPerLine,
      required this.boxHeight,
      required this.boxWidth,
      required this.coverHeight,
      required this.coverWidth,
      required this.id,
      required this.coverfilename,
      required this.tags,
      required this.description,
      required this.userData,
      required this.types});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  String title;
  int totalNumberOfCharacters;
  int numberOfCharactersPerLine;
  double boxHeight;
  double boxWidth;
  double coverHeight;
  double coverWidth;
  String id;
  String coverfilename;
  String tags;
  String description;
  String types;
  dynamic userData;
  @override
  State<MangaPreview> createState() => _MangaPreviewState();
}

class _MangaPreviewState extends State<MangaPreview> {
  @override
  Widget build(BuildContext context) {
    int sz = widget.title.length;
    String lessenedTitle =
        widget.title.substring(0, min(widget.totalNumberOfCharacters, sz));
    var actualTitle = '';
    for (int i = 0;
        i < lessenedTitle.length;
        i += widget.numberOfCharactersPerLine) {
      actualTitle += lessenedTitle.substring(i,
              min(i + widget.numberOfCharactersPerLine, lessenedTitle.length)) +
          "\n";
    }
    return InkWell(
        onTap: () => {
              if (widget.types == 'Review')
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PageReview(
                              id: widget.id,
                              title: widget.title,
                              tags: widget.tags,
                              description: widget.description,
                              coverArt: 'https://uploads.mangadex.org/covers/' +
                                  widget.id +
                                  '/' +
                                  widget.coverfilename,
                              userData: widget.userData,
                            )),
                  )
                }
              else
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MangaSummary(
                              id: widget.id,
                              title: widget.title,
                              tags: widget.tags,
                              description: widget.description,
                              coverArt: 'https://uploads.mangadex.org/covers/' +
                                  widget.id +
                                  '/' +
                                  widget.coverfilename,
                              userData: widget.userData,
                            )),
                  )
                }
            },
        child: SizedBox(
            height: widget.boxHeight,
            width: widget.boxWidth,
            child: Column(
              children: [
                Container(
                  height: widget.coverHeight,
                  width: widget.coverWidth,
                  margin: EdgeInsets.fromLTRB(2.0, 0.0, 0.0, 0.0),
                  decoration: BoxDecoration(
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(16.0),
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://uploads.mangadex.org/covers/' +
                                  widget.id +
                                  '/' +
                                  widget.coverfilename),
                          fit: BoxFit.cover)),
                ),
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(right: 5),
                    height: 100,
                    child: SingleChildScrollView(
                      child: Text(
                        actualTitle,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }
}
