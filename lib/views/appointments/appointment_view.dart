import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:furry_friends_admin/widgets/sidebar_widget.dart';

class AppointmentManagementView extends StatefulWidget {
  const AppointmentManagementView({super.key});

  @override
  State<AppointmentManagementView> createState() =>
      _AppointmentManagementViewState();
}

class _AppointmentManagementViewState extends State<AppointmentManagementView> {
  String _selectedStatFilter = 'ConfirmedToday';
  DateTime _calendarWeek = _startOfWeek(DateTime.now());
  String _searchQuery = '';
  bool _isCalendarView = false;

  final Set<String> _selectedAppointmentIds = {};

  static DateTime _startOfWeek(DateTime date) => DateTime(
    date.year,
    date.month,
    date.day,
  ).subtract(Duration(days: date.weekday - 1));

  DateTime? _appointmentDate(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    final raw = value?.toString().trim() ?? '';
    final iso = DateTime.tryParse(raw);
    if (iso != null) return iso;
    for (final pattern in ['MMMM d, yyyy', 'MMM d, yyyy', 'MM/dd/yyyy']) {
      try {
        return DateFormat(pattern).parseStrict(raw);
      } catch (_) {}
    }
    return null;
  }

  bool _sameDay(DateTime? a, DateTime b) =>
      a != null && a.year == b.year && a.month == b.month && a.day == b.day;

  String _displayDate(Object? value) {
    final parsed = _appointmentDate(value);
    return parsed == null
        ? (value?.toString() ?? 'Date unavailable')
        : DateFormat('MMMM d, yyyy').format(parsed);
  }

