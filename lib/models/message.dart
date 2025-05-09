class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime timestamp;
  final bool isRead;
  final List<String>? attachments;
  final String? assignmentId;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
    required this.isRead,
    this.attachments,
    this.assignmentId,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      text: json['text'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'],
      attachments: json['attachments'] != null
          ? List<String>.from(json['attachments'])
          : null,
      assignmentId: json['assignmentId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'attachments': attachments,
      'assignmentId': assignmentId,
    };
  }

  Message copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? text,
    DateTime? timestamp,
    bool? isRead,
    List<String>? attachments,
    String? assignmentId,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      attachments: attachments ?? this.attachments,
      assignmentId: assignmentId ?? this.assignmentId,
    );
  }
}

class Conversation {
  final String id;
  final String user1Id;
  final String user2Id;
  final DateTime lastMessageTime;
  final Message? lastMessage;
  final int unreadCount;

  Conversation({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.lastMessageTime,
    this.lastMessage,
    required this.unreadCount,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      user1Id: json['user1Id'],
      user2Id: json['user2Id'],
      lastMessageTime: DateTime.parse(json['lastMessageTime']),
      lastMessage: json['lastMessage'] != null
          ? Message.fromJson(json['lastMessage'])
          : null,
      unreadCount: json['unreadCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user1Id': user1Id,
      'user2Id': user2Id,
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'lastMessage': lastMessage?.toJson(),
      'unreadCount': unreadCount,
    };
  }
}