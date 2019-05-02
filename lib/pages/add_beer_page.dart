import 'package:flutter/material.dart';
import 'package:goedale_management/models/beer_models.dart';
import 'package:goedale_management/services/untappd.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:goedale_management/pages/untappd_beer_detail_page.dart';

class AddBeerPage extends StatefulWidget {
  @override
  _AddBeerPageState createState() => _AddBeerPageState();
}

class _AddBeerPageState extends State<AddBeerPage> {
  Future<List<Item>> _beerSearchItemsList;

  Future<List<Item>> _getBeerSearchItemsByString(String searchString) {
    return UntappdService().findBeersMatching(searchString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Untappd bier toevoegen'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Zoek naar een bier..",
                fillColor: Colors.black,
                filled: true,
              ),
              onFieldSubmitted: (String item) {
                this.setState(() {
                  _beerSearchItemsList = _getBeerSearchItemsByString(item);
                });
              },
            ),
          ),
          Divider(
            height: 10.0,
            color: Colors.white,
          ),
          FutureBuilder(
            future: _beerSearchItemsList,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container();
              } else {
                return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        // stateless widget maken
                        return Column(
                          children: <Widget>[
                            ListTile(
                              isThreeLine: true,
                              leading: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    snapshot.data[index].beer.label.iconUrl),
                              ),
                              title: Text(snapshot.data[index].beer.name),
                              subtitle: Text(
                                  snapshot.data[index].beer.style.name +
                                      " - " +
                                      snapshot.data[index].beer.abv.toString() +
                                      "% - " +
                                      snapshot.data[index].brewery.name),
                              onTap: () {
                                Navigator.push(
                                    context,
                                     MaterialPageRoute(
                                        builder: (context) => UntappdBeerDetailPage(
                                            snapshot.data[index].beer)));
                              },
                            ),
                            Divider(
                              height: 10.0,
                              color: Colors.white,
                            ),
                          ],
                        );
                      }),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
