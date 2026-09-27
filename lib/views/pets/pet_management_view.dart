import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:furry_friends_admin/widgets/sidebar_widget.dart';

const List<String> _monthsList = [
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
];

class PetManagementView extends StatefulWidget {
  const PetManagementView({super.key});

  @override
  State<PetManagementView> createState() => _PetManagementViewState();
}

class _PetManagementViewState extends State<PetManagementView> {
  String _selectedSpeciesFilter = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _calculateAge(String dobStr) {
    try {
      if (dobStr.isEmpty) return 'Unknown';
      final parts = dobStr.split(' ');
      if (parts.length != 2) return dobStr;

      final month = _monthsList.indexOf(parts[0]) + 1;
      final year = int.parse(parts[1]);
      final now = DateTime.now();

      int totalMonths = (now.year - year) * 12 + now.month - month;
      if (totalMonths < 0) totalMonths = 0;

      if (totalMonths >= 12) {
        int yrs = totalMonths ~/ 12;
        int mos = totalMonths % 12;
        return mos > 0 ? '$yrs yrs $mos mos' : '$yrs yrs';
      }
      return '$totalMonths mos';
    } catch (e) {
      return dobStr;
    }
  }

  Stream<List<Map<String, dynamic>>> _getPetsAndOwnersStream() {
    final petsStream = FirebaseFirestore.instance
        .collection('pets')
        .orderBy('createdAt', descending: true)
        .snapshots();
    final usersStream = FirebaseFirestore.instance
        .collection('users')
        .snapshots();

    return Rx.combineLatest2(petsStream, usersStream, (
      QuerySnapshot petsSnapshot,
      QuerySnapshot usersSnapshot,
    ) {
      final usersDocs = usersSnapshot.docs;

      return petsSnapshot.docs.map((doc) {
        final petData = doc.data() as Map<String, dynamic>;
        final ownerId = petData['ownerId'] ?? '';

        String ownerName =
            petData['fullName'] ?? petData['ownerName'] ?? 'Unknown';
        try {
          final userDoc = usersDocs.firstWhere((u) {
            final uData = u.data() as Map<String, dynamic>;
            return uData['ownerId'] == ownerId;
          });
          final uData = userDoc.data() as Map<String, dynamic>;
          if (uData.containsKey('firstName') && uData.containsKey('lastName')) {
            ownerName = '${uData['firstName']} ${uData['lastName']}';
          } else if (uData.containsKey('fullName')) {
            ownerName = uData['fullName'];
          }
        } catch (e) {}

        return {
          'docId': doc.id,
          'id': petData['petId'] ?? 'PET-N/A',
          'name': petData['name'] ?? 'Unknown',
          'species': petData['animalType'] ?? petData['species'] ?? 'Unknown',
          'breed': petData['breed'] ?? 'Unknown',
          'owner': ownerName,
          'ownerId': ownerId,
          'gender': petData['gender'] ?? 'Unknown',
          'dob': petData['dob'] ?? 'Unknown',
          'age': _calculateAge(petData['dob'] ?? ''),
          'colors': petData['colors'] ?? 'Not specified',
        };
      }).toList();
    });
  }

