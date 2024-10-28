import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:windowpane/main.dart';
import '../models/image.dart';
import '../database/db.dart' as db;

class GridPage extends StatefulWidget {
  const GridPage({super.key});

  @override
  State<GridPage> createState() => _GridPageState();
}

class _GridPageState extends State<GridPage> {
  var _query = db.queryImages();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _onSearch,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _query,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final images = snapshot.data as List<ImageModel>;


                return GridView.count(
                  padding: const EdgeInsets.all(8),
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    for (final image in images)
        
                      TextButton(
                          onPressed: () => Navigator.of(context)
                              .pushNamed('/image_info', arguments: image),
                         style:  TextButton.styleFrom(foregroundColor: Colors.grey[500]),
                          child: Column(
                              children: [
                                Image.memory(image.image, width: 105, height: 111,),
                                Text(image.title),
                                Text(
                                  isTwentyFourClock ? DateFormat('HH:mm MMMM d, y').format(DateTime.parse(image.date)) :  DateFormat('hh:mm MMMM d, y').format(DateTime.parse(image.date)), 
                                ),     
                              ], 
                            ),
                      )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _onSearch(String text) {
    setState(() {
      _query = db.queryImages(title: text);
    });
  }
}
