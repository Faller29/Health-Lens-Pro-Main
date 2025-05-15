import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Item {
  Item({
    required this.expandedContent,
    required this.headerValue,
    this.isExpanded = false,
  });

  Widget expandedContent;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Adobo',
      expandedContent: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Chicken',
            style: GoogleFonts.readexPro(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              textStyle: const TextStyle(
                color: Color(0xffff5963),
              ),
            ),
            textAlign: TextAlign.left,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Protein',
                style: GoogleFonts.readexPro(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  textStyle: const TextStyle(
                    color: Color(0xffff5963),
                  ),
                ),
              ),
              Text(
                'Carbohydrates',
                style: GoogleFonts.readexPro(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  textStyle: const TextStyle(
                    color: Color(0xffff5963),
                  ),
                ),
              ),
              Text(
                'Fats',
                style: GoogleFonts.readexPro(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  textStyle: const TextStyle(
                    color: Color(0xffff5963),
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                '11g',
                style: GoogleFonts.readexPro(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  textStyle: const TextStyle(
                    color: Color(0xffff5963),
                  ),
                ),
              ),
              Text(
                '40g',
                style: GoogleFonts.readexPro(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  textStyle: const TextStyle(
                    color: Color(0xffff5963),
                  ),
                ),
              ),
              Text(
                '23g',
                style: GoogleFonts.readexPro(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  textStyle: const TextStyle(
                    color: Color(0xffff5963),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  });
}