  // Stream combining appointments, users, and pets for live Firestore integration
  Stream<List<Map<String, dynamic>>> _getAppointmentsStream() {
    final appointmentsStream = FirebaseFirestore.instance
        .collection('appointments')
        .orderBy('createdAt', descending: true)
        .snapshots();
    final usersStream = FirebaseFirestore.instance
        .collection('users')
        .snapshots();
    final petsStream = FirebaseFirestore.instance
        .collection('pets')
        .snapshots();

    return Rx.combineLatest3(appointmentsStream, usersStream, petsStream, (
      QuerySnapshot apptSnap,
      QuerySnapshot userSnap,
      QuerySnapshot petSnap,
    ) {
      final usersDocs = userSnap.docs;
      final petsDocs = petSnap.docs;

      return apptSnap.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final ownerId = data['ownerId'] ?? '';
        final petId = data['petId'] ?? '';

        String ownerName = data['ownerName'] ?? 'Unknown Owner';
        String petName = data['petName'] ?? 'Unknown Pet';
        String petBreed = data['petBreed'] ?? 'General';

        // Resolve Owner Name
        try {
          final userDoc = usersDocs.firstWhere((u) {
            final uData = u.data() as Map<String, dynamic>;
            return uData['ownerId'] == ownerId || u.id == ownerId;
          });
          final uData = userDoc.data() as Map<String, dynamic>;
          if (uData.containsKey('firstName') && uData.containsKey('lastName')) {
            ownerName = '${uData['firstName']} ${uData['lastName']}';
          } else if (uData.containsKey('fullName')) {
            ownerName = uData['fullName'];
          }
        } catch (_) {}

        // Resolve Pet Details
        try {
          final petDoc = petsDocs.firstWhere((p) {
            final pData = p.data() as Map<String, dynamic>;
            return pData['petId'] == petId || p.id == petId;
          });
          final pData = petDoc.data() as Map<String, dynamic>;
          petName = pData['name'] ?? petName;
          petBreed =
              '${pData['species'] ?? 'Pet'} • ${pData['breed'] ?? 'General'}';
        } catch (_) {}

        String docName = data['assignedDoctor'] ?? 'Dr. James Nico Martinez';
        String initial = 'JM';
        if (docName.contains('Alfie')) {
          initial = 'AT';
        } else if (docName.contains('Crachzel')) {
          initial = 'CA';
        }

        return {
          'docId': doc.id,
          'petId': petId,
          'petName': petName,
          'petBreed': petBreed,
          'ownerName': ownerName,
          'ownerContact': data['ownerContact'] ?? '+1 (555) 234-8901',
          'date':
              data['date'] ??
              DateFormat('MMMM dd, yyyy').format(DateTime.now()),
          'time': data['time'] ?? '09:00 AM – 10:30 AM',
          'service': data['service'] ?? 'General Checkup',
          'status': data['status'] ?? 'Pending',
          'assignedDoctor': docName,
          'doctorInitial': initial,
          'selected': _selectedAppointmentIds.contains(doc.id),
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat(
      'EEEE, MMM. dd, yyyy',
    ).format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: Row(
        children: [
          const SidebarWidget(currentRoute: '/appointments'),

          Expanded(
            child: Column(
              children: [
                // ==========================================
                // COMPACT TOP HEADER BAR
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
                // MAIN SCROLLABLE CONTENT (Firestore Stream)
                // ==========================================
                Expanded(
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: _getAppointmentsStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            'Something went wrong loading appointments.',
                          ),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final List<Map<String, dynamic>> appointments =
                          snapshot.data ?? [];

                      int allCount = appointments.length;
                      int pendingCount = appointments
                          .where((a) => a['status'] == 'Pending')
                          .length;
                      int confirmedCount = appointments
                          .where(
                            (a) =>
                                a['status'] == 'Confirmed' &&
                                _sameDay(
                                  _appointmentDate(a['date']),
                                  DateTime.now(),
                                ),
                          )
                          .length;
                      int upcomingCount = appointments
                          .where((a) => a['status'] == 'Upcoming')
                          .length;
                      int urgentCount = appointments
                          .where((a) => a['status'] == 'Urgent')
                          .length;

                      final filteredAppointments = appointments.where((appt) {
                        final matchesStat =
                            _selectedStatFilter == 'All' ||
                            (_selectedStatFilter == 'ConfirmedToday'
                                ? appt['status'] == 'Confirmed' &&
                                      _sameDay(
                                        _appointmentDate(appt['date']),
                                        DateTime.now(),
                                      )
                                : appt['status'] == _selectedStatFilter);
                        final matchesSearch =
                            appt['petName'].toLowerCase().contains(
                              _searchQuery.toLowerCase(),
                            ) ||
                            appt['petId'].toLowerCase().contains(
                              _searchQuery.toLowerCase(),
                            ) ||
                            appt['ownerName'].toLowerCase().contains(
                              _searchQuery.toLowerCase(),
                            ) ||
                            appt['assignedDoctor'].toLowerCase().contains(
                              _searchQuery.toLowerCase(),
                            ) ||
                            appt['service'].toLowerCase().contains(
                              _searchQuery.toLowerCase(),
                            );
                        return matchesStat && matchesSearch;
                      }).toList();

                      bool isAllSelected =
                          filteredAppointments.isNotEmpty &&
                          filteredAppointments.every((a) => a['selected']);
                      bool hasSelection = _selectedAppointmentIds.isNotEmpty;

                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(32.0),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ==========================================
                            // GRADIENT HEADER CARD
                            // ==========================================
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
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Appointment Management',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.2,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'Manage clinic schedules, approve requests, and monitor doctor assignments.',
                                          style: TextStyle(
                                            color: Colors.white.withValues(
                                              alpha: 0.8,
                                            ),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.15,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.calendar_month_rounded,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Actions Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.05,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      _buildViewToggleButton(
                                        Icons.format_list_bulleted_rounded,
                                        'List',
                                        !_isCalendarView,
                                        () => setState(
                                          () => _isCalendarView = false,
                                        ),
                                      ),
                                      _buildViewToggleButton(
                                        Icons.calendar_month_rounded,
                                        'Calendar',
                                        _isCalendarView,
                                        () => setState(() {
                                          _isCalendarView = true;
                                          _selectedStatFilter = 'All';
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton(
                                  onPressed: () =>
                                      _showScheduleAppointmentDialog(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF183F82),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 4,
                                    shadowColor: const Color(
                                      0xFF183F82,
                                    ).withValues(alpha: 0.4),
                                  ),
                                  child: const Text(
                                    'Schedule Appointment',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // INTERACTIVE QUICK FILTER CARDS
                            Row(
                              children: [
                                Expanded(
                                  child: _buildAppointmentStatCard(
                                    'ALL APPOINTMENTS',
                                    allCount.toString(),
                                    Icons.grid_view_rounded,
                                    const Color(0xFF183F82),
                                    'All',
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildAppointmentStatCard(
                                    'PENDING REQUESTS',
                                    pendingCount.toString(),
                                    Icons.pending_actions_rounded,
                                    const Color(0xFFD97706),
                                    'Pending',
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildAppointmentStatCard(
                                    'CONFIRMED TODAY',
                                    confirmedCount.toString(),
                                    Icons.check_circle_rounded,
                                    const Color(0xFF059669),
                                    'ConfirmedToday',
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildAppointmentStatCard(
                                    'UPCOMING THIS WEEK',
                                    upcomingCount.toString(),
                                    Icons.event_available_rounded,
                                    const Color(0xFF2563EB),
                                    'Upcoming',
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildAppointmentStatCard(
                                    'URGENT CASES',
                                    urgentCount.toString(),
                                    Icons.warning_rounded,
                                    const Color(0xFFEF4444),
                                    'Urgent',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // BULK ACTIONS BANNER
                            if (hasSelection && !_isCalendarView)
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOutCubic,
                                margin: const EdgeInsets.only(bottom: 24),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF2563EB,
                                      ).withValues(alpha: 0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFF2563EB,
                                        ).withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check_box_rounded,
                                        color: Color(0xFF2563EB),
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      '${_selectedAppointmentIds.length} appointment(s) selected',
                                      style: const TextStyle(
                                        color: Color(0xFF1E3A8A),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const Spacer(),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        for (var docId
                                            in _selectedAppointmentIds) {
                                          FirebaseFirestore.instance
                                              .collection('appointments')
                                              .doc(docId)
                                              .update({'status': 'Confirmed'});
                                        }
                                        setState(
                                          () => _selectedAppointmentIds.clear(),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.check_circle_outline_rounded,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                      label: const Text(
                                        'Bulk Confirm',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF059669,
                                        ),
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 14,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            // MAIN VIEW AREA
                            _isCalendarView
                                ? _buildCalendarView(filteredAppointments)
                                : _buildTableView(
                                    filteredAppointments,
                                    isAllSelected,
                                  ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // VIEW TOGGLE COMPONENT
  // ==========================================
  Widget _buildViewToggleButton(
    IconData icon,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF183F82).withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? const Color(0xFF183F82)
                  : const Color(0xFF64748B),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected
                    ? const Color(0xFF183F82)
                    : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // TABLE VIEW WIDGET
  // ==========================================
  Widget _buildTableView(
    List<Map<String, dynamic>> filteredAppointments,
    bool isAllSelected,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table Toolbar
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: TextField(
                      onChanged: (value) =>
                          setState(() => _searchQuery = value),
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.search,
                          color: Color(0xFF94A3B8),
                          size: 18,
                        ),
                        hintText: 'Search by Pet, Owner, Doctor, or Service...',
                        hintStyle: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 13,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.download_rounded,
                    size: 18,
                    color: Color(0xFF183F82),
                  ),
                  label: const Text(
                    'Export Schedule',
                    style: TextStyle(
                      color: Color(0xFF183F82),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            color: const Color(0xFFF8FAFC),
            child: Row(
              children: [
                SizedBox(
                  width: 48,
                  child: Checkbox(
                    value: isAllSelected,
                    activeColor: const Color(0xFF183F82),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          for (var appt in filteredAppointments) {
                            _selectedAppointmentIds.add(appt['docId']);
                          }
                        } else {
                          _selectedAppointmentIds.clear();
                        }
                      });
                    },
                  ),
                ),
                const Expanded(
                  flex: 3,
                  child: Text(
                    'PET & OWNER DETAILS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      color: Color(0xFF64748B),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const Expanded(
                  flex: 2,
                  child: Text(
                    'ASSIGNED DOCTOR',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      color: Color(0xFF64748B),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const Expanded(
                  flex: 2,
                  child: Text(
                    'SCHEDULE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      color: Color(0xFF64748B),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const Expanded(
                  flex: 3,
                  child: Text(
                    'ACTIONS / STATUS',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      color: Color(0xFF64748B),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // Table Rows
          filteredAppointments.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(60.0),
                  child: Center(
                    child: Text(
                      'No appointments found for this category.',
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredAppointments.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  itemBuilder: (context, index) {
                    final appt = filteredAppointments[index];
                    return _HoverableAppointmentRow(
                      appt: appt,
                      formattedDate: _displayDate(appt['date']),
                      onSelectChanged: (val) {
                        setState(() {
                          if (val == true) {
                            _selectedAppointmentIds.add(appt['docId']);
                          } else {
                            _selectedAppointmentIds.remove(appt['docId']);
                          }
                        });
                      },
                      onStatusUpdate: (newStatus) {
                        FirebaseFirestore.instance
                            .collection('appointments')
                            .doc(appt['docId'])
                            .update({'status': newStatus});
                      },
                    );
                  },
                ),
        ],
      ),
    );
  }

  // Weekly calendar uses the same filtered Firestore records as the list.
  Widget _buildCalendarView(List<Map<String, dynamic>> appointments) {
    final end = _calendarWeek.add(const Duration(days: 6));
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 4,
            children: [
              IconButton(
                tooltip: 'Previous week',
                onPressed: () => setState(
                  () => _calendarWeek = _calendarWeek.subtract(
                    const Duration(days: 7),
                  ),
                ),
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              Text(
                '${DateFormat('MMM d').format(_calendarWeek)} – ${DateFormat('MMM d, yyyy').format(end)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              IconButton(
                tooltip: 'Next week',
                onPressed: () => setState(
                  () => _calendarWeek = _calendarWeek.add(
                    const Duration(days: 7),
                  ),
                ),
                icon: const Icon(Icons.chevron_right_rounded),
              ),
              TextButton(
                onPressed: () => setState(
                  () => _calendarWeek = _startOfWeek(DateTime.now()),
                ),
                child: const Text('Today'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 1120
                  ? 7
                  : constraints.maxWidth >= 650
                  ? 3
                  : constraints.maxWidth >= 350
                  ? 2
                  : 1;
              final width =
                  (constraints.maxWidth - (columns - 1) * 12) / columns;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: List.generate(7, (index) {
                  final day = _calendarWeek.add(Duration(days: index));
                  final daily = appointments
                      .where(
                        (appt) => _sameDay(_appointmentDate(appt['date']), day),
                      )
                      .toList();
                  daily.sort(
                    (a, b) => (a['time']?.toString() ?? '').compareTo(
                      b['time']?.toString() ?? '',
                    ),
                  );
                  return Container(
                    width: width,
                    constraints: const BoxConstraints(minHeight: 160),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _sameDay(day, DateTime.now())
                          ? const Color(0xFFEFF6FF)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _sameDay(day, DateTime.now())
                            ? const Color(0xFF2563EB)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('EEE, MMM d').format(day),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF183F82),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (daily.isEmpty)
                          const Text(
                            'No appointments',
                            style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 11,
                            ),
                          )
                        else
                          ...daily.map(
                            (appt) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Material(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: () => _showAppointmentDetails(appt),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          appt['time']?.toString() ?? '',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF183F82),
                                            fontSize: 11,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          appt['petName']?.toString() ?? 'Pet',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          appt['service']?.toString() ?? '',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Color(0xFF64748B),
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showAppointmentDetails(Map<String, dynamic> appt) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(appt['petName']?.toString() ?? 'Appointment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Owner: ${appt['ownerName']}'),
            Text('Doctor: ${appt['assignedDoctor']}'),
            Text('Date: ${_displayDate(appt['date'])}'),
            Text('Time: ${appt['time']}'),
            Text('Service: ${appt['service']}'),
            Text('Status: ${appt['status']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentStatCard(
    String title,
    String count,
    IconData icon,
    Color color,
    String filterKey,
  ) {
    bool isSelected = _selectedStatFilter == filterKey;
    return InkWell(
      onTap: () => setState(() => _selectedStatFilter = filterKey),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isSelected ? color : const Color(0xFF64748B),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    count,
                    style: TextStyle(
                      color: isSelected ? color : const Color(0xFF0F172A),
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // SCHEDULE APPOINTMENT DIALOG (Sleek & Professional)
  // ============================================================================
  void _showScheduleAppointmentDialog(BuildContext context) {
    String? selectedOwnerId;
    String? selectedPetId;
    String? selectedService;
    String? selectedDoctor;
    String? selectedTimeSlot;
    bool isUrgent = false;
    bool isSaving = false;

    final TextEditingController complaintController = TextEditingController();
    final TextEditingController dateController = TextEditingController(
      text: DateFormat('MMMM dd, yyyy').format(DateTime.now()),
    );

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close Dialog',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .snapshots(),
              builder: (context, userSnapshot) {
                final users = userSnapshot.data?.docs ?? [];

                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('pets')
                      .snapshots(),
                  builder: (context, petSnapshot) {
                    final pets = selectedOwnerId == null
                        ? <QueryDocumentSnapshot>[]
                        : (petSnapshot.data?.docs ?? []).where((pet) {
                            final data = pet.data() as Map<String, dynamic>;
                            return data['ownerId'] == selectedOwnerId;
                          }).toList();

                    return Center(
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          width: 850,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 40,
                                offset: const Offset(0, 15),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Elegant Header
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 24,
                                ),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Color(0xFFE2E8F0),
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: const Color(
                                              0xFF183F82,
                                            ).withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.event_available_rounded,
                                            color: Color(0xFF183F82),
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        const Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Schedule Appointment',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w800,
                                                color: Color(0xFF0F172A),
                                                letterSpacing: -0.5,
                                              ),
                                            ),
                                            SizedBox(height: 2),
                                            Text(
                                              'Book a new patient consultation or checkup.',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF64748B),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.close_rounded,
                                        color: Color(0xFF94A3B8),
                                      ),
                                      hoverColor: const Color(0xFFF1F5F9),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                ),
                              ),

                              // Clean Form Body
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 28,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Left Column: Patient Info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildPremiumFieldLabel(
                                            'PET OWNER*',
                                            Icons.person_outline_rounded,
                                          ),
                                          const SizedBox(height: 8),
                                          DropdownButtonFormField<String>(
                                            value: selectedOwnerId,
                                            hint: const Text('Select owner...'),
                                            isExpanded: true,
                                            items: users.map((u) {
                                              final data =
                                                  u.data()
                                                      as Map<String, dynamic>;
                                              final oId = data['ownerId'] ?? '';
                                              String name =
                                                  data['fullName'] ?? 'Unknown';
                                              if (data.containsKey(
                                                    'firstName',
                                                  ) &&
                                                  data.containsKey(
                                                    'lastName',
                                                  )) {
                                                name =
                                                    '${data['firstName']} ${data['lastName']}';
                                              }
                                              return DropdownMenuItem<String>(
                                                value: oId,
                                                child: Text(
                                                  '$name ($oId)',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (val) {
                                              setDialogState(() {
                                                selectedOwnerId = val;
                                                selectedPetId = null;
                                              });
                                            },
                                            decoration:
                                                _compactInputDecoration(),
                                          ),
                                          const SizedBox(height: 20),

                                          _buildPremiumFieldLabel(
                                            'PET*',
                                            Icons.pets_rounded,
                                          ),
                                          const SizedBox(height: 8),
                                          DropdownButtonFormField<String>(
                                            value: selectedPetId,
                                            hint: Text(
                                              selectedOwnerId == null
                                                  ? 'Select an owner first...'
                                                  : 'Select pet...',
                                            ),
                                            isExpanded: true,
                                            items: pets.map((p) {
                                              final data =
                                                  p.data()
                                                      as Map<String, dynamic>;
                                              final pId = data['petId'] ?? '';
                                              final pName =
                                                  data['name'] ?? 'Pet';
                                              return DropdownMenuItem<String>(
                                                value: pId,
                                                child: Text(
                                                  '$pName ($pId)',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: selectedOwnerId == null
                                                ? null
                                                : (val) => setDialogState(
                                                    () => selectedPetId = val,
                                                  ),
                                            decoration:
                                                _compactInputDecoration(),
                                          ),
                                          const SizedBox(height: 20),

                                          _buildPremiumFieldLabel(
                                            'CHIEF COMPLAINT*',
                                            Icons.notes_rounded,
                                          ),
                                          const SizedBox(height: 8),
                                          TextFormField(
                                            controller: complaintController,
                                            maxLines: 2,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Color(0xFF1E293B),
                                            ),
                                            decoration: _compactInputDecoration()
                                                .copyWith(
                                                  hintText:
                                                      'Briefly describe the reason for visit...',
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 32),

                                    // Right Column: Schedule Info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildPremiumFieldLabel(
                                            'SERVICE*',
                                            Icons.medical_services_outlined,
                                          ),
                                          const SizedBox(height: 8),
                                          DropdownButtonFormField<String>(
                                            value: selectedService,
                                            hint: const Text('Select service'),
                                            items:
                                                const [
                                                      'General Checkup',
                                                      'Dental Cleaning',
                                                      'Vaccination',
                                                      'Emergency Surgery',
                                                    ]
                                                    .map(
                                                      (s) => DropdownMenuItem(
                                                        value: s,
                                                        child: Text(s),
                                                      ),
                                                    )
                                                    .toList(),
                                            onChanged: (val) => setDialogState(
                                              () => selectedService = val,
                                            ),
                                            decoration:
                                                _compactInputDecoration(),
                                          ),
                                          const SizedBox(height: 20),

                                          _buildPremiumFieldLabel(
                                            'ASSIGNED DOCTOR*',
                                            Icons.badge_outlined,
                                          ),
                                          const SizedBox(height: 8),
                                          DropdownButtonFormField<String>(
                                            value: selectedDoctor,
                                            hint: const Text('Select doctor'),
                                            items:
                                                const [
                                                      'Dr. James Nico Martinez',
                                                      'Dr. Alfie Tamesis',
                                                      'Dr. Crachzel Kyle Asistio',
                                                    ]
                                                    .map(
                                                      (d) => DropdownMenuItem(
                                                        value: d,
                                                        child: Text(d),
                                                      ),
                                                    )
                                                    .toList(),
                                            onChanged: (val) => setDialogState(
                                              () => selectedDoctor = val,
                                            ),
                                            decoration:
                                                _compactInputDecoration(),
                                          ),
                                          const SizedBox(height: 20),

                                          Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    _buildPremiumFieldLabel(
                                                      'DATE*',
                                                      Icons
                                                          .calendar_month_rounded,
                                                    ),
                                                    const SizedBox(height: 8),
                                                    TextFormField(
                                                      controller:
                                                          dateController,
                                                      readOnly: true,
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Color(
                                                          0xFF1E293B,
                                                        ),
                                                      ),
                                                      decoration: _compactInputDecoration()
                                                          .copyWith(
                                                            suffixIcon: const Icon(
                                                              Icons
                                                                  .edit_calendar_rounded,
                                                              size: 18,
                                                              color: Color(
                                                                0xFF64748B,
                                                              ),
                                                            ),
                                                          ),
                                                      onTap: () async {
                                                        final DateTime?
                                                        picked = await showDatePicker(
                                                          context: context,
                                                          initialDate:
                                                              DateTime.now(),
                                                          firstDate:
                                                              DateTime.now(),
                                                          lastDate:
                                                              DateTime.now().add(
                                                                const Duration(
                                                                  days: 365,
                                                                ),
                                                              ),
                                                        );
                                                        if (picked != null) {
                                                          setDialogState(() {
                                                            dateController
                                                                    .text =
                                                                DateFormat(
                                                                  'MMMM dd, yyyy',
                                                                ).format(
                                                                  picked,
                                                                );
                                                          });
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    _buildPremiumFieldLabel(
                                                      'TIME SLOT*',
                                                      Icons.access_time_rounded,
                                                    ),
                                                    const SizedBox(height: 8),
                                                    DropdownButtonFormField<
                                                      String
                                                    >(
                                                      value: selectedTimeSlot,
                                                      hint: const Text(
                                                        'Select time',
                                                      ),
                                                      isExpanded: true,
                                                      items:
                                                          const [
                                                                '09:00 AM – 10:30 AM',
                                                                '10:30 AM – 12:00 PM',
                                                                '01:00 PM – 02:30 PM',
                                                                '03:00 PM – 04:30 PM',
                                                              ]
                                                              .map(
                                                                (
                                                                  t,
                                                                ) => DropdownMenuItem(
                                                                  value: t,
                                                                  child: Text(
                                                                    t,
                                                                    style: const TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                              .toList(),
                                                      onChanged: (val) =>
                                                          setDialogState(
                                                            () =>
                                                                selectedTimeSlot =
                                                                    val,
                                                          ),
                                                      decoration:
                                                          _compactInputDecoration(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Bottom Actions & Urgent Toggle
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 20,
                                ),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(color: Color(0xFFE2E8F0)),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () => setDialogState(
                                        () => isUrgent = !isUrgent,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isUrgent
                                              ? const Color(0xFFFEF2F2)
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          border: Border.all(
                                            color: isUrgent
                                                ? const Color(0xFFEF4444)
                                                : const Color(0xFFE2E8F0),
                                            width: isUrgent ? 2 : 1,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.warning_rounded,
                                              size: 18,
                                              color: isUrgent
                                                  ? const Color(0xFFEF4444)
                                                  : const Color(0xFF94A3B8),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              'MARK AS URGENT',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w800,
                                                letterSpacing: 0.5,
                                                color: isUrgent
                                                    ? const Color(0xFFEF4444)
                                                    : const Color(0xFF64748B),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: Checkbox(
                                                value: isUrgent,
                                                activeColor: const Color(
                                                  0xFFEF4444,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                onChanged: (val) =>
                                                    setDialogState(
                                                      () => isUrgent = val!,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 16,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(
                                              color: Color(0xFF64748B),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        ElevatedButton(
                                          onPressed: isSaving
                                              ? null
                                              : () async {
                                                  if (selectedOwnerId != null &&
                                                      selectedPetId != null &&
                                                      selectedService != null) {
                                                    setDialogState(
                                                      () => isSaving = true,
                                                    );
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                          'appointments',
                                                        )
                                                        .add({
                                                          'ownerId':
                                                              selectedOwnerId,
                                                          'petId':
                                                              selectedPetId,
                                                          'service':
                                                              selectedService,
                                                          'assignedDoctor':
                                                              selectedDoctor ??
                                                              'Dr. James Nico Martinez',
                                                          'chiefComplaint':
                                                              complaintController
                                                                  .text
                                                                  .trim(),
                                                          'date': dateController
                                                              .text,
                                                          'time':
                                                              selectedTimeSlot ??
                                                              '09:00 AM – 10:30 AM',
                                                          'status': isUrgent
                                                              ? 'Urgent'
                                                              : 'Pending',
                                                          'createdAt':
                                                              FieldValue.serverTimestamp(),
                                                        });
                                                    if (context.mounted)
                                                      Navigator.pop(context);
                                                  }
                                                },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(
                                              0xFF183F82,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 24,
                                              vertical: 16,
                                            ),
                                            elevation: 4,
                                            shadowColor: const Color(
                                              0xFF183F82,
                                            ).withValues(alpha: 0.3),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: isSaving
                                              ? const SizedBox(
                                                  width: 18,
                                                  height: 18,
                                                  child:
                                                      CircularProgressIndicator(
                                                        color: Colors.white,
                                                        strokeWidth: 2,
                                                      ),
                                                )
                                              : const Text(
                                                  'Confirm Booking',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
      },
    );
  }

  // Uniform white input style
  InputDecoration _compactInputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      isDense: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF183F82), width: 1.5),
      ),
    );
  }

  Widget _buildPremiumFieldLabel(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Color(0xFF64748B),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

// ===================================================================
// HOVERABLE APPOINTMENT ROW WIDGET
// ===================================================================
class _HoverableAppointmentRow extends StatefulWidget {
  final Map<String, dynamic> appt;
  final String formattedDate;
  final ValueChanged<bool?> onSelectChanged;
  final ValueChanged<String> onStatusUpdate;

  const _HoverableAppointmentRow({
    required this.appt,
    required this.formattedDate,
    required this.onSelectChanged,
    required this.onStatusUpdate,
  });

  @override
  State<_HoverableAppointmentRow> createState() =>
      _HoverableAppointmentRowState();
}

class _HoverableAppointmentRowState extends State<_HoverableAppointmentRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    bool isPending = widget.appt['status'] == 'Pending';

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: _isHovered ? const Color(0xFFF8FAFC) : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            SizedBox(
              width: 48,
              child: Checkbox(
                value: widget.appt['selected'],
                activeColor: const Color(0xFF183F82),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                onChanged: widget.onSelectChanged,
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.pets_rounded,
                      size: 18,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.appt['petName'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.appt['petBreed']} • ${widget.appt['petId']}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.person_rounded,
                              size: 12,
                              color: Color(0xFF94A3B8),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.appt['ownerName'],
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF334155),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: const Color(0xFFF3E8FF),
                    child: Text(
                      widget.appt['doctorInitial'],
                      style: const TextStyle(
                        color: Color(0xFF7C3AED),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.appt['assignedDoctor'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Color(0xFF1E293B),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.formattedDate,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.appt['time'],
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      widget.appt['service'],
                      style: const TextStyle(
                        color: Color(0xFF475569),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.center,
                child: isPending
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => widget.onStatusUpdate('Confirmed'),
                            icon: const Icon(
                              Icons.check_circle_outline_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Approve',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF059669),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: _showActions,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              side: const BorderSide(color: Color(0xFFCBD5E1)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Manage',
                              style: TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildStatusBadge(widget.appt['status']),
                          const SizedBox(width: 12),
                          IconButton(
                            icon: const Icon(
                              Icons.more_vert_rounded,
                              color: Color(0xFF64748B),
                              size: 20,
                            ),
                            tooltip: 'More Actions',
                            onPressed: _showActions,
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showActions() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  widget.appt['petName']?.toString() ?? 'Appointment',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(widget.appt['service']?.toString() ?? ''),
              ),
              ListTile(
                leading: const Icon(Icons.visibility_outlined),
                title: const Text('View details'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  showDialog<void>(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: Text(
                        widget.appt['petName']?.toString() ?? 'Appointment',
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Owner: ${widget.appt['ownerName']}'),
                          Text('Doctor: ${widget.appt['assignedDoctor']}'),
                          Text('Date: ${widget.formattedDate}'),
                          Text('Time: ${widget.appt['time']}'),
                          Text('Service: ${widget.appt['service']}'),
                          Text('Status: ${widget.appt['status']}'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              if (widget.appt['status'] != 'Confirmed')
                ListTile(
                  leading: const Icon(Icons.check_circle_outline),
                  title: const Text('Mark confirmed'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    widget.onStatusUpdate('Confirmed');
                  },
                ),
              if (widget.appt['status'] != 'Completed')
                ListTile(
                  leading: const Icon(Icons.task_alt_outlined),
                  title: const Text('Mark completed'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    widget.onStatusUpdate('Completed');
                  },
                ),
              if (widget.appt['status'] != 'Cancelled')
                ListTile(
                  leading: const Icon(
                    Icons.cancel_outlined,
                    color: Color(0xFFDC2626),
                  ),
                  title: const Text('Cancel appointment'),
                  onTap: () async {
                    Navigator.pop(sheetContext);
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: const Text('Cancel appointment?'),
                        content: const Text(
                          'This will update the appointment status to Cancelled.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(dialogContext, false),
                            child: const Text('Keep'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext, true),
                            child: const Text('Cancel appointment'),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true && mounted)
                      widget.onStatusUpdate('Cancelled');
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color badgeColor = const Color(0xFF64748B);
    Color bgColor = const Color(0xFFF1F5F9);
    IconData icon = Icons.help_rounded;

    if (status == 'Confirmed' || status == 'Completed') {
      badgeColor = const Color(0xFF059669);
      bgColor = const Color(0xFFECFDF5);
      icon = Icons.check_circle_rounded;
    } else if (status == 'Upcoming') {
      badgeColor = const Color(0xFF2563EB);
      bgColor = const Color(0xFFEFF6FF);
      icon = Icons.event_rounded;
    } else if (status == 'Urgent') {
      badgeColor = const Color(0xFFEF4444);
      bgColor = const Color(0xFFFEF2F2);
      icon = Icons.warning_rounded;
    } else if (status == 'Cancelled') {
      badgeColor = const Color(0xFFEF4444);
      bgColor = const Color(0xFFFEF2F2);
      icon = Icons.cancel_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: badgeColor),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: badgeColor,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
