import 'package:flutter/material.dart';
import '../doctor/doctor_sidebar_widget.dart'; // Tiyaking tama ang path sa sidebar

class DoctorLabDiagnosticsScreen extends StatefulWidget {
  const DoctorLabDiagnosticsScreen({super.key});

  @override
  State<DoctorLabDiagnosticsScreen> createState() =>
      _DoctorLabDiagnosticsScreenState();
}

class _DoctorLabDiagnosticsScreenState
    extends State<DoctorLabDiagnosticsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==========================================
          // 1. SIDEBAR
          // ==========================================
          const DoctorSidebarWidget(currentRoute: '/doctor/lab'),

          // ==========================================
          // 2. MAIN CONTENT
          // ==========================================
          Expanded(
            child: Column(
              children: [
                _buildTopHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: 24.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBreadcrumbsAndTitle(),
                        const SizedBox(height: 20),

                        // PATIENT HEADER CARD
                        _buildPatientInfoCard(),
                        const SizedBox(height: 16),

                        // FILTERS SECTION
                        _buildFiltersSection(),
                        const SizedBox(height: 24),

                        // MAIN TWO-COLUMN LAYOUT
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // LEFT COLUMN: TEST TIMELINE (Flex 4)
                            Expanded(
                              flex: 4,
                              child: Column(
                                children: [
                                  _buildTestHistoryTimeline(),
                                  const SizedBox(height: 16),
                                  _buildLatestVitalsCard(),
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),
                            // RIGHT COLUMN: ACTIVE PANEL RESULTS (Flex 7)
                            Expanded(
                              flex: 7,
                              child: _buildActivePanelDetails(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
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
  // TOP HEADER
  // ==========================================
  Widget _buildTopHeader() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text(
                'Furry Friends Clinical',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00174B),
                ),
              ),
              const SizedBox(width: 24),
              Container(
                width: 320,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search patients, microchips, lab reports...',
                    hintStyle: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 16,
                      color: Color(0xFF94A3B8),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 16, color: Colors.white),
                label: const Text(
                  '+ New Patient / Consult',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00174B),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.notifications_none,
                color: Color(0xFF64748B),
                size: 20,
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.help_outline,
                color: Color(0xFF64748B),
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TITLE & BREADCRUMBS
  // ==========================================
  Widget _buildBreadcrumbsAndTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Text(
              'PATIENTS > CANINE > BAMBAM (#V-4082) > ',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Color(0xFF94A3B8),
                letterSpacing: 0.5,
              ),
            ),
            Text(
              'LAB & DIAGNOSTICS',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00174B),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Lab Diagnostic Results',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.history,
                    size: 16,
                    color: Color(0xFF475569),
                  ),
                  label: const Text(
                    'Request History',
                    style: TextStyle(
                      color: Color(0xFF475569),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.science_outlined,
                    size: 16,
                    color: Colors.white,
                  ),
                  label: const Text(
                    '+ New Lab Request',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00174B),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================
  // PATIENT INFO CARD
  // ==========================================
  Widget _buildPatientInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: AssetImage('assets/images/clinic_lab_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Bambam',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '#V-4082',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    _buildPatientDetailRow(
                      Icons.pets,
                      'Canine • Golden Retriever',
                    ),
                    _buildPatientDetailRow(
                      Icons.cake_outlined,
                      '4 yrs 2 mos | Male (Neutered) | 31.4 kg',
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    _buildPatientDetailRow(
                      Icons.person_outline,
                      'Owner: Eleanor Vance',
                      isBold: true,
                    ),
                    _buildPatientDetailRow(
                      Icons.phone_outlined,
                      '+1 (555) 234-8901',
                    ),
                    _buildPatientDetailRow(
                      Icons.location_on_outlined,
                      'Ward A • Kennel #B-04',
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20),
            decoration: const BoxDecoration(
              border: Border(left: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CLINICAL RISK INDICATORS',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildIndicatorTag('Allergy:', 'Penicillin (Severe)', true),
                    const SizedBox(width: 8),
                    _buildIndicatorTag('Blood Type:', 'DEA 1.1 Pos', false),
                    const SizedBox(width: 8),
                    _buildIndicatorTag(
                      'Chip:',
                      '98514160293',
                      false,
                      isNeutral: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientDetailRow(
    IconData icon,
    String text, {
    bool isBold = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF64748B)),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? const Color(0xFF0F172A) : const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildIndicatorTag(
    String label,
    String value,
    bool isWarning, {
    bool isNeutral = false,
  }) {
    Color bgColor = isWarning
        ? const Color(0xFFFEF2F2)
        : (isNeutral ? const Color(0xFFF1F5F9) : const Color(0xFFEFF6FF));
    Color textColor = isWarning
        ? const Color(0xFFDC2626)
        : (isNeutral ? const Color(0xFF64748B) : const Color(0xFF2563EB));
    IconData icon = isWarning
        ? Icons.warning_amber_rounded
        : Icons.info_outline;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isWarning
              ? const Color(0xFFFCA5A5)
              : (isNeutral ? const Color(0xFFE2E8F0) : const Color(0xFFBFDBFE)),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            '$label $value',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // FILTERS SECTION
  // ==========================================
  Widget _buildFiltersSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildDropdownFilter('Filter test name, sample ID...'),
              const SizedBox(width: 8),
              _buildDropdownFilter('Date: Last 30 Days'),
              const SizedBox(width: 8),
              _buildDropdownFilter('All Diagnostic Types'),
              const SizedBox(width: 8),
              _buildDropdownFilter('All Requesting Vets'),
            ],
          ),
          Row(
            children: [
              _buildFilterTab('All (5)', true),
              _buildFilterTab('Completed (3)', false),
              _buildFilterTab('In Progress (1)', false),
              _buildFilterTab('Urgent / Abnormal (1)', false, isRed: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownFilter(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          const Icon(Icons.filter_list, size: 14, color: Color(0xFF64748B)),
          const SizedBox(width: 6),
          Text(
            hint,
            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.arrow_drop_down, size: 16, color: Color(0xFF64748B)),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String label, bool isActive, {bool isRed = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
          color: isRed
              ? const Color(0xFFDC2626)
              : (isActive ? const Color(0xFF0F172A) : const Color(0xFF64748B)),
        ),
      ),
    );
  }

  // ==========================================
  // TEST TIMELINE (LEFT COLUMN)
  // ==========================================
  Widget _buildTestHistoryTimeline() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Test History Timeline',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Text(
                  '5 RECORDED TESTS',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          _buildTimelineItem(
            date: '24/10/2026 • 08:45 AM',
            status: 'Urgent/Abnormal',
            isRedStatus: true,
            title: 'Comprehensive Blood Chemistry (Biochemical 18-Panel)',
            summary: '! Summary: Elevated ALT & ALP (Hepatic markers)',
            summaryIsRed: true,
            doctor: 'Dr. Tamesis, DVM',
            actionText: 'Active',
            isActiveBox: true,
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          _buildTimelineItem(
            date: '24/10/2026 • 08:15 AM',
            status: '✓ Completed',
            isRedStatus: false,
            title: 'Left Ear Cytology Swab',
            summary: 'Summary: Moderate Malassezia yeast & cocci',
            doctor: 'Dr. Tamesis, DVM',
            actionText: 'View',
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          _buildTimelineItem(
            date: '18/10/2026 • 11:30 AM',
            status: '✓ Completed',
            isRedStatus: false,
            title: 'Complete Urinalysis & Sediment',
            summary: 'Summary: Specific Gravity 1.032, Nil protein',
            doctor: 'Dr. Vance, DVM',
            actionText: 'View',
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          _buildTimelineItem(
            date: '12/10/2026 • 03:20 PM',
            status: '✓ Completed',
            isRedStatus: false,
            title: 'Digital Radiography (Right Hip Dysplasia 2-View)',
            summary: 'Summary: OFA Good Bilateral. No osteophytes.',
            doctor: 'Dr. Tamesis, DVM',
            actionText: 'View DICOM',
            iconType: Icons.image_outlined,
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          _buildTimelineItem(
            date: 'Today • 09:10 AM',
            status: '⟳ In Progress',
            isRedStatus: false,
            isWarning: true,
            title: 'Fecal Floatation & Giardia Antigen',
            summary: 'Summary: In analyzer queue (Batch #8821)',
            doctor: 'Dr. Tamesis, DVM',
            actionText: 'Check Status',
            isOutline: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required String date,
    required String status,
    required bool isRedStatus,
    bool isWarning = false,
    required String title,
    required String summary,
    bool summaryIsRed = false,
    required String doctor,
    required String actionText,
    bool isActiveBox = false,
    bool isOutline = false,
    IconData? iconType,
  }) {
    Color statusColor = isRedStatus
        ? const Color(0xFFDC2626)
        : (isWarning ? const Color(0xFFD97706) : const Color(0xFF16A34A));
    Color bgColor = isActiveBox ? const Color(0xFFF8FAFC) : Colors.white;

    return Container(
      padding: const EdgeInsets.all(16),
      color: bgColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF94A3B8),
                ),
              ),
              Text(
                status,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            summary,
            style: TextStyle(
              fontSize: 11,
              color: summaryIsRed
                  ? const Color(0xFFDC2626)
                  : const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.medical_services_outlined,
                    size: 12,
                    color: Color(0xFF94A3B8),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    doctor,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isActiveBox
                      ? const Color(0xFF00174B) // Navy Blue for active
                      : (isOutline ? Colors.white : const Color(0xFFF1F5F9)),
                  border: Border.all(
                    color: isOutline
                        ? const Color(0xFFCBD5E1)
                        : Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    if (iconType != null) ...[
                      Icon(iconType, size: 12, color: const Color(0xFF475569)),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      actionText,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isActiveBox
                            ? Colors.white
                            : const Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // VITALS CARD (LEFT COLUMN)
  // ==========================================
  Widget _buildLatestVitalsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'LATEST PHYSICAL VITALS AT BLOOD DRAW',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF94A3B8),
                ),
              ),
              Text(
                'Oct 24, 08:30 AM',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildVitalBox('Weight', '31.4', 'kg'),
              _buildVitalBox('Temp', '38.8', '°C'),
              _buildVitalBox('Heart Rate', '88', 'bpm'),
              _buildVitalBox('Resp. Rate', '22', 'rpm'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVitalBox(String label, String value, String unit) {
    return Container(
      width: 65,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 9, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(width: 2),
              Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Text(
                  unit,
                  style: const TextStyle(fontSize: 9, color: Color(0xFF64748B)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // ACTIVE PANEL DETAILS (RIGHT COLUMN)
  // ==========================================
  Widget _buildActivePanelDetails() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00174B), // Navy Blue Theme
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'ACTIVE PANEL',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Sample ID: #LAB-2024-9942',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Comprehensive Blood Chemistry\n(Biochemical 18-Panel)',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: const [
                        Icon(
                          Icons.calendar_month_outlined,
                          size: 14,
                          color: Color(0xFF64748B),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Collected: Oct 24, 2026, 08:45 AM',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        SizedBox(width: 16),
                        Icon(
                          Icons.person_outline,
                          size: 14,
                          color: Color(0xFF64748B),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Requesting Vet: Dr. Tamesis, DVM',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: const [
                        Icon(
                          Icons.science_outlined,
                          size: 14,
                          color: Color(0xFF64748B),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Specimen: Serum (Red Top Tube)',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    border: Border.all(color: const Color(0xFFFCA5A5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: const [
                      Text(
                        'Urgent /',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFDC2626),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 12,
                            color: Color(0xFFDC2626),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Abnormal',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFDC2626),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Flagged',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFDC2626),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Machine integration banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            color: const Color(0xFFF0FDF4),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  color: const Color(0xFF047857),
                  child: const Text(
                    'IDEXX',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'IDEXX VetLab Station • Verified Synchronized • Today at 09:18 AM',
                  style: TextStyle(fontSize: 11, color: Color(0xFF065F46)),
                ),
                const Spacer(),
                const Icon(
                  Icons.cloud_sync,
                  size: 14,
                  color: Color(0xFF059669),
                ),
                const SizedBox(width: 4),
                const Text(
                  'Auto-imported',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF059669),
                  ),
                ),
              ],
            ),
          ),

          // Data Table
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(3.0),
                1: FlexColumnWidth(1.5),
                2: FlexColumnWidth(1.5),
                3: FlexColumnWidth(2.0),
                4: FlexColumnWidth(1.5),
              },
              children: [
                const TableRow(
                  children: [
                    _TableHead('PARAMETER'),
                    _TableHead('RESULT'),
                    _TableHead('UNITS'),
                    _TableHead('REFERENCE\nRANGE'),
                    _TableHead('STATUS /\nFLAG'),
                  ],
                ),
                _buildResultRow(
                  'ALT',
                  '(Alanine\nAminotransferase)',
                  '198',
                  'U/L',
                  '10 - 125',
                  isHigh: true,
                ),
                _buildResultRow(
                  'ALP',
                  '(Alkaline Phosphatase)',
                  '245',
                  'U/L',
                  '23 - 212',
                  isHigh: true,
                ),
                _buildResultRow(
                  'Total Bilirubin',
                  '',
                  '0.3',
                  'mg/dL',
                  '0.0 - 0.9',
                  isHigh: false,
                ),
                _buildResultRow(
                  'BUN',
                  '(Blood Urea\nNitrogen)',
                  '18',
                  'mg/dL',
                  '7 - 27',
                  isHigh: false,
                ),
                _buildResultRow(
                  'Creatinine',
                  '',
                  '1.1',
                  'mg/dL',
                  '0.5 - 1.8',
                  isHigh: false,
                ),
                _buildResultRow(
                  'Glucose',
                  '',
                  '94',
                  'mg/dL',
                  '74 - 143',
                  isHigh: false,
                ),
                _buildResultRow(
                  'Total Protein',
                  '',
                  '6.8',
                  'g/dL',
                  '5.2 - 8.2',
                  isHigh: false,
                ),
                _buildResultRow(
                  'Albumin',
                  '',
                  '3.2',
                  'g/dL',
                  '2.3 - 4.0',
                  isHigh: false,
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // Attachments Section
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.image_outlined,
                          size: 16,
                          color: Color(0xFF64748B),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'ASSOCIATED CLINICAL IMAGING & CYTOLOGY SLIDES (2 ATTACHMENTS)',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'Open Imaging Workspace →',
                      style: TextStyle(fontSize: 11, color: Color(0xFF00174B)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildImageAttachment(
                        'Pelvic X-Ray 2-View.dcm',
                        'Right Hip & Femur • 12/10/26',
                        Icons.open_in_full,
                        'Expand View',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildImageAttachment(
                        'Ear Swab Smear #3.jpg',
                        'Malassezia yeast field • 24/1...',
                        Icons.zoom_in,
                        'Inspect Slide',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // Interpretation Section
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Veterinary Interpretation & Clinical Assessment',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Signed by Dr. J. Tamesis, DVM',
                      style: TextStyle(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const Text(
                    'Mild acute hepatocellular insult suspected, secondary to topical ear infection treatment or dietary indiscretion. Recommend starting S-Adenosylmethionine (Denamarin) liver support and re-testing serum ALT/ALP in 14 days.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF334155),
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text(
                      'RECOMMENDED PLAN:',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _buildPlanTag(
                      'Rx: Denamarin 425mg PO q24h',
                      Icons.medication,
                    ),
                    const SizedBox(width: 8),
                    _buildPlanTag(
                      'Follow-up: Hepatic Panel (14d)',
                      Icons.calendar_month,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // Footer Actions
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.picture_as_pdf_outlined,
                        size: 16,
                        color: Color(0xFF475569),
                      ),
                      label: const Text(
                        'Export Patient Lab Summary PDF',
                        style: TextStyle(
                          color: Color(0xFF475569),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.share_outlined,
                        size: 16,
                        color: Color(0xFF475569),
                      ),
                      label: const Text(
                        'Share with Client Portal',
                        style: TextStyle(
                          color: Color(0xFF475569),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      size: 16,
                      color: Color(0xFF64748B),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Mark as Reviewed by Vet',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF475569),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.save_outlined,
                        size: 16,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Save & Sign Interpretation',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00174B),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
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
    );
  }

  TableRow _buildResultRow(
    String paramMain,
    String paramSub,
    String result,
    String units,
    String range, {
    required bool isHigh,
  }) {
    return TableRow(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            children: [
              Text(
                paramMain,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                paramSub,
                style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            result,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isHigh ? const Color(0xFFDC2626) : const Color(0xFF334155),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            units,
            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            range,
            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: isHigh
              ? Row(
                  children: const [
                    Text(
                      'HIGH',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFDC2626),
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_drop_up,
                      size: 16,
                      color: Color(0xFFDC2626),
                    ),
                  ],
                )
              : const Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Icon(Icons.circle, size: 6, color: Color(0xFF10B981)),
                ),
        ),
      ],
    );
  }

  Widget _buildImageAttachment(
    String title,
    String sub,
    IconData actionIcon,
    String actionLabel,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.image,
              color: Color(0xFF94A3B8),
            ), // Placeholder
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Text(
                  sub,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(actionIcon, size: 12, color: const Color(0xFF0F172A)),
                    const SizedBox(width: 4),
                    Text(
                      actionLabel,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanTag(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        border: Border.all(color: const Color(0xFFBFDBFE)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: const Color(0xFF2563EB)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D4ED8),
            ),
          ),
        ],
      ),
    );
  }
}

class _TableHead extends StatelessWidget {
  final String label;
  const _TableHead(this.label);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Color(0xFF94A3B8),
        ),
      ),
    );
  }
}
