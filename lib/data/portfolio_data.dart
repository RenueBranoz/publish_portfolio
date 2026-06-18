import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:cyber_portfolio/data/models/skill_model.dart';
import 'package:cyber_portfolio/data/models/project_model.dart';
import 'package:cyber_portfolio/data/models/certification_model.dart';
import 'package:cyber_portfolio/data/models/timeline_model.dart';
import 'package:cyber_portfolio/data/models/testimonial_model.dart';
import 'package:cyber_portfolio/core/theme/app_colors.dart';

class PortfolioData {
  PortfolioData._();

  // ---------------- Personal Info (Hero) ----------------
  static const String fullName = 'Sriraj Renue Branoz';
  static const String title =
      'Network Engineer | Cybersecurity Enthusiast | Digital Forensics Researcher';
  static const String tagline =
      'Building secure networks, protecting digital assets, and engineering resilient digital infrastructures through networking, cybersecurity, digital forensics, and cloud technologies.';
  static const String professionalSummary =
      'Passionate ICT undergraduate specializing in network engineering, cybersecurity, digital forensics, and cloud infrastructure. Experienced in designing enterprise network solutions, security assessments, Linux server administration, and modern network technologies. Dedicated to continuous learning, leadership development, and leveraging technology to create secure and efficient digital environments.';

  static const String profileImagePath =
      'assets/images/profile_placeholder.png';
  static const String cvAssetPath = 'assets/cv/cv_placeholder.pdf';

  // ---------------- About Stats Metrics ----------------
  static const List<Map<String, dynamic>> aboutStats = [
    {
      'label': 'Network Engineering',
      'value': '90%',
      'icon': FontAwesomeIcons.networkWired
    },
    {
      'label': 'Cybersecurity',
      'value': '85%',
      'icon': FontAwesomeIcons.shieldHalved
    },
    {
      'label': 'Digital Forensics',
      'value': '80%',
      'icon': FontAwesomeIcons.magnifyingGlass
    },
    {'label': 'Linux & Cloud', 'value': '90%', 'icon': FontAwesomeIcons.linux},
  ];

  static const String aboutBio = '''
I am Sriraj Renue Branoz, an ICT undergraduate with a strong passion for networking, cybersecurity, digital forensics, cloud computing, and emerging technologies. My academic and practical experiences have enabled me to develop skills in network design, security implementation, Linux server administration, and digital investigations.

Throughout my undergraduate journey, I have actively engaged in network engineering projects involving routing, switching, VLAN implementation, OSPF configuration, and network troubleshooting. I have also explored cybersecurity domains including penetration testing, vulnerability assessment, security hardening, and secure infrastructure deployment.

My technical interests extend into digital forensics, where I study evidence acquisition, network forensics, and forensic investigation methodologies. Additionally, I maintain hands-on experience with Linux environments, VPS administration, Xray-core deployments, cloud infrastructure, and secure remote access solutions.

Beyond technology, I am deeply involved in leadership and community service activities. Through youth leadership programs, social welfare initiatives, blood donation campaigns, and educational support projects, I have developed strong communication, coordination, and problem-solving abilities.
''';

  // ---------------- Skills Matrix ----------------
  static const List<SkillCategory> skillCategories = [
    SkillCategory(
      title: 'Networking',
      icon: FontAwesomeIcons.networkWired,
      accentColor: AppColors.cyberBlue,
      skills: [
        Skill(name: 'Cisco Routing & Switching', proficiency: 0.90),
        Skill(name: 'TCP/IP Networking', proficiency: 0.90),
        Skill(name: 'Network Troubleshooting', proficiency: 0.89),
        Skill(name: 'OSPF Configuration', proficiency: 0.88),
        Skill(name: 'VLAN Design & Implementation', proficiency: 0.87),
        Skill(name: 'Network Security', proficiency: 0.86),
        Skill(name: 'DHCP Services', proficiency: 0.85),
        Skill(name: 'DNS Services', proficiency: 0.84),
      ],
    ),
    SkillCategory(
      title: 'Cybersecurity',
      icon: FontAwesomeIcons.shieldHalved,
      accentColor: AppColors.cyberGreen,
      skills: [
        Skill(name: 'Security Hardening', proficiency: 0.86),
        Skill(name: 'Vulnerability Assessment', proficiency: 0.84),
        Skill(name: 'Penetration Testing', proficiency: 0.82),
        Skill(name: 'Ethical Hacking', proficiency: 0.82),
        Skill(name: 'Web Application Security', proficiency: 0.78),
        Skill(name: 'Threat Analysis', proficiency: 0.75),
        Skill(name: 'Incident Response Fundamentals', proficiency: 0.72),
      ],
    ),
    SkillCategory(
      title: 'Digital Forensics',
      icon: FontAwesomeIcons.magnifyingGlass,
      accentColor: AppColors.cyberPurple,
      skills: [
        Skill(name: 'Forensic Investigation Procedures', proficiency: 0.80),
        Skill(name: 'Network Forensics', proficiency: 0.78),
        Skill(name: 'Evidence Collection', proficiency: 0.75),
        Skill(name: 'Disk Forensics', proficiency: 0.73),
        Skill(name: 'Memory Analysis', proficiency: 0.70),
      ],
    ),
    SkillCategory(
      title: 'Cloud & Infrastructure',
      icon: FontAwesomeIcons.cloud,
      accentColor: AppColors.cyberBlue,
      skills: [
        Skill(name: 'VPS Administration', proficiency: 0.90),
        Skill(name: 'Linux Server Management', proficiency: 0.88),
        Skill(name: 'Infrastructure Deployment', proficiency: 0.84),
        Skill(name: 'Google Cloud Fundamentals', proficiency: 0.78),
        Skill(name: 'Cloud Security', proficiency: 0.76),
      ],
    ),
    SkillCategory(
      title: 'Programming',
      icon: FontAwesomeIcons.code,
      accentColor: AppColors.cyberGreen,
      skills: [
        Skill(name: 'SQL', proficiency: 0.86),
        Skill(name: 'PHP', proficiency: 0.84),
        Skill(name: 'Java', proficiency: 0.82),
        Skill(name: 'Python', proficiency: 0.80),
        Skill(name: 'JavaScript', proficiency: 0.75),
        Skill(name: 'Flutter', proficiency: 0.72),
      ],
    ),
  ];

