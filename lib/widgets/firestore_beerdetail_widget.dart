import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:goedale_management/widgets/starrating_widget.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:goedale_management/scoped_model/global_model.dart';

class FirestoreBeerdetail extends StatefulWidget {
  final DocumentSnapshot beerdocument;

  FirestoreBeerdetail({this.beerdocument});

  @override
  _FirestoreBeerdetailState createState() => _FirestoreBeerdetailState();
}

class _FirestoreBeerdetailState extends State<FirestoreBeerdetail> {
//  String tableNumber;

  TextEditingController descriptionController = TextEditingController();
  TextEditingController tasteDescriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController addOrRemoveController = TextEditingController();


  @override
  void initState(){
    super.initState();
    descriptionController.text =  widget.beerdocument.data['desc'];
    tasteDescriptionController.text =  widget.beerdocument.data['tasteDesc'];
    priceController.text =  widget.beerdocument.data['price'].toString();
  }

   updateAmount (int amount) async {
     Firestore.instance.runTransaction(
             (Transaction transaction) async {
           DocumentReference reference =
           Firestore.instance.collection('bokaalStock').document(
               widget.beerdocument.data['id']);
           await reference.updateData({
             "amount": widget.beerdocument.data['amount'] + amount,
           });
         });
  }

  updateBeer () async{
    Firestore.instance.runTransaction(
            (Transaction transaction) async {
          DocumentReference reference =
          Firestore.instance.collection('bokaalStock').document(
              widget.beerdocument.data['id']);
          await reference.updateData({
            "price": double.parse(priceController.text),
            "desc": descriptionController.text,
            'tasteDesc': tasteDescriptionController.text,
          });
        }).then((_){
          Navigator.pop(context);
    });
  }

  deleteBeer () async{
    Firestore.instance.runTransaction(
            (Transaction transaction) async {
          DocumentReference reference =
          Firestore.instance.collection('bokaalStock').document(
              widget.beerdocument.data['id']);
          await reference.delete();}
          );//todo fix layout not having errors before closing,
  }


  @override
  Widget build(BuildContext context) {
    print(widget.beerdocument.data); // map this data to a model or not..
   // TextEditingController amountController = new TextEditingController();
    if (widget.beerdocument.data == null) {
      Navigator.pop(context);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.beerdocument.data['name']),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              onPressed: updateBeer,
              child: Row(
                children: <Widget>[
                  Text('Opslaan'),
                  Icon(Icons.save)
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              color: Colors.red,
              onPressed: deleteBeer,
              child: Row(
                children: <Widget>[
                  Text('Verwijderen'),
                  Icon(Icons.delete)
                ],
              ),
            ),
          ),
        ],
      ),
      body:
