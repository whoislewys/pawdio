class Bookmark {
  final int timestamp;
  final int audioId;

  Bookmark({this.timestamp, this.audioId});

  factory Bookmark.fromRow(Map<String, dynamic> row) {
    return Bookmark(timestamp: row['timestamp'], audioId: row['audio_id']);
  }

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp,
      'audio_id': audioId,
    };
  }

  @override
  String toString() {
    return '''

        Bookmark
        timestamp: ${this.timestamp}
        audio_id: ${this.audioId}''';
  }
}
