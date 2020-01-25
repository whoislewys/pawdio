String millisecondsToMinutesAndSeconds(double ms) {
  int curMin = (ms ~/ 1000) ~/ 60;
  int curSec = (ms ~/ 1000) % 60;
  return '$curMin:$curSec';
}

String getFileNameFromFilePath(String filePath) {
  return filePath.split('/').last;
}