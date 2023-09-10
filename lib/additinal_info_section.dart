import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdditinalInfo extends StatelessWidget {
  final IconData icon;
  final String lable;
  final String lableValue;
  const AdditinalInfo(
      {super.key,
      required this.icon,
      required this.lable,
      required this.lableValue});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        children: [
          Icon(
            icon,
            size: 32,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            lable,
            style: GoogleFonts.lato(fontSize: 14),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            lableValue,
            style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
