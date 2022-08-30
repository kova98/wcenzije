import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:wcenzije/screens/add_review/content.dart';
import 'package:wcenzije/services/geolocator.dart';

class AddReviewWhereScreen extends StatefulWidget {
  @override
  _AddReviewWhereScreenState createState() => _AddReviewWhereScreenState();
}

class _AddReviewWhereScreenState extends State<AddReviewWhereScreen> {
  static const _radius = 1000;
  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  String searchQuery = "";

  @override
  void initState() {
    String apiKey = "AIzaSyA58YfseNMaYTIGom5PglCb73FqyQCn62Y";
    googlePlace = GooglePlace(apiKey);
    initializeNearbyPlaces();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(right: 20, left: 20, top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 60, bottom: 30),
                child: Text(
                  'WCenziraj\nobližnji objekt',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(50),
                color: Colors.transparent,
                child: TextField(
                  style: const TextStyle(color: Colors.blue),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });

                    if (value.isNotEmpty) {
                      autoCompleteSearch(value);
                    } else {
                      if (predictions.isNotEmpty && mounted) {
                        setState(() {
                          predictions = [];
                        });
                      }
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: predictions.isEmpty
                    ? Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          'Ne nalazimo objekt "$searchQuery" u blizini.\n',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: predictions.length,
                        itemBuilder: (context, index) {
                          final _name = predictions[index]
                                  .description
                                  ?.split(',')
                                  .first ??
                              'error';

                          final _nameWithStreet = predictions[index]
                                  .description
                                  ?.split(',')
                                  .take(2)
                                  .join(",") ??
                              "error";

                          return ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.pin_drop,
                                color: Colors.blue,
                              ),
                            ),
                            title: Text(
                              _nameWithStreet,
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddReviewContentScreen(_name),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void initializeNearbyPlaces() async {
    var position = await determinePosition();

    var result = await googlePlace.search.getNearBySearch(
        Location(lat: position.latitude, lng: position.longitude), 100,
        rankby: RankBy.Distance);

    var searchResultsAsPredictions = result?.results
        ?.map((e) => AutocompletePrediction(description: e.name))
        .toList();

    setState(() {
      predictions = searchResultsAsPredictions ?? [];
    });
  }

  void autoCompleteSearch(String value) async {
    var position = await determinePosition();
    var result = await googlePlace.autocomplete.get(
      value,
      location: LatLon(position.latitude, position.longitude),
      radius: _radius,
      region: "hr",
      components: [Component("country", "hr")],
      strictbounds: true,
      // TODO: limit to cafes, restaurants, etc
    );
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions ?? [];
      });
    }
  }
}
