import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home ${counter.toString()}'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() => counter += 1);
            },
            icon: const Icon(Icons.plus_one),
          )
        ],
      ),
    );
  }
}