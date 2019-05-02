
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goedale_management/models/beer_models.dart';
import 'package:goedale_management/models/beerlisting_model.dart';
import 'package:goedale_management/widgets/starrating_widget.dart';
//import 'package:goedale_client/widgets/quickadd_button.dart';
import 'package:goedale_management/functions/utils.dart';
import 'package:goedale_management/pages/beer_manage_page.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FirestoreStockListview extends StatelessWidget {
  final List<DocumentSnapshot> beersInStock;

  FirestoreStockListview({this.beersInStock});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: beersInStock.length,
      itemBuilder: (BuildContext context, int index) {
        var _listing = BeerListing(
          beer: Beer(
            id: beersInStock[index].data['id'].toString(),
            name: beersInStock[index].data['name'].toString(),
            brewery: beersInStock[index].data['brewery'].toString(),
            label: BeerLabel(
                iconUrl: beersInStock[index].data['label']['iconUrl'].toString()),
            style: BeerStyle(
                id: null, name: beersInStock[index].data['style'].toString()),
            abv: beersInStock[index].data['abv'],
            rating: beersInStock[index].data['rating'],
          ),
          price: beersInStock[index].data['price'],
          stockAmount: beersInStock[index].data['amount'],
        );

        if (_listing.stockAmount == 0) {
          //  return Text('uitverkocht');
          return Container();
        } else {
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
    );
  }
}
