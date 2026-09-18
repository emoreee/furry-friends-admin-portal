import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentManagementView extends StatefulWidget {
  const AppointmentManagementView({super.key});

  @override
  State<AppointmentManagementView> createState() =>
      _AppointmentManagementViewState();
}

class _AppointmentManagementViewState extends State<AppointmentManagementView> {
  int _selectedIndex = 2;
  bool _isExpanded = false;
  String _selectedStatFilter = 'All';
  String _searchQuery = '';

  // Kumpletong Mock data para sa Appointments
  final List<Map<String, dynamic>> _appointments = [
    {
      'petId': 'PET-00005',
      'petName': 'Bambam',
      'petBreed': 'Dog • Golden Retriever',
      'ownerName': 'Jerome Polo',
      'ownerContact': '+1 (555) 234-8901',
      'date': '30/07/2026',
      'time': '09:00 AM – 10:30 AM',
      'service': 'Dental Cleaning',
      'status': 'Pending',
    },
    {
      'petId': 'PET-00001',
      'petName': 'Bella',
      'petBreed': 'Dog • Golden Retriever',
      'ownerName': 'Maria Santos',
      'ownerContact': '+1 (555) 123-4567',
      'date': 'September 17, 2026',
      'time': '10:00 AM – 11:00 AM',
      'service': 'Routine Checkup',
      'status': 'Confirmed',
    },
    {
      'petId': 'PET-00002',
      'petName': 'Sky',
      'petBreed': 'Dog • Siberian Husky',
      'ownerName': 'Jerome Polo',
      'ownerContact': '+1 (555) 234-8901',
      'date': 'September 17, 2026',
      'time': '01:00 PM – 02:00 PM',
      'service': 'Vaccination',
      'status': 'Confirmed',
    },
    {
      'petId': 'PET-00002',
      'petName': 'Sky',
      'petBreed': 'Dog • Siberian Husky',
      'ownerName': 'Jerome Polo',
      'ownerContact': '+1 (555) 234-8901',
      'date': 'September 20, 2026',
      'time': '09:00 AM – 10:30 AM',
      'service': 'General Check Up',
      'status': 'Upcoming',
    },
    {
      'petId': 'PET-00008',
      'petName': 'Rocky',
      'petBreed': 'Dog • German Shepherd',
      'ownerName': 'Ana Reyes',
      'ownerContact': '+1 (555) 888-9911',
      'date': 'September 19, 2026',
      'time': '02:00 PM – 03:00 PM',
      'service': 'Emergency Surgery',
      'status': 'Urgent',
    },
    {
      'petId': 'PET-00007',
      'petName': 'Pet',
      'petBreed': 'Dog • Mixed Breed',
      'ownerName': 'Ivhan Leander',
      'ownerContact': '+1 (555) 674-1294',
      'date': 'August 06, 2026',
      'time': '09:00 AM – 10:30 AM',
      'service': 'Vaccination',
      'status': 'Completed',
    },
    {
      'petId': 'PET-00006',
      'petName': 'Milo',
      'petBreed': 'Dog • Corgi',
      'ownerName': 'Junexenne Agravante',
      'ownerContact': '+1 (555) 980-3412',
      'date': 'August 07, 2026',
      'time': '09:00 AM – 10:30 AM',
      'service': 'General Checkup',
      'status': 'Completed',
    },
  ];

  // Re-designed Schedule Appointment Dialog na may Fixed Header at Sticky Footer Buttons
  void _showScheduleAppointmentDialog() {
    String? selectedOwner;
    String selectedService = 'General Checkup';
    String selectedDoctor = 'Dr. James Nico Martinez';
    String selectedTimeSlot = '09:00 AM - 10:30 AM';
    bool isUrgent = false;

    final TextEditingController chiefComplaintController =
        TextEditingController();
    final TextEditingController notesController = TextEditingController();
    final TextEditingController dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                width: 600,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                ),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 30,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Fixed Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Schedule Appointment',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Color(0xFF94A3B8),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Color(0xFFE2E8F0), height: 1),
                    const SizedBox(height: 16),

