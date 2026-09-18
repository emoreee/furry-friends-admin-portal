import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PetManagementView extends StatefulWidget {
  const PetManagementView({super.key});

  @override
  State<PetManagementView> createState() => _PetManagementViewState();
}

class _PetManagementViewState extends State<PetManagementView> {
  int _selectedIndex = 1;
  bool _isExpanded = false;
  String _selectedFilter = 'All';
  String _searchQuery = '';

  final List<Map<String, String>> _pets = [
    {
      'id': 'PET-00001',
      'name': 'Bella',
      'breed': 'Golden Retriever',
      'owner': 'Maria Santos',
      'ownerId': 'OWN-0001',
      'gender': 'Female (Spayed)',
      'age': '3 yrs 4 mos',
      'colors': 'Golden with light cream chest',
      'status': 'Active',
    },
    {
      'id': 'PET-00002',
      'name': 'Sky',
      'breed': 'Husky',
      'owner': 'Jerome Polo',
      'ownerId': 'OWN-0002',
      'gender': 'Male',
      'age': '2 yrs 1 mo',
      'colors': 'Gray and white with blue eyes',
      'status': 'Active',
    },
    {
      'id': 'PET-00003',
      'name': 'Muning',
      'breed': 'Puspin',
      'owner': 'Ana Reyes',
      'ownerId': 'OWN-0003',
      'gender': 'Female',
      'age': '4 yrs',
      'colors': 'Orange tabby with white paws',
      'status': 'Deceased',
    },
    {
      'id': 'PET-00004',
      'name': 'Max',
      'breed': 'German Shepherd',
      'owner': 'Carlos Gomez',
      'ownerId': 'OWN-0004',
      'gender': 'Male',
      'age': '5 yrs',
      'colors': 'Black and tan',
      'status': 'Active',
    },
  ];

