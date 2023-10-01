import 'package:flutter/material.dart';

class FilterWidget extends StatefulWidget {
  final List<int> filterOptions;
  final int selectedOption;
  final Function(int) onOptionChanged;

  const FilterWidget({
    Key? key,
    required this.filterOptions,
    required this.selectedOption,
    required this.onOptionChanged,
  }) : super(key: key);

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        //color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: DropdownButton<int>(
        value: widget.selectedOption,
        onChanged: (newValue) {
          setState(() {
            widget.onOptionChanged(newValue!);
          });
        },
        items: widget.filterOptions.map((option) {
          return DropdownMenuItem<int>(
            value: option,
            child: Text(option == -1 ? 'Tous' : option.toString()),
          );
        }).toList(),
      ),
    );
  }
}