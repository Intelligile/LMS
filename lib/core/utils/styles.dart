import 'package:flutter/material.dart';

abstract class Styles {
  static const textStyle16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: 'Avenir', // Add fontFamily here
  );

  static const textStyle20 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    fontFamily: 'Avenir', // Add fontFamily here
  );

  static const textStyle28 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    fontFamily: 'Avenir', // Add fontFamily here
  );
}

const TextStyle textStyle = TextStyle(fontFamily: 'Avenir');
