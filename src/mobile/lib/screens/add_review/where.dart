import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';

class AddReviewWhereScreen extends StatefulWidget {
  @override
  _AddReviewWhereScreenState createState() => _AddReviewWhereScreenState();
}

class _AddReviewWhereScreenState extends State<AddReviewWhereScreen> {
  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];

  @override
  void initState() {
    String apiKey = "AIzaSyA2WxrFeNpqAnWdufzpceiYtPojNzK-WDY";
    googlePlace = GooglePlace(apiKey);
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
                  'Gdje?',
                  style: TextStyle(color: Colors.white, fontSize: 32),
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
                child: ListView.builder(
                  itemCount: predictions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.pin_drop,
                          color: Colors.blue,
                        ),
                      ),
                      title: Text(
                        predictions[index].description ?? 'error',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        debugPrint(predictions[index].id);
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

  void autoCompleteSearch(String value) async {
    // var position = await GeolocatorPlatform.instance
    //         .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var result = await googlePlace.autocomplete.get(
      value,
      location: const LatLon(45.81008366919697, 15.97100945646627),
      radius: 1000,
      region: "hr",
      components: [Component("country", "hr")],
    );
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions ?? [];
      });
    }
  }
}