  void _showAddPetSelection() {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close add pet dialog',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (dialogContext, animation, secondaryAnimation) =>
          _PetOwnerSelectionDialog(
            onExistingOwner: () {
              Navigator.of(dialogContext).pop();
              if (!mounted) return;
              _fetchOwnersAndShowRegistration();
            },
            onNewOwner: () {
              Navigator.of(dialogContext).pop();
              if (mounted) Navigator.of(context).pushNamed('/users');
            },
          ),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curve = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curve,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.96, end: 1).animate(curve),
            child: child,
          ),
        );
      },
    );
  }

  Future<void> _fetchOwnersAndShowRegistration() async {
    try {
      final usersSnap = await FirebaseFirestore.instance
          .collection('users')
          .get();
      final owners = <String, String>{};

      for (var doc in usersSnap.docs) {
        final data = doc.data();
        if (data['ownerId'] != null) {
          String name = data['fullName'] ?? 'Unknown';
          if (data.containsKey('firstName') && data.containsKey('lastName')) {
            name = '${data['firstName']} ${data['lastName']}';
          }
          owners[data['ownerId']] = name;
        }
      }

      if (!mounted) return;

      showGeneralDialog<void>(
        context: context,
        barrierDismissible: true,
        barrierLabel: 'Close pet information dialog',
        barrierColor: Colors.black54,
        transitionDuration: const Duration(milliseconds: 220),
        pageBuilder: (dialogContext, animation, secondaryAnimation) =>
            _PetRegistrationDialog(
              owners: owners,
              onSuccess: () {
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pet successfully registered.'),
                    backgroundColor: Color(0xFF059669),
                  ),
                );
              },
            ),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          final curve = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return FadeTransition(
            opacity: curve,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.96, end: 1).animate(curve),
              child: child,
            ),
          );
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading owners: $e')));
      }
    }
  }

  void _showQuickViewDrawer(Map<String, dynamic> pet) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withValues(alpha: 0.4),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.centerRight,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 450,
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
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8FAFC),
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Patient Quick View',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Color(0xFF64748B),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _buildPetAvatar(
                                pet['species'],
                                pet['name'],
                                size: 70,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      pet['name']!,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0F172A),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      pet['id']!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF183F82),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          const Text(
                            'PET SUMMARY',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF94A3B8),
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildDrawerInfoRow(
                            Icons.category_rounded,
                            'Species & Breed',
                            '${pet['species']} • ${pet['breed']}',
                          ),
                          _buildDrawerInfoRow(
                            Icons.cake_rounded,
                            'Age & Gender',
                            '${pet['age']} • ${pet['gender']}',
                          ),
                          _buildDrawerInfoRow(
                            Icons.palette_rounded,
                            'Appearance',
                            pet['colors'],
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'OWNER DETAILS',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF94A3B8),
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildDrawerInfoRow(
                            Icons.person_rounded,
                            'Owner Name',
                            pet['owner'],
                          ),
                          _buildDrawerInfoRow(
                            Icons.badge_rounded,
                            'Owner ID',
                            pet['ownerId'],
                          ),
                          _buildDrawerInfoRow(
                            Icons.phone_rounded,
                            'Contact',
                            'See user directory',
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.medical_information_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Open Full Medical Record',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF183F82),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
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

  Widget _buildDrawerInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: const Color(0xFF64748B)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
          const SidebarWidget(currentRoute: '/pets'),
          Expanded(
            child: Column(
              children: [
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
                    mainAxisAlignment: MainAxisAlignment.end,
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

                // Mula dito hanggang dulo, naka-wrap sa StreamBuilder para iisang beses lang maglo-load ang UI skeleton
                Expanded(
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: _getPetsAndOwnersStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError)
                        return const Center(
                          child: Text('Something went wrong loading pets.'),
                        );
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return const Center(child: CircularProgressIndicator());

                      final List<Map<String, dynamic>> allPets =
                          snapshot.data ?? [];

                      // Calculate Stats Unfiltered
                      int totalPets = allPets.length;
                      int totalCanine = allPets.where((p) {
                        final s = p['species'].toString().toLowerCase();
                        return s == 'dog' || s == 'canine';
                      }).length;
                      int totalFeline = allPets.where((p) {
                        final s = p['species'].toString().toLowerCase();
                        return s == 'cat' || s == 'feline';
                      }).length;
                      int totalOthers = totalPets - totalCanine - totalFeline;

                      // Filter specifically for the table ONLY
                      final filteredPets = allPets.where((pet) {
                        final speciesCat = pet['species']
                            .toString()
                            .toLowerCase();
                        final isDog =
                            speciesCat == 'dog' || speciesCat == 'canine';
                        final isCat =
                            speciesCat == 'cat' || speciesCat == 'feline';

                        bool matchSpecies = _selectedSpeciesFilter == 'All';
                        if (_selectedSpeciesFilter == 'Canine' && isDog)
                          matchSpecies = true;
                        if (_selectedSpeciesFilter == 'Feline' && isCat)
                          matchSpecies = true;
                        if (_selectedSpeciesFilter == 'Others' &&
                            !isDog &&
                            !isCat)
                          matchSpecies = true;

                        final matchSearch =
                            pet['name']!.toLowerCase().contains(_searchQuery) ||
                            pet['id']!.toLowerCase().contains(_searchQuery) ||
                            pet['owner']!.toLowerCase().contains(_searchQuery);

                        return matchSpecies && matchSearch;
                      }).toList();

                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(32.0),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                          'Patient & Pet Management',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.2,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'Manage registered clinic patients and monitor pet records.',
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
                                      Icons.pets_rounded,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatCard(
                                    'Total Patients',
                                    totalPets.toString(),
                                    Icons.pets_rounded,
                                    const Color(0xFF183F82),
                                    'All',
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildStatCard(
                                    'Canine (Dogs)',
                                    totalCanine.toString(),
                                    Icons.pets_rounded,
                                    const Color(0xFF059669),
                                    'Canine',
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildStatCard(
                                    'Feline (Cats)',
                                    totalFeline.toString(),
                                    Icons.cruelty_free_rounded,
                                    const Color(0xFFD97706),
                                    'Feline',
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildStatCard(
                                    'Others',
                                    totalOthers.toString(),
                                    Icons.bug_report_rounded,
                                    const Color(0xFF8B5CF6),
                                    'Others',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.03),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF8FAFC),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: const Color(0xFFE2E8F0),
                                              ),
                                            ),
                                            child: TextField(
                                              controller: _searchController,
                                              onChanged: (value) => setState(
                                                () => _searchQuery = value
                                                    .toLowerCase(),
                                              ),
                                              style: const TextStyle(
                                                fontSize: 13,
                                              ),
                                              decoration: const InputDecoration(
                                                icon: Icon(
                                                  Icons.search,
                                                  color: Color(0xFF94A3B8),
                                                  size: 18,
                                                ),
                                                hintText:
                                                    'Search by Pet ID, Name, or Owner...',
                                                hintStyle: TextStyle(
                                                  color: Color(0xFF94A3B8),
                                                  fontSize: 13,
                                                ),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        ElevatedButton.icon(
                                          onPressed: _showAddPetSelection,
                                          icon: const Icon(
                                            Icons.add_rounded,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                          label: const Text(
                                            'Add Pet',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(
                                              0xFF183F82,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 16,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            elevation: 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    height: 1,
                                    color: Color(0xFFE2E8F0),
                                  ),

                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 14,
                                    ),
                                    color: const Color(0xFFF8FAFC),
                                    child: Row(
                                      children: const [
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            'PATIENT DETAILS',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                              color: Color(0xFF64748B),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            'SPECIES & BREED',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                              color: Color(0xFF64748B),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            'OWNER DETAILS',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                              color: Color(0xFF64748B),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          child: Text(
                                            'ACTIONS',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                              color: Color(0xFF64748B),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    height: 1,
                                    color: Color(0xFFE2E8F0),
                                  ),

                                  // ===============================================
                                  // PERFECT CROSS-FADE ANIMATION FOR LIST CHANGES
                                  // (Walang screen flash o loading)
                                  // ===============================================
                                  AnimatedSize(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOutCubic,
                                    alignment: Alignment.topCenter,
                                    child: AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      switchInCurve: Curves.easeOut,
                                      switchOutCurve: Curves.easeIn,
                                      layoutBuilder:
                                          (currentChild, previousChildren) {
                                            return Stack(
                                              alignment: Alignment.topCenter,
                                              children: <Widget>[
                                                ...previousChildren,
                                                if (currentChild != null)
                                                  currentChild,
                                              ],
                                            );
                                          },
                                      child: filteredPets.isEmpty
                                          ? Container(
                                              key: const ValueKey(
                                                'empty_state',
                                              ),
                                              padding: const EdgeInsets.all(
                                                60.0,
                                              ),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'No pets found matching your criteria.',
                                                style: TextStyle(
                                                  color: Color(0xFF94A3B8),
                                                  fontSize: 14,
                                                ),
                                              ),
                                            )
                                          : ListView.separated(
                                              key: ValueKey(
                                                _selectedSpeciesFilter +
                                                    _searchQuery,
                                              ),
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: filteredPets.length,
                                              separatorBuilder:
                                                  (context, index) =>
                                                      const Divider(
                                                        height: 1,
                                                        color: Color(
                                                          0xFFF1F5F9,
                                                        ),
                                                      ),
                                              itemBuilder: (context, index) {
                                                final pet = filteredPets[index];
                                                return _HoverablePetRow(
                                                  pet: pet,
                                                  onRowClick: () =>
                                                      _showQuickViewDrawer(pet),
                                                  avatarWidget: _buildPetAvatar(
                                                    pet['species'],
                                                    pet['name'],
                                                  ),
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

  Widget _buildPetAvatar(String species, String name, {double size = 42}) {
    Color bgColor;
    Color iconColor;
    IconData icon;
    String cleanSpecies = species.toLowerCase();

    if (cleanSpecies == 'dog' || cleanSpecies == 'canine') {
      bgColor = const Color(0xFFEFF6FF);
      iconColor = const Color(0xFF2563EB);
      icon = Icons.pets_rounded;
    } else if (cleanSpecies == 'cat' || cleanSpecies == 'feline') {
      bgColor = const Color(0xFFFEF2F2);
      iconColor = const Color(0xFFEF4444);
      icon = Icons.cruelty_free_rounded;
    } else {
      bgColor = const Color(0xFFFFFBEB);
      iconColor = const Color(0xFFD97706);
      icon = Icons.bug_report_rounded;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Center(
        child: Icon(icon, color: iconColor, size: size * 0.5),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String count,
    IconData icon,
    Color color,
    String filterValue,
  ) {
    bool isSelected = _selectedSpeciesFilter == filterValue;

    return GestureDetector(
      onTap: () {
        if (_selectedSpeciesFilter != filterValue) {
          setState(() {
            _selectedSpeciesFilter = filterValue;
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.04) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? color.withValues(alpha: 0.6)
                : Colors.transparent,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: color.withValues(alpha: 0.15),
                blurRadius: 16,
                offset: const Offset(0, 6),
              )
            else
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      color: isSelected ? color : const Color(0xFF64748B),
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w600,
                    ),
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 6),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      color: isSelected ? color : const Color(0xFF0F172A),
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                    child: Text(count),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: isSelected ? 0.15 : 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
          ],
        ),
      ),
    );
  }
}

class _PetOwnerSelectionDialog extends StatelessWidget {
  const _PetOwnerSelectionDialog({
    required this.onExistingOwner,
    required this.onNewOwner,
  });
  final VoidCallback onExistingOwner;
  final VoidCallback onNewOwner;

  @override
  Widget build(BuildContext context) => _PetModalFrame(
    title: 'Add New Pet Record',
    width: 520,
    child: Column(
      children: [
        _OwnerOption(
          title: 'Existing Owner',
          subtitle: 'Pet owner already has an account',
          onTap: onExistingOwner,
        ),
        const SizedBox(height: 12),
        _OwnerOption(
          title: 'New Owner',
          subtitle: 'Create a new pet owner account first',
          onTap: onNewOwner,
        ),
      ],
    ),
  );
}

class _PetRegistrationDialog extends StatefulWidget {
  const _PetRegistrationDialog({required this.owners, required this.onSuccess});
  final Map<String, String> owners;
  final VoidCallback onSuccess;

  @override
  State<_PetRegistrationDialog> createState() => _PetRegistrationDialogState();
}

class _PetRegistrationDialogState extends State<_PetRegistrationDialog> {
  static const _blue = Color(0xFF2457A6);
  final _formKey = GlobalKey<FormState>();
  final _petName = TextEditingController();
  final _breed = TextEditingController();
  String? _ownerId;
  String? _animal;
  String? _gender;
  String? _birthMonth;
  String? _birthYear;
  bool _saving = false;

  @override
  void dispose() {
    _petName.dispose();
    _breed.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_saving || !(_formKey.currentState?.validate() ?? false)) return;

    final now = DateTime.now();
    final year = int.parse(_birthYear!);
    final month = _monthsList.indexOf(_birthMonth!) + 1;

    if (year == now.year && month > now.month) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Birth date cannot be in the future.'),
          backgroundColor: Color(0xFFDC2626),
        ),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('pets')
          .count()
          .get();
      final count = snapshot.count ?? 0;
      final petId = 'PET-${(count + 1).toString().padLeft(5, '0')}';

      final ownerName = widget.owners[_ownerId]!;

      await FirebaseFirestore.instance.collection('pets').add({
        'animalType': _animal,
        'breed': _breed.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'dob': '$_birthMonth $_birthYear',
        'fullName': ownerName,
        'gender': _gender,
        'name': _petName.text.trim(),
        'ownerId': _ownerId,
        'ownerName': ownerName,
        'petId': petId,
        'species': _animal,
      });

      widget.onSuccess();
    } catch (e) {
      setState(() => _saving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving pet: $e'),
            backgroundColor: const Color(0xFFDC2626),
          ),
        );
      }
    }
  }

  Widget _field(String label, Widget input) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          color: Color(0xFF64748B),
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 7),
      input,
    ],
  );

  Widget _pair(Widget left, Widget right) => LayoutBuilder(
    builder: (context, constraints) => constraints.maxWidth < 420
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [left, const SizedBox(height: 16), right],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: left),
              const SizedBox(width: 12),
              Expanded(child: right),
            ],
          ),
  );

  InputDecoration _decoration(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: const BorderSide(color: Color(0xFFD7E2F3)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: const BorderSide(color: _blue, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: const BorderSide(color: Color(0xFFDC2626)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.5),
    ),
  );

  Widget _textField(TextEditingController controller, String hint) =>
      TextFormField(
        controller: controller,
        style: const TextStyle(fontSize: 12, color: Color(0xFF0F172A)),
        decoration: _decoration(hint),
        validator: (value) => value == null || value.trim().isEmpty
            ? 'This field is required'
            : null,
      );

  Widget _dropdown({
    required String? value,
    required String hint,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) => DropdownButtonFormField<String>(
    value: value,
    isExpanded: true,
    icon: const Icon(
      Icons.keyboard_arrow_down_rounded,
      color: Color(0xFF64748B),
      size: 20,
    ),
    decoration: _decoration(hint),
    style: const TextStyle(fontSize: 12, color: Color(0xFF0F172A)),
    dropdownColor: Colors.white,
    borderRadius: BorderRadius.circular(9),
    items: items,
    onChanged: onChanged,
    validator: (value) => value == null ? 'Please select an option' : null,
  );

  List<DropdownMenuItem<String>> _items(Iterable<String> values) => values
      .map(
        (item) => DropdownMenuItem<String>(
          value: item,
          child: Text(item, overflow: TextOverflow.ellipsis),
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return _PetModalFrame(
      title: 'Add New Pet Information',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _field(
              'PET OWNER*',
              _dropdown(
                value: _ownerId,
                hint: 'Select existing owner',
                items: widget.owners.entries
                    .map(
                      (entry) => DropdownMenuItem<String>(
                        value: entry.key,
                        child: Text(
                          '${entry.value} (${entry.key})',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _ownerId = value),
              ),
            ),
            const SizedBox(height: 16),
            _pair(
              _field('PET NAME*', _textField(_petName, 'Enter pet name')),
              _field(
                'TYPE OF ANIMAL*',
                _dropdown(
                  value: _animal,
                  hint: 'Select animal',
                  items: _items(const ['Dog', 'Cat', 'Bird', 'Exotic']),
                  onChanged: (value) => setState(() => _animal = value),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _pair(
              _field(
                'GENDER*',
                _dropdown(
                  value: _gender,
                  hint: 'Select gender',
                  items: _items(const ['Male', 'Female', 'Unknown']),
                  onChanged: (value) => setState(() => _gender = value),
                ),
              ),
              _field(
                'BREED / SPECIES*',
                _textField(_breed, 'Enter breed or species'),
              ),
            ),
            const SizedBox(height: 16),
            _field(
              'ESTIMATED BIRTH DATE*',
              _pair(
                _dropdown(
                  value: _birthMonth,
                  hint: 'Birth month',
                  items: _items(_monthsList),
                  onChanged: (value) => setState(() => _birthMonth = value),
                ),
                _dropdown(
                  value: _birthYear,
                  hint: 'Birth year',
                  items: _items(
                    List.generate(31, (index) => (now.year - index).toString()),
                  ),
                  onChanged: (value) => setState(() => _birthYear = value),
                ),
              ),
            ),
          ],
        ),
      ),
      footer: Wrap(
        alignment: WrapAlignment.end,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12,
        children: [
          TextButton(
            onPressed: _saving ? null : () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _saving ? null : _submit,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.disabled))
                  return const Color(0xFF94A3B8);
                if (states.contains(WidgetState.hovered))
                  return const Color(0xFF174385);
                return _blue;
              }),
              foregroundColor: const WidgetStatePropertyAll(Colors.white),
              padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 22, vertical: 15),
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
              ),
              elevation: const WidgetStatePropertyAll(0),
            ),
            child: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Save Pet Record',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
          ),
        ],
      ),
    );
  }
}

