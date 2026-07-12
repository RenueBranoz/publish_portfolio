import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:cyber_portfolio/core/theme/app_colors.dart';
import 'package:cyber_portfolio/core/constants/section_ids.dart';
import 'package:cyber_portfolio/providers/scroll_provider.dart';
import 'package:cyber_portfolio/providers/pointer_provider.dart';
import 'package:cyber_portfolio/providers/theme_provider.dart';
import 'package:cyber_portfolio/data/portfolio_data.dart';
import 'package:cyber_portfolio/widgets/painters/particle_background.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

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

  // 1. This function handles the actual PDF opening
  Future<void> _openCertificatePdf(String pdfPath) async {
    final Uri url = Uri.parse(pdfPath);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $pdfPath");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Could not open the certification file.')),
        );
      }
    }
  }

  // 2. This function builds the image dialog
  void _openCertificateImageOverlay(String certTitle, String imagePath) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 800,
          height: 600,
          decoration: BoxDecoration(
            color: AppColors.bgDarkest,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.cyberBlue, width: 2),
            boxShadow: [
              BoxShadow(
                  color: AppColors.cyberBlue.withOpacity(0.2), blurRadius: 20)
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(certTitle.toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace')),
                    ),
                    IconButton(
                        icon: const Icon(Icons.close, color: Colors.redAccent),
                        onPressed: () => Navigator.of(context).pop()),
                  ],
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(18)),
                  child: InteractiveViewer(
                    minScale: 1.0,
                    maxScale: 4.0,
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                        child: Text("FAILED TO LOAD IMAGE",
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 3. NEW: This function builds the Project Details dialog
  void _openProjectDetailsOverlay(dynamic project) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 700,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.bgDarkest,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.cyberGreen, width: 2),
            boxShadow: [
              BoxShadow(
                  color: AppColors.cyberGreen.withOpacity(0.15), blurRadius: 24)
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Hugs the content tightly
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      project.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          height: 1.3),
                    ),
                  ),
                  IconButton(
                      icon: const Icon(Icons.close, color: Colors.redAccent),
                      onPressed: () => Navigator.of(context).pop()),
                ],
              ),
              const SizedBox(height: 20),

              // Full Description (Scrollable if very long)
              Flexible(
                child: SingleChildScrollView(
                  child: Text(
                    project.description,
                    style: const TextStyle(
                        color: AppColors.textLightGrey,
                        fontSize: 15,
                        height: 1.6),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Tech Stack Chips
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: project.technologies.map<Widget>((tech) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                        color: AppColors.cyberGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: AppColors.cyberGreen.withOpacity(0.4))),
                    child: Text(tech,
                        style: const TextStyle(
                            color: AppColors.cyberGreen,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Show Project Button (Only renders if a URL exists)
              if (project.githubUrl != null &&
                  project.githubUrl.toString().isNotEmpty)
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cyberGreen,
                      foregroundColor:
                          Colors.black, // Dark text on bright button
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () async {
                      final Uri url = Uri.parse(project.githubUrl);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url,
                            mode: LaunchMode.externalApplication);
                      } else {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Could not open the project link.')),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.open_in_new, size: 20),
                    label: const Text(
                      "SHOW PROJECT",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, letterSpacing: 1.2),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  void _handleTerminalExecution(String rawInput) {
    final cleanInput = rawInput.trim().toLowerCase();
    if (cleanInput.isEmpty) return;

    String responseText = "";
    switch (cleanInput) {
      case 'help':
        responseText = "AVAILABLE SUITE UTILITIES:\n"
            "  > whoami    - Core operator validation profile.\n"
            "  > education - Parses full academic journey matrices.\n"
            "  > family    - Prints secure environment parameters.\n"
            "  > scan      - Runs a verbose system diagnostic architecture map.\n"
            "  > projects  - Lists active production code frameworks.\n"
            "  > contact   - Reveals secure connection communication nodes.\n"
            "  > clear     - Purges terminal buffer history.";
        break;
      case 'whoami':
        responseText = "OPERATOR RECORD INDEXED:\n"
            "  Name       : ${PortfolioData.fullName}\n"
            "  Role       : ICT Undergraduate Systems Engineer\n"
            "  Specialty  : Networking, Cybersecurity, Digital Forensics & Cloud Infrastructure";
        break;
      case 'education':
        responseText = "ACADEMIC ARCHITECTURE MATRIX:\n"
            "  Degree     : Bachelor of Information and Communication Technology (BICT Hons)\n"
            "  Institution: South Eastern University of Sri Lanka\n"
            "  Focus Core : Cisco Enterprise Labs, Infrastructure Hardening, Vulnerability Analysis";
        break;
      case 'family':
        responseText = "SECURE PARAMS - FAMILY NETWORK STRUCTURE:\n"
            "  Configuration: 5 Core Nodes\n"
            "  Node-01      : Father [Strategic Business Operator]\n"
            "  Node-02      : Mother [Technical Systems Educator]\n"
            "  Node-03      : Elder Brother [Undergraduate Student, SEUSL]";
        break;
      case 'scan':
        responseText = "INITIALIZING CORE DECK SYSTEM DIAGNOSTIC RUN...\n"
            "  [PROCESSING] Mapping Network Traffic Vectors...\n"
            "  [OK] Routing Infrastructure Setup: System matrices compliant.\n"
            "  [OK] Network Environments: Hardened. No spoofing anomalies index maps.\n"
            "  [STATUS] ALL SUITE GATEWAYS SECURE. ENVIRONMENT STABLE.";
        break;
      case 'projects':
        responseText = "PRODUCTION REPOSITORY MANIFEST:\n"
            "  1. Enterprise Network Infrastructure Design\n"
            "  2. Secure VPS Infrastructure Deployment\n"
            "  3. VLESS + Reality Network Security Deployment\n"
            "  4. Digital Forensics Investigation Laboratory";
        break;
      case 'contact':
        responseText = "SECURE COMMUNICATION LINKS OVERLAY:\n"
            "  Email    : ${PortfolioData.email}\n"
            "  GitHub   : ${PortfolioData.github}\n"
            "  LinkedIn : ${PortfolioData.linkedin}\n"
            "  Com Deck : ${PortfolioData.phone}\n"
            "  TryHackMe: ${PortfolioData.tryHackMe}\n"
            "  HackTheBox: ${PortfolioData.hackTheBox}";
        break;
      case 'clear':
        setState(() => _liveTerminalHistory.clear());
        _terminalInputController.clear();
        return;
      default:
        responseText =
            "UNKNOWN SCRIPT. Type 'help' to check the security suite directory protocols.";
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

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
                    padding: EdgeInsets.symmetric(
                        vertical: 24, horizontal: isMobile ? 8 : 0),
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
                            padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 12 : 40, vertical: 12),
                            child: portfolioSection
                                .animate(key: ValueKey('anim_$index'))
                                .fadeIn(
                                    duration: 500.ms,
                                    curve: Curves.easeOutCubic)
                                .scaleXY(
                                    begin: 0.93,
                                    end: 1.0,
                                    duration: 600.ms,
                                    curve: Curves.easeOutBack)
                                .slideY(
                                    begin: 0.15,
                                    end: 0,
                                    duration: 500.ms,
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
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40),
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
                    if (!isMobile)
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
                              {
                                'id': SectionId.experience,
                                'name': 'EXPERIENCE'
                              },
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
                                    onPressed: () =>
                                        _scrollToSection(sectionId),
                                    style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 12)),
                                    child: AnimatedDefaultTextStyle(
                                      duration:
                                          const Duration(milliseconds: 200),
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
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
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
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: TextStyle(
              color: AppColors.textWhite,
              fontSize: isMobile ? 32 : 44,
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
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: const TextStyle(
              color: AppColors.textLightGrey, fontSize: 15, height: 1.5),
        ),
        const SizedBox(height: 16),
        Text(
          PortfolioData.professionalSummary,
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: const TextStyle(
              color: AppColors.textMuted, fontSize: 14, height: 1.5),
        ),
        const SizedBox(height: 40),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
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

    final double avatarSize = isMobile ? screenWidth * 0.65 : 320;

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 40, vertical: isMobile ? 40 : 64),
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.bgDark.withOpacity(0.88),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.glassBorderDark),
      ),
      child: isMobile
          ? Column(
              children: [
                Center(
                  child: Container(
                    width: avatarSize,
                    height: avatarSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.primaryGradient,
                      boxShadow: AppColors.glow(AppColors.cyberBlue, blur: 24),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        PortfolioData.profileImagePath,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const _MatrixRainFallback(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                infoColumn,
              ],
            )
          : Row(
              children: [
                Expanded(flex: 3, child: infoColumn),
                const SizedBox(width: 40),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: MouseRegion(
                      onEnter: (_) => setState(() => _isAvatarHovered = true),
                      onExit: (_) => setState(() => _isAvatarHovered = false),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: _isAvatarHovered ? avatarSize + 20 : avatarSize,
                        height: _isAvatarHovered ? avatarSize + 20 : avatarSize,
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
                              shape: BoxShape.circle,
                              color: AppColors.bgDarkest),
                          clipBehavior: Clip.antiAlias,
                          child: Image.asset(
                            PortfolioData.profileImagePath,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const _MatrixRainFallback(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildAboutSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 40),
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.bgDark.withOpacity(0.88),
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
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: PortfolioData.aboutStats.map((stat) {
                return _InteractiveHoverCard(
                  child: Container(
                    width: isMobile ? screenWidth * 0.42 : 204,
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(stat['icon'] as IconData,
                            color: AppColors.cyberGreen, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                stat['value'].toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                stat['label'].toString(),
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 10),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
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
        color: AppColors.bgDark.withOpacity(0.88),
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
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: category.skills.map((skill) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.bgDarkest,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: category.accentColor.withOpacity(0.4)),
                        ),
                        child: Text(
                          skill.name,
                          style: const TextStyle(
                              color: AppColors.textLightGrey,
                              fontSize: 13,
                              fontFamily: 'monospace'),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
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
        color: AppColors.bgDark.withOpacity(0.88),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.glassBorderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "ACADEMIC & PROFESSIONAL CREDENTIALS",
            style: TextStyle(
                color: AppColors.cyberBlue,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5),
          ),
          const SizedBox(height: 6),
          const Text(
            "Click on any credential thumbnail frame below to check the verified certification vault pipeline.",
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 32),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: PortfolioData.certifications.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 440,
              mainAxisExtent: 260,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
            ),
            itemBuilder: (context, index) {
              final cert = PortfolioData.certifications[index];
              return InkWell(
                onTap: () =>
                    _openCertificateImageOverlay(cert.title, cert.imagePath),
                borderRadius: BorderRadius.circular(16),
                child: _InteractiveHoverCard(
                  hoverColor: AppColors.cyberBlue,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D1117),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF161B22),
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16)),
                              border: Border(
                                  bottom: BorderSide(
                                      color:
                                          AppColors.cyberBlue.withOpacity(0.3),
                                      width: 1.5)),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.asset(
                              cert.imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Center(
                                child: Icon(FontAwesomeIcons.certificate,
                                    color: AppColors.cyberBlue.withOpacity(0.4),
                                    size: 48),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(cert.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            height: 1.2)),
                                    const SizedBox(height: 4),
                                    Text(cert.issuer,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.6),
                                            fontSize: 12)),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                        color: AppColors.cyberGreen
                                            .withOpacity(0.15),
                                        border: Border.all(
                                            color: AppColors.cyberGreen
                                                .withOpacity(0.5)),
                                        borderRadius: BorderRadius.circular(4)),
                                    child: Text(cert.date,
                                        style: const TextStyle(
                                            color: AppColors.cyberGreen,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.5)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
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
        color: AppColors.bgDark.withOpacity(0.88),
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

              return _InteractiveHoverCard(
                hoverColor: AppColors.cyberGreen,
                // NEW: Added InkWell to make the project card clickable
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _openProjectDetailsOverlay(project),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(project.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Expanded(
                          child: Text(
                            project.description,
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
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
                                    color:
                                        AppColors.cyberGreen.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                        color: AppColors.cyberGreen
                                            .withOpacity(0.4))),
                                child: Text(tech,
                                    style: const TextStyle(
                                        color: AppColors.cyberGreen,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold)),
                              );
                            }).toList(),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildTimelineSection(String title, List<dynamic> records) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 40),
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.bgDark.withOpacity(0.88),
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
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              Text(item.title,
                                  style: const TextStyle(
                                      color: AppColors.textWhite,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
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
        color: AppColors.bgDark.withOpacity(0.88),
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
                            Expanded(
                                child: Text(block['cmd'] ?? '',
                                    style: const TextStyle(
                                        color: AppColors.textWhite,
                                        fontFamily: 'monospace',
                                        fontSize: 13))),
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
    // Group 1: Hacker Platforms & Repositories
    final ctfChannels = [
      {
        'label': 'TryHackMe Network',
        'val': PortfolioData.tryHackMe,
        'icon': FontAwesomeIcons.userSecret,
        'color': AppColors.cyberGreen
      },
      {
        'label': 'HackTheBox Node',
        'val': PortfolioData.hackTheBox,
        'icon': FontAwesomeIcons.cube,
        'color': AppColors.cyberBlue
      },
      {
        'label': 'GitHub Repository Hub',
        'val': PortfolioData.github,
        'icon': FontAwesomeIcons.github,
        'color': AppColors.cyberPurple
      },
    ];

    // Group 2: Direct Communication
    final contactChannels = [
      {
        'label': 'Email Link',
        'val': PortfolioData.email,
        'icon': Icons.email,
        'color': AppColors.cyberBlue
      },
      {
        'label': 'LinkedIn Secure Connection',
        'val': PortfolioData.linkedin,
        'icon': FontAwesomeIcons.linkedin,
        'color': AppColors.cyberGreen
      },
      {
        'label': 'Secure Telephony Node',
        'val': PortfolioData.phone,
        'icon': Icons.phone_android,
        'color': AppColors.cyberBlue
      },
    ];

    return Container(
      padding: const EdgeInsets.all(40),
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.bgDark.withOpacity(0.88),
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
          const SizedBox(height: 40),

          // --- CYBERSECURITY PLATFORMS BLOCK ---
          const Text(
            "CYBERSECURITY PLATFORMS & REPOSITORIES",
            style: TextStyle(
                color: AppColors.cyberPurple,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2),
          ),
          const SizedBox(height: 20),
          Center(
            child: Wrap(
              spacing: 24,
              runSpacing: 24,
              alignment: WrapAlignment.center,
              children: ctfChannels.map((node) {
                return _buildContactCard(node);
              }).toList(),
            ),
          ),

          const SizedBox(height: 48),
          Container(height: 1, color: AppColors.glassBorderDark),
          const SizedBox(height: 40),

          // --- DIRECT COMMUNICATION BLOCK ---
          const Text(
            "DIRECT COMMUNICATION CHANNELS",
            style: TextStyle(
                color: AppColors.cyberPurple,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2),
          ),
          const SizedBox(height: 20),
          Center(
            child: Wrap(
              spacing: 24,
              runSpacing: 24,
              alignment: WrapAlignment.center,
              children: contactChannels.map((node) {
                return _buildContactCard(node);
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildContactCard(Map<String, dynamic> node) {
    return _InteractiveHoverCard(
      hoverColor: node['color'] as Color,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          String urlString = node['val'].toString();

          if (node['label'] == 'Email Link') {
            urlString = 'mailto:$urlString';
          } else if (node['label'] == 'Secure Telephony Node') {
            urlString = 'tel:${urlString.replaceAll(' ', '')}';
          }

          final Uri url = Uri.parse(urlString);

          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          } else {
            debugPrint("Could not launch connection: $urlString");
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Could not open the connection link.')),
              );
            }
          }
        },
        child: Container(
          width: 280,
          padding: const EdgeInsets.all(20),
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
                      node['val']
                          .toString()
                          .replaceAll('https://www.', '')
                          .replaceAll('https://', '')
                          .replaceAll('app.hackthebox.com/users/', 'HTB ID: '),
                      style: const TextStyle(
                          color: Colors.white,
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
        ),
      ),
    );
  }
}

class _InteractiveHoverCard extends StatefulWidget {
  final Widget child;
  final Color hoverColor;

  const _InteractiveHoverCard({
    required this.child,
    this.hoverColor = AppColors.cyberBlue,
  });

  @override
  State<_InteractiveHoverCard> createState() => _InteractiveHoverCardState();
}

class _InteractiveHoverCardState extends State<_InteractiveHoverCard> {
  bool _isCardHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isCardHovered = true),
      onExit: (_) => setState(() => _isCardHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        transform: _isCardHovered
            ? (Matrix4.identity()..translate(0, -8, 0))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1117),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isCardHovered
                ? widget.hoverColor.withOpacity(0.8)
                : AppColors.glassBorderDark,
            width: _isCardHovered ? 1.5 : 1.0,
          ),
          boxShadow: _isCardHovered
              ? [
                  BoxShadow(
                    color: widget.hoverColor.withOpacity(0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  )
                ]
              : null,
        ),
        child: widget.child,
      ),
    );
  }
}

class _MatrixRainFallback extends StatefulWidget {
  const _MatrixRainFallback();

  @override
  State<_MatrixRainFallback> createState() => _MatrixRainFallbackState();
}

class _MatrixRainFallbackState extends State<_MatrixRainFallback>
    with SingleTickerProviderStateMixin {
  final List<double> _drops =
      List.generate(20, (_) => Random().nextDouble() * -150);
  late AnimationController _animationController;

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
