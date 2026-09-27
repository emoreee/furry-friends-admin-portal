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

  // MOCK REAL-TIME DATA (Idinesenyo para madaling i-connect sa Firestore)
  final List<Map<String, dynamic>> _monitoredPatients = [
    {
      'id': 'PET-2024-150',
      'name': 'Simba',
      'species': 'Feline',
      'breed': 'Maine Coon',
      'status': 'Critical / ICU',
      'temp': 40.5, // High Fever
      'spo2': 91, // Hypoxia
      'bpm': 180,
      'currentWeight': 4.8,
      'admissionWeight': 5.2,
      'soap': 'S: Lethargic, unresponsive. O: Temp high, breathing labored. A: Severe Trauma / Internal bleeding suspected. P: Emergency surgery prep, oxygen therapy.',
      'ivRate': 'Lactated Ringer\'s @ 20ml/hr',
    },
    {
      'id': 'PET-2024-090',
      'name': 'Charlie',
      'species': 'Canine',
      'breed': 'Pug',
      'status': 'Post-Surgery',
      'temp': 38.5, // Normal
      'spo2': 98, // Normal
      'bpm': 95,
      'currentWeight': 8.5,
      'admissionWeight': 8.5,
      'soap': 'S: Recovering well, responsive. O: Incision site clean. Vitals stable. A: Post-op recovery normal. P: Continue antibiotics, monitor next 12 hrs.',
      'ivRate': '0.9% NaCl @ 15ml/hr',
    },
    {
      'id': 'PET-2024-112',
      'name': 'Luna',
      'species': 'Feline',
      'breed': 'Persian Cat',
      'status': 'Discharged',
      'temp': 38.1,
      'spo2': 99,
      'bpm': 110,
      'currentWeight': 3.2,
      'admissionWeight': 3.1,
      'soap': 'S: Active, eating well. O: Dermatitis clearing up. A: Resolved skin infection. P: Discharged with topical cream.',
      'ivRate': 'Discontinued',
    },
    {
      'id': 'PET-2024-089',
      'name': 'Bella',
      'species': 'Canine',
      'breed': 'Golden Retriever',
      'status': 'All Active',
      'temp': 37.2, // Mild Hypothermia
      'spo2': 96,
      'bpm': 75,
      'currentWeight': 25.4,
      'admissionWeight': 26.0,
      'soap': 'S: Weak appetite. O: Slightly low temp. A: Mild dehydration. P: Warming blanket, increase fluid intake.',
      'ivRate': 'Lactated Ringer\'s @ 40ml/hr',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('EEEE, MMM. dd, yyyy').format(DateTime.now());

    // Filter Logic
    final filteredPatients = _monitoredPatients.where((pet) {
      bool matchesTab = _activeTab == 'All Active'
          ? pet['status'] != 'Discharged'
          : pet['status'] == _activeFilterMap(_activeTab);
      
      bool matchesSearch = pet['name'].toLowerCase().contains(_searchQuery) ||
                           pet['id'].toLowerCase().contains(_searchQuery);
                           
      return matchesTab && matchesSearch;
    }).toList();

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
                          const Icon(Icons.calendar_today_rounded, size: 14, color: Color(0xFF64748B)),
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
                              color: const Color(0xFF183F82).withValues(alpha: 0.1),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/juneksPic.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Center(
                                  child: Text('JA', style: TextStyle(color: Color(0xFF183F82), fontSize: 11, fontWeight: FontWeight.bold)),
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
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1E293B)),
                              ),
                              Text(
                                'Clinic Administrator',
                                style: TextStyle(color: Color(0xFF059669), fontSize: 10, fontWeight: FontWeight.w600),
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
                              colors: [Color(0xFF183F82), Color(0xFF2563EB), Color(0xFF38BDF8)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(color: const Color(0xFF183F82).withValues(alpha: 0.25), blurRadius: 15, offset: const Offset(0, 6)),
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
                                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 0.2),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Real-time clinical metrics, SOAP notes, and emergency alerts for admitted patients.',
                                    style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.monitor_heart_rounded, color: Colors.white, size: 40),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ==========================================
                        // FILTER TABS & SEARCH BAR
                        // ==========================================
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
                                ),
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
                                  style: const TextStyle(fontSize: 13),
                                  decoration: const InputDecoration(
                                    hintText: 'Search Microchip or Pet ID...',
                                    hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                                    prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF94A3B8), size: 20),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(vertical: 14),
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

                        // ==========================================
                        // PATIENT CARDS GRID
                        // ==========================================
                        filteredPatients.isEmpty
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(60.0),
                                  child: Text(
                                    'No monitored patients found in this category.',
                                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 15),
                                  ),
                                ),
                              )
                            : ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: filteredPatients.length,
                                separatorBuilder: (context, index) => const SizedBox(height: 20),
                                itemBuilder: (context, index) {
                                  return _PatientHealthCard(patient: filteredPatients[index]);
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

  String _activeFilterMap(String tab) {
    if (tab == 'Post-Surgery') return 'Post-Surgery';
    if (tab == 'Critical / ICU') return 'Critical / ICU';
    if (tab == 'Discharged') return 'Discharged';
    return 'All Active';
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
            border: Border.all(color: isSelected ? const Color(0xFF183F82) : const Color(0xFFCBD5E1)),
            boxShadow: isSelected ? [BoxShadow(color: const Color(0xFF183F82).withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 4))] : [],
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

  @override
  Widget build(BuildContext context) {
    // Threshold Analytics
    double temp = patient['temp'];
    int spo2 = patient['spo2'];
    
    // Status Colors
    Color statusColor;
    if (patient['status'] == 'Critical / ICU') statusColor = const Color(0xFFEF4444);
    else if (patient['status'] == 'Post-Surgery') statusColor = const Color(0xFFD97706);
    else if (patient['status'] == 'Discharged') statusColor = const Color(0xFF64748B);
    else statusColor = const Color(0xFF059669);

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
                      child: Icon(patient['species'] == 'Feline' ? Icons.cruelty_free : Icons.pets, color: statusColor, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              patient['name'],
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                              ),
                              child: Text(
                                patient['status'].toUpperCase(),
                                style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${patient['id']} • ${patient['breed']}',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
                
                // Quick Actions Top Right
                Row(
                  children: [
                    _buildIconButton(Icons.add_chart_rounded, 'Log Vitals', const Color(0xFF2563EB)),
                    const SizedBox(width: 8),
                    _buildIconButton(Icons.science_outlined, 'Labs', const Color(0xFF059669)),
                    const SizedBox(width: 8),
                    _buildIconButton(Icons.warning_amber_rounded, 'Alert', const Color(0xFFEF4444)),
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
                      const Text('REAL-TIME VITALS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 0.8)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _buildVitalBox('Temperature', '${temp.toStringAsFixed(1)}°C', _getTempStatus(temp), Icons.thermostat)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildVitalBox('SpO2 (Oxygen)', '$spo2%', _getSpo2Status(spo2), Icons.air)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _buildVitalBox('Heart Rate', '${patient['bpm']} bpm', 'Normal', Icons.favorite_rounded)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildVitalBox('Weight Track', '${patient['currentWeight']} kg', _getWeightTrend(patient['currentWeight'], patient['admissionWeight']), Icons.scale_rounded)),
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
                          const Text('CLINICAL STATUS & SOAP', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 0.8)),
                          InkWell(
                            onTap: (){},
                            child: const Text('Edit Notes', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                          )
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
                          style: const TextStyle(fontSize: 12, color: Color(0xFF334155), height: 1.5),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.water_drop_rounded, size: 14, color: Color(0xFF0EA5E9)),
                          const SizedBox(width: 6),
                          Text(
                            'IV Drip: ${patient['ivRate']}',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0284C7)),
                          ),
                        ],
                      )
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
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Last updated: Just now', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                TextButton(
                  onPressed: () {},
                  child: const Text('View Complete Medical History →', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF183F82))),
                )
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
    if (spo2 < 95) return 'Low (Hypoxia)';
    return 'Normal';
  }

  String _getWeightTrend(double current, double admission) {
    if (current < admission) return 'Dropped (-${(admission - current).toStringAsFixed(1)}kg)';
    if (current > admission) return 'Gained (+${(current - admission).toStringAsFixed(1)}kg)';
    return 'Stable';
  }

  // REUSABLE VITAL BOX
  Widget _buildVitalBox(String title, String value, String status, IconData icon) {
    Color statusColor;
    Color bgColor;

    if (status.contains('Fever') || status.contains('Hypoxia') || status.contains('Hypothermia')) {
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
              Text(title, style: TextStyle(fontSize: 11, color: statusColor.withValues(alpha: 0.8), fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: statusColor)),
          const SizedBox(height: 4),
          Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: statusColor)),
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