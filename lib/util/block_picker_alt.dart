import 'package:flutter/material.dart';

typedef PickerItem = Widget Function(Color color);
typedef PickerLayoutBuilder = Widget Function(BuildContext context, List<Color> colors, PickerItem child);
typedef PickerItemBuilder = Widget Function(Color color, bool isCurrentColor, void Function() changeColor);

const List<Color> _defaultColors = [
  Color(0xFFF44336),
  Color(0xFFF52794),
  Color(0xFF7E4AE7),
  Color(0xFF3D55D9),
  Color(0xFF03A9F4),
  Color(0xFF009688),
  Color(0xFF009657),
  Color(0xFF51E347),
  Color(0xFF8BC34A),
  Color(0xFFFFEB3B),
  Color(0xFFFF6422),
  Color(0xFF607D8B),
];

Widget _defaultLayoutBuilder(BuildContext context, List<Color> colors, PickerItem child) {
  Orientation orientation = MediaQuery.of(context).orientation;

  return SizedBox(
    width: 300,
    height: orientation == Orientation.portrait ? 210 : 105,
    child: GridView.count(
      crossAxisCount: orientation == Orientation.portrait ? 4 : 6,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      children: [for (Color color in colors) child(color)],
    ),
  );
}

Widget _defaultItemBuilder(Color color, bool isCurrentColor, void Function() changeColor) {
  return Container(
    margin: const EdgeInsets.all(7),
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
    Key? key,
    required this.pickerColor,
    required this.onColorChanged,
    this.availableColors = _defaultColors,
    this.useInShowDialog = true,
    this.layoutBuilder = _defaultLayoutBuilder,
    this.itemBuilder = _defaultItemBuilder,
  }) : super(key: key);

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
            ? (_currentColor?.value == color.value) &&
            (widget.useInShowDialog ? true : widget.pickerColor?.value == color.value)
            : false,
            () => changeColor(color),
      ),
    );
  }
}

class MultipleChoiceBlockPicker extends StatefulWidget {
  const MultipleChoiceBlockPicker({
    super.key,
    required this.pickerColors,
    required this.onColorsChanged,
    this.availableColors = _defaultColors,
    this.useInShowDialog = true,
    this.layoutBuilder = _defaultLayoutBuilder,
    this.itemBuilder = _defaultItemBuilder,
  });

  final List<Color>? pickerColors;
  final ValueChanged<List<Color>> onColorsChanged;
  final List<Color> availableColors;
  final bool useInShowDialog;
  final PickerLayoutBuilder layoutBuilder;
  final PickerItemBuilder itemBuilder;

  @override
  State<StatefulWidget> createState() => _MultipleChoiceBlockPickerState();
}

class _MultipleChoiceBlockPickerState extends State<MultipleChoiceBlockPicker> {
  List<Color>? _currentColors;

  @override
  void initState() {
    _currentColors = widget.pickerColors;
    super.initState();
  }

  void toggleColor(Color color) {
    setState(() {
      if (_currentColors != null) {
        _currentColors!.contains(color) ? _currentColors!.remove(color) : _currentColors!.add(color);
      }
    });
    widget.onColorsChanged(_currentColors ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return widget.layoutBuilder(
      context,
      widget.availableColors,
          (Color color) => widget.itemBuilder(
        color,
        (_currentColors != null && (widget.useInShowDialog ? true : widget.pickerColors != null))
            ? _currentColors!.contains(color) && (widget.useInShowDialog ? true : widget.pickerColors!.contains(color))
            : false,
            () => toggleColor(color),
      ),
    );
  }
}