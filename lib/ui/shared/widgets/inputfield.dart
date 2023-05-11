import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';

class InputField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool isPassword;
  final TextInputType textInputType;
  final AutovalidateMode? autovalidateMode;
  final bool validate;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLength;
  final int? maxLines;
  final bool readOnly;
  final bool enable;
  final String? counter;
  final String? initialValue;
  final String? helperText;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onEditingComplete;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const InputField({
    Key? key,
    this.hintText,
    this.labelText,
    this.controller,
    this.focusNode,
    this.isPassword = false,
    this.textInputType = TextInputType.text,
    this.autovalidateMode,
    this.validate = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLength,
    this.maxLines = 1,
    this.readOnly = false,
    this.enable = true,
    this.counter,
    this.initialValue,
    this.helperText,
    this.inputFormatters,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: isPassword,
      keyboardType: textInputType,
      autovalidateMode: autovalidateMode ??
          (validate
              ? AutovalidateMode.always
              : AutovalidateMode.onUserInteraction),
      onFieldSubmitted: onFieldSubmitted,
      onEditingComplete: onEditingComplete,
      validator: validator,
      onChanged: onChanged,
      enabled: enable,
      maxLength: maxLength,
      initialValue: initialValue,
      maxLines: maxLines,
      readOnly: readOnly,
      inputFormatters: inputFormatters,
      cursorColor:Color(0xFFD09A4E),
      
      decoration: InputDecoration(
        labelText: labelText,
        helperMaxLines: 2,
        errorMaxLines: 2,
        hintText: hintText,
        helperText: helperText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        counterText: counter,
            hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(),
      ),
    ).pSymmetric(v: 12);
  }
}

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}
