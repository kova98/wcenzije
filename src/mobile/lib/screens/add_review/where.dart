import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:wcenzije/screens/add_review/content.dart';
import 'package:wcenzije/services/geolocator.dart';

class AddReviewWhereScreen extends StatefulWidget {
  const AddReviewWhereScreen({Key? key}) : super(key: key);

  @override
  State<AddReviewWhereScreen> createState() => _AddReviewWhereScreenState();
}

class _AddReviewWhereScreenState extends State<AddReviewWhereScreen> {
  static const _radius = 1000;
  late GooglePlace googlePlace;
  List<PlacePrediction> predictions = [];
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
          margin: const EdgeInsets.only(right: 20, left: 20, top: 20),
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
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          'Ne nalazimo objekt "$searchQuery" u blizini.\n',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: predictions.length,
                        itemBuilder: (context, index) {
                          final name =
                              predictions[index].name?.split(',').first;

                          final nameWithStreet = predictions[index]
                                  .name
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
                              nameWithStreet,
                              style: const TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddReviewContentScreen(
                                      name!, predictions[index].placeId!),
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
        ?.map((e) => PlacePrediction(e.name ?? "error", e.placeId ?? "error"))
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
    );
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions
                ?.map((e) => PlacePrediction(
                      e.description,
                      e.placeId,
                    ))
                .toList() ??
            [];
      });
    }
  }
}

class PlacePrediction {
  final String? name;
  final String? placeId;

  PlacePrediction(this.name, this.placeId);
}
