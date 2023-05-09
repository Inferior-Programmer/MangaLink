// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'model/callerfunctions.dart';
import 'generalcomponents/AppBar.dart';

String query4 = '''

query(\$username: String!, \$anime: String!, \$rating: Int!, \$text: String!, \$title: String!, \$seriesName: String!){
  posted(username: \$username, anime: \$anime, rating: \$rating, text: \$text, title: \$title, seriesName: \$seriesName){
    success
  }
}
''';

class MakeReview extends StatefulWidget {
  MakeReview(
      {super.key,
      required this.seriesTitle,
      required this.startingTitle,
      required this.startingDescription,
      required this.seriesId,
      required this.userData,
      required this.startingRating});

  String seriesTitle;
  String startingTitle;
  String startingDescription;
  String seriesId;
  dynamic userData;
  String startingRating;

  @override
  State<MakeReview> createState() => _MakeReviewState();
}

const List<String> rating = <String>[
  '1',
  '2',
  '3',
  '4',
  '5',
];

class _MakeReviewState extends State<MakeReview> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String ratevals = rating.first;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.startingTitle;
    _descriptionController.text = widget.startingDescription;
    ratevals = widget.startingRating;
    setState(() {});
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context),
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
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 14,
                  ),
                  Text(
                    'Review',
                    style: GoogleFonts.lexend(
                        textStyle: const TextStyle(
                      fontSize: 30,
                    )),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 17,
                  ),
                  Text(
                    'Series: ' + widget.seriesTitle,
                    style: GoogleFonts.lexend(
                        textStyle: const TextStyle(
                      fontSize: 13,
                    )),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 55,
                width: MediaQuery.of(context).size.width - 30,
                child: TextField(
                  controller: _titleController,
                  autofocus: false,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Title',
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width - 30,
                  child: TextFormField(
                    controller: _descriptionController,
                    keyboardType: TextInputType.multiline,
                    textAlign: TextAlign.justify,
                    maxLines: 10,
                    autofocus: false,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        labelText: 'Comments'),
                  )),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 17,
                  ),
                  Text(
                    'Rating',
                    style: GoogleFonts.lexend(
                        textStyle: const TextStyle(
                      fontSize: 13,
                    )),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 230,
                    child: DropdownButtonFormField<String>(
                      value: ratevals,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepOrange),
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                          enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.deepOrange))),
                      onChanged: (String? value) {
                        setState(() {
                          ratevals = value!;
                        });
                      },
                      items:
                          rating.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width - 30,
                child: ElevatedButton(
                  onPressed: () {
                    if (_titleController.text.length > 25) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(' '),
                            content: Text('Title Too Long!'),
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
                      return;
                    }
                    Map<String, dynamic> variables = {
                      'username': widget.userData['user']['username'],
                      'anime': widget.seriesId,
                      'rating': int.parse(ratevals),
                      'title': _titleController.text,
                      'text': _descriptionController.text,
                      'seriesName': widget.seriesTitle,
                    };

                    graphqlQuery(query4, variables).then((result) {
                      if (result['data']['posted']['success']) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(' '),
                              content: Text('Review Submission Success!'),
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
                              title: Text(' '),
                              content: Text('Review Submission Failed!'),
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
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.orange)),
                  child: Text(
                    'Review',
                    style: GoogleFonts.lexend(
                        textStyle: const TextStyle(
                      fontSize: 36,
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
