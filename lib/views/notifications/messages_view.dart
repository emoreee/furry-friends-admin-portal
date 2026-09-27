import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:furry_friends_admin/widgets/sidebar_widget.dart';

class MessagesView extends StatefulWidget {
  const MessagesView({super.key});

  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  String _activeTab = 'All Chats';
  String _searchQuery = '';
  String? _selectedChatId;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // ==========================================
  // MOCK CHAT DATA (Ready for Firestore)
  // ==========================================
  final List<Map<String, dynamic>> _chats = [
    {
      'id': 'chat_1',
      'owner': 'Jerome Polo',
      'pet': 'Luna (Persian Cat)',
      'initials': 'JP',
      'phone': '09201234567',
      'lastMessage': 'Doc, may red spots po sa tiyan ni Luna. Ano po dapat ipahid?',
      'time': '10:30 AM',
      'unread': 2,
      'type': 'Inquiries',
      'status': 'Active',
      'color': const Color(0xFF183F82),
    },
    {
      'id': 'chat_2',
      'owner': 'Janelle Sombillo',
      'pet': 'Bella (Golden Retriever)',
      'initials': 'JS',
      'phone': '09175550192',
      'lastMessage': 'Sige po doc, we will be there by 9 AM for the vaccination.',
      'time': 'Yesterday',
      'unread': 0,
      'type': 'All Chats',
      'status': 'Active',
      'color': const Color(0xFF059669),
    },
    {
      'id': 'chat_3',
      'owner': 'Walk-in Client',
      'pet': 'Simba (Maine Coon)',
      'initials': 'WC',
      'phone': 'N/A',
      'lastMessage': 'Thank you so much for saving Simba!',
      'time': 'Monday',
      'unread': 0,
      'type': 'Archived',
      'status': 'Resolved',
      'color': const Color(0xFFD97706),
    },
  ];

  // ==========================================
  // MOCK MESSAGES HISTORY
  // ==========================================
  final Map<String, List<Map<String, dynamic>>> _messagesData = {
    'chat_1': [
      {'sender': 'client', 'text': 'Hello po, good morning.', 'time': '10:25 AM'},
      {'sender': 'clinic', 'text': 'Good morning, Jerome! Paano po namin matutulungan si Luna ngayon?', 'time': '10:28 AM'},
      {'sender': 'client', 'text': 'Doc, may red spots po sa tiyan ni Luna. Ano po dapat ipahid?', 'time': '10:30 AM'},
    ],
    'chat_2': [
      {'sender': 'clinic', 'text': 'Hi Janelle, this is a reminder for Bella\'s annual vaccination tomorrow at 9:00 AM.', 'time': 'Yesterday, 4:00 PM'},
      {'sender': 'client', 'text': 'Sige po doc, we will be there by 9 AM for the vaccination.', 'time': 'Yesterday, 4:30 PM'},
    ],
    'chat_3': [
      {'sender': 'clinic', 'text': 'Simba is stable now and ready for discharge.', 'time': 'Monday, 11:00 AM'},
      {'sender': 'client', 'text': 'Thank you so much for saving Simba!', 'time': 'Monday, 11:15 AM'},
    ],
  };

