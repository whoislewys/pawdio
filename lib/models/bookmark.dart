class Bookmark {
  final int timestamp;

  Bookmark({this.timestamp});

  factory Bookmark.fromRow(Map<String, dynamic> row) {
    return Bookmark(timestamp: row['timestamp']);
  }

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp,
    };
  }
}
