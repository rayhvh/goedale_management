import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goedale_management/widgets/firestore_beerdetail_widget.dart';


class BeerManagePage extends StatefulWidget {
//  final Beer beer;
//  BeerDetailPage(this.beer);
final String beerId;
BeerManagePage(this.beerId);
  @override
  _BeerManagePageState createState() => _BeerManagePageState(beerId);
}

class _BeerManagePageState extends State<BeerManagePage> {
//  final Beer beer;
//  _BeerDetailPageState(this.beer);
final String beerId;
_BeerManagePageState(this.beerId);

  @override
  Widget build(BuildContext context){
    return Container(
      child:  StreamBuilder(
        stream: Firestore.instance
            .collection('bokaalStock').document(beerId)
            .snapshots(), // change to dynamic db?
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();

          return FirestoreBeerdetail(
              beerdocument: snapshot.data );
        },
      ),);
  }
}
