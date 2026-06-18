import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:cyber_portfolio/core/theme/app_colors.dart';
import 'package:cyber_portfolio/core/constants/section_ids.dart';
import 'package:cyber_portfolio/providers/scroll_provider.dart';
import 'package:cyber_portfolio/providers/pointer_provider.dart';
import 'package:cyber_portfolio/providers/theme_provider.dart';
import 'package:cyber_portfolio/data/portfolio_data.dart';
import 'package:cyber_portfolio/widgets/painters/particle_background.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late AutoScrollController _scrollController;
  bool _isAvatarHovered = false;
  int? _hoveredNavIndex;

  final TextEditingController _terminalInputController =
      TextEditingController();
  final FocusNode _terminalFocusNode = FocusNode();
  final List<Map<String, String>> _liveTerminalHistory = [];

  @override
  void initState() {
    super.initState();
    _scrollController = AutoScrollController();
    _scrollController.addListener(_onScroll);

    _liveTerminalHistory.addAll([
      {
        'cmd': 'sysboot --verbose',
        'output':
            'KERNEL: MARS OS x86_64 v4.19\nNETSTACK: VLSM MAP DESIGN LOADED CAPABLE\nSTATUS: ONLINE / FIREWALL SECURE'
      },
      {
        'cmd': 'netstat -a',
        'output':
            'PORT 80: LISTENING [HTTP Web Portal]\nPORT 443: SECURE [SSL Active Pipeline]'
      },
    ]);
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    ref.read(scrollProgressProvider.notifier).update(currentScroll, maxScroll);
  }

  Future<void> _scrollToSection(int sectionIndex) async {
    await _scrollController.scrollToIndex(
      sectionIndex,
      preferPosition: AutoScrollPosition.begin,
    );
  }

  void _handleTerminalExecution(String rawInput) {
    final cleanInput = rawInput.trim().toLowerCase();
    if (cleanInput.isEmpty) return;

    String responseText = "";
    switch (cleanInput) {
      case 'help':
        responseText = "AVAILABLE NODE SCRIPTS:\n"
            "  > whoami    - Displays core operator identification profile details.\n"
            "  > education - Parses full academic track and institution grids.\n"
            "  > family    - Prints family parameter configuration lines safely.\n"
            "  > scan      - Runs a local network intrusion topology simulation.\n"
            "  > projects  - Lists all primary production engineering repositories.\n"
            "  > contact   - Reveals secure encrypted connection endpoints.\n"
            "  > clear     - Purges terminal buffer display history.";
        break;
      case 'whoami':
        responseText = "OPERATOR RECORD PARSING:\n"
            "  Full Name  : Shriraj Renue Branoz\n"
            "  Status     : ICT Undergraduate Engineer\n"
            "  Specialty  : Mobile Dev (Flutter/Dart), Cybersecurity, Network Engineering\n"
            "  Frameworks : VLSM Subnet Architectures, Explainable AI (XAI) Threat Detection";
        break;
      case 'education':
        responseText = "ACADEMIC ARCHITECTURE MATRIX:\n"
            "  Degree     : Bachelor of Information and Communication Technology (BICT Hons)\n"
            "  Focus Areas: Advanced Cisco Packet Tracer Routing, Threat Mitigation Simulation, Network Design\n"
            "  Research   : Systematic Literature Review on XAI Implementations in Cyber Threats";
        break;
      case 'family':
        responseText = "SECURE PARAMETERS - FAMILY ENVIRONMENT:\n"
            "  Total Nodes: 5 Members\n"
            "  Head (Node): Father - Active Businessman\n"
            "  Core (Node): Mother - Professional Educator\n"
            "  Peer (Node): Elder Brother - Undergraduate Student, SEUSL";
        break;
      case 'scan':
        responseText = "Scanning routing subnet masks via VLSM allocations...\n"
            "[✓] Gateway node spotted: 192.168.10.1\n"
            "[✓] Packet Tracer target validated: No active DHCP Hijacking spoof detected.\n"
            "[STATUS] LAN TOPOLOGY ENTIRELY COMPLIANT.";
        break;
      case 'projects':
        responseText = "PARSING COMPREHENSIVE PRODUCTION MANIFESTS:\n"
            "  1. Gini Glass POS - Commercial Hardware & Trading Management Application\n"
            "  2. Forensic-Ledger - Blockchain Chain of Custody Proof of Concept\n"
            "  3. Sentinel-Net-IDS - Snort 3 Traffic Analyzer Engine & Intrusion Detection";
        break;
      case 'contact':
        responseText = "SECURE TELEPHONY & MAIL ENDPOINTS:\n"
            "  Email    : sriraj.renue.branoz@gmail.com\n"
            "  GitHub   : github.com/Sriraj-Renue-Branoz\n"
            "  LinkedIn : linkedin.com/in/sriraj-renue-branoz\n"
            "  Signal   : +94 77 123 4567";
        break;
      case 'clear':
        setState(() => _liveTerminalHistory.clear());
        _terminalInputController.clear();
        return;
      default:
        responseText =
            "COMMAND NOT RECOGNIZED. Type 'help' to check the operational security suite directory.";
    }

    setState(() {
      _liveTerminalHistory.add({'cmd': rawInput, 'output': responseText});
    });
    _terminalInputController.clear();
    _terminalFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _terminalInputController.dispose();
    _terminalFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final scrollProgress = ref.watch(scrollProgressProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDarkest : AppColors.bgLight,
      body: MouseRegion(
        onHover: (event) {
          ref
              .read(pointerPositionProvider.notifier)
              .update(event.localPosition);
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: ParticleBackground(isDark: isDark),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.only(top: 70),
                child: SelectionArea(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    itemCount: SectionId.labels.length,
                    itemBuilder: (context, index) {
                      final portfolioSection = _buildPortfolioSection(index);
                      if (portfolioSection == const SizedBox.shrink()) {
                        return const SizedBox.shrink();
                      }

                      return AutoScrollTag(
                        key: ValueKey(index),
                        controller: _scrollController,
                        index: index,
                        child: Center(
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 1440),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 12),
                            child: portfolioSection
                                .animate(key: ValueKey('anim_$index'))
                                .fadeIn(
                                    duration: 600.ms,
                                    curve: Curves.easeOutCubic)
                                .slideY(
                                    begin: 0.1,
                                    end: 0,
                                    duration: 600.ms,
                                    curve: Curves.easeOutCubic),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: AppColors.bgDarkest.withOpacity(0.85),
                  border: const Border(
                      bottom: BorderSide(
                          color: AppColors.glassBorderDark, width: 1)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(FontAwesomeIcons.terminal,
                            color: AppColors.cyberGreen, size: 18),
                        const SizedBox(width: 10),
                        Text(
                          "SRIRAJ.SYS",
                          style: TextStyle(
                              color: AppColors.textWhite,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              fontSize: 16,
                              fontFamily: 'monospace',
                              shadows: [
                                Shadow(
                                    color:
                                        AppColors.cyberGreen.withOpacity(0.4),
                                    blurRadius: 4)
                              ]),
                        ),
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        child: Row(
                          children: [
                            {'id': SectionId.hero, 'name': 'HOME'},
                            {'id': SectionId.about, 'name': 'ABOUT'},
                            {'id': SectionId.skills, 'name': 'SKILLS'},
                            {
                              'id': SectionId.certifications,
                              'name': 'CREDENTIALS'
                            },
                            {'id': SectionId.projects, 'name': 'PROJECTS'},
                            {'id': SectionId.experience, 'name': 'EXPERIENCE'},
                            {'id': SectionId.leadership, 'name': 'LEADERSHIP'},
                            {'id': SectionId.terminal, 'name': 'TERMINAL'},
                            {'id': SectionId.contact, 'name': 'CONTACT'},
                          ].map((item) {
                            final sectionId = item['id'] as int;
                            final labelName = item['name'] as String;
                            final isHovered = _hoveredNavIndex == sectionId;

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: MouseRegion(
                                onEnter: (_) => setState(
                                    () => _hoveredNavIndex = sectionId),
                                onExit: (_) =>
                                    setState(() => _hoveredNavIndex = null),
                                child: TextButton(
                                  onPressed: () => _scrollToSection(sectionId),
                                  style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 12)),
                                  child: AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeOut,
                                    style: TextStyle(
                                      color: isHovered
                                          ? AppColors.cyberBlue
                                          : AppColors.textLightGrey,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                      fontFamily: 'monospace',
                                      shadows: isHovered
                                          ? [
                                              Shadow(
                                                  color: AppColors.cyberBlue
                                                      .withOpacity(0.6),
                                                  blurRadius: 8)
                                            ]
                                          : null,
                                    ),
                                    child: Text(labelName),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 4,
                color: AppColors.cyberBlue.withOpacity(0.1),
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: scrollProgress,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      boxShadow: AppColors.glow(AppColors.cyberBlue, blur: 8),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioSection(int index) {
    switch (index) {
      case SectionId.hero:
        return _buildHeroSection();
      case SectionId.about:
        return _buildAboutSection();
      case SectionId.skills:
        return _buildSkillsSection();
      case SectionId.certifications:
        return _buildCertificationsSection();
      case SectionId.projects:
        return _buildProjectsSection();
      case SectionId.experience:
        return _buildTimelineSection(
            "ACADEMIC & TECHNICAL JOURNEY", PortfolioData.experienceTimeline);
      case SectionId.leadership:
        return _buildTimelineSection("LEADERSHIP & VOLUNTEER MILESTONES",
            PortfolioData.leadershipActivities);
      case SectionId.terminal:
        return _buildTerminalSection();
      case SectionId.contact:
        return _buildContactSection();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildHeroSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 900;

    final infoColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "HI THERE, I'M",
          style: TextStyle(
              color: AppColors.cyberGreen,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              fontSize: 14),
        ),
        const SizedBox(height: 12),
        Text(
          PortfolioData.fullName,
          style: const TextStyle(
              color: AppColors.textWhite,
              fontSize: 44,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1),
        ),
        const SizedBox(height: 8),
        Text(
          PortfolioData.title,
          style: const TextStyle(
              color: AppColors.cyberBlue,
              fontSize: 18,
              fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 20),
        Text(
          PortfolioData.tagline,
          style: const TextStyle(
              color: AppColors.textLightGrey, fontSize: 15, height: 1.5),
        ),
        const SizedBox(height: 16),
        Text(
          PortfolioData.professionalSummary,
          style: const TextStyle(
              color: AppColors.textMuted, fontSize: 14, height: 1.5),
        ),
        const SizedBox(height: 40),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.cyberBlue,
                foregroundColor: AppColors.bgDarkest,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => _scrollToSection(SectionId.terminal),
              icon: const Icon(Icons.download),
              label: const Text("Download Resume",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side:
                    const BorderSide(color: AppColors.cyberPurple, width: 1.5),
                foregroundColor: AppColors.textWhite,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => _scrollToSection(SectionId.projects),
              child: const Text("View Projects",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        )
      ],
    );

    final avatarFrame = Center(
      child: MouseRegion(
        onEnter: (_) => setState(() => _isAvatarHovered = true),
        onExit: (_) => setState(() => _isAvatarHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: _isAvatarHovered ? 340 : 320,
          height: _isAvatarHovered ? 340 : 320,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.primaryGradient,
            boxShadow: AppColors.glow(AppColors.cyberBlue,
                blur: _isAvatarHovered ? 36 : 24),
          ),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: AppColors.bgDarkest),
            clipBehavior: Clip.antiAlias,
            child: AnimatedScale(
              scale: _isAvatarHovered ? 1.06 : 1.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              alignment: Alignment.center,
              child: Container(
                decoration: const BoxDecoration(shape: BoxShape.circle),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  'assets/images/profile_placeholder.png',
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  // INNOVATION: Live Matrix code drops rain fallback loader if local image path fails
                  errorBuilder: (context, error, stackTrace) {
                    return const _MatrixRainFallback();
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 64),
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.bgDark.withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.glassBorderDark),
      ),
      child: isMobile
          ? Column(
              children: [
                avatarFrame,
                const SizedBox(height: 48),
                infoColumn,
              ],
            )
          : Row(
              children: [
                Expanded(flex: 3, child: infoColumn),
                const SizedBox(width: 40),
                Expanded(flex: 2, child: avatarFrame),
              ],
            ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      padding: const EdgeInsets.all(40),
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.bgDark.withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.glassBorderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "ABOUT ME",
            style: TextStyle(
                color: AppColors.cyberPurple,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5),
          ),
          const SizedBox(height: 24),
          Text(
            PortfolioData.aboutBio,
            style: const TextStyle(
                color: AppColors.textLightGrey, fontSize: 15, height: 1.6),
          ),
          const SizedBox(height: 40),
          Center(
            child: Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: PortfolioData.aboutStats.map((stat) {
                return Container(
                  width: 204,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.glassFillDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.glassBorderDark),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(stat['icon'] as IconData,
                          color: AppColors.cyberGreen, size: 24),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              stat['value'].toString(),
                              style: const TextStyle(
                                  color: AppColors.textWhite,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              stat['label'].toString(),
                              style: const TextStyle(
                                  color: AppColors.textMuted, fontSize: 11),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSkillsSection() {
    return Container(
      padding: const EdgeInsets.all(40),
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.bgDark.withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.glassBorderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "TECHNICAL SKILLS MATRIX",
            style: TextStyle(
                color: AppColors.cyberGreen,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5),
          ),
          const SizedBox(height: 32),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: PortfolioData.skillCategories.length,
            itemBuilder: (context, catIndex) {
              final category = PortfolioData.skillCategories[catIndex];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(category.icon,
                          color: category.accentColor, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        category.title.toUpperCase(),
                        style: TextStyle(
                            color: category.accentColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: category.skills.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 420,
                      mainAxisExtent: 64,
                      crossAxisSpacing: 24,
                    ),
                    itemBuilder: (context, skillIndex) {
                      final skill = category.skills[skillIndex];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(skill.name,
                                  style: const TextStyle(
                                      color: AppColors.textLightGrey,
                                      fontSize: 13)),
                              Text("${(skill.proficiency * 100).toInt()}%",
                                  style: TextStyle(
                                      color: category.accentColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: skill.proficiency,
                            backgroundColor: AppColors.bgDarkest,
                            color: category.accentColor,
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCertificationsSection() {
    return Container(
      padding: const EdgeInsets.all(40),
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.bgDark.withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.glassBorderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "ACADEMIC & PROFESSIONAL TRAINING",
            style: TextStyle(
                color: AppColors.cyberBlue,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5),
          ),
          const SizedBox(height: 32),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: PortfolioData.certifications.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 440,
              mainAxisExtent: 170,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
            ),
            itemBuilder: (context, index) {
              final cert = PortfolioData.certifications[index];
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.glassFillDark,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.glassBorderDark),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(FontAwesomeIcons.certificate,
                        color: AppColors.cyberBlue, size: 22),
                    const SizedBox(height: 12),
                    Text(cert.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: AppColors.textWhite,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(cert.issuer,
                        style: const TextStyle(
                            color: AppColors.textMuted, fontSize: 12)),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: AppColors.bgDarkest,
                          borderRadius: BorderRadius.circular(4)),
                      child: Text(cert.date,
                          style: const TextStyle(
                              color: AppColors.cyberGreen,
                              fontSize: 10,
                              fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsSection() {
    return Container(
      padding: const EdgeInsets.all(40),
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.bgDark.withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.glassBorderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "FEATURED ENGINEERING PROJECTS",
            style: TextStyle(
                color: AppColors.cyberGreen,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5),
          ),
          const SizedBox(height: 32),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: PortfolioData.projects.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 440,
              mainAxisExtent: 250,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
            ),
            itemBuilder: (context, index) {
              final project = PortfolioData.projects[index];
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.glassFillDark,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.glassBorderDark),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(project.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: AppColors.textWhite,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Text(
                        project.description,
                        style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 13,
                            height: 1.5),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: project.technologies.map((tech) {
                          return Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                                color: AppColors.cyberPurple.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                    color: AppColors.cyberPurple
                                        .withOpacity(0.3))),
                            child: Text(tech,
                                style: const TextStyle(
                                    color: AppColors.textWhite, fontSize: 11)),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildTimelineSection(String title, List<dynamic> records) {
    return Container(
      padding: const EdgeInsets.all(40),
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.bgDark.withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.glassBorderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: AppColors.cyberPurple,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.3)),
          const SizedBox(height: 32),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final item = records[index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.bgDarkest,
                            border: Border.all(
                                color: AppColors.cyberPurple, width: 1.5)),
                        child: Icon(item.icon,
                            color: AppColors.cyberPurple, size: 14),
                      ),
                      if (index != records.length - 1)
                        Container(
                            width: 2,
                            height: 70,
                            color: AppColors.cyberPurple.withOpacity(0.3)),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(item.title,
                                    style: const TextStyle(
                                        color: AppColors.textWhite,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Text(item.period,
                                  style: const TextStyle(
                                      color: AppColors.cyberGreen,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(item.subtitle,
                              style: const TextStyle(
                                  color: AppColors.cyberBlue,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(height: 8),
                          Text(item.description,
                              style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 13,
                                  height: 1.5)),
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildTerminalSection() {
    return Container(
      padding: const EdgeInsets.all(40),
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.bgDark.withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.glassBorderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("INTERACTIVE SYSTEM TERMINAL",
              style: TextStyle(
                  color: AppColors.cyberGreen,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5)),
          const SizedBox(height: 6),
          const Text(
              "Click inside the guest console input node below and type 'help' to run network scripts.",
              style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: AppColors.cyberGreen.withOpacity(0.4))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ..._liveTerminalHistory.map((block) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text("guest@sriraj-portfolio:~\$ ",
                                style: TextStyle(
                                    color: AppColors.cyberPurple,
                                    fontFamily: 'monospace',
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold)),
                            Text(block['cmd'] ?? '',
                                style: const TextStyle(
                                    color: AppColors.textWhite,
                                    fontFamily: 'monospace',
                                    fontSize: 13)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(block['output'] ?? '',
                            style: const TextStyle(
                                color: AppColors.cyberGreen,
                                fontFamily: 'monospace',
                                fontSize: 13,
                                height: 1.4)),
                      ],
                    ),
                  );
                }),
                Row(
                  children: [
                    const Text("guest@sriraj-portfolio:~\$ ",
                        style: TextStyle(
                            color: AppColors.cyberPurple,
                            fontFamily: 'monospace',
                            fontSize: 13,
                            fontWeight: FontWeight.bold)),
                    Expanded(
                      child: TextField(
                        controller: _terminalInputController,
                        focusNode: _terminalFocusNode,
                        onSubmitted: _handleTerminalExecution,
                        cursorColor: AppColors.cyberGreen,
                        style: const TextStyle(
                            color: AppColors.textWhite,
                            fontFamily: 'monospace',
                            fontSize: 13),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    final contactChannels = [
      {
        'label': 'Email Link',
        'val': 'sriraj.renue.branoz@gmail.com',
        'icon': Icons.email,
        'color': AppColors.cyberBlue
      },
      {
        'label': 'LinkedIn Secure Connection',
        'val': 'linkedin.com/in/sriraj-renue-branoz',
        'icon': FontAwesomeIcons.linkedin,
        'color': AppColors.cyberGreen
      },
      {
        'label': 'GitHub Repository Hub',
        'val': 'github.com/Sriraj-Renue-Branoz',
        'icon': FontAwesomeIcons.github,
        'color': AppColors.cyberPurple
      },
      {
        'label': 'Secure Telephony Node',
        'val': '+94 77 123 4567',
        'icon': Icons.phone_android,
        'color': AppColors.cyberBlue
      },
    ];

    return Container(
      padding: const EdgeInsets.all(40),
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.bgDark.withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.glassBorderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "ESTABLISH CONNECTION",
            style: TextStyle(
                color: AppColors.cyberBlue,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5),
          ),
          const SizedBox(height: 12),
          const Text(
            "Drop a line if you are interested in network architecture deployments, threat landscape research collaborations, or security audits.",
            style: TextStyle(
                color: AppColors.textMuted, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 36),
          Center(
            child: Wrap(
              spacing: 24,
              runSpacing: 24,
              alignment: WrapAlignment.center,
              children: contactChannels.map((node) {
                return Container(
                  width: 280,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.glassFillDark,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.glassBorderDark),
                  ),
                  child: Row(
                    children: [
                      Icon(node['icon'] as IconData,
                          color: node['color'] as Color, size: 24),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              node['label'].toString().toUpperCase(),
                              style: TextStyle(
                                  color: node['color'] as Color,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              node['val'].toString(),
                              style: const TextStyle(
                                  color: AppColors.textWhite,
                                  fontSize: 12,
                                  fontFamily: 'monospace'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}

// Private widget component that renders a digital binary green cascade effect inside your photo circle frame
class _MatrixRainFallback extends StatefulWidget {
  const _MatrixRainFallback();

  @override
  State<_MatrixRainFallback> createState() => _MatrixRainFallbackState();
}

class _MatrixRainFallbackState extends State<_MatrixRainFallback>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final List<double> _drops =
      List.generate(20, (_) => Random().nextDouble() * -150);

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        for (int i = 0; i < _drops.length; i++) {
          _drops[i] += 4.5;
          if (_drops[i] > 200) _drops[i] = -20;
        }
        return CustomPaint(
          painter: _MatrixPainter(drops: _drops),
          child: Container(),
        );
      },
    );
  }
}

class _MatrixPainter extends CustomPainter {
  final List<double> drops;
  _MatrixPainter({required this.drops});

  @override
  void paint(Canvas canvas, Size size) {
    final textPaint = TextPainter(textDirection: TextDirection.ltr);
    final rand = Random();

    for (int i = 0; i < drops.length; i++) {
      final text = rand.nextBool() ? "1" : "0";
      textPaint.text = TextSpan(
        text: text,
        style: TextStyle(
            color: AppColors.cyberGreen.withOpacity(0.75),
            fontFamily: 'monospace',
            fontSize: 12,
            fontWeight: FontWeight.bold),
      );
      textPaint.layout();
      textPaint.paint(
          canvas, Offset((size.width / drops.length) * i, drops[i]));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
