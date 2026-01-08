// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MessInfoNotifier)
final messInfoProvider = MessInfoNotifierProvider._();

final class MessInfoNotifierProvider
    extends $NotifierProvider<MessInfoNotifier, MessInfo> {
  MessInfoNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'messInfoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$messInfoNotifierHash();

  @$internal
  @override
  MessInfoNotifier create() => MessInfoNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MessInfo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MessInfo>(value),
    );
  }
}

String _$messInfoNotifierHash() => r'45b6e224fe361323febc6ea5c34b094ad96f0b9b';

abstract class _$MessInfoNotifier extends $Notifier<MessInfo> {
  MessInfo build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<MessInfo, MessInfo>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MessInfo, MessInfo>,
              MessInfo,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
