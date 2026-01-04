import 'package:isar_plus/isar_plus.dart';

part 'settings_collection.g.dart';

/// Isar collection for app settings (key-value store)
@collection
class SettingsCollection {
  late int id;

  @Index(unique: true)
  late String key;

  /// Value stored as JSON string (supports any type)
  String? valueJson;

  /// Type hint for deserialization: 'string', 'int', 'double', 'bool', 'json'
  late String valueType;
}
