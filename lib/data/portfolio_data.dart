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

  // ---------------- Secure Contact Nodes (Added) ----------------
  static const String email = 'renuebranoz@gmail.com';
  static const String linkedin =
      'https://www.linkedin.com/in/renue-branoz-sriraj-670498159/';
  static const String github = 'https://github.com/RenueBranoz';
  static const String phone = '+94 70 205 4555';
  static const String tryHackMe = 'https://tryhackme.com/p/renuebranoz';
  static const String hackTheBox =
      'https://profile.hackthebox.com/profile/019dfdc9-8bf1-7288-9221-d9a251829b0b';

  // ---------------- Personal Info (Hero) ----------------
  static const String fullName = 'Sriraj Renue Branoz';
  static const String title =
      'ICT Undergraduate | Cybersecurity Researcher | SOC & Detection Engineering | Digital Forensics';

  static const String tagline =
      'Building enterprise security environments, validating attack simulations, and engineering detections to strengthen modern cyber defense.';

  static const String professionalSummary =
      'Cybersecurity-focused ICT undergraduate specializing in Security Operations (SOC), detection engineering, digital forensics, enterprise networking, and cloud infrastructure. Experienced in designing enterprise virtual SOC environments using Splunk SIEM, OPNsense Firewall, Windows Server Active Directory, Linux servers, and virtualization technologies. Passionate about attack simulation, security monitoring, threat detection, incident investigation, and developing practical defensive solutions through continuous research and hands-on cybersecurity projects.';
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
I am Sriraj Renue Branoz, an Information and Communication Technology (ICT) undergraduate with a strong passion for network, cybersecurity, digital forensics, cloud computing, and emerging technologies. I am dedicated to building secure, reliable, and efficient digital infrastructures while continuously expanding my technical expertise through hands-on projects and research.

Throughout my academic journey, I have gained practical experience in network design, routing and switching, VLAN implementation, OSPF configuration, network troubleshooting, and infrastructure security. My interest in cybersecurity has led me to explore areas such as penetration testing, vulnerability assessment, security hardening, and secure network architecture, allowing me to develop a solid foundation in protecting digital systems and data.

I am also passionate about digital forensics, where I focus on evidence acquisition, network forensics, and investigative methodologies used to analyze and respond to security incidents. In addition, I have hands-on experience with Linux server administration, VPS management, cloud-based infrastructure, Xray-core deployments, and secure remote access technologies.

Beyond my technical pursuits, I actively contribute to leadership and community development initiatives. Through youth leadership programs, social welfare projects and educational support activities, I have strengthened my skills in communication, teamwork, coordination, and problem-solving. These experiences have reinforced my belief that technology and leadership can work together to create meaningful and lasting positive impact.

