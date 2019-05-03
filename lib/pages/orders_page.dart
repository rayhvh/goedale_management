import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class OrdersPage extends StatefulWidget {
  @override
  _StockPage createState() => _StockPage();
}



class _StockPage extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('bokaalStock')
            .snapshots(),
      builder: (BuildContext context,
      AsyncSnapshot<QuerySnapshot> stockSnapshot) {
        if (!stockSnapshot.hasData) return CircularProgressIndicator();
          return StreamBuilder(
            stream: Firestore.instance
                .collection('bokaalTables')
                .snapshots(), // change to dynamic db?
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> tablesSnapshot) {
              if (!tablesSnapshot.hasData) return CircularProgressIndicator();
              return ListView.builder(
                itemCount: tablesSnapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  var currentTableString = tablesSnapshot.data.documents[index]['id'].toString();
                  return StreamBuilder(
                    stream: Firestore.instance
                        .collection('bokaalTables')
                        .document(
                        currentTableString)
                        .collection('orders')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> ordersSnapshot) {
                      if (!ordersSnapshot.hasData)
                        return CircularProgressIndicator();
                      if (ordersSnapshot.data.documents.length > 0){
                        return Card(
                          color: Colors.grey[800],
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                title: Text("Tafel: " + currentTableString),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: ordersSnapshot.data.documents.length,
                                itemBuilder: (BuildContext context, int index){
                                  var orderData = ordersSnapshot.data.documents[index].data;
                                  var timeToFormat = DateTime.fromMillisecondsSinceEpoch(orderData['madeAt']);
                                  var timeOfOrder = DateFormat('H:mm').format(timeToFormat);

                                  return Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(8.0,0,0,0),
                                        child: Card(
                                          color: Colors.grey[700],
                                          child: ListTile(
                                            title: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text("Bestelling: " + orderData['orderNr'].toString() + " - $timeOfOrder - Betaald: "),
                                                Icon((orderData['isPaid']) ? Icons.thumb_up: Icons.thumb_down, color: (orderData['isPaid']) ? Colors.green : Colors.red,),
                                              ],
                                            ),
                                           subtitle: 
                                            StreamBuilder(
                                             stream: Firestore.instance.collection('bokaalTables').document(currentTableString).collection('orders').document(ordersSnapshot.data.documents[index].documentID).collection('items').snapshots(),
                                             builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> orderItemsSnapshot){
                                             //  var beerDoc = stockSnapshot.data.documents.where((document) => document.documentID == ordersSnapshot);
                                               print(orderItemsSnapshot);
                                               return ListView.builder(
                                                 shrinkWrap: true,
                                                 itemCount: orderItemsSnapshot.data.documents.length,
                                                 itemBuilder: (BuildContext context, int index){
                                                  print("id in orderitemsnap: " +orderItemsSnapshot.data.documents[index].data['beerId']) ;

                                                   stockSnapshot.data.documents.forEach((document) => {
                                                    print (document.documentID)
                                                     if(document.documentID == )
                                                  });
                                                 /*  var beerDoc = stockSnapshot.data.documents.where((document) =>
                                                   document.data['id'] ==
                                                      "139271" );

                                                  // orderItemsSnapshot.data.documents[index].data['beerId']
                                                   print (beerDoc);
                                                   print (beerDoc);*/
                                                 },
                                               );
                                             },
                                           )
                                          ),
                                        ),
                                      ),

                                    ],
                                  );
                                },
                              ),

                            ],
                          ),
                        );
                      }
                      return Container();

                    },
                  );
                },
              );
              /*       return StreamBuilder(
                      stream: Firestore.instance.collection('bokaalTables').document(tablesSnapshot.data.documents[i]['id'].toString()).collection('orders').snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> ordersSnapshot) {
                        if (!ordersSnapshot.hasData) return CircularProgressIndicator();
                        for ( int i =0; i< ordersSnapshot.data.documents.length; i++){
                          print(ordersSnapshot.data.documents[i].data['totalAmount']);
                          return Text(ordersSnapshot.data.documents[i].data['totalAmount'].toString());
                        }
                      },
                    );*/

              /* return ListTile(
                 title: Column(
                   children: <Widget>[
                     Text(snapshot.data.documents.toString()),

                   ],
                 ),
               );*/

              /* return FirestoreStockListview(
                beersInStock: snapshot.data.documents);*/
            },
          );
      }
      ),
    );
  }
}
