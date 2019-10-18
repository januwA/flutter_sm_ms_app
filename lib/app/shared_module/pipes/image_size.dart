int _base = 1024;

String imageSize(num value) {
  if (value < _base) {
    return value.toString() + ' B';
  } else {
    return (value / 1024).toStringAsFixed(2) + ' KB';
  }
}