My goal is to establish myself as a skilled network and security professional, contributing to the development of secure digital ecosystems while using technology to solve real-world challenges and support communities.''';

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
        title: 'Introduction to Cybersecurity',
        issuer: 'Cisco Networking Academy',
        date: '2026',
        imagePath: 'assets/images/cyber.png',
        pdfPath: 'assets/pdfs/cyb.pdf'),
    Certification(
        title: 'CCNAv7: Introduction to Networks',
        issuer: 'Cisco Networking Academy',
        date: '2024',
        imagePath: 'assets/images/introtonet.png',
        pdfPath:
            'assets/pdfs/CCNA-_Introduction_to_Networks_certificate_renuebranoz-gmail-com_81ecb9e1-6f46-47a0-af94-681716d5581a.pdf'),
    Certification(
        title: 'CCNAv7: Switching, Routing, and Wireless Essentials',
        issuer: 'Cisco Networking Academy',
        date: '2025',
        imagePath: 'assets/images/switching.png',
        pdfPath:
            'assets/pdfs/CCNA-_Switching-_Routing-_and_Wireless_Essentials_certificate_renuebranoz-gmail-com_8136aff0-1b62-46ed-9d1b-030611b093cf.pdf'),
    Certification(
        title: 'Ethical Hacker',
        issuer: 'Cisco Networking Academy',
        date: '2026',
        imagePath: 'assets/images/ethical.png',
        pdfPath:
            'assets/pdfs/Ethical_Hacker_certificate_renuebranoz-gmail-com_2de38956-4166-4140-a241-01a99732b88d.pdf'),
    Certification(
        title: 'Intro to Splunk (eLearning)',
        issuer: 'Splunk',
        date: '2026',
        imagePath: 'assets/images/splunk1.png',
        pdfPath: 'assets/pdfs/splunk1.pdf'),
    Certification(
        title: 'Using Fields (eLearning)',
        issuer: 'Splunk',
        date: '2026',
        imagePath: 'assets/images/splunk2.png',
        pdfPath: 'assets/pdfs/splunk2.pdf'),
    Certification(
        title: 'Digital Forensics & Incident Investigation',
        issuer: 'Red Team Leaders',
        date: '2026',
        imagePath: 'assets/images/forensics.png',
        pdfPath: 'assets/pdfs/digital_forensi_certificate.pdf'),
    Certification(
        title: 'Certified LLM Security Professional (CLLMSP)',
        issuer: 'Red Team Leaders',
        date: '2026',
        imagePath: 'assets/images/llm.png',
        pdfPath: 'assets/pdfs/certified_llm_certificate.pdf'),
    Certification(
        title: 'Mastering Pentest & Red Team Report Writing',
        issuer: 'Red Team Leaders',
        date: '2026',
        imagePath: 'assets/images/pentest.png',
        pdfPath: 'assets/pdfs/mastering_certificate.pdf'),
  ];

  // ---------------- Featured Projects ----------------
  static const List<Project> projects = [
    Project(
      title: '🛡️Enterprise Virtual SOC & Detection Engineering Lab',
      description:
          'Designed and deployed an enterprise-style Virtual Security Operations Center (SOC) environment featuring Active Directory, Windows endpoints, Ubuntu servers, OPNsense Firewall, and Splunk SIEM. Simulated cyber attacks including Nmap reconnaissance and SQL injection to generate security telemetry, engineer SPL detections, and validate SOC monitoring capabilities through a Purple Team methodology.',
      technologies: [
        'Splunk SIEM',
        'OPNsense',
        'Active Directory',
        'Detection Engineering',
        'SPL',
        'SOC',
        'Threat Detection'
      ],
      imagePath: 'assets/images/soc.png',
      githubUrl:
          'https://medium.com/@renuebranoz/building-a-home-soc-lab-a-purple-team-approach-to-detection-engineering-bc68644fdab2',
    ),
    Project(
      title: 'Enterprise Campus Network Design',
      description:
          'Designed and implemented a secure enterprise campus network using Cisco Packet Tracer with VLAN segmentation, Inter-VLAN routing, centralized DHCP/DNS services, SSH-based device management, ACL security policies, and wireless connectivity to simulate a scalable, real-world corporate infrastructure.',
      technologies: [
        'Cisco Packet Tracer'
            'Cisco IOS',
        'VLAN',
        'Inter-VLAN Routing',
        'Layer 3 Switching',
        'DHCP',
        'DNS',
        'ACL',
        'SSH',
        'Wireless LAN'
      ],
      imagePath: 'assets/images/project_placeholder.png',
      githubUrl: 'https://github.com/RenueBranoz/Enterprise-Campus-Network',
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
      title: 'Advanced Level Education',
      subtitle: 'Highlands Central College, Hatton',
      period: '2018 — 2020',
      description:
          'Completed secondary education with a focus on G.C.E. Advanced Level examinations.',
      icon: FontAwesomeIcons.buildingColumns,
    ),
    TimelineEntry(
      title: 'Primary & Secondary Education',
      subtitle: "St. John Bosco's College, Hatton",
      period: '2007 — 2017',
      description:
          'Completed foundational primary education and G.C.E. Ordinary Level examinations.',
      icon: FontAwesomeIcons.school,
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

  static const List<Testimonial> testimonials = [];
}
