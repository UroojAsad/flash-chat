import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final Color colour;
  final VoidCallback onpress;
  final String tittle;
  RoundButton({required this.colour,required this.tittle,required this.onpress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onpress,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            tittle,
          ),
        ),
      ),
    );
  }
}
