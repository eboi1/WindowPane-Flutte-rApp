import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:windowpane/main.dart';
import '../models/image.dart';
import '../database/db.dart' as db;

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
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

                return ListView.separated(
                  itemCount: images.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (BuildContext context, int index) {
                    final image = images[index];

                    return ListTile(
                      title: Text(image.title),
                      onTap: () {
                        Navigator.of(context).pushNamed('/image_info', arguments: image);
                      },
                      leading:  Image.memory(image.image),
                      subtitle: Wrap(
                        children: [
                          Text(
                            isTwentyFourClock ? DateFormat('HH:mm MMMM d, y').format(DateTime.parse(image.date)) : DateFormat('hh:mm MMMM d, y').format(DateTime.parse(image.date)), 
                          ),
                        ],
                      ),
                    );
                  },
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