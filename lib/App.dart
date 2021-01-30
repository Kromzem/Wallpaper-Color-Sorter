import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_color_sorter/Core.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(title: "Wallpaper Color Sorter",

      home: Scaffold(body: Core()));
}
