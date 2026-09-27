import 'package:flutter/material.dart';

class SidebarWidget extends StatefulWidget {
  final String currentRoute;

  const SidebarWidget({super.key, required this.currentRoute});

  @override
  State<SidebarWidget> createState() => _SidebarWidgetState();
}

class _SidebarWidgetState extends State<SidebarWidget> {
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
          color: Color(0xFF183F82), // Restored original solid brand color
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
                    // LOGO WITH SLIDE-TO-CENTER ANIMATION
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
                                'Admin Portal',
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
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Divider(
                  color: Colors.white.withValues(alpha: 0.15),
                  height: 1,
                ),
              ),
              const SizedBox(height: 12),

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
                      route: '/dashboard',
                    ),

                    _buildSectionHeader('CLINICAL OPERATIONS'),
                    _buildSidebarItem(
                      context: context,
                      icon: Icons.monitor_heart_outlined,
                      activeIcon: Icons.monitor_heart_rounded,
                      label: 'Health Monitoring',
                      route: '/health',
                      badgeCount: 1,
                    ),
                    _buildSidebarItem(
                      context: context,
                      icon: Icons.pets_outlined,
                      activeIcon: Icons.pets_rounded,
                      label: 'Pet Management',
                      route: '/pets',
                    ),
                    _buildSidebarItem(
                      context: context,
                      icon: Icons.calendar_today_outlined,
                      activeIcon: Icons.calendar_month_rounded,
                      label: 'Appointment Management',
                      route: '/appointments',
                      badgeCount: 2,
                    ),
                    _buildSidebarItem(
                      context: context,
                      icon: Icons.forum_outlined,
                      activeIcon: Icons.forum_rounded,
                      label: 'Messages',
                      route: '/messages',
                      badgeCount: 4,
                    ),

                    _buildSectionHeader('SYSTEM & ADMIN'),
                    _buildSidebarItem(
                      context: context,
                      icon: Icons.notifications_none_outlined,
                      activeIcon: Icons.notifications_rounded,
                      label: 'Notification',
                      route: '/notifications',
                      badgeCount: 3,
                    ),
                    _buildSidebarItem(
                      context: context,
                      icon: Icons.person_outline,
                      activeIcon: Icons.person_rounded,
                      label: 'User Account',
                      route: '/users',
                    ),
                    _buildSidebarItem(
                      context: context,
                      icon: Icons.medical_services_outlined,
                      activeIcon: Icons.medical_services_rounded,
                      label: "Doctor's Portal",
                      route: '/doctor',
                    ),
                  ],
                ),
              ),

              // =========================================================
              // STICKY BOTTOM FOOTER (LOGOUT)
              // =========================================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Divider(
                  color: Colors.white.withValues(alpha: 0.15),
                  height: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                  bottom: 24.0,
                  left: 12,
                  right: 12,
                ),
                child: _HoverableSidebarIcon(
                  icon: Icons.logout_rounded,
                  activeIcon: Icons.logout_rounded,
                  label: 'Log Out',
                  isLogout: true,
                  isExpanded: _isHovered,
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
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
      height: _isHovered ? 36.0 : 0.0,
      alignment: Alignment.bottomLeft,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
        opacity: _isHovered ? 1.0 : 0.0,
        child: AnimatedSlide(
          duration: _animDuration,
          curve: _animCurve,
          offset: _isHovered ? Offset.zero : const Offset(-0.05, 0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 16, 10),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
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
    int? badgeCount,
  }) {
    final bool isActive = widget.currentRoute == route;

    return _HoverableSidebarIcon(
      icon: icon,
      activeIcon: activeIcon,
      label: label,
      isActive: isActive,
      isExpanded: _isHovered,
      badgeCount: badgeCount,
      onTap: () {
        if (!isActive) {
          Navigator.pushReplacementNamed(context, route);
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
  final bool isLogout;
  final bool isExpanded;
  final int? badgeCount;

  const _HoverableSidebarIcon({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.onTap,
    this.isActive = false,
    this.isLogout = false,
    this.isExpanded = false,
    this.badgeCount,
  });

  @override
  State<_HoverableSidebarIcon> createState() => _HoverableSidebarIconState();
}

class _HoverableSidebarIconState extends State<_HoverableSidebarIcon> {
  bool _isItemHovered = false;

  @override
  Widget build(BuildContext context) {
    // Determine colors based on active, hover, and logout states using original brand palette
    Color iconColor;
    if (widget.isLogout) {
      iconColor = _isItemHovered ? Colors.white : const Color(0xFFFCA5A5);
    } else if (widget.isActive || _isItemHovered) {
      iconColor = Colors.white;
    } else {
      iconColor = Colors.white70;
    }

    Color bgColor = Colors.transparent;
    if (widget.isActive) {
      bgColor = const Color(0xFF2B5295); // Restored original active color
    } else if (_isItemHovered) {
      bgColor = widget.isLogout
          ? Colors.redAccent.withValues(alpha: 0.25)
          : Colors.white.withValues(alpha: 0.15);
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isItemHovered = true),
      onExit: (_) => setState(() => _isItemHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
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
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              (widget.isActive)
                                  ? widget.activeIcon
                                  : widget.icon,
                              color: iconColor,
                              size: 22,
                            ),
                            // Collapsed Badge
                            Positioned(
                              top: 10,
                              right: 14,
                              child: AnimatedScale(
                                scale:
                                    (!widget.isExpanded &&
                                        widget.badgeCount != null &&
                                        widget.badgeCount! > 0)
                                    ? 1.0
                                    : 0.0,
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeOutBack,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFEF4444),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeIn,
                          opacity: widget.isExpanded ? 1.0 : 0.0,
                          child: AnimatedSlide(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeOutQuint,
                            offset: widget.isExpanded
                                ? Offset.zero
                                : const Offset(-0.05, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
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
                                // Expanded Badge
                                if (widget.badgeCount != null &&
                                    widget.badgeCount! > 0)
                                  Container(
                                    margin: const EdgeInsets.only(right: 14),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEF4444),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '${widget.badgeCount}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
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
              ),
            ),

            // Restored Original Light Blue Glowing Accent Line
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
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF60A5FA).withValues(alpha: 0.9),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
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
