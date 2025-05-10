// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_group_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getEventGroupByIdHash() => r'438160d8d4912560422f436104e79931e0ec13eb';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [getEventGroupById].
@ProviderFor(getEventGroupById)
const getEventGroupByIdProvider = GetEventGroupByIdFamily();

/// See also [getEventGroupById].
class GetEventGroupByIdFamily extends Family<AsyncValue<EventGroup?>> {
  /// See also [getEventGroupById].
  const GetEventGroupByIdFamily();

  /// See also [getEventGroupById].
  GetEventGroupByIdProvider call(
    String groupId,
  ) {
    return GetEventGroupByIdProvider(
      groupId,
    );
  }

  @override
  GetEventGroupByIdProvider getProviderOverride(
    covariant GetEventGroupByIdProvider provider,
  ) {
    return call(
      provider.groupId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getEventGroupByIdProvider';
}

/// See also [getEventGroupById].
class GetEventGroupByIdProvider extends AutoDisposeFutureProvider<EventGroup?> {
  /// See also [getEventGroupById].
  GetEventGroupByIdProvider(
    String groupId,
  ) : this._internal(
          (ref) => getEventGroupById(
            ref as GetEventGroupByIdRef,
            groupId,
          ),
          from: getEventGroupByIdProvider,
          name: r'getEventGroupByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getEventGroupByIdHash,
          dependencies: GetEventGroupByIdFamily._dependencies,
          allTransitiveDependencies:
              GetEventGroupByIdFamily._allTransitiveDependencies,
          groupId: groupId,
        );

  GetEventGroupByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.groupId,
  }) : super.internal();

  final String groupId;

  @override
  Override overrideWith(
    FutureOr<EventGroup?> Function(GetEventGroupByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetEventGroupByIdProvider._internal(
        (ref) => create(ref as GetEventGroupByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        groupId: groupId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<EventGroup?> createElement() {
    return _GetEventGroupByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetEventGroupByIdProvider && other.groupId == groupId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, groupId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetEventGroupByIdRef on AutoDisposeFutureProviderRef<EventGroup?> {
  /// The parameter `groupId` of this provider.
  String get groupId;
}

class _GetEventGroupByIdProviderElement
    extends AutoDisposeFutureProviderElement<EventGroup?>
    with GetEventGroupByIdRef {
  _GetEventGroupByIdProviderElement(super.provider);

  @override
  String get groupId => (origin as GetEventGroupByIdProvider).groupId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
