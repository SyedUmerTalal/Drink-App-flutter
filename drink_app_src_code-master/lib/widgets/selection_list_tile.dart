import 'package:flutter/material.dart';

class SelectionTile extends StatefulWidget {
  const SelectionTile({
    Key key,
    this.name,
  }) : super(key: key);
  final String name;

  @override
  _SelectionTileState createState() => _SelectionTileState();
}

class _SelectionTileState extends State<SelectionTile> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Row(
          children: [
            Expanded(flex: 1, child: SizedBox()),
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                height: 30,
                child: Text(
                  widget.name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Switch(
                  value: _selected,
                  onChanged: (value) {
                    setState(() {
                      _selected = value;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        onTap: () {
          setState(() {
            _selected = !_selected;
          });
        });
  }
}
