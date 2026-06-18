import 'package:flutter/material.dart';

/// Represents a single timeline entry for the Experience section,
/// or an achievement card for the Leadership section.
class TimelineEntry {
  final String title;
  final String subtitle;
  final String period;
  final String description;
  final IconData icon;

  const TimelineEntry({
    required this.title,
    required this.subtitle,
    required this.period,
    required this.description,
    required this.icon,
  });
}