  @override
  void initState() {
    super.initState();
    // Default select first chat
    if (_chats.isNotEmpty) {
      _selectedChatId = _chats.first['id'];
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty || _selectedChatId == null) return;
    
    setState(() {
      _messagesData[_selectedChatId]!.add({
        'sender': 'clinic',
        'text': _messageController.text.trim(),
        'time': DateFormat('hh:mm a').format(DateTime.now()),
      });
      _messageController.clear();
      
      // Update last message in chat list
      final chatIndex = _chats.indexWhere((c) => c['id'] == _selectedChatId);
      if (chatIndex != -1) {
        _chats[chatIndex]['lastMessage'] = _messagesData[_selectedChatId]!.last['text'];
        _chats[chatIndex]['time'] = 'Just now';
      }
    });

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('EEEE, MMM. dd, yyyy').format(DateTime.now());

    // Filter Logic
    final filteredChats = _chats.where((chat) {
      bool matchesTab = true;
      if (_activeTab == 'Unread') matchesTab = chat['unread'] > 0;
      else if (_activeTab == 'Client Inquiries') matchesTab = chat['type'] == 'Inquiries';
      else if (_activeTab == 'Archived') matchesTab = chat['status'] == 'Resolved';
      else if (_activeTab == 'All Chats') matchesTab = chat['status'] != 'Resolved';

      bool matchesSearch = chat['owner'].toLowerCase().contains(_searchQuery) ||
                           chat['pet'].toLowerCase().contains(_searchQuery) ||
                           chat['phone'].contains(_searchQuery);
                           
      return matchesTab && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: Row(
        children: [
          const SidebarWidget(currentRoute: '/messages'),
          Expanded(
            child: Column(
              children: [
                // ==========================================
                // TOP HEADER BAR
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
                            style: const TextStyle(color: Color(0xFF334155), fontSize: 12, fontWeight: FontWeight.w600),
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
                              Text('Junexenne Agravante', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1E293B))),
                              Text('Clinic Administrator', style: TextStyle(color: Color(0xFF059669), fontSize: 10, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ==========================================
                // SPLIT-PANE LAYOUT
                // ==========================================
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 20,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // ------------------------------------------
                        // LEFT PANE: CONVERSATION LIST
                        // ------------------------------------------
                        Container(
                          width: 380,
                          decoration: const BoxDecoration(
                            border: Border(right: BorderSide(color: Color(0xFFE2E8F0))),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header & Search
                              Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Messages', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                                    const SizedBox(height: 16),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF8FAFC),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: const Color(0xFFE2E8F0)),
                                      ),
                                      child: TextField(
                                        controller: _searchController,
                                        onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
                                        decoration: const InputDecoration(
                                          hintText: 'Search owner, pet, or phone...',
                                          hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                                          prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF94A3B8), size: 20),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Filter Tabs
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    _buildFilterTab('All Chats'),
                                    _buildFilterTab('Unread'),
                                    _buildFilterTab('Client Inquiries'),
                                    _buildFilterTab('Archived'),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Divider(height: 1, color: Color(0xFFE2E8F0)),

                              // Chat List
                              Expanded(
                                child: filteredChats.isEmpty
                                  ? const Center(child: Text('No conversations found.', style: TextStyle(color: Color(0xFF94A3B8))))
                                  : ListView.separated(
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: filteredChats.length,
                                      separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                                      itemBuilder: (context, index) {
                                        final chat = filteredChats[index];
                                        bool isSelected = _selectedChatId == chat['id'];
                                        
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              _selectedChatId = chat['id'];
                                              chat['unread'] = 0; // Mark as read
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                            decoration: BoxDecoration(
                                              color: isSelected ? const Color(0xFFEFF6FF) : Colors.transparent,
                                              border: Border(left: BorderSide(color: isSelected ? const Color(0xFF2563EB) : Colors.transparent, width: 3)),
                                            ),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                CircleAvatar(
                                                  radius: 24,
                                                  backgroundColor: chat['color'].withValues(alpha: 0.1),
                                                  child: Text(chat['initials'], style: TextStyle(color: chat['color'], fontWeight: FontWeight.bold)),
                                                ),
                                                const SizedBox(width: 14),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              chat['owner'],
                                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                                                              maxLines: 1, overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ),
                                                          Text(chat['time'], style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        chat['pet'],
                                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF183F82)),
                                                        maxLines: 1, overflow: TextOverflow.ellipsis,
                                                      ),
                                                      const SizedBox(height: 6),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              chat['lastMessage'],
                                                              style: TextStyle(fontSize: 13, color: chat['unread'] > 0 ? const Color(0xFF1E293B) : const Color(0xFF64748B), fontWeight: chat['unread'] > 0 ? FontWeight.w600 : FontWeight.normal),
                                                              maxLines: 1, overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ),
                                                          if (chat['unread'] > 0)
                                                            Container(
                                                              margin: const EdgeInsets.only(left: 8),
                                                              padding: const EdgeInsets.all(6),
                                                              decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle),
                                                              child: Text(chat['unread'].toString(), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                                            )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                              ),
                            ],
                          ),
                        ),

                        // ------------------------------------------
                        // RIGHT PANE: ACTIVE CHAT WINDOW
                        // ------------------------------------------
                        Expanded(
                          child: _selectedChatId == null
                              ? const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.forum_outlined, size: 64, color: Color(0xFFCBD5E1)),
                                      SizedBox(height: 16),
                                      Text('Select a conversation to start messaging', style: TextStyle(fontSize: 16, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                )
                              : Column(
                                  children: [
                                    // Chat Header
                                    _buildChatHeader(),
                                    const Divider(height: 1, color: Color(0xFFE2E8F0)),

                                    // Message History Stream
                                    Expanded(
                                      child: Container(
                                        color: const Color(0xFFF8FAFC).withValues(alpha: 0.5),
                                        child: ListView.builder(
                                          controller: _scrollController,
                                          padding: const EdgeInsets.all(32),
                                          itemCount: _messagesData[_selectedChatId]!.length,
                                          itemBuilder: (context, index) {
                                            final msg = _messagesData[_selectedChatId]![index];
                                            bool isMe = msg['sender'] == 'clinic';
                                            return _buildChatBubble(msg['text'], msg['time'], isMe);
                                          },
                                        ),
                                      ),
                                    ),

                                    // Interactive Attachment & Quick Actions Bar
                                    _buildChatInputArea(),
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

  // Header for Active Chat
  Widget _buildChatHeader() {
    final activeChat = _chats.firstWhere((c) => c['id'] == _selectedChatId);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: activeChat['color'].withValues(alpha: 0.1),
                child: Text(activeChat['initials'], style: TextStyle(color: activeChat['color'], fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(activeChat['owner'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.pets_rounded, size: 12, color: Color(0xFF2563EB)),
                      const SizedBox(width: 6),
                      Text(activeChat['pet'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2563EB))),
                      const SizedBox(width: 12),
                      const Icon(Icons.phone_rounded, size: 12, color: Color(0xFF64748B)),
                      const SizedBox(width: 6),
                      Text(activeChat['phone'], style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              IconButton(icon: const Icon(Icons.call_outlined, color: Color(0xFF64748B)), tooltip: 'Voice Call', onPressed: (){}),
              IconButton(icon: const Icon(Icons.videocam_outlined, color: Color(0xFF64748B)), tooltip: 'Video Consult', onPressed: (){}),
              const SizedBox(width: 12),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF64748B)),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'assign', child: Text('Assign to Doctor')),
                  const PopupMenuItem(value: 'resolve', child: Text('Mark as Resolved')),
                ],
                onSelected: (value) {},
              ),
            ],
          )
        ],
      ),
    );
  }

