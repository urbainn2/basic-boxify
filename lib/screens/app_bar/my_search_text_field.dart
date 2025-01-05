import 'package:boxify/app_core.dart';
import 'package:flutter/material.dart';

typedef SearchCallback = void Function(String query);
typedef ClearSearchCallback = void Function();

class MySearchTextField extends StatelessWidget {
  const MySearchTextField({
    super.key,
    required TextEditingController textController,
    required this.hintText,
    this.onSearch, // This callback is optional; can be null
    required this.onClear,
    this.onTextChanged, // This callback is optional; can be null
  }) : _textController = textController;

  final TextEditingController _textController;
  final String hintText;
  final SearchCallback? onSearch; // Nullable callback
  final ClearSearchCallback onClear;
  final ValueChanged<String>? onTextChanged; // Nullable callback

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      autofocus: true,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        fillColor: Core.appColor.cardColor,
        filled: true,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white38),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Core.appColor.cardColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey[900]!,
          ),
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear, color: Colors.white),
          onPressed: () {
            onClear();
            _textController.clear();
          },
        ),
      ),
      textInputAction: TextInputAction.search,
      textAlignVertical: TextAlignVertical.center,
      onSubmitted: (value) => onSearch?.call(value.trim()),
      onChanged: onTextChanged, // Call the text changed handler if provided
    );
  }
}
