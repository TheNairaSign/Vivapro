extension Capitalization on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  String get capitalizeFirstofEach {
    if (isEmpty) return this;
    return split(" ").map((str) => str.capitalize()).join(" ");
  }
}
