import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mess_manager/core/models/mess_info.dart';
import 'package:mess_manager/core/database/isar_service.dart';

part 'info_provider.g.dart';

const _messInfoKey = 'mess_info';

@riverpod
class MessInfoNotifier extends _$MessInfoNotifier {
  @override
  MessInfo build() {
    // Load from Isar
    final savedData = IsarService.getSetting<Map<String, dynamic>>(
      _messInfoKey,
    );
    if (savedData != null) {
      try {
        return MessInfo.fromJson(savedData);
      } catch (_) {
        // Fall back to default if parsing fails
      }
    }
    return const MessInfo();
  }

  void _save() {
    IsarService.saveSetting(_messInfoKey, state.toJson());
  }

  void updateInfo(MessInfo newInfo) {
    state = newInfo;
    _save();
  }

  void updateWifi(String password) {
    state = state.copyWith(wifiPassword: password);
    _save();
  }

  void updateLandlord(String name, String phone) {
    state = state.copyWith(landlordName: name, landlordPhone: phone);
    _save();
  }
}
