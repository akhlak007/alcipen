import 'package:alcipen/models/user.dart';

class Assignment {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final User seeker;
  final User? writer;
  final AssignmentStatus status;
  final DateTime createdAt;
  final List<String>? attachments;
  final int? pages;
  final double? totalAmount;
  final Meeting? meeting;

  Assignment({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.seeker,
    this.writer,
    required this.status,
    required this.createdAt,
    this.attachments,
    this.pages,
    this.totalAmount,
    this.meeting,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      seeker: User.fromJson(json['seeker']),
      writer: json['writer'] != null ? User.fromJson(json['writer']) : null,
      status: _getStatusFromString(json['status']),
      createdAt: DateTime.parse(json['createdAt']),
      attachments: json['attachments'] != null
          ? List<String>.from(json['attachments'])
          : null,
      pages: json['pages'],
      totalAmount: json['totalAmount']?.toDouble(),
      meeting: json['meeting'] != null ? Meeting.fromJson(json['meeting']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'seeker': seeker.toJson(),
      'writer': writer?.toJson(),
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'attachments': attachments,
      'pages': pages,
      'totalAmount': totalAmount,
      'meeting': meeting?.toJson(),
    };
  }

  static AssignmentStatus _getStatusFromString(String status) {
    switch (status) {
      case 'pending':
        return AssignmentStatus.pending;
      case 'accepted':
        return AssignmentStatus.accepted;
      case 'inProgress':
        return AssignmentStatus.inProgress;
      case 'completed':
        return AssignmentStatus.completed;
      case 'cancelled':
        return AssignmentStatus.cancelled;
      default:
        return AssignmentStatus.pending;
    }
  }

  Assignment copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    User? seeker,
    User? writer,
    AssignmentStatus? status,
    DateTime? createdAt,
    List<String>? attachments,
    int? pages,
    double? totalAmount,
    Meeting? meeting,
  }) {
    return Assignment(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      seeker: seeker ?? this.seeker,
      writer: writer ?? this.writer,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      attachments: attachments ?? this.attachments,
      pages: pages ?? this.pages,
      totalAmount: totalAmount ?? this.totalAmount,
      meeting: meeting ?? this.meeting,
    );
  }
}

class Meeting {
  final DateTime dateTime;
  final String location;
  final MeetingStatus status;
  final String? notes;

  Meeting({
    required this.dateTime,
    required this.location,
    required this.status,
    this.notes,
  });

  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      dateTime: DateTime.parse(json['dateTime']),
      location: json['location'],
      status: _getStatusFromString(json['status']),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dateTime': dateTime.toIso8601String(),
      'location': location,
      'status': status.toString().split('.').last,
      'notes': notes,
    };
  }

  static MeetingStatus _getStatusFromString(String status) {
    switch (status) {
      case 'scheduled':
        return MeetingStatus.scheduled;
      case 'confirmed':
        return MeetingStatus.confirmed;
      case 'completed':
        return MeetingStatus.completed;
      case 'cancelled':
        return MeetingStatus.cancelled;
      default:
        return MeetingStatus.scheduled;
    }
  }
}

enum AssignmentStatus {
  pending,
  accepted,
  inProgress,
  completed,
  cancelled,
}

enum MeetingStatus {
  scheduled,
  confirmed,
  completed,
  cancelled,
}