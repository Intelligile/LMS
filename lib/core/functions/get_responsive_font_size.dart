import 'package:flutter/material.dart';

double getResponsiveFontSize(BuildContext context,
    {required double baseFontSize}) {
  double scalingFactor = getScalingFactor(context);
  double responsiveFontSize = baseFontSize * scalingFactor;
  double lowerLimit = baseFontSize * .7;
  double upperLimit = baseFontSize * 1.1;
  return responsiveFontSize.clamp(lowerLimit, upperLimit);
}

double getScalingFactor(BuildContext context) {
  double width = MediaQuery.sizeOf(context).width;
  if (width < 400) {
    return width / 400;
  } else if (width < 700) {
    return width / 700;
  } else {
    return width / 1000;
  }
}
