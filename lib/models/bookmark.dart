class Bookmark {
  final int timestamp;

  Bookmark({this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp,
    };
  }
}
