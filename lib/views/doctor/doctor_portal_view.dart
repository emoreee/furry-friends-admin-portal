import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:furry_friends_admin/widgets/sidebar_widget.dart';

class DoctorPortalView extends StatefulWidget {
  const DoctorPortalView({super.key});

  @override
  State<DoctorPortalView> createState() => _DoctorPortalViewState();
}

class _DoctorPortalViewState extends State<DoctorPortalView> {
  String _searchQuery = '';
  String _selectedSpecialty = 'All Specialties';
  String _selectedStatus = 'All Status';

  // Mock Data
  final List<Map<String, dynamic>> _doctors = [
    {
      'name': 'Dr. Alfie Tamesis, DVM',
      'role': 'Chief Veterinarian / Clinic Owner',
      'education': 'Doctor of Veterinary Medicine, UP Los Baños',
      'license': '12345',
      'specialization': 'Internal Medicine & Surgery', // Simplified for filter
      'availability': 'Mon – Wed: 8:00 AM – 5:00 PM',
      'status': 'In Clinic',
      'imagePath': 'assets/images/dr.Alfie.jpg',
    },
    {
      'name': 'Dr. James Nico Martinez',
      'role': 'Associate Veterinarian',
      'education': 'DVM, Central Luzon State University',
      'license': '67890',
      'specialization': 'Dermatology & Exotic Pets',
      'availability': 'Thu – Fri: 9:00 AM – 4:00 PM',
      'status': 'In Clinic',
      'imagePath': 'assets/images/dr.Martinez.jpg',
    },
    {
      'name': 'Dr. Crachzel Kyle Asistio',
      'role': 'Emergency & Weekend Veterinarian',
      'education': 'DVM, De La Salle Araneta University',
      'license': '54321',
      'specialization': 'Emergency Care & Vaccinations',
      'availability': 'Saturday: 9:00 AM – 3:00 PM',
      'status': 'On Leave',
      'imagePath': 'assets/images/dr.Ck.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat(
      'EEEE, MMM. dd, yyyy',
    ).format(DateTime.now());

    // Filtering Logic
    final filteredDoctors = _doctors.where((doc) {
      final matchesSearch =
          doc['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          doc['specialization'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
      final matchesSpecialty =
          _selectedSpecialty == 'All Specialties' ||
          doc['specialization'].contains(_selectedSpecialty);
      final matchesStatus =
          _selectedStatus == 'All Status' || doc['status'] == _selectedStatus;

      return matchesSearch && matchesSpecialty && matchesStatus;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: Row(
        children: [
          // ==========================================
          // SIDEBAR INTEGRATION
          // ==========================================
          const SidebarWidget(currentRoute: '/doctor'),

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
                // MAIN CONTENT
                // ==========================================
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(32.0),
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
                                      'Doctor\'s Portal & Directory',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Meet our resident doctors, check their credentials, and view their clinic availability schedules.',
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
                                  Icons.medical_services_rounded,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ==========================================
                        // SEARCH AND FILTER BAR
                        // ==========================================
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
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
                                  onChanged: (value) =>
                                      setState(() => _searchQuery = value),
                                  style: const TextStyle(fontSize: 13),
                                  decoration: const InputDecoration(
                                    hintText:
                                        'Search doctor by name or specialty...',
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
                            const SizedBox(width: 12),
                            _buildFilterDropdown(
                              value: _selectedSpecialty,
                              items: [
                                'All Specialties',
                                'Internal Medicine & Surgery',
                                'Dermatology & Exotic Pets',
                                'Emergency Care & Vaccinations',
                              ],
                              onChanged: (val) =>
                                  setState(() => _selectedSpecialty = val!),
                            ),
                            const SizedBox(width: 12),
                            _buildFilterDropdown(
                              value: _selectedStatus,
                              items: ['All Status', 'In Clinic', 'On Leave'],
                              onChanged: (val) =>
                                  setState(() => _selectedStatus = val!),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // ==========================================
                        // RESPONSIVE DOCTOR CARDS GRID
                        // ==========================================
                        filteredDoctors.isEmpty
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(40.0),
                                  child: Text(
                                    'No doctors found matching your criteria.',
                                    style: TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              )
                            : LayoutBuilder(
                                builder: (context, constraints) {
                                  int crossAxisCount =
                                      constraints.maxWidth > 1200
                                      ? 3
                                      : (constraints.maxWidth > 800 ? 2 : 1);

                                  double cardWidth =
                                      (constraints.maxWidth -
                                          (24 * (crossAxisCount - 1))) /
                                      crossAxisCount;
                                  double totalGridWidth =
                                      (filteredDoctors.length < crossAxisCount)
                                      ? (filteredDoctors.length * cardWidth) +
                                            ((filteredDoctors.length - 1) * 24)
                                      : constraints.maxWidth;

                                  return Center(
                                    child: SizedBox(
                                      width: totalGridWidth,
                                      child: GridView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount:
                                                  (filteredDoctors.length <
                                                      crossAxisCount)
                                                  ? filteredDoctors.length
                                                  : crossAxisCount,
                                              crossAxisSpacing: 24,
                                              mainAxisSpacing: 24,
                                              mainAxisExtent:
                                                  420, // Pinaikli ang card since inalis na ang button
                                            ),
                                        itemCount: filteredDoctors.length,
                                        itemBuilder: (context, index) {
                                          return _HoverableDoctorCard(
                                            doctor: filteredDoctors[index],
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
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

  Widget _buildFilterDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF64748B),
            size: 18,
          ),
          style: const TextStyle(
            color: Color(0xFF334155),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, overflow: TextOverflow.ellipsis),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ==========================================
// HOVERABLE DOCTOR CARD WIDGET
// ==========================================
class _HoverableDoctorCard extends StatefulWidget {
  final Map<String, dynamic> doctor;

  const _HoverableDoctorCard({required this.doctor});

  @override
  State<_HoverableDoctorCard> createState() => _HoverableDoctorCardState();
}

class _HoverableDoctorCardState extends State<_HoverableDoctorCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    bool isInClinic = widget.doctor['status'] == 'In Clinic';

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0.0, _isHovered ? -8.0 : 0.0, 0.0),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? const Color(0xFF183F82).withValues(alpha: 0.15)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: _isHovered ? 20 : 15,
              offset: Offset(0, _isHovered ? 10 : 5),
            ),
          ],
          border: Border.all(
            color: _isHovered
                ? const Color(0xFF183F82).withValues(alpha: 0.5)
                : Colors.transparent,
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            // Status Indicator
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isInClinic
                      ? const Color(0xFFECFDF5)
                      : const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isInClinic
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.doctor['status'],
                      style: TextStyle(
                        color: isInClinic
                            ? const Color(0xFF059669)
                            : const Color(0xFFDC2626),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Card Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                // Premium Avatar Frame
                SizedBox(
                  width: 90,
                  height: 90,
                  child: Stack(
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFE2E8F0),
                            width: 3,
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
                            widget.doctor['imagePath'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: const Color(0xFFF1F5F9),
                                child: const Icon(
                                  Icons.person_rounded,
                                  size: 40,
                                  color: Color(0xFF94A3B8),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      // Verification Badge
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Color(0xFF2563EB),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Name and Role
                Text(
                  widget.doctor['name'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  widget.doctor['role'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF183F82),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 24),

                // Details List
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(Icons.school, widget.doctor['education']),
                      _buildDetailRow(
                        Icons.badge_rounded,
                        'License No: ${widget.doctor['license']}',
                      ),
                      _buildDetailRow(
                        Icons.medical_services_rounded,
                        'Specialization: ${widget.doctor['specialization']}',
                      ),
                      _buildDetailRow(
                        Icons.access_time_rounded,
                        'Availability:\n${widget.doctor['availability']}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Component Helpers for the Details List
  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF183F82)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF475569),
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
