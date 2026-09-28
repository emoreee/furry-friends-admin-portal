import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furry_friends_admin/widgets/sidebar_widget.dart';

class HealthMonitoringView extends StatefulWidget {
  const HealthMonitoringView({super.key});

  @override
  State<HealthMonitoringView> createState() => _HealthMonitoringViewState();
}

class _HealthMonitoringViewState extends State<HealthMonitoringView> {
  String _activeTab = 'All Active';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Mapa ang UI Tabs papunta sa totoong Firestore Statuses
  String _mapTabToStatus(String tab) {
    if (tab == 'Critical / ICU') return 'URGENT';
    if (tab == 'Post-Surgery') return 'Post-Surgery';
    if (tab == 'Discharged') return 'Discharged';
    return 'All Active';
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
          const SidebarWidget(currentRoute: '/health'),
          Expanded(
            child: Column(
              children: [
                // ==========================================
                // TOP HEADER
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
                                errorBuilder: (context, error, stackTrace) =>
                                    const Center(
                                      child: Text(
                                        'JA',
                                        style: TextStyle(
                                          color: Color(0xFF183F82),
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
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
                // MAIN SCROLLABLE DASHBOARD
                // ==========================================
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // GRADIENT BANNER
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
                                  const Text(
                                    'Health Monitoring & ICU Vitals',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Real-time clinical metrics, SOAP notes, and emergency alerts for admitted patients.',
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.8,
                                      ),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
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
                        const SizedBox(height: 24),

                        // FILTER TABS & SEARCH BAR
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.03,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: (value) => setState(
                                    () => _searchQuery = value.toLowerCase(),
                                  ),
                                  style: const TextStyle(fontSize: 13),
                                  decoration: const InputDecoration(
                                    hintText: 'Search Pet ID or Name...',
                                    hintStyle: TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 13,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search_rounded,
                                      color: Color(0xFF94A3B8),
                                      size: 20,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 3,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _buildTab('All Active'),
                                    _buildTab('Critical / ICU'),
                                    _buildTab('Post-Surgery'),
                                    _buildTab('Discharged'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // FIRESTORE STREAM BUILDER (REAL-TIME DATA)
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('health_monitoring')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(40.0),
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF183F82),
                                  ),
                                ),
                              );
                            }

                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(60.0),
                                  child: Text(
                                    'No monitored patients found in the database.',
                                    style: TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              );
                            }

                            final docs = snapshot.data!.docs;
                            final List<Map<String, dynamic>> filteredPatients =
                                [];

                            for (var doc in docs) {
                              final data = doc.data() as Map<String, dynamic>;
                              final statusStr =
                                  data['status']?.toString().toUpperCase() ??
                                  'UNKNOWN';

                              bool matchesTab = true;
                              if (_activeTab != 'All Active') {
                                final expectedStatus = _mapTabToStatus(
                                  _activeTab,
                                ).toUpperCase();
                                matchesTab = (statusStr == expectedStatus);
                              } else {
                                matchesTab = statusStr != 'DISCHARGED';
                              }

                              final pName =
                                  data['petName']?.toString().toLowerCase() ??
                                  '';
                              final pId =
                                  data['petId']?.toString().toLowerCase() ?? '';
                              bool matchesSearch =
                                  pName.contains(_searchQuery) ||
                                  pId.contains(_searchQuery);

                              if (matchesTab && matchesSearch) {
                                final vitals =
                                    data['vitals'] as Map<String, dynamic>? ??
                                    {};

                                filteredPatients.add({
                                  'id': data['petId'] ?? 'N/A',
                                  'name': data['petName'] ?? 'Unknown',
                                  'breed': data['breed'] ?? 'Unknown',
                                  'species':
                                      (data['breed']
                                              .toString()
                                              .toLowerCase()
                                              .contains('feline') ||
                                          data['breed']
                                              .toString()
                                              .toLowerCase()
                                              .contains('cat'))
                                      ? 'Feline'
                                      : 'Canine',
                                  'status': data['status'] ?? 'Unknown',
                                  'temp':
                                      double.tryParse(
                                        vitals['temperature']?.toString() ??
                                            '0',
                                      ) ??
                                      0.0,
                                  'spo2':
                                      int.tryParse(
                                        vitals['respiratoryRate']?.toString() ??
                                            '0',
                                      ) ??
                                      98,
                                  'bpm':
                                      int.tryParse(
                                        vitals['heartRate']?.toString() ?? '0',
                                      ) ??
                                      0,
                                  'currentWeight':
                                      double.tryParse(
                                        vitals['weight']?.toString() ?? '0',
                                      ) ??
                                      0.0,
                                  'admissionWeight':
                                      double.tryParse(
                                        vitals['weight']?.toString() ?? '0',
                                      ) ??
                                      0.0,
                                  'soap':
                                      data['chiefComplaint'] ??
                                      'No notes available.',
                                  'ivRate':
                                      data['locationBay'] ?? 'General Ward',
                                  'ownerId': data['ownerId'] ?? 'Unknown',
                                  'doctorName':
                                      data['doctorName'] ?? 'Unassigned',
                                });
                              }
                            }

                            if (filteredPatients.isEmpty) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(60.0),
                                  child: Text(
                                    'No matching patients found in this category.',
                                    style: TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              );
                            }

                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: filteredPatients.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 20),
                              itemBuilder: (context, index) {
                                return _PatientHealthCard(
                                  patient: filteredPatients[index],
                                );
                              },
                            );
                          },
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

  Widget _buildTab(String label) {
    bool isSelected = _activeTab == label;
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: InkWell(
        onTap: () => setState(() => _activeTab = label),
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
            label,
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
// COMPLEX PATIENT HEALTH CARD
// ===================================================================
class _PatientHealthCard extends StatelessWidget {
  final Map<String, dynamic> patient;

  const _PatientHealthCard({required this.patient});

  // ==========================================
  // COMPLETE MEDICAL HISTORY MODAL (WITH FIRESTORE)
  // ==========================================
  void _showMedicalHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(40),
          child: Container(
            width: 900,
            height: 700,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 24,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8FAFC),
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF183F82,
                              ).withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.history_edu_rounded,
                              color: Color(0xFF183F82),
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${patient['name']}\'s Medical History',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'ID: ${patient['id']}  •  ${patient['breed']}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF64748B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),

                // BODY CONTENT
                Expanded(
                  child: Row(
                    children: [
                      // LEFT SIDE: PROFILE SUMMARY
                      Container(
                        width: 300,
                        padding: const EdgeInsets.all(32),
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'PATIENT SUMMARY',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF94A3B8),
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 24),
                            _buildSummaryItem(
                              Icons.pets,
                              'Species',
                              patient['species'],
                            ),
                            const SizedBox(height: 16),
                            _buildSummaryItem(
                              Icons.monitor_weight_outlined,
                              'Current Weight',
                              '${patient['currentWeight']} kg',
                            ),
                            const SizedBox(height: 16),
                            _buildSummaryItem(
                              Icons.medical_services_outlined,
                              'Attending Vet',
                              patient['doctorName'],
                            ),
                            const SizedBox(height: 16),
                            _buildSummaryItem(
                              Icons.person_outline,
                              'Owner ID',
                              patient['ownerId'],
                            ),
                            const SizedBox(height: 32),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF2F2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFFCA5A5),
                                ),
                              ),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.warning_amber_rounded,
                                        color: Color(0xFFDC2626),
                                        size: 16,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Known Allergies',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFDC2626),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '• Verify with owner\n• No known data yet',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF991B1B),
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // RIGHT SIDE: FIRESTORE MEDICAL TIMELINE
                      Expanded(
                        child: Container(
                          color: const Color(0xFFF8FAFC).withValues(alpha: 0.5),
                          child: StreamBuilder<QuerySnapshot>(
                            // Kumukuha ng records mula sa medical_records collection base sa petId
                            stream: FirebaseFirestore.instance
                                .collection('medical_records')
                                .where('petId', isEqualTo: patient['id'])
                                .orderBy('createdAt', descending: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return const Center(
                                  child: Text(
                                    'No historical medical records found.',
                                    style: TextStyle(color: Color(0xFF64748B)),
                                  ),
                                );
                              }

                              final records = snapshot.data!.docs;

                              return ListView.builder(
                                padding: const EdgeInsets.all(32),
                                physics: const BouncingScrollPhysics(),
                                itemCount:
                                    records.length +
                                    1, // +1 for the header text
                                itemBuilder: (context, index) {
                                  if (index == 0) {
                                    return const Padding(
                                      padding: EdgeInsets.only(bottom: 24),
                                      child: Text(
                                        'CLINICAL TIMELINE',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF94A3B8),
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    );
                                  }

                                  final recordData =
                                      records[index - 1].data()
                                          as Map<String, dynamic>;

                                  // Formatting Date
                                  String dateStr = 'Unknown Date';
                                  if (recordData['createdAt'] != null) {
                                    if (recordData['createdAt'] is Timestamp) {
                                      dateStr =
                                          DateFormat(
                                            'MMMM dd, yyyy • hh:mm a',
                                          ).format(
                                            (recordData['createdAt']
                                                    as Timestamp)
                                                .toDate(),
                                          );
                                    } else if (recordData['createdAt']
                                        is String) {
                                      dateStr = recordData['createdAt'];
                                    }
                                  }

                                  // Extracting data fields based on your DB structure
                                  final service =
                                      recordData['service'] ?? 'Consultation';
                                  final diagnosis =
                                      recordData['diagnosis'] ??
                                      'No diagnosis recorded.';
                                  final vetNotes =
                                      recordData['veterinarianNotes'] ?? '';
                                  final isUrgent =
                                      recordData['isUrgent'] == true ||
                                      recordData['isUrgent'] == 'true';

                                  final content =
                                      '$diagnosis\n\nNotes: $vetNotes';

                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 24.0,
                                    ),
                                    child: _buildTimelineItem(
                                      date: dateStr,
                                      title: service,
                                      doctor:
                                          patient['doctorName'], // O kung may specific doctor field sa record
                                      icon: isUrgent
                                          ? Icons.local_hospital_rounded
                                          : Icons.health_and_safety_rounded,
                                      iconColor: isUrgent
                                          ? const Color(0xFFEF4444)
                                          : const Color(0xFF059669),
                                      content: content,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineItem({
    required String date,
    required String title,
    required String doctor,
    required IconData icon,
    required Color iconColor,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(height: 8),
            Container(width: 2, height: 80, color: const Color(0xFFE2E8F0)),
          ],
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        date,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Attending: $doctor',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(color: Color(0xFFF1F5F9)),
                const SizedBox(height: 12),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF334155),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Threshold Analytics
    double temp = patient['temp'];
    int spo2 = patient['spo2'];

    // Status Colors based on database values
    Color statusColor;
    String rawStatus = patient['status'].toString().toUpperCase();

    if (rawStatus == 'URGENT' || rawStatus == 'CRITICAL / ICU') {
      statusColor = const Color(0xFFEF4444);
    } else if (rawStatus == 'POST-SURGERY') {
      statusColor = const Color(0xFFD97706);
    } else if (rawStatus == 'DISCHARGED') {
      statusColor = const Color(0xFF64748B);
    } else {
      statusColor = const Color(0xFF059669);
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: statusColor.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CARD HEADER
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        patient['species'] == 'Feline'
                            ? Icons.cruelty_free
                            : Icons.pets,
                        color: statusColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              patient['name'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: statusColor.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                patient['status'].toString().toUpperCase(),
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${patient['id']} • ${patient['breed']}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Quick Actions Top Right
                Row(
                  children: [
                    _buildIconButton(
                      Icons.add_chart_rounded,
                      'Log Vitals',
                      const Color(0xFF2563EB),
                    ),
                    const SizedBox(width: 8),
                    _buildIconButton(
                      Icons.science_outlined,
                      'Labs',
                      const Color(0xFF059669),
                    ),
                    const SizedBox(width: 8),
                    _buildIconButton(
                      Icons.warning_amber_rounded,
                      'Alert',
                      const Color(0xFFEF4444),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // CARD BODY: VITALS & SOAP
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // LEFT: Vitals Grid
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'REAL-TIME VITALS',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF94A3B8),
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildVitalBox(
                              'Temperature',
                              '${temp.toStringAsFixed(1)}°C',
                              _getTempStatus(temp),
                              Icons.thermostat,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildVitalBox(
                              'Resp. Rate',
                              '$spo2 bpm',
                              _getSpo2Status(spo2),
                              Icons.air,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildVitalBox(
                              'Heart Rate',
                              '${patient['bpm']} bpm',
                              'Normal',
                              Icons.favorite_rounded,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildVitalBox(
                              'Weight Track',
                              '${patient['currentWeight']} kg',
                              _getWeightTrend(
                                patient['currentWeight'],
                                patient['admissionWeight'],
                              ),
                              Icons.scale_rounded,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // DIVIDER
                Container(
                  width: 1,
                  height: 160,
                  color: const Color(0xFFE2E8F0),
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                ),

                // RIGHT: Clinical Notes
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'CLINICAL STATUS & COMPLAINT',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF94A3B8),
                              letterSpacing: 0.8,
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: const Text(
                              'Edit Notes',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Text(
                          patient['soap'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF334155),
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            size: 14,
                            color: Color(0xFF0EA5E9),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Location: ${patient['ivRate']}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0284C7),
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

          // CARD FOOTER
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Live Data from Database',
                  style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                ),
                TextButton(
                  onPressed: () => _showMedicalHistoryDialog(context),
                  child: const Text(
                    'View Complete Medical History →',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF183F82),
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

  // LOGIC HELPERS FOR VITALS
  String _getTempStatus(double temp) {
    if (temp > 39.5) return 'Fever';
    if (temp < 37.5) return 'Hypothermia';
    return 'Normal';
  }

  String _getSpo2Status(int spo2) {
    if (spo2 < 20 || spo2 > 60)
      return 'Abnormal'; // Adjust based on pet normal resp rate
    return 'Normal';
  }

  String _getWeightTrend(double current, double admission) {
    if (current < admission) {
      return 'Dropped (-${(admission - current).toStringAsFixed(1)}kg)';
    }
    if (current > admission) {
      return 'Gained (+${(current - admission).toStringAsFixed(1)}kg)';
    }
    return 'Stable';
  }

  // REUSABLE VITAL BOX
  Widget _buildVitalBox(
    String title,
    String value,
    String status,
    IconData icon,
  ) {
    Color statusColor;
    Color bgColor;

    if (status.contains('Fever') ||
        status.contains('Abnormal') ||
        status.contains('Hypothermia')) {
      statusColor = const Color(0xFFEF4444); // Red Warning
      bgColor = const Color(0xFFFEF2F2);
    } else if (status.contains('Dropped')) {
      statusColor = const Color(0xFFD97706); // Orange Warning
      bgColor = const Color(0xFFFFFBEB);
    } else {
      statusColor = const Color(0xFF059669); // Green Normal
      bgColor = const Color(0xFFECFDF5);
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: statusColor.withValues(alpha: 0.7)),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  color: statusColor.withValues(alpha: 0.8),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: statusColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            status,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  // REUSABLE QUICK ACTION BUTTON
  Widget _buildIconButton(IconData icon, String tooltip, Color color) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );
  }
}
