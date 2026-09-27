import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// Tiyaking tama ang path papunta sa iyong sidebar widget file
import '../doctor/doctor_sidebar_widget.dart';

class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final String _currentDoctorName = 'Dr. Alfie Tamesis';
  final String _currentDoctorImagePath = 'assets/images/dr.Alfie.jpg';

  String _consultationTab = 'All Patients (0)';

  // BAGONG STATE: Kung anong Stat Card ang pinindot
  String _activeStatFilter = 'Patients Today';

  // DYNAMIC PET NAME RESOLVER
  Future<String> _resolvePetName(Map<String, dynamic> data) async {
    if (data['petName'] != null &&
        data['petName'].toString().trim().isNotEmpty) {
      return data['petName'].toString().trim();
    }
    if (data['name'] != null && data['name'].toString().trim().isNotEmpty) {
      return data['name'].toString().trim();
    }

    final petId = data['petId']?.toString().trim();
    if (petId != null && petId.isNotEmpty) {
      try {
        final query = await _db
            .collection('pets')
            .where('petId', isEqualTo: petId)
            .limit(1)
            .get();
        if (query.docs.isNotEmpty) {
          final pData = query.docs.first.data();
          return (pData['name'] ?? pData['petName'] ?? petId).toString();
        }
      } catch (e) {}
    }
    return petId ?? 'Pet Patient';
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat(
      'EEEE, MMMM d, yyyy',
    ).format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==========================================
          // 1. SIDEBAR INTEGRATION
          // ==========================================
          const DoctorSidebarWidget(currentRoute: '/doctor'),

          // ==========================================
          // 2. MAIN CONTENT AREA
          // ==========================================
          Expanded(
            child: Column(
              children: [
                _buildTopHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48.0,
                      vertical: 36.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ==========================================
                        // GRADIENT BANNER (MAY GREETING AT DATE)
                        // ==========================================
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(32),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Good morning, $_currentDoctorName',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.2,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(
                                              alpha: 0.2,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            border: Border.all(
                                              color: Colors.white.withValues(
                                                alpha: 0.3,
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.calendar_today_rounded,
                                                color: Colors.white,
                                                size: 14,
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                formattedDate,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Here are your scheduled patient consultations and clinic activities for today.',
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
                                  color: Colors.white.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.monitor_heart_rounded,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // INTERACTIVE STAT CARDS
                        _buildStatCardsRow(),
                        const SizedBox(height: 32),

                        // DYNAMIC SECTION BASE SA KUNG ANONG CARD ANG PININDOT
                        _buildDynamicSection(),
                        const SizedBox(height: 48),
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

  // ==========================================
  // TOP HEADER (May Picture at Pangalan ng Doctor sa Top Left)
  // ==========================================
  Widget _buildTopHeader() {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 48),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Doctor Profile Section sa Top Left
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        _currentDoctorImagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFFF1F5F9),
                            child: const Icon(
                              Icons.person_rounded,
                              size: 24,
                              color: Color(0xFF94A3B8),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentDoctorName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const Text(
                        'Chief Veterinarian',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 40),
              // Search Bar
              Container(
                width: 380,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search patients, microchips, lab reports...',
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF94A3B8),
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      size: 20,
                      color: Color(0xFF2563EB),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 13),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.notifications_none_rounded,
                      color: Color(0xFF475569),
                      size: 20,
                    ),
                  ),
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.help_outline_rounded,
                  color: Color(0xFF475569),
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // INTERACTIVE STAT CARDS ROW
  // ==========================================
  Widget _buildStatCardsRow() {
    final todayStr = DateTime.now().toString().split(' ')[0];

    return Row(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: _db.collection('appointments').snapshots(),
          builder: (context, snapshot) {
            int activeCount = 0;
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              activeCount = snapshot.data!.docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final status = (data['status'] ?? '').toString().toLowerCase();
                final date = (data['date'] ?? '').toString();
                return status != 'completed' &&
                    status != 'cancelled' &&
                    date == todayStr;
              }).length;
            }
            return _buildStatCard(
              title: 'PATIENTS TODAY',
              value: activeCount < 10 ? '0$activeCount' : '$activeCount',
              subtext: activeCount > 0
                  ? 'Active schedule today'
                  : 'No patients queued',
              icon: Icons.calendar_today_rounded,
              accentColor: const Color(0xFF2563EB), // Royal Blue
            );
          },
        ),
        const SizedBox(width: 20),
        StreamBuilder<QuerySnapshot>(
          stream: _db.collection('health_monitoring').snapshots(),
          builder: (context, snapshot) {
            int pendingLabs = 0;
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              pendingLabs = snapshot.data!.docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final status = (data['status'] ?? data['labStatus'] ?? '')
                    .toString()
                    .toLowerCase();
                return status.contains('pending') ||
                    status.contains('progress');
              }).length;
            }
            return _buildStatCard(
              title: 'PENDING LAB RESULTS',
              value: pendingLabs < 10 ? '0$pendingLabs' : '$pendingLabs',
              subtext: pendingLabs > 0
                  ? 'Tests ready for review'
                  : 'All lab reports complete',
              icon: Icons.science_rounded,
              accentColor: const Color(0xFF0EA5E9), // Sky Blue
            );
          },
        ),
        const SizedBox(width: 20),
        StreamBuilder<QuerySnapshot>(
          stream: _db.collection('appointments').snapshots(),
          builder: (context, snapshot) {
            int urgentCount = 0;
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              urgentCount = snapshot.data!.docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final isUrgent = data['isUrgent'] ?? false;
                final status = (data['status'] ?? '').toString().toLowerCase();
                return isUrgent == true &&
                    status != 'completed' &&
                    status != 'cancelled';
              }).length;
            }
            return _buildStatCard(
              title: 'URGENT CONSULTATIONS',
              value: urgentCount < 10 ? '0$urgentCount' : '$urgentCount',
              subtext: urgentCount > 0
                  ? 'Requires immediate attention'
                  : 'No urgent cases',
              icon: Icons.warning_amber_rounded,
              accentColor: const Color(0xFFEF4444), // Red for Urgent
            );
          },
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtext,
    required IconData icon,
    required Color accentColor,
  }) {
    bool isActive = _activeStatFilter == title;

    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _activeStatFilter = title;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 22.0,
            ),
            decoration: BoxDecoration(
              color: isActive
                  ? accentColor.withValues(alpha: 0.05)
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isActive ? accentColor : const Color(0xFFE2E8F0),
                width: isActive ? 2 : 1,
              ),
              boxShadow: [
                if (isActive)
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  )
                else
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: isActive
                              ? accentColor
                              : const Color(0xFF64748B),
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          color: isActive
                              ? accentColor
                              : const Color(0xFF0F172A),
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtext,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accentColor.withValues(alpha: 0.15),
                        accentColor.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: accentColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Icon(icon, color: accentColor, size: 28),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // DYNAMIC SECTION SWITCHER
  // ==========================================
  Widget _buildDynamicSection() {
    if (_activeStatFilter == 'PATIENTS TODAY') {
      return _buildPatientConsultationsSection();
    } else if (_activeStatFilter == 'PENDING LAB RESULTS') {
      return _buildPendingLabResultsSection();
    } else {
      return _buildUrgentConsultationsSection();
    }
  }

  // ==========================================
  // 1. PATIENT CONSULTATIONS SECTION (Default)
  // ==========================================
  Widget _buildPatientConsultationsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header & Tabs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.calendar_month_rounded,
                      size: 20,
                      color: Color(0xFF2563EB),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Today\'s Patient Consultations',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      '08:00 AM - 06:00 PM',
                      style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      _buildTabButton('All Patients (0)'),
                      _buildTabButton('In-Consultation'),
                      _buildTabButton('Scheduled'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Body (Empty State)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFEFF6FF), Color(0xFFDBEAFE)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withValues(alpha: 0.15),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.event_note_rounded,
                    size: 40,
                    color: Color(0xFF2563EB),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'No Active Patients Today Scheduled',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'There are currently no active appointments matching this filter.',
                  style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 2. PENDING LAB RESULTS SECTION (Linked to Sky Blue Card)
  // ==========================================
  Widget _buildPendingLabResultsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0EA5E9).withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 24.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.science_rounded,
                      size: 20,
                      color: Color(0xFF0EA5E9),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Pending Lab Results',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F9FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFBAE6FD)),
                      ),
                      child: const Text(
                        '3 records',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0284C7),
                        ),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'View All Records →',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0EA5E9),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // Table Content
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 24.0,
            ),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(2.5),
                1: FlexColumnWidth(2.0),
                2: FlexColumnWidth(1.5),
                3: FlexColumnWidth(1.0),
                4: FlexColumnWidth(0.6),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                const TableRow(
                  children: [
                    _DoctorTableHeader('PATIENT'),
                    _DoctorTableHeader('TEST TYPE'),
                    _DoctorTableHeader('REQUESTED BY'),
                    _DoctorTableHeader('STATUS'),
                    _DoctorTableHeader('ACTION'),
                  ],
                ),
                // MOCK DATA FOR LABS
                _buildLabRow(
                  'Bambam',
                  'Golden Retriever, Canine • ID #V-4082',
                  'Checkup Test',
                  'Dr. Alfie Tamesis',
                  'PENDING',
                  isWarning: true,
                ),
                _buildLabRow(
                  'Sky',
                  'Siamese Cat, Feline • ID #V-3914',
                  'Checkup Test (Biochemical Panel)',
                  'Dr. Alfie Tamesis',
                  'COMPLETED',
                ),
                _buildLabRow(
                  'Mosang',
                  'French Bulldog, Canine • ID #V-4128',
                  'Checkup Test (Routine Bloodwork)',
                  'Dr. Vance',
                  'COMPLETED',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 3. URGENT CONSULTATIONS SECTION (Linked to Red Card)
  // ==========================================
  Widget _buildUrgentConsultationsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEF4444).withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              children: const [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 20,
                  color: Color(0xFFEF4444),
                ),
                SizedBox(width: 12),
                Text(
                  'Urgent Consultations',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),

          // Stream Builder for Real-Time Data
          StreamBuilder<QuerySnapshot>(
            stream: _db.collection('appointments').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final urgentDocs = snapshot.data!.docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final isUrgent = data['isUrgent'] ?? false;
                final status = (data['status'] ?? '').toString().toLowerCase();
                return isUrgent == true &&
                    status != 'completed' &&
                    status != 'cancelled';
              }).toList();

              if (urgentDocs.isEmpty) {
                return _buildUrgentEmptyState();
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                itemCount: urgentDocs.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final data = urgentDocs[index].data() as Map<String, dynamic>;
                  final docId = urgentDocs[index].id;
                  return _buildUrgentCaseCard(data, docId);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // ==========================================
  // URGENT EMPTY STATE
  // ==========================================
  Widget _buildUrgentEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFEF2F2), Color(0xFFFEE2E2)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_circle_outline_rounded,
                size: 40,
                color: Color(0xFFEF4444),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Urgent Cases Queued',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'All immediate attention cases have been resolved or stabilized.',
              style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // URGENT CASE CARD
  // ==========================================
  Widget _buildUrgentCaseCard(Map<String, dynamic> data, String docId) {
    final breed = data['breed'] ?? data['species'] ?? 'Unknown Breed';
    final reason = data['reason'] ?? data['service'] ?? 'Critical Emergency';
    final time = data['time'] ?? DateFormat('hh:mm a').format(DateTime.now());

    return FutureBuilder<String>(
      future: _resolvePetName(data),
      builder: (context, snapshot) {
        final petName = snapshot.data ?? 'Patient...';
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF2F2), // Light Red Background
            border: Border.all(color: const Color(0xFFFCA5A5)), // Red border
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFFEF4444),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.medical_services_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              // Middle-Left: Details
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          petName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF991B1B),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEE2E2),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: const Color(0xFFF87171)),
                          ),
                          child: const Text(
                            'EMERGENCY',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFDC2626),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      breed,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFB91C1C),
                      ),
                    ),
                  ],
                ),
              ),

              // Middle: Complaint & Time
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CRITICAL COMPLAINT',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFEF4444),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      reason,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7F1D1D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          size: 12,
                          color: Color(0xFFDC2626),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Triage Time: $time',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFFB91C1C),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Right: Action Buttons
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFD97706), // Amber
                          side: const BorderSide(color: Color(0xFFFCD34D)),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'View Vital Signs',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444), // Red
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Mark Stabilized',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.person_add_alt_1,
                      size: 12,
                      color: Color(0xFFDC2626),
                    ),
                    label: const Text(
                      'Assign ER Doctor',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFDC2626),
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ==========================================
  // HELPERS
  // ==========================================
  Widget _buildTabButton(String title) {
    bool isActive = _consultationTab == title;
    return GestureDetector(
      onTap: () => setState(() => _consultationTab = title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.blue.withValues(alpha: 0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
            color: isActive ? const Color(0xFF2563EB) : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  TableRow _buildLabRow(
    String petName,
    String details,
    String test,
    String doctor,
    String status, {
    bool isWarning = false,
  }) {
    bool isCompleted = status == 'COMPLETED';
    return TableRow(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF8FAFC))),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF8FAFC), Color(0xFFEFF6FF)],
                  ),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  details.contains('Canine')
                      ? Icons.pets_rounded
                      : Icons.catching_pokemon_rounded,
                  size: 20,
                  color: const Color(0xFF2563EB),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    petName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    details,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Text(
          test,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF334155),
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          doctor,
          style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isWarning
                  ? const Color(0xFFFFFBEB)
                  : const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isWarning
                    ? const Color(0xFFFDE68A)
                    : const Color(0xFFBBF7D0),
              ),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isWarning
                    ? const Color(0xFFD97706)
                    : const Color(0xFF16A34A),
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.description_outlined,
            size: 18,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }
}

class _DoctorTableHeader extends StatelessWidget {
  final String label;
  const _DoctorTableHeader(this.label);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Color(0xFF94A3B8),
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
