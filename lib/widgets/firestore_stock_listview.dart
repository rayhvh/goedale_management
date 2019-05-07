
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goedale_management/models/beer_models.dart';
import 'package:goedale_management/models/beerlisting_model.dart';
import 'package:goedale_management/widgets/starrating_widget.dart';
//import 'package:goedale_client/widgets/quickadd_button.dart';
import 'package:goedale_management/functions/utils.dart';
import 'package:goedale_management/pages/beer_manage_page.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FirestoreStockListview extends StatefulWidget {
  final List<DocumentSnapshot> beersInStock;

  FirestoreStockListview({this.beersInStock});

  @override
  _FirestoreStockListviewState createState() => _FirestoreStockListviewState();
}

class _FirestoreStockListviewState extends State<FirestoreStockListview> {
  final searchController = TextEditingController();
  String filterString = "";

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    searchController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();

    // Start listening to changes
    searchController.addListener(_updateSearchItems);
  }

  _updateSearchItems(){
    this.setState((){
      filterString = searchController.text.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0,0,0,0),
          child: TextFormField(
            controller: searchController,
            decoration: const InputDecoration(
              icon: Icon(Icons.search),
              hintText: 'Filter op naam of style of brouwerij of beschrijving: "Sweet" "Smoke" "Vanilla" ',
              labelText: 'Zoeken',),
            /*   onFieldSubmitted: (String sString) {
                this.setState((){
                  searchString = sString.toLowerCase();
                  print(searchString);
                });
            },*/

          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.beersInStock.length,
            itemBuilder: (BuildContext context, int index) {
              var _listing = BeerListing(
                beer: Beer(
                  id: widget.beersInStock[index].data['id'].toString(),
                  name: widget.beersInStock[index].data['name'].toString(),
                  brewery: widget.beersInStock[index].data['brewery'].toString(),
                  label: BeerLabel(
                      iconUrl: widget.beersInStock[index].data['label']['iconUrl'].toString()),
                  style: BeerStyle(
                      id: null, name: widget.beersInStock[index].data['style'].toString()),
                  abv: widget.beersInStock[index].data['abv'],
                  rating: widget.beersInStock[index].data['rating'],
                    description: widget.beersInStock[index].data['desc'],
                    tasteDescription: widget.beersInStock[index].data['tasteDesc']
                ),
                price: widget.beersInStock[index].data['price'],
                stockAmount: widget.beersInStock[index].data['amount'],
              );

              if (_listing.stockAmount == 0) {
                //  return Text('uitverkocht');
                return Container();
              }
              else if (filterString != '')
              {
                if (_listing.beer.name.toLowerCase().contains(filterString) | _listing.beer.style.name.toLowerCase().contains(filterString) | _listing.beer.brewery.toLowerCase().contains(filterString) | _listing.beer.description.toLowerCase().contains(filterString) | _listing.beer.tasteDescription.toLowerCase().contains(filterString)){
                  return ListTile(
                    title: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: ListTile(
                                isThreeLine: true,
                                leading: CircleAvatar(
                                  backgroundImage:
                                  CachedNetworkImageProvider(_listing.beer.label.iconUrl,),
                                ),
                                title: Text(_listing.beer.name,
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(_listing.beer.brewery),
                                    Text(_listing.beer.abv.toString() + "%"),
                                    Text(_listing.beer.style.name),
                                    //   Text( _listing.beer.rating.toString()),
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              child: Column(
                                children: <Widget>[
                                  StarRating(
                                    rating: toRound(_listing.beer.rating),
                                    color: Colors.white,
                                    borderColor: Colors.white,
                                  ),
                                  Text(_listing.beer.rating.toString()),
                                ],
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Text((_listing.stockAmount > 0) ? _listing.stockAmount.toString() + " x" : "Tap bier"),
                                    Text("€" + _listing.price.toString()),

                                  ],
                                ),
                                /*    Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  onPressed: (){

                                  },
                                  child: Icon(Icons.edit),
                                ),
                              ),
*/
                              ],
                            ),

                          ],
                        ),
                        Divider(
                          height: 15.0,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    onTap:() {
                      Navigator.push(context, new MaterialPageRoute(builder: (context) => BeerManagePage(_listing.beer.id)));
                    },
                  );
                }
                else {
                  return Container();
                }
              }
              else if (filterString == ''){
                return ListTile(
                  title: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: ListTile(
                              isThreeLine: true,
                              leading: CircleAvatar(
                                backgroundImage:
                                CachedNetworkImageProvider(_listing.beer.label.iconUrl,),
                              ),
                              title: Text(_listing.beer.name,
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(_listing.beer.brewery),
                                  Text(_listing.beer.abv.toString() + "%"),
                                  Text(_listing.beer.style.name),
                                  //   Text( _listing.beer.rating.toString()),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            child: Column(
                              children: <Widget>[
                                StarRating(
                                  rating: toRound(_listing.beer.rating),
                                  color: Colors.white,
                                  borderColor: Colors.white,
                                ),
                                Text(_listing.beer.rating.toString()),
                              ],
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text((_listing.stockAmount > 0) ? _listing.stockAmount.toString() + " x" : "Tap bier"),
                                  Text("€" + _listing.price.toString()),

                                ],
                              ),
                          /*    Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  onPressed: (){

                                  },
                                  child: Icon(Icons.edit),
                                ),
                              ),
*/
                            ],
                          ),

                        ],
                      ),
                      Divider(
                        height: 15.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  onTap:() {
                    Navigator.push(context, new MaterialPageRoute(builder: (context) => BeerManagePage(_listing.beer.id)));
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
