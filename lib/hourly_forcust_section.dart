import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EarlyForCustItem extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temp;
  const EarlyForCustItem(
      {super.key, required this.time, required this.icon, required this.temp});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              time,
              style:
                  GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            Icon(
              icon,
              size: 32,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              temp,
              style: GoogleFonts.lato(),
            ),
          ],
        ),
      ),
    );
  }
}
