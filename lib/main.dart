import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flixtor App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flixtor App Bar',
          style: TextStyle(fontSize: 30))
        ),
        body: const HomePage(
          title: '',
        )
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;
  @override
  State<HomePage> createState() => _HomePageState();
}


class  _HomePageState extends State<HomePage> {
  var movie = "",desc = "";
  String selectMovie = "Adventure";
  List<String> movielist = [
    "Adventure",
    "Comedy",
    "Fantasy",
    "Crime"
  ];
 @override
  Widget build(BuildContext context) {
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Movie Search",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          DropdownButton(
            itemHeight: 60,
            value: selectMovie,
            onChanged: (newValue) {
              setState(() {
                selectMovie = newValue.toString();
              });
            },
            items: movielist.map((selectMovie) {
              return DropdownMenuItem(
                value: selectMovie,
                child: Text(
                  selectMovie,
                ),
              );
            }).toList(),
          ),
          ElevatedButton(onPressed: _getGenre, child: const Text("Search")),
          Text(desc,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

Future<void> _getGenre() async {
  AlertDialog alert = AlertDialog(
    content: Row(children: [
      CircularProgressIndicator(
        backgroundColor: Colors.yellow,
      ),
      Container(margin: EdgeInsets.only(left: 7), child: Text("Loading..."))
    ]),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
    var apikey = "9cf794ef";
    var url = Uri.parse('https://www.omdbapi.com/?t=$selectMovie&apikey=$apikey');
    var response = await http.get(url);
    var rescode = response.statusCode;
    if (rescode == 200) {
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);
      setState(() {
        var title = parsedJson["Title"];
        var genre = parsedJson["Genre"];
        var year = parsedJson["Year"];
        var descs = parsedJson["Plot"];
        var poster = parsedJson["Poster"];
        Navigator.pop(context);
        desc =
            "Your Search result for $selectMovie is $title \n\nThis movie main genre is $genre and released in $year.\n\n$descs\n\nClick link to view image link\n$poster";
      });
    } else {
      setState(() {
        Navigator.pop(context);
        desc = "No record";
      });
    }
  }
}