  // Individual Chat Bubble
  Widget _buildChatBubble(String text, String time, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFF183F82) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(4),
                  bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5, offset: const Offset(0, 2)),
                ],
                border: isMe ? null : Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Text(
                text,
                style: TextStyle(fontSize: 14, color: isMe ? Colors.white : const Color(0xFF1E293B), height: 1.4),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(time, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                if (isMe) ...[
                  const SizedBox(width: 6),
                  const Icon(Icons.done_all_rounded, size: 14, color: Color(0xFF059669)),
                ]
              ],
            )
          ],
        ),
      ),
    );
  }

  // Bottom Input Area
  Widget _buildChatInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(16)),
      ),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.attach_file_rounded, color: Color(0xFF94A3B8)), tooltip: 'Attach File', onPressed: (){}),
          IconButton(icon: const Icon(Icons.science_outlined, color: Color(0xFF059669)), tooltip: 'Attach Lab Result', onPressed: (){}),
          IconButton(icon: const Icon(Icons.calendar_month_outlined, color: Color(0xFF2563EB)), tooltip: 'Send Appointment Link', onPressed: (){}),
          IconButton(icon: const Icon(Icons.medication_outlined, color: Color(0xFFD97706)), tooltip: 'Send Prescription', onPressed: (){}),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _messageController,
              onSubmitted: (_) => _sendMessage(),
              decoration: InputDecoration(
                hintText: 'Type a message to the pet owner...',
                hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                suffixIcon: IconButton(icon: const Icon(Icons.emoji_emotions_outlined, color: Color(0xFF94A3B8)), onPressed: (){}),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF183F82),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
              onPressed: _sendMessage,
            ),
          )
        ],
      ),
    );
  }

  // Helper for filter tabs
  Widget _buildFilterTab(String label) {
    bool isSelected = _activeTab == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: InkWell(
        onTap: () => setState(() => _activeTab = label),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF183F82) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isSelected ? const Color(0xFF183F82) : const Color(0xFFE2E8F0)),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF64748B),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}