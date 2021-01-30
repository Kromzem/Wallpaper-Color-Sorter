import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:flutter/material.dart';

class PathRow extends StatefulWidget {
  final ValueChanged<String> _pathChanged;
  final _label;

  const PathRow(this._label, this._pathChanged);

  @override
  State<StatefulWidget> createState() => _PathRowState(_label, _pathChanged);
}

class _PathRowState extends State<PathRow> {
  final ValueChanged<String> _pathChanged;
  final String _label;
  String _path;

  _PathRowState(this._label, this._pathChanged);

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
              flex: 95,
              child: TextField(
                onChanged: (path) {
                  this._path = path;
                  _pathChanged(path);
                },
                decoration: InputDecoration(border: const OutlineInputBorder(), labelText: _label),
                controller: TextEditingController(text: _path),
              )),
          Expanded(
              flex: 5,
              child: TextButton(
                onPressed: () {
                  var filePicker = OpenFilePicker()..forceFileSystemItems = false;

                  var file = filePicker.getFile();
                  setState(() {
                    _path = file.parent.path;
                    _pathChanged(_path);
                  });
                },
                child: Icon(Icons.more_horiz),
                style: TextButton.styleFrom(primary: Colors.white, backgroundColor: Colors.blue),
              ))
        ],
      );
}
