class Audio {
  final String filePath;
  final int lastPosition;
  final int id;

  Audio({this.filePath, this.lastPosition, this.id});

  factory Audio.fromRow(Map<String, dynamic> row) {
    return Audio(
        filePath: row['file_path'],
        lastPosition: row['last_position'],
        id: row['id']);
  }

  const Audio.emptyAudio(
      {this.filePath: '', this.lastPosition: -1, this.id: -1});

  Map<String, dynamic> toMap() {
    return {
      'file_path': filePath,
      'last_position': lastPosition,
      'id': id,
    };
  }

  @override
  String toString() {
    return '''

    Audio.
    filePath: ${this.filePath}
    last_position: ${this.lastPosition}
    id: ${this.id}
    ''';
  }
}
