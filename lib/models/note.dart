class Note {
  final String note;
  final int audioId;

  Note({this.note, this.audioId});

  Map<String, dynamic> toMap() {
    return {
      'note': note,
      'audio_id': audioId,
    };
  }

  @override
  String toString() {
    return '''

        Note
        note: ${this.note}
        audio_id: ${this.audioId}''';
  }
}