  void _showPetProfileDialog(Map<String, String> pet) {
    bool isActive = pet['status'] == 'Active';

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            width: 820,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 35,
                  offset: const Offset(0, 15),
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.description_rounded,
                              size: 14,
                              color: Color(0xFF64748B),
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Electronic Medical Record (EMR)',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
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
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF173F81,
                              ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(
                              Icons.pets_rounded,
                              color: Color(0xFF173F81),
                              size: 32,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? const Color(0xFF059669)
                                    : const Color(0xFFEF4444),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 18),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                pet['name']!,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? const Color(0xFFECFDF5)
                                      : const Color(0xFFFEF2F2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  pet['status']!,
                                  style: TextStyle(
                                    color: isActive
                                        ? const Color(0xFF059669)
                                        : const Color(0xFFEF4444),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Text(
                                pet['id']!,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF173F81),
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                '•',
                                style: TextStyle(color: Color(0xFF94A3B8)),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Chip ID: 985141001248921',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: Color(0xFFE2E8F0), height: 1),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.info_outline_rounded,
                                  size: 16,
                                  color: Color(0xFF173F81),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'PATIENT INFORMATION',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF173F81),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  'Species: Canine',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            _buildProfileCardItem(
                              Icons.category_rounded,
                              'Breed / Species',
                              pet['breed']!,
                            ),
                            const SizedBox(height: 10),
                            _buildProfileCardItem(
                              Icons.transgender_rounded,
                              'Gender',
                              pet['gender'] ?? 'Female',
                              badge: 'Spayed',
                            ),
                            const SizedBox(height: 10),
                            _buildProfileCardItem(
                              Icons.cake_rounded,
                              'Age',
                              pet['age'] ?? '3 yrs 4 mos',
                              subtitle: 'DOB: May 12, 2023',
                            ),
                            const SizedBox(height: 10),
                            _buildProfileCardItem(
                              Icons.monitor_weight_rounded,
                              'Current Weight',
                              '18.4 kg',
                              subtitle: '(40.5 lbs)',
                            ),
                            const SizedBox(height: 10),
                            _buildProfileCardItem(
                              Icons.palette_rounded,
                              'Colors & Markings',
                              pet['colors'] ?? 'Golden with white chest',
                            ),
                            const SizedBox(height: 10),
                            _buildProfileCardItem(
                              Icons.local_offer_rounded,
                              'Rabies Tag ID',
                              'TAG-2026-8842',
                              isTag: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.person_outline_rounded,
                                  size: 16,
                                  color: Color(0xFF173F81),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'OWNER & EMERGENCY DETAILS',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF173F81),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            _buildProfileCardItem(
                              Icons.person_rounded,
                              'Owner Name',
                              pet['owner']!,
                              badge: 'Primary',
                              isPrimary: true,
                            ),
                            const SizedBox(height: 10),
                            _buildProfileCardItem(
                              Icons.badge_rounded,
                              'Owner ID',
                              pet['ownerId'] ?? 'OWN-0001',
                              isTag: true,
                            ),
                            const SizedBox(height: 10),
                            _buildProfileCardItem(
                              Icons.phone_rounded,
                              'Primary Contact',
                              '+1 (555) 234-8901',
                              actionIcon: Icons.phone_callback_rounded,
                            ),
                            const SizedBox(height: 10),
                            _buildProfileCardItem(
                              Icons.email_rounded,
                              'Email Address',
                              'maria.santos@email.com',
                              verified: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Divider(color: Color(0xFFE2E8F0), height: 1),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.medical_services_rounded,
                            size: 18,
                            color: Color(0xFF173F81),
                          ),
                          label: const Text(
                            'Medical History',
                            style: TextStyle(
                              color: Color(0xFF173F81),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFCBD5E1)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF173F81),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Close Profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
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
  }

  Widget _buildProfileCardItem(
    IconData icon,
    String label,
    String value, {
    String? subtitle,
    String? badge,
    bool isPrimary = false,
    bool isTag = false,
    bool verified = false,
    IconData? actionIcon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF173F81).withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF173F81)),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF1E293B),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(width: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ],
              ),
              if (verified) ...[
                const SizedBox(height: 2),
                const Row(
                  children: [
                    Icon(Icons.check, size: 12, color: Color(0xFF059669)),
                    SizedBox(width: 4),
                    Text(
                      'Emergency Contact Verified',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF059669),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          const Spacer(),
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isPrimary
                    ? const Color(0xFFEFF6FF)
                    : const Color(0xFFF3E8FF),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  color: isPrimary
                      ? const Color(0xFF2563EB)
                      : const Color(0xFF9333EA),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (isTag)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF059669),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (actionIcon != null)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFFECFDF5),
                shape: BoxShape.circle,
              ),
              child: Icon(actionIcon, size: 16, color: const Color(0xFF059669)),
            ),
        ],
      ),
    );
  }

  void _showPetSuccessAnimationDialog(String petName, String petId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Future.delayed(const Duration(seconds: 2), () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        });

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 400),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 40,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF173F81,
                            ).withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const Icon(
                          Icons.pets_rounded,
                          color: Color(0xFF173F81),
                          size: 45,
                        ),
                        Positioned(
                          top: 0,
                          right: 10,
                          child: Icon(
                            Icons.star_rounded,
                            color: Colors.blue.shade400,
                            size: 22,
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          left: 5,
                          child: Icon(
                            Icons.favorite_rounded,
                            color: Colors.indigo.shade300,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Paw-fectly Saved! 🐾',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Successfully registered $petName with ID $petId into the clinic system.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF173F81),
                        ),
                      ),
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

  void _showAddPetDialog() {
    final TextEditingController ownerController = TextEditingController();
    final TextEditingController petNameController = TextEditingController();
    final TextEditingController breedController = TextEditingController();
    final TextEditingController colorController = TextEditingController();

    String autoPetId = 'PET-0000${_pets.length + 1}';
    String autoOwnerId = 'OWN-000${_pets.length + 1}';
    String selectedGender = 'Male';

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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF173F81,
                                  ).withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.pets_rounded,
                                  color: Color(0xFF173F81),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Add New Patient (Pet)',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Fill in the complete patient and owner information below.',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
                      const SizedBox(height: 24),
                      const Divider(color: Color(0xFFE2E8F0), height: 1),
                      const SizedBox(height: 24),
                      const Text(
                        'OWNER DETAILS',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF173F81),
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: ownerController,
                              style: const TextStyle(
                                color: Color(0xFF1E293B),
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Owner Name',
                                hintText: 'Enter full name',
                                hintStyle: const TextStyle(
                                  color: Color(0xFF94A3B8),
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFCBD5E1),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFCBD5E1),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF173F81),
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 1,
                            child: TextField(
                              readOnly: true,
                              controller: TextEditingController(
                                text: autoOwnerId,
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF64748B),
                              ),
                              decoration: InputDecoration(
                                labelText: 'Owner ID',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                filled: true,
                                fillColor: const Color(0xFFF1F5F9),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFCBD5E1),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFCBD5E1),
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'PET PATIENT DETAILS',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF173F81),
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: TextField(
                              readOnly: true,
                              controller: TextEditingController(
                                text: autoPetId,
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF64748B),
                              ),
                              decoration: InputDecoration(
                                labelText: 'Pet ID',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                filled: true,
                                fillColor: const Color(0xFFF1F5F9),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFCBD5E1),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFCBD5E1),
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: petNameController,
                              style: const TextStyle(
                                color: Color(0xFF1E293B),
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Pet Name',
                                hintText: 'Enter pet name',
                                hintStyle: const TextStyle(
                                  color: Color(0xFF94A3B8),
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFCBD5E1),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFCBD5E1),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF173F81),
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: breedController,
                              style: const TextStyle(
                                color: Color(0xFF1E293B),
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Breed / Species',
                                hintText: 'e.g. Golden Retriever, Puspin',
                                hintStyle: const TextStyle(
                                  color: Color(0xFF94A3B8),
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFCBD5E1),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFCBD5E1),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF173F81),
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 1,
                            child: DropdownButtonFormField<String>(
                              initialValue: selectedGender,
                              style: const TextStyle(
                                color: Color(0xFF1E293B),
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Gender',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFCBD5E1),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFCBD5E1),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF173F81),
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 18,
                                ),
                              ),
                              items: ['Male', 'Female'].map((String gender) {
                                return DropdownMenuItem(
                                  value: gender,
                                  child: Text(gender),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setDialogState(() => selectedGender = val!);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: colorController,
                        style: const TextStyle(
                          color: Color(0xFF1E293B),
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Pet Colors & Markings',
                          hintText: 'e.g. Brown with white chest spot',
                          hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xFFCBD5E1),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xFFCBD5E1),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xFF173F81),
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
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
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28,
                                vertical: 16,
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              if (ownerController.text.isNotEmpty &&
                                  petNameController.text.isNotEmpty) {
                                setState(() {
                                  _pets.add({
                                    'id': autoPetId,
                                    'name': petNameController.text,
                                    'breed': breedController.text.isNotEmpty
                                        ? breedController.text
                                        : 'Unknown',
                                    'owner': ownerController.text,
                                    'ownerId': autoOwnerId,
                                    'gender': selectedGender,
                                    'age': '1 yr',
                                    'colors': colorController.text.isNotEmpty
                                        ? colorController.text
                                        : 'None recorded',
                                    'status': 'Active',
                                  });
                                });
                                Navigator.pop(context);
                                _showPetSuccessAnimationDialog(
                                  petNameController.text,
                                  autoPetId,
                                );
                              }
                            },
                            child: const Text(
                              'Save Pet',
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

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat(
      'EEEE, MMM. dd, yyyy',
    ).format(DateTime.now());

    final filteredPets = _pets.where((pet) {
      final matchesFilter =
          _selectedFilter == 'All' || pet['status'] == _selectedFilter;
      final matchesSearch =
          pet['name']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          pet['id']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          pet['owner']!.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();

    int totalPets = _pets.length;
    int activePets = _pets.where((p) => p['status'] == 'Active').length;
    int deceasedPets = _pets.where((p) => p['status'] == 'Deceased').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Row(
        children: [
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
          Expanded(
            child: Column(
              children: [
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
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
                                'Clinic Staff',
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
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(28.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF173F81),
                                Color(0xFF2563EB),
                                Color(0xFF38BDF8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF173F81,
                                ).withValues(alpha: 0.2),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Pet Management',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Manage registered clinic patients, monitor health records, and update patient statuses seamlessly in one unified platform.',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                        height: 1.4,
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
                                  Icons.pets_rounded,
                                  color: Colors.white,
                                  size: 36,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'Total Patients',
                                totalPets.toString(),
                                Icons.pets_rounded,
                                const Color(0xFF173F81),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                'Active Patients',
                                activePets.toString(),
                                Icons.check_circle_rounded,
                                const Color(0xFF059669),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                'Deceased Cases',
                                deceasedPets.toString(),
                                Icons.warning_rounded,
                                const Color(0xFFEF4444),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
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
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF8FAFC),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: const Color(0xFFE2E8F0),
                                        ),
                                      ),
                                      child: TextField(
                                        onChanged: (value) => setState(
                                          () => _searchQuery = value,
                                        ),
                                        decoration: const InputDecoration(
                                          icon: Icon(
                                            Icons.search,
                                            color: Color(0xFF94A3B8),
                                            size: 18,
                                          ),
                                          hintText:
                                              'Search Pet ID, Pet Name, or Owner...',
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
                                  _buildFilterButton('All'),
                                  const SizedBox(width: 8),
                                  _buildFilterButton('Active'),
                                  const SizedBox(width: 8),
                                  _buildFilterButton('Deceased'),
                                  const SizedBox(width: 16),
                                  ElevatedButton.icon(
                                    onPressed: _showAddPetDialog,
                                    icon: const Icon(
                                      Icons.add_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    label: const Text(
                                      'Add Pet',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF173F81),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
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
                                      flex: 2,
                                      child: Text(
                                        'PET NAME',
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
                                        'BREED',
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
                                        'OWNER\'S NAME',
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
                                        'STATUS',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        'ACTIONS',
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
                              filteredPets.isEmpty
                                  ? const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 40,
                                      ),
                                      child: Center(
                                        child: Text(
                                          'No pets found matching your search.',
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
                                      itemCount: filteredPets.length,
                                      itemBuilder: (context, index) {
                                        final pet = filteredPets[index];
                                        bool isActive =
                                            pet['status'] == 'Active';
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
                                                  pet['id']!,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13,
                                                    color: Color(0xFF173F81),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  pet['name']!,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    color: Color(0xFF1E293B),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  pet['breed']!,
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Color(0xFF64748B),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  pet['owner']!,
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Color(0xFF1E293B),
                                                  ),
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
                                                      color: isActive
                                                          ? const Color(
                                                              0xFFECFDF5,
                                                            )
                                                          : const Color(
                                                              0xFFFEF2F2,
                                                            ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      pet['status']!,
                                                      style: TextStyle(
                                                        color: isActive
                                                            ? const Color(
                                                                0xFF059669,
                                                              )
                                                            : const Color(
                                                                0xFFEF4444,
                                                              ),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 80,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    PopupMenuButton<String>(
                                                      icon: const Icon(
                                                        Icons
                                                            .more_horiz_rounded,
                                                        color: Color(
                                                          0xFF64748B,
                                                        ),
                                                        size: 20,
                                                      ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                      onSelected: (value) {
                                                        if (value ==
                                                            'profile') {
                                                          _showPetProfileDialog(
                                                            pet,
                                                          );
                                                        }
                                                      },
                                                      itemBuilder:
                                                          (
                                                            BuildContext
                                                            context,
                                                          ) => <PopupMenuEntry<String>>[
                                                            const PopupMenuItem<
                                                              String
                                                            >(
                                                              value: 'profile',
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .visibility_rounded,
                                                                    size: 18,
                                                                    color: Color(
                                                                      0xFF173F81,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Text(
                                                                    'Pet Profile',
                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Color(
                                                                        0xFF1E293B,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
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

  Widget _buildStatCard(
    String title,
    String count,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
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
    );
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

  Widget _buildFilterButton(String label) {
    bool isSelected = _selectedFilter == label;
    return OutlinedButton(
      onPressed: () => setState(() => _selectedFilter = label),
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? const Color(0xFF173F81) : Colors.white,
        side: BorderSide(
          color: isSelected ? const Color(0xFF173F81) : const Color(0xFFE2E8F0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF64748B),
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}
