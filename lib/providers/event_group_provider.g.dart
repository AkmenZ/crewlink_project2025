// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_group_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getEventGroupByIdHash() => r'caebf1c6e8739e37d1467abd7f949df62de542a9';

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

String _$getEventGroupsForMemberHash() =>
    r'677f4194083fc1fb6a987b65adf190cd64a61274';

/// See also [getEventGroupsForMember].
@ProviderFor(getEventGroupsForMember)
const getEventGroupsForMemberProvider = GetEventGroupsForMemberFamily();

/// See also [getEventGroupsForMember].
class GetEventGroupsForMemberFamily
    extends Family<AsyncValue<List<EventGroup>>> {
  /// See also [getEventGroupsForMember].
  const GetEventGroupsForMemberFamily();

  /// See also [getEventGroupsForMember].
  GetEventGroupsForMemberProvider call(
    String userId,
  ) {
    return GetEventGroupsForMemberProvider(
      userId,
    );
  }

  @override
  GetEventGroupsForMemberProvider getProviderOverride(
    covariant GetEventGroupsForMemberProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'getEventGroupsForMemberProvider';
}

/// See also [getEventGroupsForMember].
class GetEventGroupsForMemberProvider
    extends AutoDisposeFutureProvider<List<EventGroup>> {
  /// See also [getEventGroupsForMember].
  GetEventGroupsForMemberProvider(
    String userId,
  ) : this._internal(
          (ref) => getEventGroupsForMember(
            ref as GetEventGroupsForMemberRef,
            userId,
          ),
          from: getEventGroupsForMemberProvider,
          name: r'getEventGroupsForMemberProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getEventGroupsForMemberHash,
          dependencies: GetEventGroupsForMemberFamily._dependencies,
          allTransitiveDependencies:
              GetEventGroupsForMemberFamily._allTransitiveDependencies,
          userId: userId,
        );

  GetEventGroupsForMemberProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    FutureOr<List<EventGroup>> Function(GetEventGroupsForMemberRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetEventGroupsForMemberProvider._internal(
        (ref) => create(ref as GetEventGroupsForMemberRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<EventGroup>> createElement() {
    return _GetEventGroupsForMemberProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetEventGroupsForMemberProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetEventGroupsForMemberRef
    on AutoDisposeFutureProviderRef<List<EventGroup>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _GetEventGroupsForMemberProviderElement
    extends AutoDisposeFutureProviderElement<List<EventGroup>>
    with GetEventGroupsForMemberRef {
  _GetEventGroupsForMemberProviderElement(super.provider);

  @override
  String get userId => (origin as GetEventGroupsForMemberProvider).userId;
}

String _$getEventGroupMembersHash() =>
    r'23edc1d194d7f8cd052270e83c6844370b82ccc5';

/// See also [getEventGroupMembers].
@ProviderFor(getEventGroupMembers)
const getEventGroupMembersProvider = GetEventGroupMembersFamily();

/// See also [getEventGroupMembers].
class GetEventGroupMembersFamily
    extends Family<AsyncValue<List<EventGroupMember>>> {
  /// See also [getEventGroupMembers].
  const GetEventGroupMembersFamily();

  /// See also [getEventGroupMembers].
  GetEventGroupMembersProvider call(
    String groupId,
  ) {
    return GetEventGroupMembersProvider(
      groupId,
    );
  }

  @override
  GetEventGroupMembersProvider getProviderOverride(
    covariant GetEventGroupMembersProvider provider,
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
  String? get name => r'getEventGroupMembersProvider';
}

/// See also [getEventGroupMembers].
class GetEventGroupMembersProvider
    extends AutoDisposeFutureProvider<List<EventGroupMember>> {
  /// See also [getEventGroupMembers].
  GetEventGroupMembersProvider(
    String groupId,
  ) : this._internal(
          (ref) => getEventGroupMembers(
            ref as GetEventGroupMembersRef,
            groupId,
          ),
          from: getEventGroupMembersProvider,
          name: r'getEventGroupMembersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getEventGroupMembersHash,
          dependencies: GetEventGroupMembersFamily._dependencies,
          allTransitiveDependencies:
              GetEventGroupMembersFamily._allTransitiveDependencies,
          groupId: groupId,
        );

  GetEventGroupMembersProvider._internal(
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
    FutureOr<List<EventGroupMember>> Function(GetEventGroupMembersRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetEventGroupMembersProvider._internal(
        (ref) => create(ref as GetEventGroupMembersRef),
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
  AutoDisposeFutureProviderElement<List<EventGroupMember>> createElement() {
    return _GetEventGroupMembersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetEventGroupMembersProvider && other.groupId == groupId;
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
mixin GetEventGroupMembersRef
    on AutoDisposeFutureProviderRef<List<EventGroupMember>> {
  /// The parameter `groupId` of this provider.
  String get groupId;
}

class _GetEventGroupMembersProviderElement
    extends AutoDisposeFutureProviderElement<List<EventGroupMember>>
    with GetEventGroupMembersRef {
  _GetEventGroupMembersProviderElement(super.provider);

  @override
  String get groupId => (origin as GetEventGroupMembersProvider).groupId;
}

String _$eventGroupMembersStreamHash() =>
    r'fc18c87fa1b7f7d8f1d792c6a0669cbc2ff45e60';

/// See also [eventGroupMembersStream].
@ProviderFor(eventGroupMembersStream)
const eventGroupMembersStreamProvider = EventGroupMembersStreamFamily();

/// See also [eventGroupMembersStream].
class EventGroupMembersStreamFamily
    extends Family<AsyncValue<List<EventGroupMember>>> {
  /// See also [eventGroupMembersStream].
  const EventGroupMembersStreamFamily();

  /// See also [eventGroupMembersStream].
  EventGroupMembersStreamProvider call(
    String userId,
  ) {
    return EventGroupMembersStreamProvider(
      userId,
    );
  }

  @override
  EventGroupMembersStreamProvider getProviderOverride(
    covariant EventGroupMembersStreamProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'eventGroupMembersStreamProvider';
}

/// See also [eventGroupMembersStream].
class EventGroupMembersStreamProvider
    extends AutoDisposeStreamProvider<List<EventGroupMember>> {
  /// See also [eventGroupMembersStream].
  EventGroupMembersStreamProvider(
    String userId,
  ) : this._internal(
          (ref) => eventGroupMembersStream(
            ref as EventGroupMembersStreamRef,
            userId,
          ),
          from: eventGroupMembersStreamProvider,
          name: r'eventGroupMembersStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$eventGroupMembersStreamHash,
          dependencies: EventGroupMembersStreamFamily._dependencies,
          allTransitiveDependencies:
              EventGroupMembersStreamFamily._allTransitiveDependencies,
          userId: userId,
        );

  EventGroupMembersStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    Stream<List<EventGroupMember>> Function(EventGroupMembersStreamRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EventGroupMembersStreamProvider._internal(
        (ref) => create(ref as EventGroupMembersStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<EventGroupMember>> createElement() {
    return _EventGroupMembersStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EventGroupMembersStreamProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin EventGroupMembersStreamRef
    on AutoDisposeStreamProviderRef<List<EventGroupMember>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _EventGroupMembersStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<EventGroupMember>>
    with EventGroupMembersStreamRef {
  _EventGroupMembersStreamProviderElement(super.provider);

  @override
  String get userId => (origin as EventGroupMembersStreamProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
