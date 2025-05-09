import 'package:alcipen/models/user.dart';
import 'package:alcipen/models/assignment.dart';
import 'package:alcipen/models/message.dart';

// This service provides mock data for development purposes
class MockDataService {
  static List<User> getMockWriters() {
    return [
      User(
        id: '1',
        name: 'Aarav Sharma',
        email: 'aarav.sharma@example.com',
        photo: 'https://images.pexels.com/photos/2379005/pexels-photo-2379005.jpeg',
        bio: 'Engineering student specializing in technical writing and diagrams. I can help with your assignments quickly and effectively.',
        specialties: ['Technical Writing', 'Diagrams', 'Research'],
        role: UserRole.writer,
        rating: 4.8,
        completedProjects: 32,
        writerDetails: {
          'pageRate': 8.0,
          'isAvailable': true,
          'subjects': ['Engineering', 'Computer Science', 'Mathematics'],
          'totalEarnings': 4800,
          'sampleWork': [
            'https://example.com/sample1.pdf',
            'https://example.com/sample2.pdf',
          ],
        },
      ),
      User(
        id: '2',
        name: 'Priya Patel',
        email: 'priya.patel@example.com',
        photo: 'https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg',
        bio: 'Literature major with a passion for academic writing. I specialize in essays, literature reviews, and creative writing projects.',
        specialties: ['Essays', 'Literature Reviews', 'Creative Writing'],
        role: UserRole.writer,
        rating: 4.9,
        completedProjects: 45,
        writerDetails: {
          'pageRate': 9.0,
          'isAvailable': true,
          'subjects': ['Literature', 'History', 'Sociology'],
          'totalEarnings': 6300,
          'sampleWork': [
            'https://example.com/sample3.pdf',
            'https://example.com/sample4.pdf',
          ],
        },
      ),
      User(
        id: '3',
        name: 'Rohan Mehta',
        email: 'rohan.mehta@example.com',
        photo: 'https://images.pexels.com/photos/2128807/pexels-photo-2128807.jpeg',
        bio: 'Economics and business student offering assistance with case studies, financial reports, and business plans.',
        specialties: ['Business Plans', 'Economic Analysis', 'Case Studies'],
        role: UserRole.writer,
        rating: 4.7,
        completedProjects: 28,
        writerDetails: {
          'pageRate': 10.0,
          'isAvailable': true,
          'subjects': ['Economics', 'Business', 'Finance'],
          'totalEarnings': 5600,
          'sampleWork': [
            'https://example.com/sample5.pdf',
            'https://example.com/sample6.pdf',
          ],
        },
      ),
      User(
        id: '4',
        name: 'Ananya Singh',
        email: 'ananya.singh@example.com',
        photo: 'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg',
        bio: 'Medical student helping with biology assignments, lab reports, and health-related research papers.',
        specialties: ['Lab Reports', 'Medical Research', 'Biology'],
        role: UserRole.writer,
        rating: 4.9,
        completedProjects: 38,
        writerDetails: {
          'pageRate': 8.5,
          'isAvailable': false,
          'subjects': ['Biology', 'Medicine', 'Health Sciences'],
          'totalEarnings': 6460,
          'sampleWork': [
            'https://example.com/sample7.pdf',
            'https://example.com/sample8.pdf',
          ],
        },
      ),
    ];
  }

  static List<Assignment> getMockAssignments() {
    final writers = getMockWriters();
    final seeker = User(
      id: '5',
      name: 'Vikram Kapoor',
      email: 'vikram.kapoor@example.com',
      photo: 'https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg',
      role: UserRole.seeker,
    );

    return [
      Assignment(
        id: '1',
        title: 'Engineering Mechanics Diagrams',
        description: 'Need help creating 5 detailed force and momentum diagrams for my Engineering Mechanics assignment.',
        dueDate: DateTime.now().add(const Duration(days: 3)),
        seeker: seeker,
        writer: writers[0],
        status: AssignmentStatus.accepted,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        pages: 5,
        totalAmount: 40.0,
        meeting: Meeting(
          dateTime: DateTime.now().add(const Duration(days: 1)),
          location: 'Central Library, Study Room 3',
          status: MeetingStatus.scheduled,
        ),
      ),
      Assignment(
        id: '2',
        title: 'Literature Review on Modern Poetry',
        description: 'I need a 10-page literature review on contemporary poetry movements from 2000-2020.',
        dueDate: DateTime.now().add(const Duration(days: 5)),
        seeker: seeker,
        writer: writers[1],
        status: AssignmentStatus.inProgress,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        pages: 10,
        totalAmount: 90.0,
        meeting: Meeting(
          dateTime: DateTime.now().add(const Duration(days: 2, hours: 3)),
          location: 'Coffee House on Campus',
          status: MeetingStatus.confirmed,
        ),
      ),
      Assignment(
        id: '3',
        title: 'Business Case Study Analysis',
        description: 'Need help with analyzing a business case study for my Management class. Approximately 7 pages with graphs.',
        dueDate: DateTime.now().add(const Duration(days: 4)),
        seeker: seeker,
        status: AssignmentStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        pages: 7,
        totalAmount: 70.0,
      ),
    ];
  }

