import 'package:flutter/material.dart';
import '../doctor/doctor_sidebar_widget.dart';

class DoctorPatientRecordsScreen extends StatefulWidget {
  const DoctorPatientRecordsScreen({super.key});

  @override
  State<DoctorPatientRecordsScreen> createState() =>
      _DoctorPatientRecordsScreenState();
}

class _DoctorPatientRecordsScreenState
    extends State<DoctorPatientRecordsScreen> {
  final String _currentDoctorName = 'Dr. Alfie Tamesis';
  final String _currentDoctorImagePath = 'assets/images/dr.Alfie.jpg';

  // State para sa Interactive Tabs
  String _activeTab = 'Overview / Summary';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==========================================
          // 1. DEDICATED DOCTOR SIDEBAR
          // ==========================================
          const DoctorSidebarWidget(currentRoute: '/doctor/patients'),

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
                      horizontal: 32.0,
                      vertical: 24.0,
                    ),
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
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Patient Clinical Record',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Comprehensive health history, SOAP clinical notes, vaccinations, and lab diagnostics.',
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
                                  Icons.folder_shared_rounded,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        _buildBreadcrumbsAndActions(),
                        const SizedBox(height: 24),

                        // Header Cards (Patient & Owner Details)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 5, child: _buildPatientHeaderCard()),
                            const SizedBox(width: 20),
                            Expanded(flex: 4, child: _buildOwnerInfoCard()),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Interactive Tab Navigation
                        _buildTabNavigation(),
                        const SizedBox(height: 24),

                        // Dynamic Content Based on Active Tab
                        _buildTabContent(),

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
  // WIDGET: TOP HEADER (Wala nang + Button)
  // ==========================================
  Widget _buildTopHeader() {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        _currentDoctorImagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            color: Color(0xFF94A3B8),
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
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const Text(
                        'Chief Veterinarian',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 32),
              Container(
                width: 340,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search patients, microchips, lab reports...',
                    hintStyle: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      size: 18,
                      color: Color(0xFF2563EB),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 11),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: Color(0xFF64748B),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.help_outline_rounded,
                  color: Color(0xFF64748B),
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
  // WIDGET: BREADCRUMBS & ACTIONS (Wala na ring + button)
  // ==========================================
  Widget _buildBreadcrumbsAndActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(
              Icons.folder_open_rounded,
              size: 16,
              color: Color(0xFF64748B),
            ),
            const SizedBox(width: 8),
            const Text(
              'Patients / Canine / ',
              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
            const Text(
              'Bambam (#V-4082)',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                '• Active Patient - In Clinic',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF16A34A),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.print_outlined,
                size: 16,
                color: Color(0xFF475569),
              ),
              label: const Text(
                'Print Record',
                style: TextStyle(
                  color: Color(0xFF475569),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                side: const BorderSide(color: Color(0xFFCBD5E1)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(width: 10),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.share_outlined,
                size: 16,
                color: Color(0xFF475569),
              ),
              label: const Text(
                'Share with Owner',
                style: TextStyle(
                  color: Color(0xFF475569),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                side: const BorderSide(color: Color(0xFFCBD5E1)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================
  // WIDGET: PATIENT HEADER CARD
  // ==========================================
  Widget _buildPatientHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(24),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/clinic_lab_bg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.pets, size: 12, color: Color(0xFF2563EB)),
                    SizedBox(width: 4),
                    Text(
                      'Canine',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    const Text(
                      'Bambam',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'ID: #V-4082',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        '• Status: Stable',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF16A34A),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Golden Retriever • Golden honey, white chest patch',
                  style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildInfoTag('Allergy:', 'Penicillin (Severe)', true),
                    _buildInfoTag('Blood Type:', 'DEA 1.1 Pos', false),
                    _buildInfoTag(
                      'Microchip:',
                      '985141003492102',
                      false,
                      isBlue: true,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildVitalsSummary('AGE', '4 yrs 2 mos'),
                    _buildVitalsSummary('SEX / REPRO', 'Male (Neutered)'),
                    _buildVitalsSummary('WEIGHT', '31.4 kg (Today)'),
                    _buildVitalsSummary('BODY SCORE', '5 / 9 (Ideal)'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTag(
    String label,
    String value,
    bool isWarning, {
    bool isBlue = false,
  }) {
    Color bgColor = isWarning
        ? const Color(0xFFFEF2F2)
        : (isBlue ? const Color(0xFFEFF6FF) : const Color(0xFFF8FAFC));
    Color textColor = isWarning
        ? const Color(0xFFDC2626)
        : (isBlue ? const Color(0xFF2563EB) : const Color(0xFF334155));
    IconData icon = isWarning
        ? Icons.warning_amber_rounded
        : Icons.info_outline;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isWarning ? const Color(0xFFFCA5A5) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
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

  Widget _buildVitalsSummary(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Color(0xFF94A3B8),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF334155),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // WIDGET: OWNER INFO CARD
  // ==========================================
  Widget _buildOwnerInfoCard() {
    return Container(
      padding: const EdgeInsets.all(24),
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
              const Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 16,
                    color: Color(0xFF64748B),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'OWNER & CLIENT INFORMATION',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF64748B),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Edit Client',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF183F82),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Eleanor Vance',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const Text(
                '+1 (555) 234-8961',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF334155),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 14,
                color: Color(0xFF94A3B8),
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  '742 Evergreen Terrace, Ward A, City',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Row(
            children: [
              Icon(
                Icons.emergency_outlined,
                size: 14,
                color: Color(0xFFEF4444),
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Emergency: David Vance (Spouse) - +1 (555) 987-6543',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 38),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildOwnerActionBtn(Icons.edit_outlined, 'Edit Profile'),
              _buildOwnerActionBtn(Icons.sync_alt, 'Transfer'),
              _buildOwnerActionBtn(Icons.qr_code, 'QR Tag'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOwnerActionBtn(IconData icon, String label) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 14, color: const Color(0xFF0F172A)),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0F172A),
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // ==========================================
  // WIDGET: INTERACTIVE TAB NAVIGATION
  // ==========================================
  Widget _buildTabNavigation() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          _buildTabItem('Overview / Summary', Icons.insert_chart_outlined),
          _buildTabItem(
            'Medical & Clinical History',
            Icons.medical_services_outlined,
          ),
          _buildTabItem(
            'Vaccination & Immunization',
            Icons.vaccines_outlined,
            count: 4,
          ),
          _buildTabItem(
            'Laboratory & Diagnostics',
            Icons.science_outlined,
            count: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(String label, IconData icon, {int? count}) {
    bool isActive = _activeTab == label;

    return InkWell(
      onTap: () {
        setState(() {
          _activeTab = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? const Color(0xFF183F82) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive
                  ? const Color(0xFF183F82)
                  : const Color(0xFF64748B),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                color: isActive
                    ? const Color(0xFF183F82)
                    : const Color(0xFF64748B),
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ==========================================
  // DYNAMIC TAB CONTENT SWITCHER
  // ==========================================
  Widget _buildTabContent() {
    if (_activeTab == 'Vaccination & Immunization') {
      return Column(children: [_buildVaccinationCard()]);
    } else if (_activeTab == 'Laboratory & Diagnostics') {
      return Column(children: [_buildLaboratoryCard()]);
    } else if (_activeTab == 'Medical & Clinical History') {
      return Column(
        children: [
          _buildSOAPNotesCard(),
          const SizedBox(height: 24),
          _buildPrescriptionsCard(),
        ],
      );
    } else {
      // Default: Overview / Summary (Kasalukuyang dalawang column layout)
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Column(
              children: [
                _buildSOAPNotesCard(),
                const SizedBox(height: 24),
                _buildVaccinationCard(),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                _buildPrescriptionsCard(),
                const SizedBox(height: 24),
                _buildLaboratoryCard(),
                const SizedBox(height: 24),
                _buildBillingCard(),
              ],
            ),
          ),
        ],
      );
    }
  }

  // ==========================================
  // WIDGET: SOAP NOTES CARD (LEFT COLUMN)
  // ==========================================
  Widget _buildSOAPNotesCard() {
    return Container(
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.assignment_turned_in_outlined,
                      size: 18,
                      color: Color(0xFF0F172A),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Latest Clinical Visit (SOAP Notes)',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
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
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'October 24, 2026 - 09:30 AM',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'ATTENDING VETERINARIAN',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Dr. Tamesis, Lead Clinician',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF334155),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text(
                          'ENCOUNTER REASON',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Routine Semi-Annual & Dermatological Check',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF334155),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSOAPSection(
                  'S',
                  'SUBJECTIVE OBSERVATIONS',
                  'Owner reports intermittent scratching around left ear flap for 4 days. Shaking head occasionally after outdoor walks. Appetite, hydration, and energy levels remain normal.',
                ),
                const SizedBox(height: 16),
                _buildSOAPSection(
                  'O',
                  'OBJECTIVE PHYSICAL EXAM',
                  'Mild erythema observed in left pinna and horizontal acoustic canal. Scant dark brown ceruminous exudate present. Tympanic membrane intact bilaterally. Right ear clear.',
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildVitalsSummary('BODY TEMP', '38.6°C (Nrml)'),
                        _buildVitalsSummary('HEART RATE', '88 bpm'),
                        _buildVitalsSummary('RESP RATE', '24 bpm'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildSOAPSection(
                  'A',
                  'CLINICAL ASSESSMENT / DIAGNOSIS',
                  'Mild unilateral otitis externa (bacterial / yeast suspected).',
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'ICD-10-Vet:\nH60.92',
                      style: TextStyle(fontSize: 10, color: Color(0xFF2563EB)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildSOAPSection(
                  'P',
                  'TREATMENT PLAN & PROTOCOL',
                  '1. Otic cytological swab performed in-house.\n2. Prescribed Surolan Otic drops: 5 drops BID in left ear for 7 days.\n3. Client instructed on gentle cleaning prior to instillation.\n4. Scheduled re-check exam in 10 days (Nov 3, 2026).',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSOAPSection(
    String letter,
    String title,
    String content, {
    Widget? child,
    Widget? trailing,
  }) {
    Color badgeColor;
    if (letter == 'S')
      badgeColor = const Color(0xFFDBEAFE);
    else if (letter == 'O')
      badgeColor = const Color(0xFFE0E7FF);
    else if (letter == 'A')
      badgeColor = const Color(0xFFDBEAFE);
    else
      badgeColor = const Color(0xFFD1FAE5);

    Color textColor;
    if (letter == 'P')
      textColor = const Color(0xFF059669);
    else
      textColor = const Color(0xFF1D4ED8);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFF1F5F9)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              letter,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                if (child != null) child,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        content,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF475569),
                          height: 1.5,
                        ),
                      ),
                    ),
                    if (trailing != null) ...[
                      const SizedBox(width: 12),
                      trailing,
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // WIDGET: VACCINATIONS CARD (LEFT COLUMN)
  // ==========================================
  Widget _buildVaccinationCard() {
    return Container(
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.vaccines_outlined,
                      size: 18,
                      color: Color(0xFF0F172A),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Vaccination & Immunization Record',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Log Vaccine',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(2.5),
                1: FlexColumnWidth(1.5),
                2: FlexColumnWidth(1.2),
                3: FlexColumnWidth(1.5),
                4: FlexColumnWidth(1.0),
                5: FlexColumnWidth(1.2),
              },
              children: [
                const TableRow(
                  children: [
                    _DocTableHeader('VACCINE NAME'),
                    _DocTableHeader('ADMINISTERED'),
                    _DocTableHeader('BATCH / LOT #'),
                    _DocTableHeader('ADMINISTERED BY'),
                    _DocTableHeader('NEXT DUE'),
                    _DocTableHeader('STATUS'),
                  ],
                ),
                _buildVaccineRow(
                  'Rabies 3-Yr (Imrab 3)',
                  'Subcutaneous • Right Hind',
                  '15 Jan 2026',
                  'RRB-99281',
                  'Dr. Tamesis',
                  'Jan 2029',
                  'Up-to-date',
                ),
                _buildVaccineRow(
                  'DHPP / Core 5-in-1',
                  'Distemper, Hepatitis, Parvo, Para',
                  '15 Jan 2026',
                  'JDH-88129',
                  'Dr. Tamesis',
                  'Jan 2027',
                  'Due Soon',
                  isWarning: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildVaccineRow(
    String name,
    String subName,
    String date,
    String batch,
    String doc,
    String due,
    String status, {
    bool isWarning = false,
  }) {
    return TableRow(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              Text(
                subName,
                style: const TextStyle(fontSize: 9, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Text(
            date,
            style: const TextStyle(fontSize: 11, color: Color(0xFF334155)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Text(
            batch,
            style: const TextStyle(fontSize: 11, color: Color(0xFF334155)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Text(
            doc,
            style: const TextStyle(fontSize: 11, color: Color(0xFF334155)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Text(
            due,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isWarning ? FontWeight.bold : FontWeight.normal,
              color: isWarning
                  ? const Color(0xFFD97706)
                  : const Color(0xFF334155),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Text(
            status,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isWarning
                  ? const Color(0xFFD97706)
                  : const Color(0xFF16A34A),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // WIDGET: PRESCRIPTIONS CARD (RIGHT COLUMN)
  // ==========================================
  Widget _buildPrescriptionsCard() {
    return Container(
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.medication_outlined,
                      size: 18,
                      color: Color(0xFF0F172A),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Active Prescriptions',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Prescribe Rx',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF183F82),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildMedicationItem(
                  'Surolan Otic Drops (15ml)',
                  '5 drops BID in left ear x 7 days • Dispensed today',
                  '6 days left',
                  true,
                ),
                const SizedBox(height: 12),
                _buildMedicationItem(
                  'Simparica Trio Chewable',
                  '1 chew monthly for fleas, ticks & heartworm prevention',
                  'Routine Care',
                  false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationItem(
    String name,
    String desc,
    String tag,
    bool isActive,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFF1F5F9)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.water_drop_outlined,
              size: 16,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      tag,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isActive
                            ? const Color(0xFF16A34A)
                            : const Color(0xFF0284C7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
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
  // WIDGET: LAB DIAGNOSTICS CARD (RIGHT COLUMN)
  // ==========================================
  Widget _buildLaboratoryCard() {
    return Container(
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: const [
                Icon(
                  Icons.science_outlined,
                  size: 18,
                  color: Color(0xFF0F172A),
                ),
                SizedBox(width: 8),
                Text(
                  'Laboratory & Diagnostics',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildLabItem(
                  'Ear Cytology Swab (Left Ear)',
                  'In-House',
                  'Result: Yeast + cocci observed',
                  'Oct 24, 2026',
                  Icons.biotech_outlined,
                ),
                const SizedBox(height: 12),
                _buildLabItem(
                  'Routine Bloodwork (Biochemical Panel)',
                  'External Lab',
                  'Result: Normal liver/kidney values',
                  'Oct 12, 2026',
                  Icons.bloodtype_outlined,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabItem(
    String name,
    String type,
    String result,
    String date,
    IconData icon,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: const Color(0xFF64748B)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      type,
                      style: const TextStyle(
                        fontSize: 9,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                result,
                style: const TextStyle(fontSize: 11, color: Color(0xFF334155)),
              ),
              const SizedBox(height: 2),
              Text(
                date,
                style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.visibility_outlined,
            size: 16,
            color: Color(0xFF183F82),
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  // ==========================================
  // WIDGET: BILLING CARD (RIGHT COLUMN)
  // ==========================================
  Widget _buildBillingCard() {
    return Container(
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 18,
                      color: Color(0xFF0F172A),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Billing & Invoices Snapshot',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF183F82),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildBillingItem(
                  '#INV-2024-884',
                  'Today\'s Consult & Cytology',
                  '\$145.00',
                  'Pending Checkout',
                  true,
                ),
                const SizedBox(height: 12),
                _buildBillingItem(
                  '#INV-2024-712',
                  'Annual Wellness & Core Meds',
                  '\$280.00',
                  'Paid in Full',
                  false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillingItem(
    String inv,
    String desc,
    String amount,
    String status,
    bool isPending,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFF1F5F9)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                isPending ? Icons.pending_actions : Icons.check_circle_outline,
                size: 16,
                color: isPending
                    ? const Color(0xFFD97706)
                    : const Color(0xFF16A34A),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    inv,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    desc,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              Text(
                status,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isPending
                      ? const Color(0xFFD97706)
                      : const Color(0xFF16A34A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DocTableHeader extends StatelessWidget {
  final String label;
  const _DocTableHeader(this.label);
  @override
  Widget build(BuildContext context) {
    String query = label;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        query,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Color(0xFF94A3B8),
        ),
      ),
    );
  }
}
