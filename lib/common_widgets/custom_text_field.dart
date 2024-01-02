import 'package:flutter/material.dart';

Widget defaultFormField({
  required TextEditingController textEditingController,
  required TextInputType textInputType,
  required String label,
  bool ispassword = false,
  IconData? perfix,
  IconData? suffix,
  VoidCallback? suffixpressed,
  VoidCallback? ontap,
  FormFieldValidator<String>? onSubmit,
  FormFieldValidator<String>? onChange,
  required FormFieldValidator<String>? validator,
  required BuildContext context,
}) =>
    TextFormField(
      controller: textEditingController,
      keyboardType: textInputType,
      validator: validator,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: ontap,
      obscureText: ispassword,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white70,
            ),
          ),
          prefixIcon: Icon(
            perfix,
            color: Colors.white,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              suffix,
              color: Colors.white,
            ),
            onPressed: suffixpressed,
          ),
          label: Text(
            label,
            style: TextStyle(
              color: Colors.white,
            ),
          )),
    );
