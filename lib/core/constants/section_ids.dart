/// Identifiers for each scrollable section, used by the nav bar /
/// scroll_to_index controller to jump to the right place.
class SectionId {
  SectionId._();

  static const int hero = 0;
  static const int about = 1;
  static const int skills = 2;
  static const int certifications = 3;
  static const int projects = 4;
  static const int experience = 5;
  static const int leadership = 6;
  static const int techStack = 7;
  static const int terminal = 8;
  static const int testimonials = 9;
  static const int contact = 10;

  static const Map<int, String> labels = {
    hero: 'Home',
    about: 'About',
    skills: 'Skills',
    certifications: 'Certifications',
    projects: 'Projects',
    experience: 'Experience',
    leadership: 'Leadership',
    techStack: 'Tech Stack',
    terminal: 'Terminal',
    testimonials: 'Testimonials',
    contact: 'Contact',
  };
}
