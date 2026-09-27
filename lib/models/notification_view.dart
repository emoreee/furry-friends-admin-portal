import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:furry_friends_admin/widgets/sidebar_widget.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  String _activeFilter = 'All';

  // ==========================================
  // MOCK NOTIFICATION DATA
  // ==========================================
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 'notif_1',
      'title': 'CRITICAL: Severe Trauma Case',
      'message':
          'Pet "Simba" (Maine Coon) requires immediate ER attention. Please assign a doctor immediately.',
      'time': '2 mins ago',
      'type': 'Urgent',
      'isRead': false,
      'route': '/appointments',
    },
    {
      'id': 'notif_2',
      'title': 'New Appointment Request',
      'message':
          'Jerome Polo has requested a Skin Consultation for "Luna" at 10:30 AM tomorrow.',
      'time': '15 mins ago',
      'type': 'Appointments',
      'isRead': false,
      'route': '/appointments',
    },
    {
      'id': 'notif_3',
      'title': 'Lab Results Released',
      'message':
          'Biochemical Panel for "Sky" is complete and ready for veterinary review.',
      'time': '1 hour ago',
      'type': 'Labs',
      'isRead': true,
      'route': '/doctor/lab',
    },
    {
      'id': 'notif_4',
      'title': 'Payment Confirmed',
      'message':
          'Invoice #INV-2024-089 for Bella\'s Annual Vaccination has been settled.',
      'time': '3 hours ago',
      'type': 'System',
      'isRead': true,
      'route': '/billing',
    },
    {
      'id': 'notif_5',
      'title': 'System Maintenance Alert',
      'message':
          'The Smart Vet Care portal will undergo routine backend maintenance at 12:00 AM.',
      'time': '1 day ago',
      'type': 'System',
      'isRead': true,
      'route': '/dashboard',
    },
    {
      'id': 'notif_6',
      'title': 'Appointment Cancelled',
      'message':
          'Maria Santos has cancelled the Dental Cleaning appointment for "Max".',
      'time': '1 day ago',
      'type': 'Appointments',
      'isRead': true,
      'route': '/appointments',
    },
  ];

  void _markAllAsRead() {
    setState(() {
      for (var notif in _notifications) {
        notif['isRead'] = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read.'),
        backgroundColor: Color(0xFF059669),
      ),
    );
  }

  void _clearHistory() {
    setState(() {
      _notifications.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification history cleared.'),
        backgroundColor: Color(0xFF183F82),
      ),
    );
  }

  void _markAsReadAndNavigate(Map<String, dynamic> notif) {
    setState(() {
      notif['isRead'] = true;
    });
    Navigator.pushNamed(context, notif['route']);
  }

  void _deleteNotification(String id) {
    setState(() {
      _notifications.removeWhere((notif) => notif['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat(
      'EEEE, MMM. dd, yyyy',
    ).format(DateTime.now());

    // Filter Logic
    final filteredNotifications = _notifications.where((notif) {
      if (_activeFilter == 'All') return true;
      return notif['type'] == _activeFilter;
    }).toList();

    int unreadCount = _notifications.where((n) => n['isRead'] == false).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: Row(
        children: [
          const SidebarWidget(currentRoute: '/notifications'),

          Expanded(
            child: Column(
              children: [
                // ==========================================
                // TOP HEADER BAR
                // ==========================================
                Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            size: 14,
                            color: Color(0xFF64748B),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              color: Color(0xFF334155),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(
                                0xFF183F82,
                              ).withValues(alpha: 0.1),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/juneksPic.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Text(
                                      'JA',
                                      style: TextStyle(
                                        color: Color(0xFF183F82),
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Junexenne Agravante',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              Text(
                                'Clinic Administrator',
                                style: TextStyle(
                                  color: Color(0xFF059669),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ==========================================
                // MAIN SCROLLABLE CONTENT
                // ==========================================
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32.0),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // GRADIENT BANNER WITH ACTIONS
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF183F82),
                                Color(0xFF2563EB),
                                Color(0xFF38BDF8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF183F82,
                                ).withValues(alpha: 0.25),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'Notifications & Alerts',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                      if (unreadCount > 0) ...[
                                        const SizedBox(width: 12),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFEF4444),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            '$unreadCount Unread',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Stay updated with your clinic\'s latest activities and urgent cases.',
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.8,
                                      ),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  TextButton.icon(
                                    onPressed: _markAllAsRead,
                                    icon: const Icon(
                                      Icons.done_all_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    label: const Text(
                                      'Mark All as Read',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.white.withValues(
                                        alpha: 0.15,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  TextButton.icon(
                                    onPressed: _clearHistory,
                                    icon: const Icon(
                                      Icons.delete_sweep_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    label: const Text(
                                      'Clear History',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.white.withValues(
                                        alpha: 0.15,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ==========================================
                        // FILTER CHIPS
                        // ==========================================
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: [
                              _buildFilterChip('All'),
                              _buildFilterChip('Appointments'),
                              _buildFilterChip('Urgent'),
                              _buildFilterChip('Labs'),
                              _buildFilterChip('System'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ==========================================
                        // NOTIFICATION LIST
                        // ==========================================
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: filteredNotifications.isEmpty
                              ? Container(
                                  key: const ValueKey('empty_state'),
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 80,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: const Color(0xFFE2E8F0),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(24),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF1F5F9),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.notifications_off_rounded,
                                          size: 40,
                                          color: Color(0xFF94A3B8),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'No notifications found',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1E293B),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'You\'re all caught up! No alerts for this category.',
                                        style: TextStyle(
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  key: ValueKey(_activeFilter),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: filteredNotifications.length,
                                  itemBuilder: (context, index) {
                                    final notif = filteredNotifications[index];
                                    return _HoverableNotificationCard(
                                      notification: notif,
                                      onTap: () =>
                                          _markAsReadAndNavigate(notif),
                                      onDelete: () =>
                                          _deleteNotification(notif['id']),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    bool isSelected = _activeFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: InkWell(
        onTap: () => setState(() => _activeFilter = label),
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF183F82) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF183F82)
                  : const Color(0xFFCBD5E1),
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF183F82).withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Text(
            label == 'Appointments'
                ? 'Appointments & Bookings'
                : label == 'Urgent'
                ? 'Urgent Emergencies'
                : label == 'Labs'
                ? 'Lab Results'
                : label == 'System'
                ? 'System Alerts'
                : 'All Notifications',
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF64748B),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

// ===================================================================
// HOVERABLE NOTIFICATION CARD
// ===================================================================
class _HoverableNotificationCard extends StatefulWidget {
  final Map<String, dynamic> notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _HoverableNotificationCard({
    required this.notification,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<_HoverableNotificationCard> createState() =>
      _HoverableNotificationCardState();
}

class _HoverableNotificationCardState
    extends State<_HoverableNotificationCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    bool isRead = widget.notification['isRead'];
    String type = widget.notification['type'];

    // Define Icons and Colors based on Type
    IconData icon;
    Color accentColor;
    Color bgColor;

    switch (type) {
      case 'Urgent':
        icon = Icons.warning_rounded;
        accentColor = const Color(0xFFEF4444); // Red
        bgColor = const Color(0xFFFEF2F2);
        break;
      case 'Appointments':
        icon = Icons.calendar_month_rounded;
        accentColor = const Color(0xFF2563EB); // Blue
        bgColor = const Color(0xFFEFF6FF);
        break;
      case 'Labs':
        icon = Icons.science_rounded;
        accentColor = const Color(0xFF059669); // Green
        bgColor = const Color(0xFFECFDF5);
        break;
      case 'System':
      default:
        icon = Icons.info_outline_rounded;
        accentColor = const Color(0xFF8B5CF6); // Purple
        bgColor = const Color(0xFFF5F3FF);
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(
            _isHovered ? 4.0 : 0.0,
            0.0,
            0.0,
          ),
          decoration: BoxDecoration(
            color: isRead ? Colors.white : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered
                  ? accentColor.withValues(alpha: 0.5)
                  : const Color(0xFFE2E8F0),
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon Container
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: bgColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: accentColor.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Icon(icon, color: accentColor, size: 24),
                    ),
                    const SizedBox(width: 16),

                    // Main Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.notification['title'],
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: isRead
                                        ? FontWeight.w600
                                        : FontWeight.w800,
                                    color: isRead
                                        ? const Color(0xFF334155)
                                        : const Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                              // Timestamp
                              Text(
                                widget.notification['time'],
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF94A3B8),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.notification['message'],
                            style: TextStyle(
                              fontSize: 13,
                              color: isRead
                                  ? const Color(0xFF64748B)
                                  : const Color(0xFF475569),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Right Side Actions (Unread Dot & Delete)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (!isRead)
                          Container(
                            width: 10,
                            height: 10,
                            margin: const EdgeInsets.only(top: 4, bottom: 12),
                            decoration: const BoxDecoration(
                              color: Color(
                                0xFF2563EB,
                              ), // Distinct Blue Dot for Unread
                              shape: BoxShape.circle,
                            ),
                          )
                        else
                          const SizedBox(
                            height: 26,
                          ), // Spacer to maintain alignment

                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: _isHovered ? 1.0 : 0.0,
                          child: InkWell(
                            onTap: widget.onDelete,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF2F2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                size: 16,
                                color: Color(0xFFEF4444),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
