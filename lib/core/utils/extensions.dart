extension DoubleRounding on double {
  double roundToTwo() {
    return double.parse(toStringAsFixed(2));
  }
}
