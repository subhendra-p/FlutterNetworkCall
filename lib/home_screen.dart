import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'api_response_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  APIResponseModel _apiResponseModel;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Networking Example'),
          ),
          body: Container(
            child: Center(
              child: buildDataWidget(),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: isLoading
                ? CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  )
                : Icon(Icons.cloud_download),
            tooltip: 'Get data from the api',
            onPressed: () => getDataFromApi(),
          ),
        ),
      ),
    );
  }

  buildDataWidget() {
    if (_apiResponseModel == null) {
      return Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Press the floating action button to get the data',
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      return Text(
        "Today's Cases : ${_apiResponseModel.todayCases}\n"
        "Total Deaths : ${_apiResponseModel.deaths}\n"
        "Today's Deaths : ${_apiResponseModel.todayDeaths}\n"
        "Total Recovered : ${_apiResponseModel.recovered}\n"
        "Active Cases : ${_apiResponseModel.active}\n"
        "Critical Cases : ${_apiResponseModel.critical}\n"
        "Cases per million: ${_apiResponseModel.casesPerOneMillion}\n"
        "Deaths per million: ${_apiResponseModel.deathsPerOneMillion}\n"
        "Total Tests Done: ${_apiResponseModel.tests}\n"
        "Tests per million: ${_apiResponseModel.testsPerOneMillion}\n"
        "Affected countries : ${_apiResponseModel.affectedCountries}\n",
        style: TextStyle(fontSize: 18),
      );
    }
  }

  void getDataFromApi() async {
    setState(() {
      isLoading = true;
    });
    const String API_URL = "https://corona.lmao.ninja/v2/all";
    var response = await http.get(Uri.parse(API_URL));
    var parsedJson = await jsonDecode(response.body);
    setState(() {
      _apiResponseModel = APIResponseModel.fromJson(parsedJson);
      isLoading = false;
    });
  }
}
