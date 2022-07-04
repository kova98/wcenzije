import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  final List<String> reviews = const [
    "review 1",
    "some review 2",
    "another review 3",
    "another review 4",
    "one more 5",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wcenzije"),
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {},
            title: Text(reviews[index]),
          );
        },
      ),
    );
  }
}
