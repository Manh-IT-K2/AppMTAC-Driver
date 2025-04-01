class NoteImportantModel {
  final String nameNote;
  final String contentNote;
  final String hourNote;

  NoteImportantModel({
    required this.nameNote,
    required this.contentNote,
    required this.hourNote,
  });

  // Convert Map to NoteImportantModel
  factory NoteImportantModel.fromMap(Map<String, dynamic> map) {
    return NoteImportantModel(
        nameNote: map['nameNote'],
        contentNote: map['contentNote'],
        hourNote: map['hourNote']);
  }

  // Convert NoteImportantModel to Map
  Map<String, dynamic> toMap() {
    return {
      'nameNote': nameNote,
      'contentNote': contentNote,
      'hourNote': hourNote,
    };
  }
}
