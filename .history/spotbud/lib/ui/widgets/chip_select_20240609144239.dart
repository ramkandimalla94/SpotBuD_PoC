import 'package:flutter/material.dart';

Widget buildChipSelect({
  required String title,
  required List<String> options,
  required ValueChanged<String> onOptionSelected,
  String? initialOption,
}) {
  return ChipSelect(
    title: title,
    options: options,
    onOptionSelected: onOptionSelected,
    initialOption: initialOption,
  );
}

class ChipSelect extends StatefulWidget {
  final String title;
  final List<String> options;
  final ValueChanged<String> onOptionSelected;
  final String? initialOption;

  const ChipSelect({
    Key? key,
    required this.title,
    required this.options,
    required this.onOptionSelected,
    this.initialOption,
  }) : super(key: key);

  @override
  _ChipSelectState createState() => _ChipSelectState();
}

class _ChipSelectState extends State<ChipSelect> {
  late String _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.initialOption ?? widget.options.first;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ),
        Wrap(
          spacing: 8.0,
          children: widget.options.map((option) {
            return ChoiceChip(
              label: Text(option),
              selected: _selectedOption == option,
              onSelected: (isSelected) {
                setState(() {
                  _selectedOption = option;
                });
                widget.onOptionSelected(option);
              },
              selectedColor: Theme.of(context).colorScheme.primary,
              labelStyle: TextStyle(
                color: _selectedOption == option
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onBackground,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
