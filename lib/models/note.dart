class Note {
  final String note;

  Note({this.note});

  Map<String, dynamic> toMap() {
    return {
      'note': note,
    };
  }

}