import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mess_manager/core/models/member.dart';
import 'package:mess_manager/core/database/isar_service.dart';

class MemberService {
  static final _firestore = FirebaseFirestore.instance;
  static const _collection = 'members';

  /// Get all members (Offline-first: Isar -> Firestore)
  static Future<List<Member>> getMembers({bool forceRefresh = false}) async {
    // 1. Try Load from Local Storage first
    if (!forceRefresh) {
      final localMembers = IsarService.getAllMembers();
      if (localMembers.isNotEmpty) {
        // Sync in background if not forced
        _fetchAndSync().ignore();
        return localMembers;
      }
    }

    // 2. Fetch from Firestore if local is empty or forced
    return await _fetchAndSync();
  }

  /// Fetch from Firestore and update Isar
  static Future<List<Member>> _fetchAndSync() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();
      final members = snapshot.docs
          .map((doc) => Member.fromJson(doc.data()))
          .toList();

      // Update Local Storage
      IsarService.saveMembers(members);

      return members;
    } catch (e) {
      // If offline/error, return specific error or empty
      // relying on local data from step 1
      rethrow;
    }
  }

  /// Add or Update a Member
  static Future<void> saveMember(Member member) async {
    // 1. Save to Firestore
    await _firestore
        .collection(_collection)
        .doc(member.id)
        .set(member.toJson());

    // 2. Update Local Storage immediately (Optimistic UI)
    IsarService.saveMember(member);
  }

  /// Mark member as inactive (soft delete)
  static Future<void> deleteMember(String memberId) async {
    await _firestore.collection(_collection).doc(memberId).update({
      'isActive': false,
    });

    // Update local cache
    final member = IsarService.getMemberById(memberId);
    if (member != null) {
      IsarService.saveMember(member.copyWith(isActive: false));
    }
  }
}

extension FutureIgnore on Future {
  void ignore() {}
}
