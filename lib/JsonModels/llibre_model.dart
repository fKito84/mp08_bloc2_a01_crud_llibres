import '../settings/constants_db.dart';

class LlibreModel {
  final int? llibreId;
  final String llibreTitle;
  final String llibreContent;
  final String createdAt;


  LlibreModel({
    this.llibreId,
    required this.llibreTitle,
    required this.llibreContent,
    required this.createdAt,
  });

  factory LlibreModel.fromMap(Map<String, dynamic> json) => LlibreModel(
        llibreId: json[ConstantsDb.FIELD_LLIBRES_ID] as int?,
        llibreTitle: json[ConstantsDb.FIELD_LLIBRES_TITOL] as String??'',
        llibreContent: json[ConstantsDb.FIELD_LLIBRES_CONTENT]as String??'',
        createdAt: json[ConstantsDb.FIELD_LLIBRES_CREATED_AT]as String??'',
      );

  Map<String, dynamic> toMap() => {
    ConstantsDb.FIELD_LLIBRES_ID: llibreId,
    ConstantsDb.FIELD_LLIBRES_TITOL: llibreTitle,
    ConstantsDb.FIELD_LLIBRES_CONTENT: llibreContent,
    ConstantsDb.FIELD_LLIBRES_CREATED_AT: createdAt,
      };
}
