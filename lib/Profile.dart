import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'model/callerfunctions.dart';
import 'MakeReview.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'generalcomponents/ReviewList.dart';
import 'generalcomponents/AppBar.dart';

class Profile extends StatefulWidget {
  Profile(
      {super.key,
      required this.userData,
      required this.frozen,
      required this.lookAt});
  dynamic userData;
  bool frozen;
  String lookAt;
  @override
  State<Profile> createState() => _ProfileState();
}

String query6 = '''
query(\$username: String!, \$startAt: Int!, \$endAt: Int!){
  postlistuser(username:\$username, startAt: \$startAt, endAt: \$endAt){
    posts{
      anime, 
      text, 
      title,
      rating,
      seriesName
    }
  }
}
''';

String getImageQuery = '''
query(\$username: String!){
  imagestring(username: \$username)
}
''';

String setImageQuery = '''
query(\$username: String!, \$imagestrings: String!){
  setimagestring(username: \$username, imagestrings: \$imagestrings)
}
''';

class _ProfileState extends State<Profile> {
  List<Widget> userPosting = [];

  String base64Image = '';

  void getImage() async {
    Map<String, dynamic> variables = {
      "username":
          (widget.frozen) ? widget.lookAt : widget.userData['user']['username'],
    };
    graphqlQuery(getImageQuery, variables).then((result) {
      base64Image = result['data']['imagestring'];
      setState(() {});
    });
  }

  void getImageAndUpload() async {
    if (widget.frozen) {
      return;
    }
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 256,
        maxWidth: 256,
        imageQuality: 75);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      Map<String, dynamic> variables = {
        "username": widget.userData['user']['username'],
        "imagestrings": base64Encode(bytes)
      };
      graphqlQuery(setImageQuery, variables).then((result) {
        if (result['data']['setimagestring'] != "") {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Submission Success'),
                content: Text('Submission Success'),
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
          getImage();
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Submission Failed'),
                content: Text('Submission Failed'),
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
    }
  }

  void generalFunc(i) {
    if (widget.frozen) {
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MakeReview(
                seriesTitle: i['seriesName'],
                startingDescription: i['text'],
                startingTitle: i['title'],
                seriesId: i['anime'],
                userData: widget.userData,
                startingRating: i['rating'].toString(),
              )),
    ).then((val) {
      if (val == null) {
        userPosting = [];
        Map<String, dynamic> variables = {
          'username': (widget.frozen)
              ? widget.lookAt
              : widget.userData['user']['username'],
          'startAt': 0,
          'endAt': 20,
        };
        getPostList(userPosting, variables, query6, setState, generalFunc,
            'seriesName', ' Series: ', 'postlistuser');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    userPosting = [];
    Map<String, dynamic> variables = {
      'username':
          (widget.frozen) ? widget.lookAt : widget.userData['user']['username'],
      'startAt': 0,
      'endAt': 20,
    };

    getPostList(userPosting, variables, query6, setState, generalFunc,
        'seriesName', ' Series: ', 'postlistuser');
    getImage();
  }

  dynamic images = AssetImage('icons/Kanon.jpg');
  @override
  Widget build(BuildContext context) {
    if (base64Image == '') {
      images = AssetImage('icons/Kanon.jpg');
    } else {
      images = MemoryImage(base64Decode(base64Image));
    }
    Widget scrollviewmain = SingleChildScrollView(
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
            const SizedBox(height: 30),
            Center(
              child: Container(
                height: 175,
                width: 175,
                child: GestureDetector(
                  onTap: () {
                    getImageAndUpload();
                  },
                  child: CircleAvatar(
                    backgroundImage: images,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              widget.userData['user']['username'],
              style: GoogleFonts.lexend(
                  textStyle: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w400,
              )),
            ),
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
      ),
    );
    if (widget.frozen) {
      return Scaffold(
        appBar: getAppBar(context),
        body: scrollviewmain,
      );
    }
    return scrollviewmain;
  }
}
