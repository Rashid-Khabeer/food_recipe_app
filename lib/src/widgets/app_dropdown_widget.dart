import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/base/themes.dart';

class AppDropDownWidget<T> extends StatefulWidget {
  const AppDropDownWidget({
    Key? key,
    required this.hint,
    required this.label,
    required this.items,
    this.onSaved,
    this.value,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  final String hint;
  final String label;
  final T? value;
  final ValueSetter<T?>? onSaved;
  final ValueChanged<T?> onChanged;
  final List<DropdownMenuItem<T>> items;
  final FormFieldValidator<T>? validator;

  @override
  _AppDropDownWidgetState<T> createState() => _AppDropDownWidgetState<T>();
}

class _AppDropDownWidgetState<T> extends State<AppDropDownWidget<T>> {
  late T? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if(widget.label.isNotEmpty)
      Padding(
        padding: const EdgeInsets.only(
          left: 10,
          bottom: 10,
        ),
        child: Text(widget.label),
      ),
      DropdownButtonFormField<T>(
        items: widget.items,
        value: _value,
        onSaved: widget.onSaved,
        validator: widget.validator,
        style: const TextStyle(fontSize: 14, color: Colors.black),
        decoration: InputDecoration(
          fillColor: AppTheme.neutralColor.shade100,
          filled: true,
          isDense: true,
          hintText: widget.hint,
          hintStyle: const TextStyle(fontSize: 12),
          labelStyle: const TextStyle(fontSize: 12),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppTheme.neutralColor.shade200,
              width: 1,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppTheme.primaryColor.shade500,
              width: 1,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
        ),
        onChanged: (value) {
          _value = value;
          setState(() {});
          widget.onChanged(_value);
        },
      ),
    ], crossAxisAlignment: CrossAxisAlignment.start);
  }
}
