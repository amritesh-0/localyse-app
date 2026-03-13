import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppNotification {
  final String id;
  final String title;
  final String body;
  final String type;
  final bool isRead;
  final DateTime? createdAt;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    this.createdAt,
  });

  factory AppNotification.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final Map<String, dynamic> data = document.data() ?? <String, dynamic>{};
    return AppNotification(
      id: document.id,
      title: data['title']?.toString() ?? 'Notification',
      body: data['body']?.toString() ?? '',
      type: data['type']?.toString() ?? 'general',
      isRead: data['isRead'] == true,
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
    );
  }
}

class NotificationPreferences {
  final bool newCampaigns;
  final bool directMessages;
  final bool paymentAlerts;
  final bool marketing;

  const NotificationPreferences({
    required this.newCampaigns,
    required this.directMessages,
    required this.paymentAlerts,
    required this.marketing,
  });

  const NotificationPreferences.defaults()
      : newCampaigns = true,
        directMessages = true,
        paymentAlerts = true,
        marketing = false;

  factory NotificationPreferences.fromUserData(Map<String, dynamic>? userData) {
    final Map<String, dynamic> preferences =
        userData?['notificationPreferences'] is Map<String, dynamic>
            ? userData!['notificationPreferences'] as Map<String, dynamic>
            : <String, dynamic>{};
    return NotificationPreferences(
      newCampaigns: preferences['newCampaigns'] != false,
      directMessages: preferences['directMessages'] != false,
      paymentAlerts: preferences['paymentAlerts'] != false,
      marketing: preferences['marketing'] == true,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'newCampaigns': newCampaigns,
      'directMessages': directMessages,
      'paymentAlerts': paymentAlerts,
      'marketing': marketing,
    };
  }
}

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUid => _auth.currentUser?.uid;

  Stream<List<AppNotification>> notificationsStream() {
    final String? uid = currentUid;
    if (uid == null) {
      return const Stream<List<AppNotification>>.empty();
    }
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(AppNotification.fromDocument).toList());
  }

  Stream<NotificationPreferences> preferencesStream() {
    final String? uid = currentUid;
    if (uid == null) {
      return const Stream<NotificationPreferences>.empty();
    }
    return _firestore.collection('users').doc(uid).snapshots().map(
      (snapshot) => NotificationPreferences.fromUserData(snapshot.data()),
    );
  }

  Future<void> updatePreferences(NotificationPreferences preferences) async {
    final String? uid = currentUid;
    if (uid == null) {
      throw StateError('No authenticated user found.');
    }
    await _firestore.collection('users').doc(uid).set(
      <String, dynamic>{
        'notificationPreferences': preferences.toMap(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> markAllRead() async {
    final String? uid = currentUid;
    if (uid == null) {
      return;
    }
    final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .get();
    final WriteBatch batch = _firestore.batch();
    for (final QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
      batch.set(doc.reference, <String, dynamic>{'isRead': true}, SetOptions(merge: true));
    }
    await batch.commit();
  }

  Future<void> markRead(String notificationId) async {
    final String? uid = currentUid;
    if (uid == null) {
      return;
    }
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .doc(notificationId)
        .set(<String, dynamic>{'isRead': true}, SetOptions(merge: true));
  }

  Future<void> addNotification({
    required String uid,
    required String title,
    required String body,
    required String type,
  }) async {
    final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await _firestore.collection('users').doc(uid).get();
    final NotificationPreferences preferences =
        NotificationPreferences.fromUserData(userSnapshot.data());
    if (!_isEnabledForType(preferences, type)) {
      return;
    }
    await _firestore.collection('users').doc(uid).collection('notifications').add(
      <String, dynamic>{
        'title': title,
        'body': body,
        'type': type,
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      },
    );
  }

  bool _isEnabledForType(NotificationPreferences preferences, String type) {
    switch (type) {
      case 'campaign_application':
      case 'campaign_approved':
      case 'campaign_rejected':
      case 'campaign_started':
        return preferences.newCampaigns;
      case 'payment':
      case 'proof_submission':
        return preferences.paymentAlerts;
      case 'message':
        return preferences.directMessages;
      case 'marketing':
        return preferences.marketing;
      default:
        return true;
    }
  }
}