  // ---------------- Certifications ----------------
  static const List<Certification> certifications = [
    Certification(
      title: 'Cisco Networking Academy Training',
      issuer: 'Cisco Networking Academy',
      date: 'In Progress',
      imagePath: 'assets/images/cert_placeholder.png',
    ),
    Certification(
      title: 'Cybersecurity Fundamentals',
      issuer: 'Self-Learning / Online Training',
      date: 'Ongoing',
      imagePath: 'assets/images/cert_placeholder.png',
    ),
    Certification(
      title: 'Linux Administration Training',
      issuer: 'Self-Learning / Online Training',
      date: 'Ongoing',
      imagePath: 'assets/images/cert_placeholder.png',
    ),
    Certification(
      title: 'Ethical Hacking & Security Learning',
      issuer: 'Self-Learning / Online Training',
      date: 'Ongoing',
      imagePath: 'assets/images/cert_placeholder.png',
    ),
    Certification(
      title: 'Digital Forensics Learning Path',
      issuer: 'Self-Learning / Online Training',
      date: 'Ongoing',
      imagePath: 'assets/images/cert_placeholder.png',
    ),
  ];

  // ---------------- Featured Projects ----------------
  static const List<Project> projects = [
    Project(
      title: 'Enterprise Network Infrastructure Design',
      description:
          'Designed and configured enterprise-level network infrastructures using Cisco technologies. Implemented routing protocols, VLAN segmentation, IP addressing schemes, and network optimization strategies while ensuring reliability and scalability.',
      technologies: [
        'Cisco Packet Tracer',
        'OSPF',
        'VLAN',
        'Routing',
        'Switching',
        'TCP/IP',
        'Network Security'
      ],
      imagePath: 'assets/images/project_placeholder.png',
      githubUrl: null,
    ),
    Project(
      title: 'Secure VPS Infrastructure Deployment',
      description:
          'Configured and managed cloud-hosted VPS infrastructures with Xray-core, secure tunneling technologies, DNS optimization, routing policies, WARP integration, and Linux server hardening to provide secure and high-performance connectivity.',
      technologies: [
        'Linux',
        'VPS',
        'Xray-Core',
        'WireGuard',
        'Cloudflare WARP',
        'DNS',
        'Security Hardening'
      ],
      imagePath: 'assets/images/project_placeholder.png',
      githubUrl: null,
    ),
    Project(
      title: 'VLESS + Reality Network Security Deployment',
      description:
          'Implemented advanced Xray-core configurations using VLESS and Reality protocols to enhance security, privacy, performance, and traffic obfuscation while maintaining efficient routing and accessibility.',
      technologies: [
        'Xray-Core',
        'VLESS',
        'Reality',
        'TLS',
        'Linux',
        'VPS Security'
      ],
      imagePath: 'assets/images/project_placeholder.png',
      githubUrl: null,
    ),
    Project(
      title: 'Digital Forensics Investigation Laboratory',
      description:
          'Conducted digital forensic investigations focusing on evidence collection, traffic analysis, system examination, and forensic reporting using industry-standard methodologies and tools.',
      technologies: [
        'Digital Forensics',
        'Wireshark',
        'Linux',
        'Network Analysis',
        'Investigation'
      ],
      imagePath: 'assets/images/project_placeholder.png',
      githubUrl: null,
    ),
    Project(
      title: 'Learning Management System',
      description:
          'Designed and developed a learning management platform to support educational activities, content delivery, and user management while applying software engineering principles.',
      technologies: ['PHP', 'MySQL', 'HTML', 'CSS', 'JavaScript'],
      imagePath: 'assets/images/project_placeholder.png',
      githubUrl: null,
    ),
    Project(
      title: 'Bookstore Management System',
      description:
          'Developed a web-based bookstore application with inventory management, customer interactions, database integration, and responsive user interfaces.',
      technologies: ['PHP', 'MySQL', 'Bootstrap', 'JavaScript'],
      imagePath: 'assets/images/project_placeholder.png',
      githubUrl: null,
    ),
  ];

