class Level {
  final String name;
  final int blue;
  final int red;
  final int yellow;
  final int takeRed;
  final int takeYellow;

  Level(this.name, this.blue, this.red, this.yellow, this.takeRed, this.takeYellow);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Level && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