                    // Scrollable Body
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Pet Owner Field
                            _buildDialogFieldLabel('PET OWNER*'),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              value: selectedOwner,
                              decoration: _dialogInputDecoration(
                                'Search owner name or ID...',
                              ),
                              items:
                                  [
                                    'Maria Santos (OWN-0001)',
                                    'Jerome Polo (OWN-0002)',
                                    'Ana Reyes (OWN-0003)',
                                    'Carlos Gomez (OWN-0004)',
                                  ].map((String owner) {
                                    return DropdownMenuItem(
                                      value: owner,
                                      child: Text(
                                        owner,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (val) =>
                                  setDialogState(() => selectedOwner = val),
                            ),
                            const SizedBox(height: 12),

                            // Helper Info Box para sa Pet Selection
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.info_outline_rounded,
                                    size: 18,
                                    color: Color(0xFF64748B),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Please select an owner above first to view their pets.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF64748B),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Service & Assigned Doctor Row
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildDialogFieldLabel('SERVICE*'),
                                      const SizedBox(height: 6),
                                      DropdownButtonFormField<String>(
                                        value: selectedService,
                                        decoration: _dialogInputDecoration(''),
                                        items:
                                            [
                                              'General Checkup',
                                              'Dental Cleaning',
                                              'Vaccination',
                                              'Emergency Surgery',
                                            ].map((String s) {
                                              return DropdownMenuItem(
                                                value: s,
                                                child: Text(
                                                  s,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                        onChanged: (val) => setDialogState(
                                          () => selectedService = val!,
                                        ),
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
                                      _buildDialogFieldLabel(
                                        'ASSIGNED DOCTOR*',
                                      ),
                                      const SizedBox(height: 6),
                                      DropdownButtonFormField<String>(
                                        value: selectedDoctor,
                                        decoration: _dialogInputDecoration(''),
                                        items:
                                            [
                                              'Dr. James Nico Martinez',
                                              'Dr. Sarah Jenkins',
                                              'Dr. Michael Chen',
                                            ].map((String d) {
                                              return DropdownMenuItem(
                                                value: d,
                                                child: Text(
                                                  d,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                        onChanged: (val) => setDialogState(
                                          () => selectedDoctor = val!,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Chief Complaint
                            _buildDialogFieldLabel('CHIEF COMPLAINT*'),
                            const SizedBox(height: 6),
                            TextField(
                              controller: chiefComplaintController,
                              decoration: _dialogInputDecoration(
                                'Enter reason for checkup or surgery...',
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Appointment Date & Time Slot Row
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildDialogFieldLabel(
                                        'APPOINTMENT DATE*',
                                      ),
                                      const SizedBox(height: 6),
                                      TextField(
                                        controller: dateController,
                                        decoration: _dialogInputDecoration('')
                                            .copyWith(
                                              suffixIcon: const Icon(
                                                Icons.calendar_today_rounded,
                                                size: 18,
                                                color: Color(0xFF64748B),
                                              ),
                                            ),
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
                                      _buildDialogFieldLabel('TIME SLOT*'),
                                      const SizedBox(height: 6),
                                      DropdownButtonFormField<String>(
                                        value: selectedTimeSlot,
                                        decoration: _dialogInputDecoration(''),
                                        items:
                                            [
                                              '09:00 AM - 10:30 AM',
                                              '10:30 AM - 12:00 PM',
                                              '01:00 PM - 02:30 PM',
                                              '03:00 PM - 04:30 PM',
                                            ].map((String t) {
                                              return DropdownMenuItem(
                                                value: t,
                                                child: Text(
                                                  t,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                        onChanged: (val) => setDialogState(
                                          () => selectedTimeSlot = val!,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Mark as Urgent Checkbox Box
                            InkWell(
                              onTap: () =>
                                  setDialogState(() => isUrgent = !isUrgent),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isUrgent
                                      ? const Color(0xFFFEF2F2)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isUrgent
                                        ? const Color(0xFFEF4444)
                                        : const Color(0xFFCBD5E1),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.warning_amber_rounded,
                                      color: Color(0xFFEF4444),
                                      size: 22,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'MARK AS URGENT / EMERGENCY CASE',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFFEF4444),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          const Text(
                                            'Prioritizes this walk-in patient in clinic queue',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Color(0xFF64748B),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Checkbox(
                                      value: isUrgent,
                                      activeColor: const Color(0xFFEF4444),
                                      onChanged: (val) =>
                                          setDialogState(() => isUrgent = val!),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Notes / Special Requests
                            _buildDialogFieldLabel('NOTES / SPECIAL REQUESTS'),
                            const SizedBox(height: 6),
                            TextField(
                              controller: notesController,
                              maxLines: 2,
                              decoration: _dialogInputDecoration(
                                'Add medical notes or specific requests...',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Color(0xFFE2E8F0), height: 1),
                    const SizedBox(height: 16),

                    // Fixed Footer Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF173F81),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            if (selectedOwner != null) {
                              setState(() {
                                _appointments.insert(0, {
                                  'petId':
                                      'PET-0000${_appointments.length + 1}',
                                  'petName': 'Patient Pet',
                                  'petBreed': 'Dog • General',
                                  'ownerName': selectedOwner!.split(' (')[0],
                                  'ownerContact': '+1 (555) 234-8901',
                                  'date': dateController.text,
                                  'time': selectedTimeSlot,
                                  'service': selectedService,
                                  'status': isUrgent ? 'Urgent' : 'Pending',
                                });
                              });
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Appointment successfully booked!',
                                  ),
                                  backgroundColor: Color(0xFF059669),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please select a pet owner first.',
                                  ),
                                  backgroundColor: Color(0xFFEF4444),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            'Book Appointment',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDialogFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: Color(0xFF64748B),
        letterSpacing: 0.5,
      ),
    );
  }

  InputDecoration _dialogInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF173F81), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat(
      'EEEE, MMM. dd, yyyy',
    ).format(DateTime.now());

    int allCount = _appointments.length;
    int pendingCount = _appointments
        .where((a) => a['status'] == 'Pending')
        .length;
    int confirmedCount = _appointments
        .where((a) => a['status'] == 'Confirmed')
        .length;
    int upcomingCount = _appointments
        .where((a) => a['status'] == 'Upcoming')
        .length;
    int urgentCount = _appointments
        .where((a) => a['status'] == 'Urgent')
        .length;

    final filteredAppointments = _appointments.where((appt) {
      final matchesStat =
          _selectedStatFilter == 'All' || appt['status'] == _selectedStatFilter;
      final matchesSearch =
          appt['petName'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          appt['petId'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          appt['ownerName'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          appt['service'].toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesStat && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Row(
        children: [
          // Responsive Hover Sidebar
          MouseRegion(
            onEnter: (_) => setState(() => _isExpanded = true),
            onExit: (_) => setState(() => _isExpanded = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              width: _isExpanded ? 260 : 84,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                color: Color(0xFF173F81),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 15,
                    offset: Offset(4, 0),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 26,
                      horizontal: 12,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.pets,
                            color: Color(0xFF173F81),
                            size: 26,
                          ),
                        ),
                        if (_isExpanded) ...[
                          const SizedBox(height: 10),
                          AnimatedOpacity(
                            opacity: _isExpanded ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 200),
                            child: Column(
                              children: const [
                                Text(
                                  'Smart Vet Care',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    letterSpacing: 0.3,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Admin Portal',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                    letterSpacing: 0.2,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: Divider(color: Colors.white24, height: 1),
                  ),
                  const SizedBox(height: 12),
                  _buildNavItem(
                    0,
                    Icons.dashboard_rounded,
                    'Dashboard',
                    '/dashboard',
                  ),
                  _buildNavItem(
                    1,
                    Icons.pets_rounded,
                    'Pet Management',
                    '/pets',
                  ),
                  _buildNavItem(
                    2,
                    Icons.calendar_month_rounded,
                    'Appointment Management',
                    '/appointments',
                  ),
                  _buildNavItem(
                    3,
                    Icons.notifications_rounded,
                    'Notification',
                    '/notifications',
                  ),
                  _buildNavItem(
                    4,
                    Icons.person_rounded,
                    'User Account',
                    '/users',
                  ),
                  _buildNavItem(
                    5,
                    Icons.medical_services_rounded,
                    'Doctor\'s Portal',
                    '/doctors',
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/');
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.redAccent.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: _isExpanded
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.logout_rounded,
                                color: Color(0xFFFCA5A5),
                                size: 18,
                              ),
                              if (_isExpanded) ...[
                                const SizedBox(width: 12),
                                Expanded(
                                  child: AnimatedOpacity(
                                    opacity: _isExpanded ? 1.0 : 0.0,
                                    duration: const Duration(milliseconds: 200),
                                    child: const Text(
                                      'Log Out',
                                      style: TextStyle(
                                        color: Color(0xFFFCA5A5),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Top Header Bar
                Container(
                  height: 75,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x08000000),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Smart Vet Care Portal',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const Text(
                            'Bayside Animal Hospital & Surgical Center',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            size: 16,
                            color: Color(0xFF64748B),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 25),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: const Color(
                              0xFF173F81,
                            ).withValues(alpha: 0.1),
                            child: const Text(
                              'JA',
                              style: TextStyle(
                                color: Color(0xFF173F81),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Junaxanne Agravante',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              Text(
                                'Head Veterinary Nurse',
                                style: TextStyle(
                                  color: Color(0xFF10B981),
                                  fontSize: 11,
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

                // Body Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(28.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title & Schedule Appointment Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Appointment Management',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Manage schedules, intake assessments, patient verifications, and clinical workflows.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: _showScheduleAppointmentDialog,
                              icon: const Icon(
                                Icons.add_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                              label: const Text(
                                'Schedule Appointment',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF173F81),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 22,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Search Bar
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
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
                              hintText:
                                  'Search by Pet ID, Pet Name, Owner, or Service...',
                              hintStyle: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 13,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // CLICKABLE Stat Cards
                        Row(
                          children: [
                            Expanded(
                              child: _buildAppointmentStatCard(
                                'ALL APPOINTMENTS',
                                allCount.toString(),
                                Icons.grid_view_rounded,
                                const Color(0xFF173F81),
                                'All',
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: _buildAppointmentStatCard(
                                'PENDING REQUESTS',
                                pendingCount.toString(),
                                Icons.pending_actions_rounded,
                                const Color(0xFFD97706),
                                'Pending',
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: _buildAppointmentStatCard(
                                'CONFIRMED TODAY',
                                confirmedCount.toString(),
                                Icons.check_circle_rounded,
                                const Color(0xFF059669),
                                'Confirmed',
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: _buildAppointmentStatCard(
                                'UPCOMING THIS WEEK',
                                upcomingCount.toString(),
                                Icons.event_available_rounded,
                                const Color(0xFF2563EB),
                                'Upcoming',
                              ),
                            ),
                            const SizedBox(width: 14),
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

                        // Appointments Table Container
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
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
                              // Table Header
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: const [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'PET ID',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        'PET INFO',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        'OWNER',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        'DATE & TIME',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'SERVICES',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'ACTIONS / STATUS',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Table Rows
                              filteredAppointments.isEmpty
                                  ? const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 40,
                                      ),
                                      child: Center(
                                        child: Text(
                                          'No appointments found for this category.',
                                          style: TextStyle(
                                            color: Color(0xFF94A3B8),
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: filteredAppointments.length,
                                      itemBuilder: (context, index) {
                                        final appt =
                                            filteredAppointments[index];
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 16,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: const Color(0xFFF1F5F9),
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  appt['petId'],
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13,
                                                    color: Color(0xFF173F81),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            6,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            const Color(
                                                              0xFF173F81,
                                                            ).withValues(
                                                              alpha: 0.1,
                                                            ),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: const Icon(
                                                        Icons.pets_rounded,
                                                        size: 14,
                                                        color: Color(
                                                          0xFF173F81,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          appt['petName'],
                                                          style:
                                                              const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 13,
                                                                color: Color(
                                                                  0xFF1E293B,
                                                                ),
                                                              ),
                                                        ),
                                                        const SizedBox(
                                                          height: 2,
                                                        ),
                                                        Text(
                                                          appt['petBreed'],
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 11,
                                                                color: Color(
                                                                  0xFF64748B,
                                                                ),
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      appt['ownerName'],
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13,
                                                        color: Color(
                                                          0xFF1E293B,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      appt['ownerContact'],
                                                      style: const TextStyle(
                                                        fontSize: 11,
                                                        color: Color(
                                                          0xFF64748B,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      appt['date'],
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13,
                                                        color: Color(
                                                          0xFF1E293B,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      appt['time'],
                                                      style: const TextStyle(
                                                        fontSize: 11,
                                                        color: Color(
                                                          0xFF64748B,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 4,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                        0xFFEFF6FF,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      appt['service'],
                                                      style: const TextStyle(
                                                        color: Color(
                                                          0xFF2563EB,
                                                        ),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Center(
                                                  child:
                                                      _buildActionStatusBadge(
                                                        appt,
                                                        index,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                            ],
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
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? color : const Color(0xFF64748B),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  count,
                  style: TextStyle(
                    color: color,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionStatusBadge(Map<String, dynamic> appt, int index) {
    String status = appt['status'];
    if (status == 'Pending') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                appt['status'] = 'Confirmed';
              });
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFFECFDF5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                size: 14,
                color: Color(0xFF059669),
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {
              setState(() {
                appt['status'] = 'Cancelled';
              });
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFFFEF2F2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 14,
                color: Color(0xFFEF4444),
              ),
            ),
          ),
        ],
      );
    } else {
      Color badgeColor = const Color(0xFF64748B);
      Color bgColor = const Color(0xFFF1F5F9);
      if (status == 'Confirmed') {
        badgeColor = const Color(0xFF059669);
        bgColor = const Color(0xFFECFDF5);
      } else if (status == 'Upcoming') {
        badgeColor = const Color(0xFF2563EB);
        bgColor = const Color(0xFFEFF6FF);
      } else if (status == 'Urgent') {
        badgeColor = const Color(0xFFEF4444);
        bgColor = const Color(0xFFFEF2F2);
      } else if (status == 'Completed') {
        badgeColor = const Color(0xFF059669);
        bgColor = const Color(0xFFECFDF5);
      } else if (status == 'Cancelled') {
        badgeColor = const Color(0xFFEF4444);
        bgColor = const Color(0xFFFEF2F2);
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          status,
          style: TextStyle(
            color: badgeColor,
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
      );
    }
  }

  Widget _buildNavItem(int index, IconData icon, String title, String route) {
    bool isSelected = _selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
            if (index == 0) {
              Navigator.pushReplacementNamed(context, '/dashboard');
            } else if (index == 1) {
              Navigator.pushReplacementNamed(context, '/pets');
            } else if (index == 2) {
              Navigator.pushReplacementNamed(context, '/appointments');
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected
                      ? Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1,
                        )
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: _isExpanded
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      color: isSelected ? Colors.white : Colors.white70,
                      size: 20,
                    ),
                    if (_isExpanded) ...[
                      const SizedBox(width: 14),
                      Expanded(
                        child: AnimatedOpacity(
                          opacity: _isExpanded ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: Text(
                            title,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.white70,
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              letterSpacing: 0.2,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isSelected)
                Positioned(
                  left: 0,
                  top: 8,
                  bottom: 8,
                  child: Container(
                    width: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFF60A5FA),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF60A5FA).withValues(alpha: 0.6),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
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
}
