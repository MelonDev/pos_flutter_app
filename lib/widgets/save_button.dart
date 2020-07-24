import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SaveButton extends StatelessWidget {
  final VoidCallback _onPressed;

  SaveButton({Key key, VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      onPressed: _onPressed,
      child: Text(
        'บันทึก',
          style: GoogleFonts.itim(
          fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Colors.white),
      ),
      color: Colors.orange,
    );
  }
}
