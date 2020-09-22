class Audio {
  final int filePath;
  final int lastPosition;

  Audio({this.filePath, this.lastPosition});

  factory Audio.fromRow(Map<String, dynamic> row) {
    return Audio(
        filePath: row['file_path'], lastPosition: row['last_position']);
  }

  Map<String, dynamic> toMap() {
    return {
      'file_path': filePath,
      'last_position': lastPosition,
    };
  }

  @override
  String toString() {
    return '''

        Audio
        filePath: ${this.filePath}
        last_position: ${this.lastPosition}''';
  }
}
