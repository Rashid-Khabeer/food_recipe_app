import 'package:flutter/material.dart';
import 'package:food_recipie_app/src/base/themes.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    Key? key,
    this.hint,
    this.onTap,
    this.label,
    this.value,
    this.obscure = false,
    this.suffix,
    this.onSaved,
    this.maxLines = 1,
    this.onChanged,
    this.readonly = false,
    this.validator,
    this.prefixIcon,
    this.keyboardType,
    this.floatLabel = false,
    this.textEditingController,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.enabled = true,
  }) : super(key: key);

  final bool obscure;
  final bool enabled;
  final String? hint;
  final String? label;
  final int? maxLines;
  final String? value;
  final bool readonly;
  final Widget? suffix;
  final bool floatLabel;
  final Widget? prefixIcon;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final FormFieldSetter<String?>? onSaved;
  final FormFieldSetter<String?>? onChanged;
  final FormFieldValidator<String?>? validator;
  final TextEditingController? textEditingController;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: textCapitalization,
      onTap: onTap,
      onSaved: onSaved,
      readOnly: readonly,
      maxLines: maxLines,
      initialValue: value,
      onChanged: onChanged,
      validator: validator,
      obscureText: obscure,
      keyboardType: keyboardType,
      controller: textEditingController,
      textInputAction: textInputAction,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppTheme.neutralColor.shade900,
      ),
      decoration: InputDecoration(
        isDense: true,
        enabled: enabled,
        filled: true,
        fillColor: enabled ? Colors.white : AppTheme.neutralColor.shade100,
        hintText: hint,
        errorMaxLines: 3,
        floatingLabelBehavior: floatLabel
            ? FloatingLabelBehavior.always
            : FloatingLabelBehavior.auto,
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        hintStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppTheme.neutralColor.shade300,
        ),
        suffixIcon: suffix,
        prefixIcon: prefixIcon,
        contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
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
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.primaryColor,
            width: 2.5,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.neutralColor.shade300,
            width: 1,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}