  // ---------------- Academic & Professional Timeline ----------------
  static const List<TimelineEntry> experienceTimeline = [
    TimelineEntry(
      title: 'ICT Undergraduate',
      subtitle: 'South Eastern University of Sri Lanka',
      period: 'Present',
      description:
          'Pursuing undergraduate studies in Information and Communication Technology with strong focus areas in networking, cybersecurity, cloud infrastructure, digital forensics, and software development.',
      icon: FontAwesomeIcons.graduationCap,
    ),
    TimelineEntry(
      title: 'Network Engineering Studies',
      subtitle: 'Core Focus',
      period: '2024 — Present',
      description:
          'Completed practical networking laboratories involving routers, switches, VLANs, OSPF, and network troubleshooting.',
      icon: FontAwesomeIcons.networkWired,
    ),
    TimelineEntry(
      title: 'Cybersecurity Studies',
      subtitle: 'Core Focus',
      period: '2024 — Present',
      description:
          'Focused on ethical hacking, penetration testing, vulnerability assessment, and security best practices.',
      icon: FontAwesomeIcons.shieldHalved,
    ),
    TimelineEntry(
      title: 'Linux Server Administration',
      subtitle: 'Technical Experience',
      period: '2025 — Present',
      description:
          'Managing VPS infrastructures, security configurations, networking services, and performance optimization.',
      icon: FontAwesomeIcons.linux,
    ),
  ];

  // ---------------- Leadership / Volunteer Milestones ----------------
  static const List<TimelineEntry> leadershipActivities = [
    TimelineEntry(
      title: 'Catholic Youth Association Leadership',
      subtitle: 'Youth Leadership',
      period: 'Ongoing',
      description:
          'Coordinating youth activities, leadership development programs, and community engagement initiatives.',
      icon: FontAwesomeIcons.userGroup,
    ),
    TimelineEntry(
      title: 'Saint Vincent de Paul Social Welfare Activities',
      subtitle: 'Social Welfare',
      period: 'Ongoing',
      description:
          'Participating in welfare projects aimed at supporting disadvantaged communities and students.',
      icon: FontAwesomeIcons.handsHolding,
    ),
    TimelineEntry(
      title: 'Blood Donation Campaign Coordination',
      subtitle: 'Social Welfare',
      period: 'Ongoing',
      description:
          'Assisting in organizing blood donation drives and public awareness activities.',
      icon: FontAwesomeIcons.heartPulse,
    ),
    TimelineEntry(
      title: 'Educational Support Initiatives',
      subtitle: 'Community Development',
      period: 'Ongoing',
      description:
          'Working on programs that improve educational opportunities and living conditions for underprivileged students.',
      icon: FontAwesomeIcons.bookOpen,
    ),
  ];

  // ---------------- Terminal Section Commands ----------------
  static const List<Map<String, String>> terminalCommands = [
    {
      'cmd': 'whoami',
      'output':
          'Sriraj Renue Branoz\nICT Undergraduate | Network Engineer | Cybersecurity Enthusiast'
    },
    {
      'cmd': 'skills --list',
      'output':
          '• Networking\n• Cybersecurity\n• Digital Forensics\n• Linux Administration\n• Cloud Infrastructure\n• Programming\n• Leadership'
    },
    {
      'cmd': 'show projects',
      'output':
          '• Enterprise Network Infrastructure Design\n• Secure VPS Infrastructure Deployment\n• VLESS + Reality Security Deployment\n• Digital Forensics Investigation Lab\n• Learning Management System\n• Bookstore Management System'
    },
    {
      'cmd': 'show certifications',
      'output':
          '• Cisco Networking Academy Training\n• Cybersecurity Fundamentals\n• Linux Administration Training\n• Ethical Hacking Learning Path\n• Digital Forensics Learning Path'
    },
    {
      'cmd': 'contact --info',
      'output':
          'Available for internships, networking projects, cybersecurity research collaborations, and technology-driven initiatives.'
    },
    {
      'cmd': 'mission',
      'output':
          'To build secure digital infrastructures, continuously expand technical expertise, and create positive impact through leadership, technology, and community service.'
    },
  ];

  // Fallback placeholder list for UI rendering requirements
  static const List<Testimonial> testimonials = [];
}
