import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:goedale_management/models/beer_models.dart';

import 'dart:async';
import 'dart:io';
import 'dart:convert';

class UntappdService  {
  static const _UNTAPPD_DB_API_ENDPOINT = "api.untappd.com";
  static const _MAX_TRY_BEFORE_FAIL = 3;

  final List<String> _keysExcludedIds = List();

  Tuple2<Uri, String> _buildUntappdServiceURI({
    @required String path,
    @required int retryCount,
    Map<String, String> queryParameters,
  }) {
    final Map<String, String> queryParams = queryParameters ?? Map();

    queryParams.addAll({
      "client_secret": "F9F5BE857919FE3A91196BDC3FA5E84A9B5A9C26",
      "client_id": "3F67FBB565C90403B951D4F0CD13D1A6FD7ED3E9"
    });

    return Tuple2(Uri.https(_UNTAPPD_DB_API_ENDPOINT, "/v4/$path", queryParams),
        "3F67FBB565C90403B951D4F0CD13D1A6FD7ED3E9");
  }

  Future<Beer> findBeerById(String id) async {
    HttpClient client = new HttpClient();
    return _callApiBeerById(client, id, 1);
  }

  Future<Beer> _callApiBeerById(HttpClient httpClient, String id, int retryCount) async {

    final response = await http.get("https://api.untappd.com/v4/beer/info/" +id + "?client_id=3F67FBB565C90403B951D4F0CD13D1A6FD7ED3E9&client_secret=F9F5BE857919FE3A91196BDC3FA5E84A9B5A9C26");
    if (response.statusCode == 200){
      print(json.decode(response.body));

      return Beer.fromJson(json.decode(response.body));
    }
    else {
      // If that response was not OK, throw an error.
      print (response.statusCode);
      throw Exception('Failed to load post');
    }
    /* final Map<String, dynamic> responseJson = data["response"];
    print(responseJson['beer']);
    return(responseJson['beer'] as Beer);*/
  }


  Future<List<Item>> findBeersMatching(String pattern) async {
    HttpClient client = new HttpClient();
    return _callApiBeerItems(client, pattern, 1);
  }

  Future<List<Item>> _callApiBeerItems(
      HttpClient httpClient, String pattern, int retryCount) async {
    if (pattern == null || pattern.trim().isEmpty) {
      return List(0);
    }

    final serviceUri = _buildUntappdServiceURI(
        path: "search/beer",
        queryParameters: {'q': pattern, 'limit': '50'},
        retryCount: retryCount);

    HttpClientRequest request = await httpClient.getUrl(serviceUri.item1);
    HttpClientResponse response = await request.close();
    if (response.statusCode < 200 || response.statusCode > 299) {
      if (retryCount < _MAX_TRY_BEFORE_FAIL) {
        _keysExcludedIds.add(serviceUri.item2);
        return _callApiBeerItems(httpClient, pattern, retryCount + 1);
      }
      throw Exception(
          "Bad response: ${response.statusCode} (${response.reasonPhrase})");
    }

    String responseBody = await response.transform(utf8.decoder).join();
    Map data = json.decode(responseBody);
    final Map<String, dynamic> responseJson = data["response"];
    int totalResults = responseJson["found"] ?? 0;
    if (totalResults == 0) {
      return List(0);
    }

    return (responseJson['beers']['items'] as List).map((beerJsonObject) {
      final Map<String, dynamic> beerJson = beerJsonObject["beer"];
      final Map<String, dynamic> breweryJson = beerJsonObject["brewery"];

      BeerStyle style;
      final String styleName = beerJson["beer_style"];
      if (styleName != null) {
        style = BeerStyle(
          id: styleName,
          name: styleName,
        );
      }

      double abv;
      if (beerJson["beer_abv"] != null) {
        if (beerJson["beer_abv"] is double) {
          abv = beerJson["beer_abv"];
        } else if (beerJson["beer_abv"] is int) {
          abv = (beerJson["beer_abv"] as int).toDouble();
        }
      }

      BeerLabel label;
      if (beerJson["beer_label"] != null) {
        label = BeerLabel(
          iconUrl: beerJson["beer_label"],
        );
      }

      return Item(
          beer: Beer(
            id: (beerJson["bid"] as int).toString(),
            name: beerJson["beer_name"],
            description: beerJson["beer_description"],
            abv: abv,
            label: label,
            style: style,
          ),
          brewery: Brewery(
            id: breweryJson["brewery_id"].toString(),
            name: breweryJson["brewery_name"],
          ));
    }).toList(growable: false);
  }
}