/*      LayoutBuilder(
        builder:
        (BuildContext context, BoxConstraints viewportConstraints){
          return SingleChildScrollView(
            child: ConstrainedBox(constraints: BoxConstraints(minHeight: viewportConstraints.maxHeight)
            ,child:  Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                CachedNetworkImage(
                                  imageUrl: widget.beerdocument.data["label"]["largeUrl"],
                                  height: 200,
                                ),
                                Text(widget.beerdocument.data['name'],
                                    style: Theme.of(context).textTheme.title),
                                Text(widget.beerdocument.data['brewery']),
                                Text(widget.beerdocument.data['style']),
                                Text(widget.beerdocument.data['abv'].toString() + "%"),
                                StarRating(rating: widget.beerdocument.data['rating'],
                                  color: Colors.white,
                                  borderColor: Colors.white,),
                                Text(widget.beerdocument.data['rating'].toString()),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(),
                        )
                      ],
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text("Beschrijving",
                              style: Theme.of(context).textTheme.title),
                          TextFormField(
                            controller: descriptionController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            // initialValue: widget.beerdocument.data['desc'],
                          ),
                          //   Text(widget.beerdocument.data['desc']),
                          Text("Smaak omschrijving",
                              style: Theme.of(context).textTheme.title),
                          Text(widget.beerdocument.data['tasteDesc']),
                          Text("Foto's", style: Theme.of(context).textTheme.title),
                          StreamBuilder(
                            stream: Firestore.instance
                                .collection('bokaalStock')
                                .document(widget.beerdocument.data['id'])
                                .collection('beerPhotos')
                                .snapshots(), // change to dynamic db?
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData)
                                return CircularProgressIndicator();

                              return Container(
                                height: 200,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data.documents.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CachedNetworkImage( imageUrl:snapshot.data.documents[index].data['photo_md'] , placeholder: (context, url) => new CircularProgressIndicator(),
                                            errorWidget: (context, url, error) => new Icon(Icons.error),)
//
                                      );
                                    }),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          );
        },
//todo make scrollable details..
      ),
      */
       Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: widget.beerdocument.data["label"]["largeUrl"],
                      height: 200,
                    ),
                    Text(widget.beerdocument.data['name'],
                        style: Theme.of(context).textTheme.title),
                    Text(widget.beerdocument.data['brewery']),
                    Text(widget.beerdocument.data['style']),
                    Text(widget.beerdocument.data['abv'].toString() + "%"),
                    StarRating(rating: widget.beerdocument.data['rating'],
                      color: Colors.white,
                      borderColor: Colors.white,),
                    Text(widget.beerdocument.data['rating'].toString()),
                  ],
                ),
              ),
            ),
            Flexible(
              child: Column(
                children: <Widget>[

                  Row(
                    children: <Widget>[

                      Flexible(
                        child: TextFormField(
                          keyboardType: TextInputType.numberWithOptions(),
                          maxLines: 1,
                          controller: priceController,
                          decoration: InputDecoration(hintText: "Prijs punten gescheiden", labelText: "Prijs", icon: Icon(Icons.euro_symbol)),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,15,0,0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Voorraad aantal: ",
                            style: Theme.of(context).textTheme.title),
                        Text(widget.beerdocument.data['amount'].toString(),style: Theme.of(context).textTheme.title),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8,0,8,0),
                        child: RaisedButton(
                          onPressed: (){
                            updateAmount(-int.parse(addOrRemoveController.text));
                          },
                          child: Icon(Icons.remove),
                        ),
                      ),
                      Flexible(
                        child: TextFormField(
                          controller: addOrRemoveController,
                          keyboardType: TextInputType.numberWithOptions(),
                          decoration: InputDecoration(
                            hintText: "Aantal erbij of eraf..",
                          labelText: "Bijvoegen of eraf halen"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          onPressed: (){
                            updateAmount(int.parse(addOrRemoveController.text));
                          },
                          child: Icon(Icons.add),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              Text("Beschrijving",
                  style: Theme.of(context).textTheme.title),
              TextFormField(
                controller: descriptionController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
              Text("Smaak omschrijving",
                  style: Theme.of(context).textTheme.title),
              TextFormField(
                controller: tasteDescriptionController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
              Text("Foto's", style: Theme.of(context).textTheme.title),
      /*        RaisedButton(
                onPressed: (){
                  Firestore.instance.runTransaction(
                          (Transaction transaction) async { // improve using batch,
                        CollectionReference reference =
                        Firestore.instance.collection("bokaalStock").document(widget.beerdocument.data['id']).collection("beerPhotos");
                        reference.getDocuments().then((beerPhotoSnap) {
                          for (DocumentSnapshot documentPhoto in beerPhotoSnap.documents){
                            documentPhoto.reference.delete();
                          }
                        }).then((_){
                          for(var i = 0; i < snapshot.data.beerPhotos.length; i++){
                            reference.add({
                              "photo_md": snapshot.data.beerPhotos[i].photo_md,
                            });
                          }
                        });

                      }
                  );
                },
              ),*/ //todo update photo's using untappd.
              StreamBuilder(
                stream: Firestore.instance
                    .collection('bokaalStock')
                    .document(widget.beerdocument.data['id'])
                    .collection('beerPhotos')
                    .snapshots(), // change to dynamic db?
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData)
                    return CircularProgressIndicator();

                  return Container(
                    height: 200,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CachedNetworkImage( imageUrl:snapshot.data.documents[index].data['photo_md'] , placeholder: (context, url) => new CircularProgressIndicator(),
                                errorWidget: (context, url, error) => new Icon(Icons.error),)
//
                          );
                        }),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    ),
    );
  }
}
