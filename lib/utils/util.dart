import 'package:flutter/widgets.dart';

String millisecondsToMinutesAndSeconds(double ms) {
  int curMin = (ms ~/ 1000) ~/ 60;
  int curSec = (ms ~/ 1000) % 60;
  return curSec > 10 ? '$curMin:$curSec' : '$curMin:0$curSec';
}

String getFileNameFromFilePath(String filePath) {
  return filePath.split('/').last;
}

/*
* Returns the index of the element closest to and greater than the input element
*/
int findNearestAbove({@required List<int> sortedList, @required int element}) {
  for (int i = 0; i < sortedList.length; i++) {
    if (sortedList[i] > element) {
      return i;
    }
  }
  // If no element is greater than the input element, return the last element in the list
  return sortedList.length;
}

/*
* Returns the index of the element closest to and less than the input element
*/
int findNearestBelow({@required List<int> sortedList, @required int element}) {
  for (int i = sortedList.length; i > 0; i--) {
    if (sortedList[i] < element) {
      return i;
    }
  }
  // If no element is lesser than the input element, return the first element in the list
  return 0;
}
// int binarySearch<T>(List<T> sortedList, T value, {int compare(T a, T b)}) {
//   compare ??= defaultCompare<T>();
//   int min = 0;
//   int max = sortedList.length;
//   while (min < max) {
//     int mid = min + ((max - min) >> 1);
//     var element = sortedList[mid];
//     int comp = compare(element, value);
//     if (comp == 0) return mid;
//     if (comp < 0) {
//       min = mid + 1;
//     } else {
//       max = mid;
//     }
//   }
//   return -1;
// }