class _PetModalFrame extends StatelessWidget {
  const _PetModalFrame({
    required this.title,
    required this.child,
    this.footer,
    this.width = 560,
  });
  final String title;
  final Widget child;
  final Widget? footer;
  final double width;

  @override
  Widget build(BuildContext context) {
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
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(28, 22, 28, 24),
                  child: child,
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
}

class _OwnerOption extends StatefulWidget {
  const _OwnerOption({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  State<_OwnerOption> createState() => _OwnerOptionState();
}

class _OwnerOptionState extends State<_OwnerOption> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _hovered = true),
    onExit: (_) => setState(() => _hovered = false),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      decoration: BoxDecoration(
        color: _hovered ? const Color(0xFFEFF6FF) : Colors.white,
        border: Border.all(
          color: _hovered ? const Color(0xFF2457A6) : const Color(0xFFD7E2F3),
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

// ===================================================================
// HOVERABLE TABLE ROW WIDGET (With Drawer Trigger)
// ===================================================================
class _HoverablePetRow extends StatefulWidget {
  final Map<String, dynamic> pet;
  final VoidCallback onRowClick;
  final Widget avatarWidget;

  const _HoverablePetRow({
    required this.pet,
    required this.onRowClick,
    required this.avatarWidget,
  });

  @override
  State<_HoverablePetRow> createState() => _HoverablePetRowState();
}

class _HoverablePetRowState extends State<_HoverablePetRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onRowClick,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            color: _isHovered ? const Color(0xFFF8FAFC) : Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      widget.avatarWidget,
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.pet['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.pet['id'],
                              style: const TextStyle(
                                color: Color(0xFF183F82),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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
                        widget.pet['species'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.pet['breed'],
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.pet['owner'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.pet['ownerId'],
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: Center(
                    child: PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        color: Color(0xFF94A3B8),
                        size: 22,
                      ),
                      tooltip: 'Actions',
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      offset: const Offset(0, 40),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'view',
                          child: Row(
                            children: [
                              Icon(
                                Icons.medical_information_outlined,
                                size: 18,
                                color: Color(0xFF64748B),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Medical Records',
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit_outlined,
                                size: 18,
                                color: Color(0xFF64748B),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Edit Details',
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'appointment',
                          child: Row(
                            children: [
                              Icon(
                                Icons.event_outlined,
                                size: 18,
                                color: Color(0xFF64748B),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Schedule Checkup',
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {},
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
