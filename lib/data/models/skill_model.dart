import 'package:flutter/material.dart';

/// Represents a single skill with a proficiency level (0.0 - 1.0)
/// used for progress circles / bars / radar chart points.
class Skill {
  final String name;
  final double proficiency; // 0.0 to 1.0
  final IconData? icon;

  const Skill({
    required this.name,
    required this.proficiency,
    this.icon,
  });
}

/// A category grouping multiple skills, e.g. "Networking", "Cybersecurity".
class SkillCategory {
  final String title;
  final IconData icon;
  final Color accentColor;
  final List<Skill> skills;

  const SkillCategory({
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.skills,
  });
}
