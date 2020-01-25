String millisecondsToMinutesAndSeconds(double ms) {
  int curMin = (ms ~/ 1000) ~/ 60;
  int curSec = (ms ~/ 1000) % 60;
  return curSec > 10 ? '$curMin:$curSec' : '$curMin:0$curSec';
}

String getFileNameFromFilePath(String filePath) {
  return filePath.split('/').last;
}