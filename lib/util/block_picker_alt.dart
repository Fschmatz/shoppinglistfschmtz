import 'package:flutter/material.dart';

typedef PickerItem = Widget Function(Color color);
typedef PickerLayoutBuilder = Widget Function(BuildContext context, List<Color> colors, PickerItem child);
typedef PickerItemBuilder = Widget Function(Color color, bool isCurrentColor, void Function() changeColor);

const List<Color> _defaultColors = [
  Color(0xFF8A63C6),
  Color(0xFF336699),
  Color(0xFF2196f3),
  Color(0xFF009688),
  Color(0xFF60b044),
  Color(0xFFffc107),
  Color(0xFFff9800),
  Color(0xFFff5722),
  Color(0xFFE91E63),
  Color(0xFF607D8B),
];

Widget _defaultLayoutBuilder(BuildContext context, List<Color> colors, PickerItem child) {
  Orientation orientation = MediaQuery.of(context).orientation;

  return SizedBox(
    width: 300,
    height: orientation == Orientation.portrait ? 110 : 105,
    child: GridView.count(
      crossAxisCount: orientation == Orientation.portrait ? 5 : 6,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      children: [for (Color color in colors) child(color)],
    ),
  );
}

Widget _defaultItemBuilder(Color color, bool isCurrentColor, void Function() changeColor) {
  return Container(
    margin: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color,
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: changeColor,
        borderRadius: BorderRadius.circular(50),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 210),
          opacity: isCurrentColor ? 1 : 0,
          child: const Icon(Icons.done, color: Colors.black),
        ),
      ),
    ),
  );
}

class BlockPicker extends StatefulWidget {
  const BlockPicker({
    super.key,
    required this.pickerColor,
    required this.onColorChanged,
    this.availableColors = _defaultColors,
    this.useInShowDialog = true,
    this.layoutBuilder = _defaultLayoutBuilder,
    this.itemBuilder = _defaultItemBuilder,
  });

  final Color? pickerColor;
  final ValueChanged<Color> onColorChanged;
  final List<Color> availableColors;
  final bool useInShowDialog;
  final PickerLayoutBuilder layoutBuilder;
  final PickerItemBuilder itemBuilder;

  @override
  State<StatefulWidget> createState() => _BlockPickerState();
}

class _BlockPickerState extends State<BlockPicker> {
  Color? _currentColor;

  @override
  void initState() {
    _currentColor = widget.pickerColor;
    super.initState();
  }

  void changeColor(Color color) {
    setState(() => _currentColor = color);
    widget.onColorChanged(color);
  }

  @override
  Widget build(BuildContext context) {
    return widget.layoutBuilder(
      context,
      widget.availableColors,
      (Color color) => widget.itemBuilder(
        color,
        (_currentColor != null && (widget.useInShowDialog ? true : widget.pickerColor != null))
            ? (_currentColor?.value == color.value) && (widget.useInShowDialog ? true : widget.pickerColor?.value == color.value)
            : false,
        () => changeColor(color),
      ),
    );
  }
}
