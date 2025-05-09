import 'package:flutter/material.dart';
import 'package:alcipen/config/theme.dart';
import 'package:alcipen/models/message.dart';
import 'package:alcipen/models/user.dart';
import 'package:alcipen/services/mock_data_service.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  
  List<Conversation> conversations = MockDataService.getMockConversations();
  List<Message> messages = [];
  String? selectedConversationId;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Mock the current user (a seeker for this example)
    currentUser = User(
      id: '5',
      name: 'Vikram Kapoor',
      email: 'vikram.kapoor@example.com',
      photo: 'https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg',
      role: UserRole.seeker,
    );
    
    // Load messages for the first conversation if available
    if (conversations.isNotEmpty) {
      selectedConversationId = conversations[0].id;
      _loadMessages(selectedConversationId!);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _loadMessages(String conversationId) {
    setState(() {
      selectedConversationId = conversationId;
      messages = MockDataService.getMockMessages(conversationId);
    });
    
    // Scroll to the bottom of the messages list
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty || selectedConversationId == null) {
      return;
    }

    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: currentUser!.id,
      receiverId: conversations
          .firstWhere((conv) => conv.id == selectedConversationId)
          .user2Id,
      text: _messageController.text.trim(),
      timestamp: DateTime.now(),
      isRead: false,
    );

    setState(() {
      messages.add(newMessage);
      _messageController.clear();
    });

    // Scroll to the bottom of the messages list
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryBlue,
          unselectedLabelColor: AppColors.grey,
          indicatorColor: AppColors.primaryBlue,
          tabs: const [
            Tab(text: 'Chats'),
            Tab(text: 'Requests'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildChatInterface(),
          _buildRequestsTab(),
        ],
      ),
    );
  }

  Widget _buildChatInterface() {
    if (conversations.isEmpty) {
      return _buildEmptyState(
        icon: Icons.chat_bubble_outline,
        title: 'No conversations yet',
        subtitle: 'Your chats with writers will appear here',
      );
    }

    return Row(
      children: [
        // Conversations list sidebar
        Container(
          width: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search conversations...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: conversations.length,
                  itemBuilder: (context, index) {
                    final conversation = conversations[index];
                    final writer = MockDataService.getMockWriters().firstWhere(
                      (writer) => writer.id == conversation.user2Id,
                    );
                    final isSelected = selectedConversationId == conversation.id;

                    return _buildConversationTile(
                      conversation: conversation,
                      user: writer,
                      isSelected: isSelected,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        
        // Chat messages area
        Expanded(
          child: selectedConversationId == null
              ? _buildNoChatSelected()
              : Column(
                  children: [
                    // Chat header
                    _buildChatHeader(),
                    
                    // Messages list
                    Expanded(
                      child: messages.isEmpty
                          ? _buildEmptyChat()
                          : ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.all(16),
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                final message = messages[index];
                                final bool isCurrentUser = message.senderId == currentUser!.id;
                                final bool showDate = index == 0 ||
                                    !_isSameDay(
                                      messages[index].timestamp,
                                      messages[index - 1].timestamp,
                                    );

                                return Column(
                                  children: [
                                    if (showDate) _buildDateSeparator(message.timestamp),
                                    _buildMessageBubble(message, isCurrentUser),
                                  ],
                                );
                              },
                            ),
                    ),
                    
                    // Message input
                    _buildMessageInput(),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildConversationTile({
    required Conversation conversation,
    required User user,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () => _loadMessages(conversation.id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: isSelected ? AppColors.primaryBlue.withOpacity(0.1) : null,
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(user.photo),
                ),
                if (conversation.unreadCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${conversation.unreadCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: TextStyle(
                      fontWeight: conversation.unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                      fontSize: 16,
                      color: isSelected ? AppColors.primaryBlue : AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    conversation.lastMessage?.text ?? '',
                    style: TextStyle(
                      color: conversation.unreadCount > 0 ? AppColors.black : AppColors.grey,
                      fontWeight: conversation.unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatMessageTime(conversation.lastMessageTime),
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                if (conversation.lastMessage?.senderId == currentUser!.id)
                  const Icon(
                    Icons.check_circle_outline,
                    size: 14,
                    color: AppColors.success,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatHeader() {
    if (selectedConversationId == null) return const SizedBox();
    
    final conversation = conversations.firstWhere(
      (conv) => conv.id == selectedConversationId,
    );
    
    final writer = MockDataService.getMockWriters().firstWhere(
      (writer) => writer.id == conversation.user2Id,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(writer.photo),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  writer.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Online',
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.phone_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.videocam_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.offWhite,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message, bool isCurrentUser) {
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.5,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isCurrentUser 
              ? AppColors.primaryBlue
              : Colors.white,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomLeft: isCurrentUser ? null : const Radius.circular(0),
            bottomRight: isCurrentUser ? const Radius.circular(0) : null,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: isCurrentUser ? Colors.white : AppColors.black,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatMessageTime(message.timestamp),
                  style: TextStyle(
                    color: isCurrentUser ? Colors.white.withOpacity(0.7) : AppColors.grey,
                    fontSize: 12,
                  ),
                ),
                if (isCurrentUser) ...[
                  const SizedBox(width: 4),
                  Icon(
                    message.isRead ? Icons.done_all : Icons.done,
                    size: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSeparator(DateTime timestamp) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          const Expanded(
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _formatMessageDate(timestamp),
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Expanded(
            child: Divider(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChat() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: AppColors.lightGrey,
          ),
          const SizedBox(height: 16),
          Text(
            'Start a conversation',
            style: TextStyle(
              color: AppColors.grey,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Send a message to start chatting',
            style: TextStyle(
              color: AppColors.grey,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNoChatSelected() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: AppColors.lightGrey,
          ),
          const SizedBox(height: 16),
          Text(
            'Select a conversation',
            style: TextStyle(
              color: AppColors.grey,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose a conversation from the sidebar to start chatting',
            style: TextStyle(
              color: AppColors.grey,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRequestsTab() {
    return _buildEmptyState(
      icon: Icons.inbox_outlined,
      title: 'No pending requests',
      subtitle: 'New assignment requests will appear here',
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: AppColors.lightGrey,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: AppColors.grey,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: AppColors.grey,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatMessageTime(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (messageDate == today) {
      return DateFormat.jm().format(timestamp); // e.g., 2:30 PM
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat.MMMd().format(timestamp); // e.g., Jan 20
    }
  }

  String _formatMessageDate(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat.yMMMd().format(timestamp); // e.g., Jan 20, 2023
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}