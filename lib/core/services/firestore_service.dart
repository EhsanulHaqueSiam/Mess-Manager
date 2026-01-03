import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mess_manager/core/services/firebase_service.dart';
import 'package:mess_manager/core/services/auth_service.dart';

/// Firestore Service
/// Handles all database operations with security
class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Collection references
  static CollectionReference<Map<String, dynamic>> get _users =>
      _db.collection('users');
  static CollectionReference<Map<String, dynamic>> get _messes =>
      _db.collection('messes');

  // ==================== User Operations ====================

  /// Create or update user profile
  static Future<void> saveUser({
    required String uid,
    required String email,
    String? name,
    String? phone,
  }) async {
    try {
      await _users.doc(uid).set({
        'email': email,
        'name': name,
        'phone': phone,
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await FirebaseService.logEvent(name: 'user_profile_saved');
    } catch (e) {
      await FirebaseService.logError(
        e,
        StackTrace.current,
        reason: 'Save user failed',
      );
      rethrow;
    }
  }

  /// Get user profile
  static Future<Map<String, dynamic>?> getUser(String uid) async {
    try {
      final doc = await _users.doc(uid).get();
      return doc.data();
    } catch (e) {
      await FirebaseService.logError(
        e,
        StackTrace.current,
        reason: 'Get user failed',
      );
      return null;
    }
  }

  /// Get user profile stream
  static Stream<DocumentSnapshot<Map<String, dynamic>>> userStream(String uid) {
    return _users.doc(uid).snapshots();
  }

  // ==================== Mess Operations ====================

  /// Create a new mess
  static Future<String> createMess({
    required String name,
    String? address,
  }) async {
    try {
      final uid = AuthService.currentUser?.uid;
      if (uid == null) throw Exception('User not authenticated');

      final inviteCode = _generateInviteCode();

      final docRef = await _messes.add({
        'name': name,
        'address': address,
        'ownerId': uid,
        'inviteCode': inviteCode,
        'members': [uid],
        'createdAt': FieldValue.serverTimestamp(),
      });

      await FirebaseService.logEvent(name: 'mess_created');
      return docRef.id;
    } catch (e) {
      await FirebaseService.logError(
        e,
        StackTrace.current,
        reason: 'Create mess failed',
      );
      rethrow;
    }
  }

  /// Join mess by invite code
  static Future<String?> joinMess(String inviteCode) async {
    try {
      final uid = AuthService.currentUser?.uid;
      if (uid == null) throw Exception('User not authenticated');

      // Find mess with invite code
      final query = await _messes
          .where('inviteCode', isEqualTo: inviteCode.toUpperCase())
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        return null; // Mess not found
      }

      final messDoc = query.docs.first;

      // Add user to members
      await messDoc.reference.update({
        'members': FieldValue.arrayUnion([uid]),
      });

      await FirebaseService.logEvent(name: 'mess_joined');
      return messDoc.id;
    } catch (e) {
      await FirebaseService.logError(
        e,
        StackTrace.current,
        reason: 'Join mess failed',
      );
      return null;
    }
  }

  /// Get mess by ID
  static Future<Map<String, dynamic>?> getMess(String messId) async {
    try {
      final doc = await _messes.doc(messId).get();
      return doc.exists ? {'id': doc.id, ...doc.data()!} : null;
    } catch (e) {
      await FirebaseService.logError(
        e,
        StackTrace.current,
        reason: 'Get mess failed',
      );
      return null;
    }
  }

  /// Get user's messes
  static Stream<QuerySnapshot<Map<String, dynamic>>> userMessesStream() {
    final uid = AuthService.currentUser?.uid;
    if (uid == null) return const Stream.empty();

    return _messes.where('members', arrayContains: uid).snapshots();
  }

  /// Update mess
  static Future<void> updateMess(
    String messId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _messes.doc(messId).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      await FirebaseService.logError(
        e,
        StackTrace.current,
        reason: 'Update mess failed',
      );
      rethrow;
    }
  }

  /// Leave mess
  static Future<void> leaveMess(String messId) async {
    try {
      final uid = AuthService.currentUser?.uid;
      if (uid == null) throw Exception('User not authenticated');

      await _messes.doc(messId).update({
        'members': FieldValue.arrayRemove([uid]),
      });

      await FirebaseService.logEvent(name: 'mess_left');
    } catch (e) {
      await FirebaseService.logError(
        e,
        StackTrace.current,
        reason: 'Leave mess failed',
      );
      rethrow;
    }
  }

  // ==================== Meals Operations ====================

  static CollectionReference<Map<String, dynamic>> _mealsCollection(
    String messId,
  ) => _messes.doc(messId).collection('meals');

  /// Add meal
  static Future<String> addMeal({
    required String messId,
    required String memberId,
    required DateTime date,
    required String type, // breakfast, lunch, dinner
    int count = 1,
    int guestCount = 0,
  }) async {
    try {
      final docRef = await _mealsCollection(messId).add({
        'memberId': memberId,
        'date': Timestamp.fromDate(date),
        'type': type,
        'count': count,
        'guestCount': guestCount,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await FirebaseService.logEvent(name: 'meal_added');
      return docRef.id;
    } catch (e) {
      await FirebaseService.logError(
        e,
        StackTrace.current,
        reason: 'Add meal failed',
      );
      rethrow;
    }
  }

  /// Get meals stream for a date range
  static Stream<QuerySnapshot<Map<String, dynamic>>> mealsStream(
    String messId, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    Query<Map<String, dynamic>> query = _mealsCollection(messId);

    if (startDate != null) {
      query = query.where(
        'date',
        isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
      );
    }
    if (endDate != null) {
      query = query.where(
        'date',
        isLessThanOrEqualTo: Timestamp.fromDate(endDate),
      );
    }

    return query.orderBy('date', descending: true).snapshots();
  }

  /// Delete meal
  static Future<void> deleteMeal(String messId, String mealId) async {
    try {
      await _mealsCollection(messId).doc(mealId).delete();
      await FirebaseService.logEvent(name: 'meal_deleted');
    } catch (e) {
      await FirebaseService.logError(
        e,
        StackTrace.current,
        reason: 'Delete meal failed',
      );
      rethrow;
    }
  }

  // ==================== Bazar Operations ====================

  static CollectionReference<Map<String, dynamic>> _bazarCollection(
    String messId,
  ) => _messes.doc(messId).collection('bazar');

  /// Add bazar entry
  static Future<String> addBazar({
    required String messId,
    required String memberId,
    required DateTime date,
    required double amount,
    String? description,
    List<Map<String, dynamic>>? items,
  }) async {
    try {
      final docRef = await _bazarCollection(messId).add({
        'memberId': memberId,
        'date': Timestamp.fromDate(date),
        'amount': amount,
        'description': description,
        'items': items ?? [],
        'createdAt': FieldValue.serverTimestamp(),
      });

      await FirebaseService.logEvent(
        name: 'bazar_added',
        parameters: {'amount': amount},
      );
      return docRef.id;
    } catch (e) {
      await FirebaseService.logError(
        e,
        StackTrace.current,
        reason: 'Add bazar failed',
      );
      rethrow;
    }
  }

  /// Get bazar stream
  static Stream<QuerySnapshot<Map<String, dynamic>>> bazarStream(
    String messId, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    Query<Map<String, dynamic>> query = _bazarCollection(messId);

    if (startDate != null) {
      query = query.where(
        'date',
        isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
      );
    }
    if (endDate != null) {
      query = query.where(
        'date',
        isLessThanOrEqualTo: Timestamp.fromDate(endDate),
      );
    }

    return query.orderBy('date', descending: true).snapshots();
  }

  /// Delete bazar entry
  static Future<void> deleteBazar(String messId, String bazarId) async {
    try {
      await _bazarCollection(messId).doc(bazarId).delete();
      await FirebaseService.logEvent(name: 'bazar_deleted');
    } catch (e) {
      await FirebaseService.logError(
        e,
        StackTrace.current,
        reason: 'Delete bazar failed',
      );
      rethrow;
    }
  }

  // ==================== Batch Operations (Free Tier Optimization) ====================

  /// Batch add multiple meals
  static Future<void> batchAddMeals(
    String messId,
    List<Map<String, dynamic>> meals,
  ) async {
    try {
      final batch = _db.batch();

      for (final meal in meals) {
        final docRef = _mealsCollection(messId).doc();
        batch.set(docRef, {...meal, 'createdAt': FieldValue.serverTimestamp()});
      }

      await batch.commit();
      await FirebaseService.logEvent(
        name: 'meals_batch_added',
        parameters: {'count': meals.length},
      );
    } catch (e) {
      await FirebaseService.logError(
        e,
        StackTrace.current,
        reason: 'Batch add meals failed',
      );
      rethrow;
    }
  }

  // ==================== Helpers ====================

  /// Generate a random invite code
  static String _generateInviteCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    return List.generate(
      6,
      (index) => chars[(random + index * 7) % chars.length],
    ).join();
  }
}
