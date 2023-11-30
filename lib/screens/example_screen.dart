import 'package:flutter/material.dart';
import 'package:tegnordbok/models.dart';
import 'package:tegnordbok/widgets/player.dart';

class ExampleScreen extends StatelessWidget {
  const ExampleScreen(this.example, this.index, {super.key});

  final Example example;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Eksempel $index"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              PlayerWidget(example.stream.getUrl),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                    child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Text(example.example),
                )),
              ),
            ],
          ),
        ));
  }
}
