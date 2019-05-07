import 'package:flutter/material.dart';
import 'package:goedale_management/models/beer_models.dart';
import 'package:goedale_management/services/untappd.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UntappdBeerDetailPage extends StatefulWidget {
  final Beer _beer;
  UntappdBeerDetailPage(this._beer);
  @override
  State<StatefulWidget> createState() {
    return _UntappdBeerDetailPageState(_beer);
  }
}

class _UntappdBeerDetailPageState extends State<UntappdBeerDetailPage>{
  final Beer _beer;
  Future<Beer> _untappdBeer;

  _UntappdBeerDetailPageState(this._beer);
  TextEditingController amountController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  TextEditingController tasteDescriptionController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  @override
  void initState(){
    super.initState();
    _untappdBeer = UntappdService().findBeerById(_beer.id);
    descriptionController.text = _beer.description;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_beer.name)),
      body: SingleChildScrollView(
        child: Container(
          child: FutureBuilder(
              future: _untappdBeer,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container(child: Center(child: CircularProgressIndicator()));
                } else {

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    Image.network(snapshot.data.label.largeUrl, height: 200,),
                                    Text(_beer.name, style: Theme.of(context).textTheme.title),
                                    Text(snapshot.data.brewery), // via future untappd because we can only have 100 calls a hour. it only gets calls and info of beer at details
                                    Text(_beer.style.name),
                                    Text(_beer.abv.toString()+"%"),
                                    Text("Rating: " + snapshot.data.rating.toString()),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              
                              child: Flexible(
                                child: Column(
                                  children: <Widget>[
                                    TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: amountController,
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.library_add),
                                          hintText: "In cijfers",
                                          labelText: 'Hoeveelheid',
                                      ),
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: priceController,
                                      decoration:
                                      const InputDecoration(hintText: "In cijfers met punten",
                                      icon: Icon(Icons.euro_symbol),
                                        labelText: 'Prijs', ),
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      controller: tasteDescriptionController,
                                      decoration:
                                      const InputDecoration(hintText: "Een omschrijving voor het zoeken",
                                      icon: Icon(Icons.description),
                                        labelText: 'Smaakomschrijving', ),
                                    ),
                                    RaisedButton(
                                        onPressed: () {
                                          Firestore.instance.runTransaction(
                                                  (Transaction transaction) async {
                                                DocumentReference reference =
                                                Firestore.instance
                                                    .collection("bokaalStock").document(_beer.id);
                                                await reference.setData({
                                                  "name": _beer.name,
                                                  "abv": _beer.abv,
                                                  "brewery": snapshot.data.brewery,
                                                  "desc": descriptionController.text,
                                                  "tasteDesc": tasteDescriptionController.text,
                                                  "id": _beer.id,
                                                  "rating": snapshot.data.rating,
                                                  "style": _beer.style.name,
                                                  "label": {
                                                    "iconUrl": _beer.label.iconUrl,
                                                    "mediumUrl": _beer.label.iconUrl,
                                                    "largeUrl": snapshot.data.label.largeUrl,
                                                  },
                                                  "price": (priceController.text == '') ? 1 : double.parse(priceController.text) ,
                                                  "amount": (amountController.text == '') ? 1 : int.parse(amountController.text),
                                                });
                                              });

                                          Firestore.instance.runTransaction(
                                                  (Transaction transaction) async { // improve using batch,
                                                CollectionReference reference =
                                                Firestore.instance.collection("bokaalStock").document(_beer.id).collection("beerPhotos");
                                                 reference.getDocuments().then((beerPhotoSnap) {
                                              for (DocumentSnapshot documentPhoto in beerPhotoSnap.documents){
                                                documentPhoto.reference.delete();
                                              }
                                               }).then((_){
                                                   for(var i = 0; i < snapshot.data.beerPhotos.length; i++){
                                                      reference.add({
                                                       "photo_sm": snapshot.data.beerPhotos[i].photo_sm,
                                                       "photo_md": snapshot.data.beerPhotos[i].photo_md,
                                                       "photo_og": snapshot.data.beerPhotos[i].photo_og,
                                                     });
                                                   }
                                                 });

                                              }
                                          );

                                          Navigator.pop(context);
                                        },
                                        child: const Text('Toevoegen')),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          child: Column(
                            children: <Widget>[
                              Text("Beschrijving",style: Theme.of(context).textTheme.title),
                              TextFormField(
                                controller: descriptionController,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                              ),
                            //  Text(_beer.description),
                              Text("Foto's",style: Theme.of(context).textTheme.title),

                              Container( height: 200,
                                child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: snapshot.data.beerPhotos.length, itemBuilder: (BuildContext context, int index){
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.network(snapshot.data.beerPhotos[index].photo_md, height: 200,),
                                  );
                                },),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }
}