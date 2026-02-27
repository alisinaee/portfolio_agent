import 'package:flutter/foundation.dart';

enum PortfolioSectionId {
  about,
  contact,
  experience,
  skills,
  achievements,
  packages,
  focus,
}

@immutable
class PortfolioSnapshot {
  const PortfolioSnapshot({
    required this.fullName,
    required this.headline,
    required this.location,
    required this.resumeUrl,
    required this.heroLinks,
    required this.profile,
    required this.contactLinks,
    required this.experiences,
    required this.skillGroups,
    required this.achievementGroups,
    required this.packageGroup,
    required this.currentFocus,
  });

  final String fullName;
  final String headline;
  final String location;
  final String resumeUrl;
  final List<ContactLink> heroLinks;
  final ProfileInfo profile;
  final List<ContactLink> contactLinks;
  final List<ExperienceItem> experiences;
  final List<SkillGroup> skillGroups;
  final List<AchievementGroup> achievementGroups;
  final PackageGroup packageGroup;
  final List<String> currentFocus;
}

@immutable
class ProfileInfo {
  const ProfileInfo({required this.fields});

  final List<ProfileField> fields;
}

@immutable
class ProfileField {
  const ProfileField({required this.label, required this.value});

  final String label;
  final String value;
}

@immutable
class ContactLink {
  const ContactLink({required this.label, required this.value, this.url});

  final String label;
  final String value;
  final String? url;
}

@immutable
class SkillGroup {
  const SkillGroup({required this.title, required this.items, this.subtitle});

  final String title;
  final String? subtitle;
  final List<String> items;
}

@immutable
class ExperienceItem {
  const ExperienceItem({
    required this.role,
    required this.period,
    required this.company,
    required this.location,
    required this.project,
    required this.projectSummary,
    required this.responsibilities,
    required this.architectureAndTools,
    required this.platforms,
    required this.technologies,
    required this.relatedLinks,
    required this.keyAchievements,
  });

  final String role;
  final String period;
  final String company;
  final String location;
  final String project;
  final String projectSummary;
  final List<String> responsibilities;
  final List<String> architectureAndTools;
  final String platforms;
  final List<String> technologies;
  final List<ContactLink> relatedLinks;
  final List<String> keyAchievements;
}

@immutable
class AchievementGroup {
  const AchievementGroup({required this.title, required this.items});

  final String title;
  final List<String> items;
}

@immutable
class PackageGroup {
  const PackageGroup({required this.title, required this.groups});

  final String title;
  final List<SkillGroup> groups;
}
