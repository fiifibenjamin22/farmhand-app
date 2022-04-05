import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController controllerIn;
  final String hintTextIn;
  final Function onTapIn;
  final Function onChangeIn;
  final bool obscureTextIn;
  final FocusNode focusNodeIn;
  CommonTextField(
      {this.controllerIn,
      this.hintTextIn,
      this.onTapIn,
      this.onChangeIn,
      this.obscureTextIn = false,
      this.focusNodeIn});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controllerIn,
        onTap: onTapIn,
        onChanged: onChangeIn,
        obscureText: obscureTextIn,
        focusNode: focusNodeIn,
        decoration: InputDecoration(
          isDense: true,
          hintText: hintTextIn,
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(12)),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(12)),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(12)),
        ));
  }
}

class CommonButtonIn extends StatelessWidget {
  final Function onPressedIn;
  final Widget childIn;
  final Color colorIn;
  final ShapeBorder shapeBorderIn;
  CommonButtonIn(
      {this.onPressedIn, this.childIn, this.colorIn, this.shapeBorderIn});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(colorIn),
          shape:
              MaterialStateProperty.all<RoundedRectangleBorder>(shapeBorderIn)),
      onPressed: onPressedIn,
      child: childIn,
    );
  }
}
