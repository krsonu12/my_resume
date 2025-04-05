import 'package:freezed_annotation/freezed_annotation.dart';

part 'resume_model.freezed.dart';
part 'resume_model.g.dart';

class TimestampConverter implements JsonConverter<DateTime, dynamic> {
  const TimestampConverter();

  @override
  DateTime fromJson(dynamic timestamp) {
    if (timestamp is DateTime) return timestamp;
    return DateTime.parse(timestamp.toString());
  }

  @override
  String toJson(DateTime date) => date.toIso8601String();
}

@freezed
class Resume with _$Resume {
  const factory Resume({
    required String name,
    required PersonalInfo personalInfo,
    required String summary,
    required List<Skill> skills,
    required List<WorkExperience> workExperience,
    required Education education,
    required List<String> languages,
    required List<String> websites,
    required List<Certification> certifications,
  }) = _Resume;

  factory Resume.fromJson(Map<String, dynamic> json) => _$ResumeFromJson(json);
}

@freezed
class PersonalInfo with _$PersonalInfo {
  const factory PersonalInfo({
    required String email,
    required String phone,
    required String location,
    required String pincode,
  }) = _PersonalInfo;

  factory PersonalInfo.fromJson(Map<String, dynamic> json) =>
      _$PersonalInfoFromJson(json);
}

@freezed
class Skill with _$Skill {
  const factory Skill({
    required String name,
    String? category,
  }) = _Skill;

  factory Skill.fromJson(Map<String, dynamic> json) => _$SkillFromJson(json);
}

@freezed
class WorkExperience with _$WorkExperience {
  const factory WorkExperience({
    required String company,
    required String position,
    required String location,
    @TimestampConverter() required DateTime startDate,
    @TimestampConverter() DateTime? endDate,
    required List<String> responsibilities,
    List<String>? technologies,
    String? description,
  }) = _WorkExperience;

  factory WorkExperience.fromJson(Map<String, dynamic> json) =>
      _$WorkExperienceFromJson(json);
}

@freezed
class Education with _$Education {
  const factory Education({
    required List<EducationEntry> entries,
  }) = _Education;

  factory Education.fromJson(Map<String, dynamic> json) =>
      _$EducationFromJson(json);
}

@freezed
class EducationEntry with _$EducationEntry {
  const factory EducationEntry({
    required String degree,
    required String institution,
    required String location,
    @TimestampConverter() required DateTime graduationDate,
    String? fieldOfStudy,
  }) = _EducationEntry;

  factory EducationEntry.fromJson(Map<String, dynamic> json) =>
      _$EducationEntryFromJson(json);
}

@freezed
class Certification with _$Certification {
  const factory Certification({
    required String name,
    @TimestampConverter() required DateTime date,
    String? organization,
    String? id,
  }) = _Certification;

  factory Certification.fromJson(Map<String, dynamic> json) =>
      _$CertificationFromJson(json);
}
