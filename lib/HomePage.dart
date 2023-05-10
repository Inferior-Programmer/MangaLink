import 'dart:convert';
import 'model/callerfunctions.dart';
import 'package:flutter/material.dart';
import 'generalcomponents/MangaPreview.dart';

const double coverHeight = 250;
const double coverWidth = 190;
const double boxHeight = 310;
const double boxWidth = 180;
const int numberOfCharactersPerLine = 25;
const int totalNumberOfCharacters = 100;

class HomePage extends StatefulWidget {
  HomePage(
      {super.key,
      required this.title,
      required this.names,
      required this.order,
      required this.userData});

  String title;
  String names;
  Map<String, String> order;
  dynamic userData;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  var tags = {};
  var loaded = false;

  late TextEditingController _controller;
  var titlesAndId = [];

  void initialCalling(String title) {
    titlesAndId = [];
    setState(() {
      loaded = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchGreatest(widget.order, title: title).then((val) async {
        List<dynamic> data = jsonDecode(val.body)['data'];

        for (var vals in data) {
          titlesAndId.add(
            {
              'id': vals['id'],
              'title': vals['attributes']['title']['en'] ??
                  vals['attributes']['title'].values.toList()[0],
              'description': vals['attributes']['description']['en'] ??
                  vals['attributes']['description'].values.toList()[0] ??
                  ' ',
              'tags': '',
            },
          );

          for (var tagss in vals['attributes']['tags']) {
            titlesAndId[titlesAndId.length - 1]['tags'] +=
                tagss['attributes']['name']['en'] + ",";
          }
          for (var typesss in vals['relationships']) {
            if (typesss['type'] == 'cover_art') {
              await fetchCoverArt(typesss['id']).then((val2) {
                titlesAndId[titlesAndId.length - 1]['coverfilename'] =
                    jsonDecode(val2.body)['data']['attributes']['fileName'];
              });
            }
          }
        }
      });
      setState(() {
        loaded = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    initialCalling('');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.

            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: (titlesAndId.length / 2).floor(),
                itemBuilder: (BuildContext context, int index) {
                  List<Widget> childs = [];

                  if (index * 2 >= titlesAndId.length) {
                    childs.add(Container());
                  } else {
                    childs.add(MangaPreview(
                      key: PageStorageKey(titlesAndId[index * 2]['id'] ?? ' '),
                      title: titlesAndId[index * 2]['title'] ?? ' ',
                      totalNumberOfCharacters: totalNumberOfCharacters,
                      numberOfCharactersPerLine: numberOfCharactersPerLine,
                      boxHeight: boxHeight,
                      boxWidth: boxWidth,
                      coverHeight: coverHeight,
                      coverWidth: coverWidth,
                      id: titlesAndId[index * 2]['id'] ?? ' ',
                      coverfilename:
                          titlesAndId[index * 2]['coverfilename'] ?? ' ',
                      tags: titlesAndId[index * 2]['tags'],
                      description: titlesAndId[index * 2]['description'] ?? ' ',
                      userData: widget.userData,
                      types: widget.names,
                    ));
                  }
                  childs.add(Spacer());
                  if (index * 2 + 1 >= titlesAndId.length) {
                    childs.add(Container());
                  } else {
                    childs.add(
                      MangaPreview(
                        key: PageStorageKey(
                            titlesAndId[index * 2 + 1]['id'] ?? ' '),
                        title: titlesAndId[index * 2 + 1]['title'] ?? ' ',
                        totalNumberOfCharacters: totalNumberOfCharacters,
                        numberOfCharactersPerLine: numberOfCharactersPerLine,
                        boxHeight: boxHeight,
                        boxWidth: boxWidth,
                        coverHeight: coverHeight,
                        coverWidth: coverWidth,
                        id: titlesAndId[index * 2 + 1]['id'] ?? ' ',
                        coverfilename:
                            titlesAndId[index * 2 + 1]['coverfilename'] ?? ' ',
                        tags: titlesAndId[index * 2 + 1]['tags'] ?? ' ',
                        description:
                            titlesAndId[index * 2 + 1]['description'] ?? ' ',
                        userData: widget.userData,
                        types: widget.names,
                      ),
                    );
                  }
                  if (index == 0) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          widget.names,
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 0, bottom: 4, top: 2, right: 2),
                            child: SizedBox(
                              width: 350,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: ColoredBox(
                                    color: Colors.white,
                                    child: TextField(
                                      controller: _controller,
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.search)),
                                      onSubmitted: (String value) {
                                        initialCalling(_controller.text);
                                      },
                                    ),
                                  )),
                            )),
                        Row(
                          children: childs,
                        )
                      ],
                    );
                  }
                  return Row(
                    children: childs,
                  );
                })));
  }
}
