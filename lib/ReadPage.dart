import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'model/callerfunctions.dart';
import 'generalcomponents/AppBar.dart';

class Read extends StatefulWidget {
  Read({super.key, required this.chapters, required this.initialIndex});

  List<dynamic> chapters;
  int initialIndex;
  @override
  State<Read> createState() => _ReadState();
}

class _ReadState extends State<Read> {
  List<String> chapters = <String>[
    'Chapter 1',
    'Chapter 2',
    'Chapter 3',
    'Chapter 4',
    'Chapter 5',
    'Chapter 6',
  ];
  Map<String, String> pages = {};
  String dropDownvalue1 = 'Page Number:1';
  String dropDownvalue2 = 'Chapter 1';
  List<String> pagesName = <String>[
    'Page Number:1',
    'Page Number:2',
    'Page Number:3',
    'Page Number:4',
    'Page Number:5',
    'Page Number:6',
  ];
  String hash = " ";
  bool loaded = false;
  int selectedPageIndex = 0;
  Map<String, int> nameToIndex = {};
  void loadChapterNew(String chapterId) {
    setState(() {
      loaded = false;
    });
    makeGetRequest(chapterId).then((result) {
      selectedPageIndex = 0;
      int counters = 0;
      pagesName = [];
      pages = {};
      hash = result['chapter']['hash'];
      for (var i in result['chapter']['data']) {
        pagesName.add('Page Number:' + (counters + 1).toString());
        pages['Page Number:' + (counters + 1).toString()] = i;
        counters += 1;
      }
      dropDownvalue1 = pagesName.first;
      setState(() {
        loaded = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    int chapterCounters = 0;
    chapters = [];
    nameToIndex = {};
    for (var i in widget.chapters) {
      chapters.add('Chapter ' + (chapterCounters + 1).toString());
      nameToIndex['Chapter ' + (chapterCounters + 1).toString()] =
          chapterCounters;
      chapterCounters += 1;
    }

    dropDownvalue2 = chapters[widget.initialIndex];

    loadChapterNew(widget.chapters[widget.initialIndex]['id']);
  }

  @override
  Widget build(BuildContext context) {
    Widget toLoading = Center(
        child: Container(
            height: MediaQuery.of(context).size.height * 0.75,
            child: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        Colors.blue), //choose your own color
                  ),
                ))));
    if (loaded) {
      toLoading = InteractiveViewer(
        minScale: 0.1,
        maxScale: 4.0,
        child: Image.network(
            'https://uploads.mangadex.org/data/' +
                hash +
                '/' +
                pages[dropDownvalue1]!,
            width: double.infinity,
            fit: BoxFit.fitHeight),
      );
    }
    return Scaffold(
      appBar: getAppBar(context),
      body: Container(
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.chapters[nameToIndex[dropDownvalue2]!]['title'] ??
                        '0',
                    style: GoogleFonts.lexend(
                        textStyle: const TextStyle(
                      fontSize: 30,
                    )),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              toLoading,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      int index = pagesName.indexOf(dropDownvalue1);
                      index -= 1;

                      if (index <= 0) {
                        index = 0;
                      }
                      dropDownvalue1 = pagesName[index];
                      setState(() {});
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                  IconButton(
                    onPressed: () {
                      int index = pagesName.indexOf(dropDownvalue1);
                      index += 1;

                      if (index >= pagesName.length) {
                        index = pagesName.length - 1;
                      }
                      dropDownvalue1 = pagesName[index];
                      setState(() {});
                    },
                    icon: Icon(Icons.arrow_forward),
                  ),
                ],
              ), // sample langs
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<String>(
                    value: dropDownvalue2,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepOrange),
                    underline: Container(
                      height: 2,
                      color: Colors.deepOrange,
                    ),
                    onChanged: (String? value) {
                      dropDownvalue2 = value!;
                      loadChapterNew(
                          widget.chapters[nameToIndex[dropDownvalue2]!]['id']);
                    },
                    items:
                        chapters.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  DropdownButton<String>(
                    value: dropDownvalue1,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepOrange),
                    underline: Container(
                      height: 2,
                      color: Colors.deepOrange,
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        dropDownvalue1 = value!;
                      });
                    },
                    items:
                        pagesName.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
