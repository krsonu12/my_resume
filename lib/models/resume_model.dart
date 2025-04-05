class Resume {
  final String name;
  final PersonalInfo personalInfo;
  final String summary;
  final List<Skill> skills;
  final List<WorkExperience> workExperience;
  final List<EducationEntry> educationEntries;
  final List<String> languages;
  final List<String> websites;
  final List<Certification> certifications;

  Resume({
    required this.name,
    required this.personalInfo,
    required this.summary,
    required this.skills,
    required this.workExperience,
    required this.educationEntries,
    required this.languages,
    required this.websites,
    required this.certifications,
  });
}

class PersonalInfo {
  final String email;
  final String phone;
  final String location;
  final String pincode;

  const PersonalInfo({
    required this.email,
    required this.phone,
    required this.location,
    required this.pincode,
  });
}

class Skill {
  final String name;
  final String? category;

  const Skill({
    required this.name,
    this.category,
  });
}

class WorkExperience {
  final String company;
  final String position;
  final String location;
  final DateTime startDate;
  final DateTime? endDate;
  final List<String> responsibilities;
  final List<String>? technologies;
  final String? description;

  WorkExperience({
    required this.company,
    required this.position,
    required this.location,
    required this.startDate,
    this.endDate,
    required this.responsibilities,
    this.technologies,
    this.description,
  });
}

class EducationEntry {
  final String degree;
  final String institution;
  final String location;
  final DateTime graduationDate;
  final String? fieldOfStudy;

  EducationEntry({
    required this.degree,
    required this.institution,
    required this.location,
    required this.graduationDate,
    this.fieldOfStudy,
  });
}

class Certification {
  final String name;
  final DateTime date;
  final String? organization;
  final String? id;

  Certification({
    required this.name,
    required this.date,
    this.organization,
    this.id,
  });
}
