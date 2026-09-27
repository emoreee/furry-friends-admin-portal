import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:furry_friends_admin/widgets/sidebar_widget.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _selectedCardIndex = 0;
  String _searchQuery = '';

  // ==========================================
  // LOCAL MOCK DATA (Gagana sa UI kahit walang Database)
  // ==========================================
  List<Map<String, dynamic>> _appointmentsToday = [
    {
      'id': 'PET-2024-089',
      'time': '09:00 AM - 10:30 AM',
      'pet': 'Bella (Golden Retriever)',
      'owner': 'Janelle Sombillo',
      'ownerContact': '+63 917 555 0192',
      'reason': 'Annual Vaccination',
      'status': 'Confirmed',
      'species': 'Canine',
      'breed': 'Golden Retriever',
      'gender': 'Female (Spayed)',
      'age': '3 yrs 4 mos',
      'colors': 'Golden',
      'doctor': 'Dr. Alfie Tamesis',
      'notes': 'No known allergies.',
    },
    {
      'id': 'PET-2024-112',
      'time': '10:30 AM - 12:00 PM',
      'pet': 'Luna (Persian Cat)',
      'owner': 'Jerome Polo',
      'ownerContact': '+63 920 123 4567',
      'reason': 'Skin Consultation',
      'status': 'Pending',
      'species': 'Feline',
      'breed': 'Persian Cat',
      'gender': 'Female',
      'age': '2 yrs 1 mo',
      'colors': 'White',
      'doctor': 'Dr. James Nico Martinez',
      'notes': 'Has red spots on belly.',
    },
  ];

  List<Map<String, dynamic>> _inPatients = [
    {
      'id': 'PET-2024-090',
      'ward': 'Ward A-1',
      'time': 'N/A',
      'pet': 'Charlie (Pug)',
      'owner': 'Junexenne Agravante',
      'ownerContact': '+63 917 111 2222',
      'condition': 'Post-Surgery Recovery',
      'reason': 'Post-Surgery Recovery',
      'status': 'Stable',
      'species': 'Canine',
      'breed': 'Pug',
      'gender': 'Male',
      'age': '4 yrs',
      'colors': 'Fawn',
      'doctor': 'Dr. Kyle Asistio',
      'notes': 'Monitoring for 24 hours.',
    },
  ];

  List<Map<String, dynamic>> _urgentCases = [
    {
      'id': 'PET-2024-150',
      'time': '08:15 AM - 09:30 AM',
      'pet': 'Simba (Maine Coon)',
      'owner': 'Walk-in',
      'ownerContact': 'N/A',
      'reason': 'Severe Trauma / Accident',
      'condition': 'Critical',
      'status': 'Critical',
      'species': 'Feline',
      'breed': 'Maine Coon',
      'gender': 'Male',
      'age': '1 yr',
      'colors': 'Orange Tabby',
      'doctor': 'Dr. Alfie Tamesis',
      'notes': 'Hit by car.',
    },
  ];

  // Logic para ma-sort ang time mula maaga hanggang pinaka-late
  int _timeMinutes(Object? time) {
    final text = (time?.toString() ?? '')
        .split(RegExp(r'\s*[–-]\s*'))
        .first
        .trim();
    for (final pattern in ['hh:mm a', 'h:mm a']) {
      try {
        final date = DateFormat(pattern).parseStrict(text);
        return date.hour * 60 + date.minute;
      } catch (_) {}
    }
    return 9999;
  }

  String _string(Object? value, [String fallback = '—']) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? fallback : text;
  }

  @override
  void initState() {
    super.initState();
    // I-sort agad sa pag-load
    _appointmentsToday.sort(
      (a, b) => _timeMinutes(a['time']).compareTo(_timeMinutes(b['time'])),
    );
    _urgentCases.sort(
      (a, b) => _timeMinutes(a['time']).compareTo(_timeMinutes(b['time'])),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat(
      'EEEE, MMM. dd, yyyy',
    ).format(DateTime.now());
    final String upperDate = DateFormat(
      'MMMM dd, yyyy',
    ).format(DateTime.now()).toUpperCase();

    Color activeAccentColor = _selectedCardIndex == 0
        ? const Color(0xFF183F82)
        : _selectedCardIndex == 1
        ? const Color(0xFF059669)
        : const Color(0xFFEF4444);
    Color activeSoftBgColor = _selectedCardIndex == 0
        ? const Color(0xFFEFF6FF)
        : _selectedCardIndex == 1
        ? const Color(0xFFECFDF5)
        : const Color(0xFFFEF2F2);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: Row(
        children: [
          const SidebarWidget(currentRoute: '/dashboard'),
          Expanded(
            child: Column(
              children: [
                // Top Header Bar
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
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: TextField(
                            onChanged: (value) => setState(
                              () => _searchQuery = value.trim().toLowerCase(),
                            ),
                            style: const TextStyle(fontSize: 13),
                            decoration: const InputDecoration(
                              icon: Icon(
                                Icons.search_rounded,
                                color: Color(0xFF94A3B8),
                                size: 18,
                              ),
                              hintText:
                                  'Search pets, appointments, health records...',
                              hintStyle: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 13,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
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
                                  color: Color(0xFF0F172A),
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

                // Main Content Area (Diretso na, walang StreamBuilder)
                Expanded(
                  child: _buildDynamicDashboardContent(
                    _appointmentsToday,
                    _inPatients,
                    _urgentCases,
                    10, // Mock yesterday count
                    activeAccentColor,
                    activeSoftBgColor,
                    upperDate,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicDashboardContent(
    List<Map<String, dynamic>> todayRows,
    List<Map<String, dynamic>> admittedRows,
    List<Map<String, dynamic>> urgentRows,
    int yesterdayCount,
    Color activeAccentColor,
    Color activeSoftBgColor,
    String upperDate,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
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
                  color: const Color(0xFF183F82).withValues(alpha: 0.25),
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
                        'Good Morning, Admin Team!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Here is what\'s happening at Bayside Animal Hospital today.',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _buildQuickActionButton(
                            icon: Icons.calendar_month_rounded,
                            label: 'Quick Book',
                            bgColor: Colors.white,
                            textColor: const Color(0xFF183F82),
                            onPressed: () => _showQuickBookDialog(context),
                          ),
                          const SizedBox(width: 10),
                          _buildQuickActionButton(
                            icon: Icons.pets_rounded,
                            label: 'Register Pet',
                            bgColor: Colors.white.withValues(alpha: 0.15),
                            textColor: Colors.white,
                            onPressed: () =>
                                _showRegisterPetSelectionDialog(context),
                          ),
                        ],
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
                    Icons.storefront_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Clinic Overview',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              Text(
                'Click a card to filter the view below',
                style: TextStyle(
                  fontSize: 12,
                  color: const Color(0xFF64748B).withValues(alpha: 0.8),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildPremiumOverviewCard(
                  0,
                  'Appointments Today',
                  todayRows.length.toString(),
                  '${todayRows.length - yesterdayCount >= 0 ? '+' : ''}${todayRows.length - yesterdayCount} from yesterday',
                  true,
                  Icons.calendar_today_rounded,
                  const Color(0xFF183F82),
                  const Color(0xFFEFF6FF),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildPremiumOverviewCard(
                  1,
                  'In-Patient',
                  admittedRows.length.toString(),
                  'Stable capacity',
                  true,
                  Icons.hotel_rounded,
                  const Color(0xFF059669),
                  const Color(0xFFECFDF5),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildPremiumOverviewCard(
                  2,
                  'Urgent Case',
                  urgentRows.length.toString(),
                  '${urgentRows.length} new critical',
                  false,
                  Icons.warning_rounded,
                  const Color(0xFFEF4444),
                  const Color(0xFFFEF2F2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(width: 4, color: activeAccentColor),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 20, 20, 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: activeSoftBgColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    _selectedCardIndex == 0
                                        ? Icons.calendar_today_rounded
                                        : _selectedCardIndex == 1
                                        ? Icons.hotel_rounded
                                        : Icons.warning_rounded,
                                    color: activeAccentColor,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _getSectionTitle(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: activeSoftBgColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                upperDate,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: activeAccentColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(color: Color(0xFFF1F5F9), height: 1),
                      _buildDynamicContentTable(
                        _selectedCardIndex == 0
                            ? todayRows
                            : _selectedCardIndex == 1
                            ? admittedRows
                            : urgentRows,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showQuickViewDrawer(BuildContext context, Map<String, dynamic> pet) {
    String petName = pet['pet'] != null
        ? pet['pet'].toString().split(' (')[0]
        : 'Unknown Pet';
    double drawerWidth = 580;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return StatefulBuilder(
          builder: (context, setDrawerState) {
            return Align(
              alignment: Alignment.centerRight,
              child: Material(
                color: Colors.transparent,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        setDrawerState(() {
                          drawerWidth -= details.delta.dx;
                          if (drawerWidth < 450) drawerWidth = 450;
                          if (drawerWidth > 900) drawerWidth = 900;
                        });
                      },
                      child: Container(
                        width: 8,
                        height: double.infinity,
                        color: Colors.transparent,
                        child: Center(
                          child: Container(
                            width: 3,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF94A3B8),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: drawerWidth,
                      height: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 20,
                            offset: Offset(-5, 0),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 20,
                            ),
                            color: const Color(0xFF2457A6),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF3972C3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.pets_rounded,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            petName,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF047857),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: const Text(
                                              'Local\nPreview',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 8,
                                                fontWeight: FontWeight.bold,
                                                height: 1.2,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Pet ID: #${pet['id'] ?? 'N/A'}',
                                        style: const TextStyle(
                                          color: Color(0xFF94A3B8),
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(24),
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _detailLine(
                                    'Species & Breed',
                                    '${pet['breed'] ?? 'Mixed'} (${pet['species'] ?? 'Canine'})',
                                  ),
                                  _detailLine('Gender', pet['gender']),
                                  _detailLine('Age', pet['age']),
                                  _detailLine('Color', pet['colors']),
                                  const Divider(height: 32),
                                  _detailLine('Owner', pet['owner']),
                                  _detailLine('Contact', pet['ownerContact']),
                                  const Divider(height: 32),
                                  _detailLine('Time', pet['time']),
                                  _detailLine('Service', pet['reason']),
                                  _detailLine('Doctor', pet['doctor']),
                                  _detailLine('Notes', pet['notes']),
                                ],
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
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
              .animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
          child: child,
        );
      },
    );
  }

  Widget _detailLine(String label, Object? value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 145,
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
          ),
        ),
        Expanded(
          child: Text(
            _string(value),
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );

  static const Color _dialogBlue = Color(0xFF2457A6);

  Future<T?> _showAdminDialog<T>(Widget child) => showGeneralDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Close dialog',
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 230),
    pageBuilder: (dialogContext, animation, secondaryAnimation) => child,
    transitionBuilder: (dialogContext, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.96, end: 1).animate(curved),
          child: child,
        ),
      );
    },
  );

  Widget _adminDialogFrame({
    required BuildContext context,
    required String title,
    required Widget body,
    Widget? footer,
    double width = 560,
  }) {
    final size = MediaQuery.sizeOf(context);
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: width,
          constraints: BoxConstraints(
            maxWidth: size.width - 32,
            maxHeight: size.height - 32,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.16),
                blurRadius: 32,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 20, 20, 18),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Close',
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Color(0xFF94A3B8),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(28, 22, 28, 24),
                  child: body,
                ),
              ),
              if (footer != null) ...[
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 16,
                  ),
                  child: footer,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _dialogFooter(
    BuildContext context,
    String label,
    bool loading,
    VoidCallback onSubmit,
  ) {
    return Wrap(
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      children: [
        TextButton(
          onPressed: loading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: loading ? null : onSubmit,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled))
                return const Color(0xFF94A3B8);
              if (states.contains(WidgetState.hovered))
                return const Color(0xFF174385);
              return _dialogBlue;
            }),
            foregroundColor: const WidgetStatePropertyAll(Colors.white),
            elevation: const WidgetStatePropertyAll(0),
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 22, vertical: 15),
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
            ),
          ),
          child: loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _responsiveFields(Widget first, Widget second) => LayoutBuilder(
    builder: (context, constraints) => constraints.maxWidth < 420
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [first, const SizedBox(height: 16), second],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: first),
              const SizedBox(width: 12),
              Expanded(child: second),
            ],
          ),
  );

  Widget _formField(String label, Widget field) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildCompactFieldLabel(label),
      const SizedBox(height: 6),
      field,
    ],
  );

  void _showQuickBookDialog(BuildContext context) {
    final key = GlobalKey<FormState>();
    String? owner, pet, service, doctor, time;
    bool urgent = false, loading = false;
    final complaint = TextEditingController();
    final notes = TextEditingController();
    final date = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );

    _showAdminDialog(
      StatefulBuilder(
        builder: (dialogContext, update) {
          Future<void> submit() async {
            if (!(key.currentState?.validate() ?? false) || loading) return;
            update(() => loading = true);
            await Future<void>.delayed(const Duration(milliseconds: 550));
            if (!dialogContext.mounted) return;

            // ==========================================
            // LOCAL STATE UPDATE: Idadagdag agad sa table
            // ==========================================
            this.setState(() {
              final newAppt = {
                'id':
                    'PET-NEW-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                'time': time ?? '09:00 AM - 10:30 AM',
                'pet': pet ?? 'Unknown Pet',
                'owner': owner ?? 'Unknown Owner',
                'ownerContact': 'N/A',
                'reason': service ?? 'General Checkup',
                'status': urgent ? 'Urgent' : 'Pending',
                'species': 'Unknown',
                'breed': 'Mixed',
                'gender': 'Unknown',
                'age': 'N/A',
                'colors': 'N/A',
                'doctor': doctor ?? 'Unassigned',
                'notes': complaint.text,
                'ward': 'N/A',
                'condition': urgent ? 'Critical' : 'Stable',
              };

              _appointmentsToday.add(newAppt);
              if (urgent) {
                _urgentCases.add(newAppt);
              }

              // Muling i-sort ang oras (early booking to late)
              _appointmentsToday.sort(
                (a, b) =>
                    _timeMinutes(a['time']).compareTo(_timeMinutes(b['time'])),
              );
              _urgentCases.sort(
                (a, b) =>
                    _timeMinutes(a['time']).compareTo(_timeMinutes(b['time'])),
              );
            });

            Navigator.pop(dialogContext);
            if (mounted) {
              ScaffoldMessenger.of(this.context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Local Appointment successfully added to list!',
                  ),
                ),
              );
            }
          }

          return _adminDialogFrame(
            context: dialogContext,
            title: 'Quick Book Appointment',
            body: Form(
              key: key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _formField(
                    'PET OWNER*',
                    _buildCompactDropdown(
                      value: owner,
                      hint: 'Select an owner',
                      requiredField: true,
                      items: const [
                        'Maria Santos (OWN-0001)',
                        'Jerome Polo (OWN-0002)',
                        'Ana Reyes (OWN-0003)',
                      ],
                      onChanged: (v) => update(() {
                        owner = v;
                        pet = null;
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _formField(
                    'PET*',
                    _buildCompactDropdown(
                      value: pet,
                      hint: owner == null
                          ? 'Select owner first'
                          : 'Select a pet',
                      requiredField: true,
                      items: const [
                        'Buddy (Golden Retriever)',
                        'Milo (Beagle)',
                        'Bella (Shih Tzu)',
                      ],
                      onChanged: owner == null
                          ? null
                          : (v) => update(() => pet = v),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _responsiveFields(
                    _formField(
                      'SERVICE*',
                      _buildCompactDropdown(
                        value: service,
                        hint: 'Select service',
                        requiredField: true,
                        items: const [
                          'General Checkup',
                          'Dental Cleaning',
                          'Vaccination',
                          'Surgery',
                        ],
                        onChanged: (v) => update(() => service = v),
                      ),
                    ),
                    _formField(
                      'ASSIGNED DOCTOR',
                      _buildCompactDropdown(
                        value: doctor,
                        hint: 'Select doctor',
                        items: const [
                          'Dr. James Nico Martinez',
                          'Dr. Alfie Tamesis',
                          'Dr. Kyle Asistio',
                        ],
                        onChanged: (v) => update(() => doctor = v),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _formField(
                    'CHIEF COMPLAINT*',
                    _buildCompactTextField(
                      controller: complaint,
                      hint: 'Enter reason',
                      requiredField: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _responsiveFields(
                    _formField(
                      'APPOINTMENT DATE*',
                      _buildCompactTextField(
                        controller: date,
                        hint: 'Select date',
                        readOnly: true,
                        requiredField: true,
                        suffixIcon: Icons.calendar_today_rounded,
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: dialogContext,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          if (picked != null)
                            date.text = DateFormat('yyyy-MM-dd').format(picked);
                        },
                      ),
                    ),
                    _formField(
                      'TIME SLOT*',
                      _buildCompactDropdown(
                        value: time,
                        hint: 'Select time',
                        requiredField: true,
                        items: const [
                          '09:00 AM - 10:30 AM',
                          '10:30 AM - 12:00 PM',
                          '01:00 PM - 02:30 PM',
                          '03:00 PM - 04:30 PM',
                        ],
                        onChanged: (v) => update(() => time = v),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    value: urgent,
                    onChanged: (v) => update(() => urgent = v ?? false),
                    title: const Text(
                      'Mark as urgent / emergency case',
                      style: TextStyle(fontSize: 12),
                    ),
                    activeColor: const Color(0xFFEF4444),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ],
              ),
            ),
            footer: _dialogFooter(
              dialogContext,
              'Book Appointment',
              loading,
              submit,
            ),
          );
        },
      ),
    ).whenComplete(() {
      complaint.dispose();
      notes.dispose();
      date.dispose();
    });
  }

  void _showRegisterPetSelectionDialog(BuildContext context) {
    _showAdminDialog(
      Builder(
        builder: (dialogContext) => _adminDialogFrame(
          context: dialogContext,
          title: 'Add New Pet Record',
          width: 520,
          body: Column(
            children: [
              _buildCompactSelectionCard(
                title: 'Existing Owner',
                subtitle: 'Pet owner already has an account',
                onTap: () {
                  Navigator.pop(dialogContext);
                  _showPetRegistrationFormDialog(context);
                },
              ),
              const SizedBox(height: 12),
              _buildCompactSelectionCard(
                title: 'New Owner',
                subtitle: 'Create a new pet owner account first',
                onTap: () {
                  Navigator.pop(dialogContext);
                  Navigator.pushNamed(context, '/users');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPetRegistrationFormDialog(BuildContext context) {
    final key = GlobalKey<FormState>();
    String? owner, animal, gender, month, year;
    bool loading = false;
    final petName = TextEditingController();
    final breed = TextEditingController();
    final years = List.generate(
      27,
      (index) => (DateTime.now().year - index).toString(),
    );

    _showAdminDialog(
      StatefulBuilder(
        builder: (dialogContext, update) {
          Future<void> submit() async {
            if (!(key.currentState?.validate() ?? false) || loading) return;
            update(() => loading = true);
            await Future<void>.delayed(const Duration(milliseconds: 550));
            if (!dialogContext.mounted) return;
            Navigator.pop(dialogContext);
            if (mounted)
              ScaffoldMessenger.of(this.context).showSnackBar(
                const SnackBar(content: Text('Pet saved locally!')),
              );
          }

          return _adminDialogFrame(
            context: dialogContext,
            title: 'Add New Pet Information',
            body: Form(
              key: key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _formField(
                    'PET OWNER*',
                    _buildCompactDropdown(
                      value: owner,
                      hint: 'Select existing owner',
                      requiredField: true,
                      items: const ['Maria Santos', 'Jerome Polo'],
                      onChanged: (v) => update(() => owner = v),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _responsiveFields(
                    _formField(
                      'PET NAME*',
                      _buildCompactTextField(
                        controller: petName,
                        hint: 'Enter pet name',
                        requiredField: true,
                      ),
                    ),
                    _formField(
                      'TYPE OF ANIMAL*',
                      _buildCompactDropdown(
                        value: animal,
                        hint: 'Select animal',
                        requiredField: true,
                        items: const ['Dog', 'Cat', 'Bird', 'Exotic'],
                        onChanged: (v) => update(() => animal = v),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _responsiveFields(
                    _formField(
                      'GENDER*',
                      _buildCompactDropdown(
                        value: gender,
                        hint: 'Select gender',
                        requiredField: true,
                        items: const ['Male', 'Female', 'Unknown'],
                        onChanged: (v) => update(() => gender = v),
                      ),
                    ),
                    _formField(
                      'BREED / SPECIES*',
                      _buildCompactTextField(
                        controller: breed,
                        hint: 'Enter breed',
                        requiredField: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCompactFieldLabel('ESTIMATED BIRTH DATE*'),
                  const SizedBox(height: 6),
                  _responsiveFields(
                    _buildCompactDropdown(
                      value: month,
                      hint: 'Birth month',
                      requiredField: true,
                      items: const [
                        'January',
                        'February',
                        'March',
                        'April',
                        'May',
                        'June',
                        'July',
                        'August',
                        'September',
                        'October',
                        'November',
                        'December',
                      ],
                      onChanged: (v) => update(() => month = v),
                    ),
                    _buildCompactDropdown(
                      value: year,
                      hint: 'Birth year',
                      requiredField: true,
                      items: years,
                      onChanged: (v) => update(() => year = v),
                    ),
                  ),
                ],
              ),
            ),
            footer: _dialogFooter(
              dialogContext,
              'Save Pet Record',
              loading,
              submit,
            ),
          );
        },
      ),
    ).whenComplete(() {
      petName.dispose();
      breed.dispose();
    });
  }

  Widget _buildCompactFieldLabel(String label) => Text(
    label,
    style: const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.bold,
      color: Color(0xFF64748B),
    ),
  );

  InputDecoration _compactDecoration(String hint, {IconData? suffixIcon}) =>
      InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
        suffixIcon: suffixIcon == null
            ? null
            : Icon(suffixIcon, size: 17, color: const Color(0xFF64748B)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: Color(0xFFD7E2F3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: _dialogBlue, width: 1.5),
        ),
      );

  Widget _buildCompactTextField({
    required TextEditingController controller,
    required String hint,
    bool readOnly = false,
    bool requiredField = false,
    int maxLines = 1,
    IconData? suffixIcon,
    VoidCallback? onTap,
  }) => TextFormField(
    controller: controller,
    readOnly: readOnly,
    onTap: onTap,
    maxLines: maxLines,
    validator: requiredField
        ? (v) => v == null || v.trim().isEmpty ? 'Required' : null
        : null,
    style: const TextStyle(fontSize: 12, color: Color(0xFF0F172A)),
    decoration: _compactDecoration(hint, suffixIcon: suffixIcon),
  );

  Widget _buildCompactDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?>? onChanged,
    bool requiredField = false,
  }) => DropdownButtonFormField<String>(
    value: value,
    isExpanded: true,
    icon: const Icon(
      Icons.keyboard_arrow_down_rounded,
      color: Color(0xFF64748B),
      size: 20,
    ),
    validator: requiredField ? (v) => v == null ? 'Select option' : null : null,
    style: const TextStyle(fontSize: 12, color: Color(0xFF0F172A)),
    decoration: _compactDecoration(hint),
    dropdownColor: Colors.white,
    borderRadius: BorderRadius.circular(9),
    items: items
        .map(
          (item) => DropdownMenuItem(
            value: item,
            child: Text(item, overflow: TextOverflow.ellipsis),
          ),
        )
        .toList(),
    onChanged: onChanged,
  );

  Widget _buildCompactSelectionCard({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) => _DashboardSelectionCard(title: title, subtitle: subtitle, onTap: onTap);

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color bgColor,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 14, color: textColor),
      label: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: textColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  String _getSectionTitle() {
    switch (_selectedCardIndex) {
      case 0:
        return 'Appointments Today Overview';
      case 1:
        return 'In-Patient Records Overview';
      case 2:
        return 'Urgent Cases & Emergencies';
      default:
        return 'Overview';
    }
  }

  Widget _buildDynamicContentTable(List<Map<String, dynamic>> currentList) {
    final rows = _searchQuery.isEmpty
        ? currentList
        : currentList
              .where(
                (row) => ['pet', 'owner', 'reason', 'id', 'status'].any(
                  (field) => _string(
                    row[field],
                    '',
                  ).toLowerCase().contains(_searchQuery),
                ),
              )
              .toList();
    if (rows.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text(
            'No matching records found.',
            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rows.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
      itemBuilder: (context, index) {
        final item = rows[index];
        return _HoverableDashboardRow(
          item: item,
          indexType: _selectedCardIndex,
          onRowTap: () => _showQuickViewDrawer(context, item),
          onCheckIn:
              item['status'] == 'Confirmed' || item['status'] == 'Pending'
              ? () {
                  setState(() {
                    item['status'] = 'Checked-In';
                  });
                }
              : null,
        );
      },
    );
  }

  Widget _buildPremiumOverviewCard(
    int index,
    String title,
    String count,
    String trend,
    bool isPositiveTrend,
    IconData icon,
    Color accentColor,
    Color softBgColor,
  ) {
    bool isSelected = _selectedCardIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedCardIndex = index),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? softBgColor.withValues(alpha: 0.6) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? accentColor : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? accentColor.withValues(alpha: 0.15)
                  : Colors.black.withValues(alpha: 0.02),
              blurRadius: isSelected ? 12 : 6,
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
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: isSelected ? accentColor : const Color(0xFF64748B),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: softBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: accentColor, size: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              count,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 28,
                color: isSelected ? accentColor : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  isPositiveTrend
                      ? Icons.trending_up_rounded
                      : Icons.priority_high_rounded,
                  size: 14,
                  color: isPositiveTrend
                      ? const Color(0xFF059669)
                      : const Color(0xFFEF4444),
                ),
                const SizedBox(width: 4),
                Text(
                  trend,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isPositiveTrend
                        ? const Color(0xFF059669)
                        : const Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HoverableDashboardRow extends StatefulWidget {
  final Map<String, dynamic> item;
  final int indexType;
  final VoidCallback onRowTap;
  final VoidCallback? onCheckIn;

  const _HoverableDashboardRow({
    required this.item,
    required this.indexType,
    required this.onRowTap,
    this.onCheckIn,
  });

  @override
  State<_HoverableDashboardRow> createState() => _HoverableDashboardRowState();
}

class _HoverableDashboardRowState extends State<_HoverableDashboardRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onRowTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(
            _isHovered ? 6.0 : 0.0,
            0.0,
            0.0,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            color: _isHovered ? const Color(0xFFEFF6FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered ? const Color(0xFFBFDBFE) : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 140,
                child: Text(
                  widget.indexType == 1
                      ? widget.item['ward']
                      : widget.item['time'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                    fontSize: 12,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item['pet'].toString().split(' (')[0],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline_rounded,
                          size: 12,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.item['owner'],
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  widget.indexType == 1
                      ? widget.item['condition']
                      : widget.item['reason'],
                  style: const TextStyle(
                    color: Color(0xFF334155),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _buildStatusBadge(),
                ),
              ),
              SizedBox(
                width: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (widget.onCheckIn != null)
                      TextButton(
                        onPressed: widget.onCheckIn,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          backgroundColor: const Color(
                            0xFF183F82,
                          ).withValues(alpha: 0.1),
                        ),
                        child: const Text(
                          'Check-in',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF183F82),
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFF94A3B8),
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      tooltip: 'View Details',
                      onPressed: widget.onRowTap,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    String status = widget.item['status'];
    Color bgColor, textColor;
    switch (status) {
      case 'Confirmed':
      case 'Stable':
        bgColor = const Color(0xFFECFDF5);
        textColor = const Color(0xFF059669);
        break;
      case 'Pending':
      case 'Observing':
        bgColor = const Color(0xFFFFFBEB);
        textColor = const Color(0xFFD97706);
        break;
      case 'Checked-In':
        bgColor = const Color(0xFFEFF6FF);
        textColor = const Color(0xFF2563EB);
        break;
      case 'Critical':
      case 'Urgent':
        bgColor = const Color(0xFFFEF2F2);
        textColor = const Color(0xFFEF4444);
        break;
      default:
        bgColor = const Color(0xFFF1F5F9);
        textColor = const Color(0xFF64748B);
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
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _DashboardSelectionCard extends StatefulWidget {
  const _DashboardSelectionCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final String title, subtitle;
  final VoidCallback onTap;
  @override
  State<_DashboardSelectionCard> createState() =>
      _DashboardSelectionCardState();
}

class _DashboardSelectionCardState extends State<_DashboardSelectionCard> {
  bool hovered = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => hovered = true),
    onExit: (_) => setState(() => hovered = false),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      decoration: BoxDecoration(
        color: hovered ? const Color(0xFFEFF6FF) : Colors.white,
        border: Border.all(
          color: hovered ? const Color(0xFF2457A6) : const Color(0xFFD7E2F3),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_rounded,
                size: 18,
                color: Color(0xFF2457A6),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
