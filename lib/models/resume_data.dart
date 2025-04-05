import 'package:my_portfolio/models/resume_model.dart';

class ResumeData {
  static Resume getResume() {
    return Resume(
      name: 'Sonu Kumar Paswan',
      personalInfo: const PersonalInfo(
        email: 'krsonu12996@gmail.com',
        phone: '+919525599153',
        location: 'Jamshedpur, Jharkhand',
        pincode: '832108',
      ),
      summary:
          'Senior Software Engineer with a proven track record at Creativebuzz Solutions Pvt Ltd, specializing in cloud integrations and IAM. Expert in AWS and GCP, I excel in automating data synchronization and enhancing security protocols. A collaborative problem-solver, I deliver efficient, scalable solutions that drive business success.',
      skills: [
        const Skill(name: 'Sailpoint'),
        const Skill(name: 'Azure AD'),
        const Skill(name: 'SNOW'),
        const Skill(name: 'CherWell'),
        const Skill(name: 'IDAM'),
        const Skill(name: 'AWS'),
        const Skill(name: 'IAM'),
        const Skill(name: 'GitHub'),
        const Skill(name: 'GCP'),
        const Skill(name: 'Cloud Admin'),
      ],
      workExperience: [
        WorkExperience(
          company: 'Creativebuzz Solutions Pvt Ltd',
          position: 'Senior Software Engineer',
          location: 'Ghaziabad, India',
          startDate: DateTime(2024, 11),
          endDate: null, // Current
          responsibilities: [
            'Designed and deployed system integrations using APIs, webhooks, and cloud functions across AWS, GCP, Firebase, and Supabase.',
            'Automated data synchronization between multiple cloud platforms using event-driven architectures (AWS Lambda, GCP Pub/Sub, Firebase Functions).',
            'Ensured secure data handling with IAM policies, OAuth, JWT authentication, and role-based access control (RBAC).',
            'Integrated cloud storage solutions (AWS S3, GCP Storage, Firebase Storage) with efficient data access and security controls.',
          ],
        ),
        WorkExperience(
          company: 'Cookytech Technology Pvt Ltd',
          position: 'Associate Software Engineer',
          location: 'Kolkata, IN',
          startDate: DateTime(2022, 12),
          endDate: DateTime(2024, 11),
          responsibilities: [
            'System Integration & Cloud Services Experience',
            'AWS: Integrated IAM roles, S3 storage, Lambda functions, RDS, and CloudWatch for seamless cloud-based solutions.',
            'GCP: Implemented secure authentication and access control using GCP IAM, integrated CI/CD with GitHub',
            'Firebase: Developed and connected Firestore, Authentication, Cloud Functions, and Realtime Database',
            'Supabase: Configured PostgreSQL database, authentication, and edge functions for serverless backend solutions, with real-time capabilities.',
          ],
        ),
        WorkExperience(
          company: 'Khetan Group Of Industries',
          position: 'Cloud Administrator',
          location: 'Jamshedpur, India',
          startDate: DateTime(2021, 9),
          endDate: DateTime(2022, 12),
          responsibilities: [
            'Working over 15+ SaaS Sites (Administrative, Self-Registration, Admin+Self Register sites)',
            'Working on Cloud AD for manipulating user\'s data',
            'Checking for user\'s access roles and groups with Azure AD',
            'Doing Manual Provisioning De-provisioning',
            'Creating Groups, User Delegation, Modification of access',
            'Resetting passwords and managing user\'s directories with Azure AD',
            'Working on On-Boarding to Off-Boarding (whole Life Cycle Management of IAM) of used on systems',
            'Helping Users with their issues and solving with using ERPNext',
            'Support 24x7 to our client by collaboratively working with various teams, and providing services',
          ],
        ),
      ],
      educationEntries: [
        EducationEntry(
          degree: 'Bachelor',
          institution: 'Shree Krishna University',
          location: 'Chhatarpur, MP',
          graduationDate: DateTime(2021, 12),
          fieldOfStudy: 'Computer Application',
        ),
        EducationEntry(
          degree: 'Intermediate',
          institution: 'Karim City Collage',
          location: 'Jamshedpur, Jharkhand',
          graduationDate: DateTime(2014, 5),
          fieldOfStudy: 'Science',
        ),
      ],
      languages: ['Hindi: First Language', 'English: Intermediate (B1)'],
      websites: ['linkedin.com/in/sonu-kumar-paswan83a51178'],
      certifications: [
        Certification(
          name: 'Google analytics certification',
          date: DateTime(2023, 2, 1),
        ),
        Certification(
          name: 'Cyber Security fundamentals Certification',
          date: DateTime(2023, 2, 1),
        ),
      ],
    );
  }
}