  static List<Conversation> getMockConversations() {
    final writers = getMockWriters();
    final seeker = User(
      id: '5',
      name: 'Vikram Kapoor',
      email: 'vikram.kapoor@example.com',
      photo: 'https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg',
      role: UserRole.seeker,
    );

    return [
      Conversation(
        id: '1',
        user1Id: seeker.id,
        user2Id: writers[0].id,
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
        lastMessage: Message(
          id: '10',
          senderId: writers[0].id,
          receiverId: seeker.id,
          text: 'I can definitely help with those engineering diagrams. When would you like to meet?',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          isRead: false,
        ),
        unreadCount: 1,
      ),
      Conversation(
        id: '2',
        user1Id: seeker.id,
        user2Id: writers[1].id,
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 5)),
        lastMessage: Message(
          id: '8',
          senderId: seeker.id,
          receiverId: writers[1].id,
          text: 'Thanks for the clarification on the literature review requirements!',
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          isRead: true,
        ),
        unreadCount: 0,
      ),
    ];
  }

  static List<Message> getMockMessages(String conversationId) {
    final writers = getMockWriters();
    final seeker = User(
      id: '5',
      name: 'Vikram Kapoor',
      email: 'vikram.kapoor@example.com',
      photo: 'https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg',
      role: UserRole.seeker,
    );

    if (conversationId == '1') {
      return [
        Message(
          id: '1',
          senderId: seeker.id,
          receiverId: writers[0].id,
          text: 'Hi, I need help with some engineering diagrams for my mechanics class.',
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          isRead: true,
        ),
        Message(
          id: '2',
          senderId: writers[0].id,
          receiverId: seeker.id,
          text: 'Hello! I specialize in technical diagrams. What specific type of diagrams do you need?',
          timestamp: DateTime.now().subtract(const Duration(hours: 4, minutes: 55)),
          isRead: true,
        ),
        Message(
          id: '3',
          senderId: seeker.id,
          receiverId: writers[0].id,
          text: 'I need 5 force and momentum diagrams for an Engineering Mechanics assignment.',
          timestamp: DateTime.now().subtract(const Duration(hours: 4, minutes: 50)),
          isRead: true,
        ),
        Message(
          id: '4',
          senderId: writers[0].id,
          receiverId: seeker.id,
          text: 'I can definitely help with that. What\'s your deadline?',
          timestamp: DateTime.now().subtract(const Duration(hours: 4, minutes: 45)),
          isRead: true,
        ),
        Message(
          id: '5',
          senderId: seeker.id,
          receiverId: writers[0].id,
          text: 'It\'s due in 3 days. Would that be enough time?',
          timestamp: DateTime.now().subtract(const Duration(hours: 4, minutes: 40)),
          isRead: true,
          assignmentId: '1',
        ),
        Message(
          id: '10',
          senderId: writers[0].id,
          receiverId: seeker.id,
          text: 'I can definitely help with those engineering diagrams. When would you like to meet?',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          isRead: false,
        ),
      ];
    } else if (conversationId == '2') {
      return [
        Message(
          id: '6',
          senderId: seeker.id,
          receiverId: writers[1].id,
          text: 'Hello, I need help with a literature review on modern poetry.',
          timestamp: DateTime.now().subtract(const Duration(hours: 8)),
          isRead: true,
        ),
        Message(
          id: '7',
          senderId: writers[1].id,
          receiverId: seeker.id,
          text: 'Hi there! I\'d be happy to help. Could you tell me more about the specific requirements for your literature review?',
          timestamp: DateTime.now().subtract(const Duration(hours: 7, minutes: 45)),
          isRead: true,
        ),
        Message(
          id: '8',
          senderId: seeker.id,
          receiverId: writers[1].id,
          text: 'Thanks for the clarification on the literature review requirements!',
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          isRead: true,
          assignmentId: '2',
        ),
      ];
    }

    return [];
  }
}