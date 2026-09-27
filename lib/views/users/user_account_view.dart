import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:furry_friends_admin/widgets/sidebar_widget.dart';

class UserAccountView extends StatefulWidget {
  const UserAccountView({super.key});

  @override
  State<UserAccountView> createState() => _UserAccountViewState();
}

class _UserAccountViewState extends State<UserAccountView> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatusFilter = 'All Status';
  String _selectedLocationFilter = 'All Locations';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ============================================================================
  // STREAM COMBINATION (Users + Pets)
  // ============================================================================
  Stream<List<Map<String, dynamic>>> _getUsersWithPetsStream() {
    final usersStream = FirebaseFirestore.instance
        .collection('users')
        .orderBy('createdAt', descending: true)
        .snapshots();
    final petsStream = FirebaseFirestore.instance
        .collection('pets')
        .snapshots();

    return Rx.combineLatest2(usersStream, petsStream, (
      QuerySnapshot usersSnapshot,
      QuerySnapshot petsSnapshot,
    ) {
      final petsDocs = petsSnapshot.docs;

      return usersSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String ownerId = data['ownerId'] ?? 'OWN-N/A';

        // Kunin ang lahat ng pets na may matching ownerId
        final userPets = petsDocs
            .where((petDoc) {
              final petData = petDoc.data() as Map<String, dynamic>;
              return petData['ownerId'] == ownerId;
            })
            .map((petDoc) => petDoc.data() as Map<String, dynamic>)
            .toList();

        String displayName = data['fullName'] ?? 'Unknown';
        if (data.containsKey('firstName') && data.containsKey('lastName')) {
          displayName = '${data['firstName']} ${data['lastName']}';
        }

        return {
          'docId': doc.id,
          'id': ownerId,
          'name': displayName,
          'email': data['email'] ?? 'N/A',
          'phone': data['phone'] ?? 'N/A',
          'petsCount': userPets.length,
          'petsList': userPets,
          'address': data['address'] ?? 'Unknown Location',
          'status': data['status'] == 'active'
              ? 'Active'
              : data['status'] ?? 'Active',
        };
      }).toList();
    });
  }

  // ============================================================================
  // DUPLICATE FULL NAME VERIFICATION DIALOG
  // ============================================================================
  Future<bool> _verifyDuplicateFullName(
    BuildContext context,
    String fullName,
  ) async {
    bool? proceed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFD97706),
                size: 28,
              ),
              const SizedBox(width: 12),
              const Text(
                'Duplicate Name Detected',
                style: TextStyle(
                  color: Color(0xFF0F172A),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Text(
            'The name "$fullName" already exists in the database. Are you sure you want to create a new account with the exact same name?',
            style: const TextStyle(color: Color(0xFF475569), fontSize: 14),
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false), // Cancel
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true), // Proceed
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F172A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Proceed to Save',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    return proceed ?? false;
  }

  // ============================================================================
  // ADD NEW USER DIALOG (Firebase Integrated & Real-time Validation)
  // ============================================================================
  void _showAddUserDialog(
    BuildContext context,
    List<Map<String, dynamic>> existingUsers,
  ) {
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();
    final TextEditingController contactController = TextEditingController();
    final TextEditingController addressController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    bool obscurePassword = true;
    bool isSaving = false;
    String newOwnerId = 'Generating ID...';

    String? duplicateNameWarning;
    String? duplicatePhoneWarning;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            void checkDuplicates() {
              String first = firstNameController.text.trim().toLowerCase();
              String last = lastNameController.text.trim().toLowerCase();
              String full = '$first $last'.trim();
              String phone = contactController.text.trim();

              bool hasDupName = false;
              bool hasDupPhone = false;

              if (first.isNotEmpty && last.isNotEmpty) {
                hasDupName = existingUsers.any(
                  (u) => u['name'].toString().toLowerCase() == full,
                );
              }
              if (phone.isNotEmpty) {
                hasDupPhone = existingUsers.any(
                  (u) => u['phone'].toString() == phone,
                );
              }

              setDialogState(() {
                duplicateNameWarning = hasDupName
                    ? 'A user with this exact full name already exists.'
                    : null;
                duplicatePhoneWarning = hasDupPhone
                    ? 'This contact number is already registered to another user.'
                    : null;
              });
            }

            if (newOwnerId == 'Generating ID...') {
              FirebaseFirestore.instance.collection('users').count().get().then(
                (snapshot) {
                  int count = snapshot.count ?? 0;
                  setDialogState(() {
                    newOwnerId =
                        'OWN-${(count + 1).toString().padLeft(5, '0')}';
                  });
                },
              );

              firstNameController.addListener(checkDuplicates);
              lastNameController.addListener(checkDuplicates);
              contactController.addListener(checkDuplicates);
            }

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                width: 600,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Add New Pet Owner',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Color(0xFF64748B),
                            ),
                            onPressed: () {
                              firstNameController.removeListener(
                                checkDuplicates,
                              );
                              lastNameController.removeListener(
                                checkDuplicates,
                              );
                              contactController.removeListener(checkDuplicates);
                              Navigator.pop(context);
                            },
                            splashRadius: 20,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Enter client details to create a new pet owner record.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 28),

                      TextFormField(
                        key: ValueKey(newOwnerId),
                        initialValue: newOwnerId,
                        readOnly: true,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Owner ID Number',
                          labelStyle: const TextStyle(
                            color: Color(0xFF1E293B),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          prefixIcon: const Icon(
                            Icons.badge_outlined,
                            color: Color(0xFF64748B),
                            size: 20,
                          ),
                          suffixIcon: const Icon(
                            Icons.lock_outline_rounded,
                            color: Color(0xFF64748B),
                            size: 20,
                          ),
                          filled: true,
                          fillColor: const Color(
                            0xFFE2E8F0,
                          ).withValues(alpha: 0.6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: _buildFloatingTextField(
                              controller: firstNameController,
                              label: 'First Name*',
                              hint: 'e.g., Juan',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildFloatingTextField(
                              controller: lastNameController,
                              label: 'Last Name*',
                              hint: 'e.g., Dela Cruz',
                            ),
                          ),
                        ],
                      ),
                      if (duplicateNameWarning != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.warning_amber_rounded,
                                size: 16,
                                color: Color(0xFFD97706),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                duplicateNameWarning!,
                                style: const TextStyle(
                                  color: Color(0xFFD97706),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 20),

                      _buildFloatingTextField(
                        controller: contactController,
                        label: 'Contact Number*',
                        hint: 'e.g., 09171234567',
                      ),
                      if (duplicatePhoneWarning != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline_rounded,
                                size: 16,
                                color: Color(0xFFEF4444),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                duplicatePhoneWarning!,
                                style: const TextStyle(
                                  color: Color(0xFFEF4444),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 20),

                      _buildFloatingTextField(
                        controller: addressController,
                        label: 'Complete Address*',
                        hint: 'House No., Street, City, Province',
                      ),
                      const SizedBox(height: 20),

                      TextFormField(
                        controller: passwordController,
                        obscureText: obscurePassword,
                        style: const TextStyle(
                          color: Color(0xFF0F172A),
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Account Password*',
                          labelStyle: const TextStyle(
                            color: Color(0xFF0F172A),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: '••••••••',
                          hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: const Color(0xFF94A3B8),
                              size: 20,
                            ),
                            onPressed: () => setDialogState(
                              () => obscurePassword = !obscurePassword,
                            ),
                            splashRadius: 20,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 18,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFCBD5E1),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFCBD5E1),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF183F82),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: isSaving
                                ? null
                                : () {
                                    firstNameController.removeListener(
                                      checkDuplicates,
                                    );
                                    lastNameController.removeListener(
                                      checkDuplicates,
                                    );
                                    contactController.removeListener(
                                      checkDuplicates,
                                    );
                                    Navigator.pop(context);
                                  },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed:
                                (isSaving || duplicatePhoneWarning != null)
                                ? null
                                : () async {
                                    if (firstNameController.text.isNotEmpty &&
                                        lastNameController.text.isNotEmpty &&
                                        passwordController.text.isNotEmpty) {
                                      String firstName = firstNameController
                                          .text
                                          .trim();
                                      String lastName = lastNameController.text
                                          .trim();
                                      String generatedFullName =
                                          '$firstName $lastName';

                                      bool shouldProceed = true;

                                      if (duplicateNameWarning != null) {
                                        if (context.mounted) {
                                          shouldProceed =
                                              await _verifyDuplicateFullName(
                                                context,
                                                generatedFullName,
                                              );
                                        } else {
                                          shouldProceed = false;
                                        }
                                      }

                                      if (shouldProceed) {
                                        setDialogState(() => isSaving = true);
                                        try {
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .add({
                                                'ownerId': newOwnerId,
                                                'firstName': firstName,
                                                'lastName': lastName,
                                                'fullName': generatedFullName,
                                                'email':
                                                    '${firstName.toLowerCase().replaceAll(' ', '.')}.${lastName.toLowerCase().replaceAll(' ', '.')}@furryfriends.com',
                                                'phone':
                                                    contactController
                                                        .text
                                                        .isNotEmpty
                                                    ? contactController.text
                                                    : 'N/A',
                                                'address':
                                                    addressController
                                                        .text
                                                        .isNotEmpty
                                                    ? addressController.text
                                                    : 'Unknown',
                                                'password':
                                                    passwordController.text,
                                                'role': 'Pet Owner',
                                                'status': 'Active',
                                                'createdAt':
                                                    FieldValue.serverTimestamp(),
                                              });

                                          firstNameController.removeListener(
                                            checkDuplicates,
                                          );
                                          lastNameController.removeListener(
                                            checkDuplicates,
                                          );
                                          contactController.removeListener(
                                            checkDuplicates,
                                          );

                                          if (context.mounted)
                                            Navigator.pop(context);
                                        } catch (e) {
                                          setDialogState(
                                            () => isSaving = false,
                                          );
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Error saving user: $e',
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      }
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0F172A),
                              disabledBackgroundColor: const Color(0xFF94A3B8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28,
                                vertical: 18,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            child: isSaving
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Save Owner Record',
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
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFloatingTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Color(0xFF0F172A), fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Color(0xFF0F172A),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
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
          borderSide: const BorderSide(color: Color(0xFF183F82), width: 2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: Row(
        children: [
          const SidebarWidget(currentRoute: '/users'),
          Expanded(
            child: Column(
              children: [
                // ==========================================
                // COMPACT TOP HEADER BAR (Updated)
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
                            DateFormat(
                              'EEEE, MMM. dd, yyyy',
                            ).format(DateTime.now()),
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
                // SCROLLABLE BODY CONTENT
                // ==========================================
                Expanded(
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: _getUsersWithPetsStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('Something went wrong loading users.'),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final List<Map<String, dynamic>> allUsers =
                          snapshot.data ?? [];

                      // Apply Client-Side Filters
                      final filteredUsers = allUsers.where((user) {
                        final matchStatus =
                            _selectedStatusFilter == 'All Status' ||
                            user['status'] == _selectedStatusFilter;
                        final matchLocation =
                            _selectedLocationFilter == 'All Locations' ||
                            user['address'].toString().contains(
                              _selectedLocationFilter,
                            );
                        final matchSearch =
                            _searchQuery.isEmpty ||
                            user['name'].toString().toLowerCase().contains(
                              _searchQuery,
                            ) ||
                            user['id'].toString().toLowerCase().contains(
                              _searchQuery,
                            ) ||
                            user['email'].toString().toLowerCase().contains(
                              _searchQuery,
                            );
                        return matchStatus && matchLocation && matchSearch;
                      }).toList();

                      int activePetsCount = filteredUsers.fold(
                        0,
                        (sum, item) => sum + (item['petsCount'] as int),
                      );

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
                                          'User Account Management',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.2,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'Manage user accounts, privileges, and pet owner records.',
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
                                      Icons.group_rounded,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Actions Row (Add Button)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () =>
                                      _showAddUserDialog(context, allUsers),
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
                                    'Add User Account',
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

                            // Enhanced Summary Cards
                            Row(
                              children: [
                                Expanded(
                                  child: _buildEnhancedStatCard(
                                    title: 'Total Users',
                                    count: allUsers.length.toString(),
                                    icon: Icons.group_rounded,
                                    iconColor: const Color(0xFF183F82),
                                    trendText: 'Live database',
                                    isPositiveTrend: true,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: _buildEnhancedStatCard(
                                    title: 'Active Pets',
                                    count: activePetsCount.toString(),
                                    icon: Icons.pets_rounded,
                                    iconColor: const Color(0xFF059669),
                                    trendText: 'Total linked pets',
                                    isPositiveTrend: true,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Premium Search and Filters Row
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
                                      controller: _searchController,
                                      style: const TextStyle(fontSize: 13),
                                      decoration: const InputDecoration(
                                        hintText:
                                            'Search by User ID, Name, Email...',
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
                                  value: _selectedStatusFilter,
                                  items: ['All Status', 'Active', 'Suspended'],
                                  onChanged: (val) => setState(
                                    () => _selectedStatusFilter = val!,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                _buildFilterDropdown(
                                  value: _selectedLocationFilter,
                                  items: [
                                    'All Locations',
                                    'Caloocan City',
                                    'Navotas City',
                                    'Malabon City',
                                    'Valenzuela City',
                                  ],
                                  onChanged: (val) => setState(
                                    () => _selectedLocationFilter = val!,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // ==========================================
                            // FIREBASE CONNECTED DIRECTORY TABLE
                            // ==========================================
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 18,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'User Directory',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF0F172A),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.download_rounded,
                                              color: Color(0xFF64748B),
                                              size: 20,
                                            ),
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            tooltip: 'Export Directory',
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                      height: 1,
                                      color: Color(0xFFF1F5F9),
                                    ),

                                    // Table Header (Removed Checkbox)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      color: const Color(0xFFF8FAFC),
                                      child: Row(
                                        children: const [
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              'OWNER DETAILS',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF64748B),
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              'ACCOUNT STATUS',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF64748B),
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              'REGISTERED PETS',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF64748B),
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              'LOCATION',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF64748B),
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 60,
                                            child: Text(
                                              'ACTIONS',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF64748B),
                                                letterSpacing: 0.5,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                      height: 1,
                                      color: Color(0xFFF1F5F9),
                                    ),

                                    // Firestore Table Rows
                                    filteredUsers.isEmpty
                                        ? const Padding(
                                            padding: EdgeInsets.all(40.0),
                                            child: Center(
                                              child: Text(
                                                'No users found in database.',
                                                style: TextStyle(
                                                  color: Color(0xFF94A3B8),
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          )
                                        : ListView.separated(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: filteredUsers.length,
                                            separatorBuilder:
                                                (context, index) =>
                                                    const Divider(
                                                      height: 1,
                                                      color: Color(0xFFF1F5F9),
                                                    ),
                                            itemBuilder: (context, index) {
                                              final user = filteredUsers[index];
                                              return _HoverableUserRow(
                                                user: user,
                                                statusBadge: _buildStatusBadge(
                                                  user['status'],
                                                ),
                                              );
                                            },
                                          ),
                                  ],
                                ),
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

  Widget _buildEnhancedStatCard({
    required String title,
    required String count,
    required IconData icon,
    required Color iconColor,
    required String trendText,
    required bool isPositiveTrend,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  count,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      isPositiveTrend
                          ? Icons.trending_up_rounded
                          : Icons.info_outline_rounded,
                      size: 12,
                      color: isPositiveTrend
                          ? const Color(0xFF059669)
                          : const Color(0xFFD97706),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      trendText,
                      style: TextStyle(
                        fontSize: 11,
                        color: isPositiveTrend
                            ? const Color(0xFF059669)
                            : const Color(0xFFD97706),
                        fontWeight: FontWeight.w600,
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
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    IconData statusIcon;

    switch (status) {
      case 'Active':
        bgColor = const Color(0xFFECFDF5);
        textColor = const Color(0xFF059669);
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'Pending':
        bgColor = const Color(0xFFFEF3C7);
        textColor = const Color(0xFFD97706);
        statusIcon = Icons.access_time_filled_rounded;
        break;
      case 'Suspended':
        bgColor = const Color(0xFFFEF2F2);
        textColor = const Color(0xFFEF4444);
        statusIcon = Icons.cancel_rounded;
        break;
      default:
        bgColor = const Color(0xFFF1F5F9);
        textColor = const Color(0xFF64748B);
        statusIcon = Icons.help_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 10, color: textColor),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: textColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ===================================================================
// HOVERABLE TABLE ROW WIDGET (Removed Checkbox)
// ===================================================================
class _HoverableUserRow extends StatefulWidget {
  final Map<String, dynamic> user;
  final Widget statusBadge;

  const _HoverableUserRow({required this.user, required this.statusBadge});

  @override
  State<_HoverableUserRow> createState() => _HoverableUserRowState();
}

class _HoverableUserRowState extends State<_HoverableUserRow> {
  bool _isHovered = false;

  void _showViewProfileDialog() {
    List<dynamic> pets = widget.user['petsList'] ?? [];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            widget.user['name'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          content: SizedBox(
            width: 400,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: Color(0xFFE2E8F0)),
                  const SizedBox(height: 8),
                  _buildProfileDetailRow(
                    Icons.badge_outlined,
                    'Owner ID',
                    widget.user['id'],
                  ),
                  _buildProfileDetailRow(
                    Icons.email_outlined,
                    'Email',
                    widget.user['email'],
                  ),
                  _buildProfileDetailRow(
                    Icons.phone_outlined,
                    'Phone',
                    widget.user['phone'],
                  ),
                  _buildProfileDetailRow(
                    Icons.location_on_outlined,
                    'Address',
                    widget.user['address'],
                  ),

                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFFE2E8F0)),
                  const SizedBox(height: 8),
                  const Text(
                    'Registered Pets:',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  pets.isEmpty
                      ? const Text(
                          'No pets linked yet.',
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 12,
                          ),
                        )
                      : Column(
                          children: pets.map((pet) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.pets_rounded,
                                    size: 16,
                                    color: Color(0xFF183F82),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      pet['name'] ??
                                          pet['petName'] ??
                                          'Unknown Pet',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Color(0xFF0F172A),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    pet['breed'] ??
                                        pet['animalType'] ??
                                        'Mixed',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),

                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        size: 18,
                        color: Color(0xFF64748B),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Account Status:',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      widget.statusBadge,
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Close',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEditDetailsDialog() {
    final TextEditingController contactController = TextEditingController(
      text: widget.user['phone'],
    );
    final TextEditingController addressController = TextEditingController(
      text: widget.user['address'],
    );
    bool isSaving = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                width: 450,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Edit User Details',
                          style: TextStyle(
                            fontSize: 20,
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
                          splashRadius: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Editing profile for ${widget.user['name']}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: contactController,
                      decoration: InputDecoration(
                        labelText: 'Contact Number',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: addressController,
                      decoration: InputDecoration(
                        labelText: 'Complete Address',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: isSaving
                              ? null
                              : () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: isSaving
                              ? null
                              : () async {
                                  setDialogState(() => isSaving = true);
                                  try {
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(widget.user['docId'])
                                        .update({
                                          'phone': contactController.text,
                                          'address': addressController.text,
                                        });
                                    if (context.mounted) Navigator.pop(context);
                                  } catch (e) {
                                    setDialogState(() => isSaving = false);
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F172A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                          ),
                          child: isSaving
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Save Changes',
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
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFEF4444),
                size: 28,
              ),
              const SizedBox(width: 12),
              const Text(
                'Delete Record',
                style: TextStyle(
                  color: Color(0xFF0F172A),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to permanently delete the record for ${widget.user['name']}? This action cannot be undone.',
            style: const TextStyle(color: Color(0xFF475569), fontSize: 14),
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context); // Close dialog first
                try {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.user['docId'])
                      .delete();
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error deleting record: $e')),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF64748B)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: _isHovered ? const Color(0xFFF8FAFC) : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF183F82,
                          ).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          widget.user['id'],
                          style: const TextStyle(
                            color: Color(0xFF183F82),
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          widget.user['email'],
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: widget.statusBadge,
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.pets_rounded,
                        size: 10,
                        color: Color(0xFF64748B),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.user['petsCount']} Pets',
                        style: const TextStyle(
                          color: Color(0xFF334155),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                widget.user['address'],
                style: const TextStyle(
                  color: Color(0xFF334155),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              width: 60,
              child: Center(
                child: PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: Color(0xFF64748B),
                    size: 20,
                  ),
                  tooltip: 'Actions',
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  offset: const Offset(0, 30),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'view',
                      child: Row(
                        children: [
                          Icon(
                            Icons.visibility_outlined,
                            size: 16,
                            color: Color(0xFF64748B),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'View Profile',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
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
                            size: 16,
                            color: Color(0xFF64748B),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Edit Details',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline_rounded,
                            size: 16,
                            color: Color(0xFFEF4444),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Delete Record',
                            style: TextStyle(
                              color: Color(0xFFEF4444),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'view') {
                      _showViewProfileDialog();
                    } else if (value == 'edit') {
                      _showEditDetailsDialog();
                    } else if (value == 'delete') {
                      _showDeleteConfirmationDialog();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
