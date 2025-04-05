// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resume_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ResumeImpl _$$ResumeImplFromJson(Map<String, dynamic> json) => _$ResumeImpl(
      name: json['name'] as String,
      personalInfo:
          PersonalInfo.fromJson(json['personalInfo'] as Map<String, dynamic>),
      summary: json['summary'] as String,
      skills: (json['skills'] as List<dynamic>)
          .map((e) => Skill.fromJson(e as Map<String, dynamic>))
          .toList(),
      workExperience: (json['workExperience'] as List<dynamic>)
          .map((e) => WorkExperience.fromJson(e as Map<String, dynamic>))
          .toList(),
      education: Education.fromJson(json['education'] as Map<String, dynamic>),
      languages:
          (json['languages'] as List<dynamic>).map((e) => e as String).toList(),
      websites:
          (json['websites'] as List<dynamic>).map((e) => e as String).toList(),
      certifications: (json['certifications'] as List<dynamic>)
          .map((e) => Certification.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ResumeImplToJson(_$ResumeImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'personalInfo': instance.personalInfo,
      'summary': instance.summary,
      'skills': instance.skills,
      'workExperience': instance.workExperience,
      'education': instance.education,
      'languages': instance.languages,
      'websites': instance.websites,
      'certifications': instance.certifications,
    };

_$PersonalInfoImpl _$$PersonalInfoImplFromJson(Map<String, dynamic> json) =>
    _$PersonalInfoImpl(
      email: json['email'] as String,
      phone: json['phone'] as String,
      location: json['location'] as String,
      pincode: json['pincode'] as String,
    );

Map<String, dynamic> _$$PersonalInfoImplToJson(_$PersonalInfoImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'phone': instance.phone,
      'location': instance.location,
      'pincode': instance.pincode,
    };

_$SkillImpl _$$SkillImplFromJson(Map<String, dynamic> json) => _$SkillImpl(
      name: json['name'] as String,
      category: json['category'] as String?,
    );

Map<String, dynamic> _$$SkillImplToJson(_$SkillImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'category': instance.category,
    };

_$WorkExperienceImpl _$$WorkExperienceImplFromJson(Map<String, dynamic> json) =>
    _$WorkExperienceImpl(
      company: json['company'] as String,
      position: json['position'] as String,
      location: json['location'] as String,
      startDate: const TimestampConverter().fromJson(json['startDate']),
      endDate: const TimestampConverter().fromJson(json['endDate']),
      responsibilities: (json['responsibilities'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      technologies: (json['technologies'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$WorkExperienceImplToJson(
        _$WorkExperienceImpl instance) =>
    <String, dynamic>{
      'company': instance.company,
      'position': instance.position,
      'location': instance.location,
      'startDate': const TimestampConverter().toJson(instance.startDate),
      'endDate': _$JsonConverterToJson<dynamic, DateTime>(
          instance.endDate, const TimestampConverter().toJson),
      'responsibilities': instance.responsibilities,
      'technologies': instance.technologies,
      'description': instance.description,
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);

_$EducationImpl _$$EducationImplFromJson(Map<String, dynamic> json) =>
    _$EducationImpl(
      entries: (json['entries'] as List<dynamic>)
          .map((e) => EducationEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$EducationImplToJson(_$EducationImpl instance) =>
    <String, dynamic>{
      'entries': instance.entries,
    };

_$EducationEntryImpl _$$EducationEntryImplFromJson(Map<String, dynamic> json) =>
    _$EducationEntryImpl(
      degree: json['degree'] as String,
      institution: json['institution'] as String,
      location: json['location'] as String,
      graduationDate:
          const TimestampConverter().fromJson(json['graduationDate']),
      fieldOfStudy: json['fieldOfStudy'] as String?,
    );

Map<String, dynamic> _$$EducationEntryImplToJson(
        _$EducationEntryImpl instance) =>
    <String, dynamic>{
      'degree': instance.degree,
      'institution': instance.institution,
      'location': instance.location,
      'graduationDate':
          const TimestampConverter().toJson(instance.graduationDate),
      'fieldOfStudy': instance.fieldOfStudy,
    };

_$CertificationImpl _$$CertificationImplFromJson(Map<String, dynamic> json) =>
    _$CertificationImpl(
      name: json['name'] as String,
      date: const TimestampConverter().fromJson(json['date']),
      organization: json['organization'] as String?,
      id: json['id'] as String?,
    );

Map<String, dynamic> _$$CertificationImplToJson(_$CertificationImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'date': const TimestampConverter().toJson(instance.date),
      'organization': instance.organization,
      'id': instance.id,
    };
