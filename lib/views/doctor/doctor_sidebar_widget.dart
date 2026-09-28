import 'package:flutter/material.dart';
import '../dashboard/doctor_dashboard.dart';
import 'doctor_patient_records.dart';
import 'doctor_lab.dart';

class DoctorSidebarWidget extends StatefulWidget {
  final String currentRoute;

  const DoctorSidebarWidget({super.key, required this.currentRoute});

  @override
  State<DoctorSidebarWidget> createState() => _DoctorSidebarWidgetState();
}

class _DoctorSidebarWidgetState extends State<DoctorSidebarWidget> {
  bool _isHovered = false;

  static const double _collapsedWidth = 84.0;
  static const double _expandedWidth = 260.0;

  static const Duration _animDuration = Duration(milliseconds: 350);
  static const Curve _animCurve = Curves.easeOutQuint;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: _animDuration,
        curve: _animCurve,
        width: _isHovered ? _expandedWidth : _collapsedWidth,
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          color: Color(0xFF183F82),
          boxShadow: [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 15,
              offset: Offset(4, 0),
            ),
          ],
        ),
        child: OverflowBox(
          alignment: Alignment.topLeft,
          minWidth: _expandedWidth,
          maxWidth: _expandedWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================================================
              // CLINIC HEADER & LOGO (CENTERED & MULTILINE)
              // =========================================================
              Padding(
                padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
                child: Column(
                  children: [
                    // LOGO WITH ANIMATION
                    AnimatedContainer(
                      duration: _animDuration,
                      curve: _animCurve,
                      width: _isHovered ? _expandedWidth : _collapsedWidth,
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/images/furryFriendsLogo.png',
                            width: 44,
                            height: 44,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.pets_rounded,
                                color: Colors.white,
                                size: 32,
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    // TEXT WITH FADE & EXPAND ANIMATION
                    AnimatedContainer(
                      duration: _animDuration,
                      curve: _animCurve,
                      width: _isHovered ? _expandedWidth : _collapsedWidth,
                      height: _isHovered ? 76.0 : 0.0,
                      alignment: Alignment.center,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeIn,
                        opacity: _isHovered ? 1.0 : 0.0,
                        child: const Padding(
                          padding: EdgeInsets.only(top: 12.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'FURRY FRIENDS\nANIMAL CLINIC',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                  height: 1.2,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Doctor\'s Portal',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(
                  color: Colors.white.withValues(alpha: 0.15),
                  height: 1,
                ),
              ),
              const SizedBox(height: 8),

              // =========================================================
              // NAVIGATION MENU
              // =========================================================
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildSectionHeader('MAIN OVERVIEW'),
                    _buildSidebarItem(
                      context: context,
                      icon: Icons.dashboard_outlined,
                      activeIcon: Icons.dashboard_rounded,
                      label: 'Dashboard',
                      route: '/doctor',
                      destinationPage: const DoctorDashboardScreen(),
                    ),
                    const SizedBox(height: 12),

                    _buildSectionHeader('CLINICAL OPERATIONS'),
                    _buildSidebarItem(
                      context: context,
                      icon: Icons.pets_outlined,
                      activeIcon: Icons.pets_rounded,
                      label: 'Patient Records',
                      route: '/doctor/patients',
                      destinationPage: const DoctorPatientRecordsScreen(),
                    ),
                    _buildSidebarItem(
                      context: context,
                      icon: Icons.science_outlined,
                      activeIcon: Icons.science_rounded,
                      label: 'Lab & Diagnostics',
                      route: '/doctor/lab',
                      destinationPage: const HealthMonitoringView(),
                    ),

                    const SizedBox(height: 24),
                    _buildSectionHeader('SYSTEM & PREFERENCES'),
                    _buildSidebarItem(
                      context: context,
                      icon: Icons.notifications_none,
                      activeIcon: Icons.notifications,
                      label: 'Notifications',
                      route: '/doctor/notifications',
                    ),
                    _buildSidebarItem(
                      context: context,
                      icon: Icons.warning_amber_rounded,
                      activeIcon: Icons.warning_rounded,
                      label: 'Emergency Protocol',
                      route: '/doctor/emergency',
                      isDanger: true,
                    ),
                  ],
                ),
              ),

              // =========================================================
              // LOGOUT BUTTON (Bottom)
              // =========================================================
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0, left: 16.0),
                child: InkWell(
                  onTap: () => Navigator.pushReplacementNamed(context, '/'),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.logout_rounded,
                        color: Colors.white70,
                        size: 20,
                      ),
                      if (_isHovered) ...[
                        const SizedBox(width: 12),
                        const Text(
                          'Log Out',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return AnimatedContainer(
      duration: _animDuration,
      curve: _animCurve,
      height: _isHovered ? 34.0 : 0.0,
      alignment: Alignment.bottomLeft,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: _isHovered ? 1.0 : 0.0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 0, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSidebarItem({
    required BuildContext context,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required String route,
    Widget? destinationPage,
    bool isDanger = false,
  }) {
    final bool isActive = widget.currentRoute == route;

    return _HoverableSidebarIcon(
      icon: icon,
      activeIcon: activeIcon,
      label: label,
      isActive: isActive,
      isExpanded: _isHovered,
      isDanger: isDanger,
      onTap: () {
        if (!isActive && destinationPage != null) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, anim1, anim2) => destinationPage,
              transitionDuration: Duration.zero,
            ),
          );
        }
      },
    );
  }
}

class _HoverableSidebarIcon extends StatefulWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;
  final bool isExpanded;
  final bool isDanger;

  const _HoverableSidebarIcon({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.onTap,
    this.isActive = false,
    this.isExpanded = false,
    this.isDanger = false,
  });

  @override
  State<_HoverableSidebarIcon> createState() => _HoverableSidebarIconState();
}

class _HoverableSidebarIconState extends State<_HoverableSidebarIcon> {
  bool _isItemHovered = false;

  @override
  Widget build(BuildContext context) {
    Color iconColor;
    if (widget.isDanger) {
      iconColor = const Color(0xFFFCA5A5);
    } else if (widget.isActive || _isItemHovered) {
      iconColor = Colors.white;
    } else {
      iconColor = Colors.white70;
    }

    Color bgColor = Colors.transparent;
    if (widget.isActive) {
      bgColor = const Color(0xFF2B5295);
    } else if (_isItemHovered) {
      bgColor = widget.isDanger
          ? Colors.redAccent.withValues(alpha: 0.15)
          : Colors.white.withValues(alpha: 0.15);
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isItemHovered = true),
      onExit: (_) => setState(() => _isItemHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: widget.isActive
              ? Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1)
              : null,
        ),
        child: Stack(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: widget.onTap,
                child: SizedBox(
                  height: 48,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 60,
                        child: Icon(
                          (_isItemHovered || widget.isActive)
                              ? widget.activeIcon
                              : widget.icon,
                          color: iconColor,
                          size: 22,
                        ),
                      ),
                      Expanded(
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 250),
                          opacity: widget.isExpanded ? 1.0 : 0.0,
                          child: AnimatedSlide(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeOutQuint,
                            offset: widget.isExpanded
                                ? Offset.zero
                                : const Offset(-0.05, 0),
                            child: Text(
                              widget.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: iconColor,
                                fontSize: 13,
                                fontWeight: widget.isActive
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 10,
              bottom: 10,
              child: AnimatedScale(
                scale: widget.isActive ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCirc,
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF60A5FA),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
