(String, String, String) millisecondsToHMS(int value) {
  final hours = ((value / 1000) / 3600).floor().toString().padLeft(2, '0');
  final minutes = ((value / 1000) / 60 % 60).floor().toString().padLeft(2, '0');
  final seconds = ((value / 1000) % 60).floor().toString().padLeft(2, '0');
  return (hours, minutes, seconds);
}

(String, String) millisecondsToBiggestTimeUnit(int value) {
  final result = value / 1000;

  var resultUnit = 'second${result == 1 ? '' : 's'}';
  var resultStr = result.toStringAsFixed(0);
  if (result > 3600) {
    final dur = result / 3600;
    resultUnit = 'hour${dur == 1 ? '' : 's'}';
    resultStr = dur.toStringAsFixed(1);
  } else if (result > 60) {
    final dur = result / 60;
    resultUnit = 'minutes${dur == 1 ? '' : 's'}';
    resultStr = dur.toStringAsFixed(0);
  }
  return (resultStr, resultUnit);
}
