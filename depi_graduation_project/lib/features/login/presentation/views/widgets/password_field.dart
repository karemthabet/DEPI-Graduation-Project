import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
final String hintText;
final IconData icon;
final bool isPassword;
final bool isConfirmPassword;
final TextEditingController controller;

const PasswordField({
super.key,
required this.hintText,
required this.icon,
required this.controller,
this.isPassword = false,
this.isConfirmPassword = false,
});

@override
_PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
bool obscurePassword = true;

void togglePasswordVisibility() {
setState(() {
obscurePassword = !obscurePassword;
});
}

@override
Widget build(BuildContext context) {
return TextField(
controller: widget.controller,
obscureText: widget.isPassword || widget.isConfirmPassword
? obscurePassword
: false,
decoration: InputDecoration(
prefixIcon: Icon(widget.icon),
hintText: widget.hintText,
suffixIcon: widget.isPassword || widget.isConfirmPassword
? IconButton(
icon: Icon(
obscurePassword
? Icons.visibility_off_outlined
: Icons.visibility_outlined,
),
onPressed: togglePasswordVisibility,
)
: null,
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(30),
),
),
);
}
}
