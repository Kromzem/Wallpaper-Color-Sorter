import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_palette/flutter_palette.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'PathRow.dart';

class Core extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CoreState();
}

class _CoreState extends State<Core> {
  String _sourcePath;
  String _destinationPath;

  @override
  Widget build(BuildContext context) => Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.only(bottom: 20.0), child: PathRow("Source path", (path) => _sourcePath = path)),
          Padding(padding: EdgeInsets.only(bottom: 20.0), child: PathRow("Destination path", (path) => _destinationPath = path)),
          TextButton(
            onPressed: () {
              _sort();
            },
            child: Text("Start"),
            style: TextButton.styleFrom(primary: Colors.white, backgroundColor: Colors.blue),
          )
        ],
      ));

  void _sort() async {
    print("Start sorting ...\n");

    var dialog = ProgressDialog(context, type: ProgressDialogType.Download)..style(progress: 0.0, maxProgress: 100.0, progressWidget: CircularProgressIndicator(), message: "Sorting ...");
    await dialog.show();

    var sourceDirectory = Directory(_sourcePath);
    var destinationDirectory = Directory(_destinationPath);

    destinationDirectory.list().forEach((element) {
      element.deleteSync();
    });

    var files = sourceDirectory.listSync();
    var fileCount = files.length;
    var percent = 0.0;

    var palette = ColorPalette.empty();
    for(var element in files) {
      var generator = await PaletteGenerator.fromImageProvider(Image.file(element).image);

      print("$element loaded!");
      percent += 50.0 / fileCount;
      dialog.update(progress: percent);

      palette.add(WallpaperData(element.path, generator.dominantColor.color));
    }

    palette.sortByHue();

    var index = 0;
    palette.colors.forEach((element) {
      var data = element as WallpaperData;

      try {
        index++;

        var file = File(data.path);
        file.copySync("${destinationDirectory.path}\\$index.${file.path.split(".").last}");

        print("${data.path} copied!");
      } on Exception catch (ex) {
        print("${data.path} failed!\n$ex\n");
      }

      percent += 50.0 / fileCount;
      dialog.update(progress: percent);
    });

    print("Complete!\n");
    await dialog.hide();
  }
}

class WallpaperData extends RgbColor {
  final String path;

  WallpaperData(this.path, Color color) : super(color.red, color.green, color.blue);
}
