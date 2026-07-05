// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$registrationControllerHash() =>
    r'6b1ff5ef454ba72a26a75cb86e0a42a73c3cafb8';

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

abstract class _$RegistrationController
    extends BuildlessAutoDisposeAsyncNotifier<Registration> {
  late final String carId;

  FutureOr<Registration> build(
    String carId,
  );
}

/// See also [RegistrationController].
@ProviderFor(RegistrationController)
const registrationControllerProvider = RegistrationControllerFamily();

/// See also [RegistrationController].
class RegistrationControllerFamily extends Family<AsyncValue<Registration>> {
  /// See also [RegistrationController].
  const RegistrationControllerFamily();

  /// See also [RegistrationController].
  RegistrationControllerProvider call(
    String carId,
  ) {
    return RegistrationControllerProvider(
      carId,
    );
  }

  @override
  RegistrationControllerProvider getProviderOverride(
    covariant RegistrationControllerProvider provider,
  ) {
    return call(
      provider.carId,
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
  String? get name => r'registrationControllerProvider';
}

/// See also [RegistrationController].
class RegistrationControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<RegistrationController,
        Registration> {
  /// See also [RegistrationController].
  RegistrationControllerProvider(
    String carId,
  ) : this._internal(
          () => RegistrationController()..carId = carId,
          from: registrationControllerProvider,
          name: r'registrationControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$registrationControllerHash,
          dependencies: RegistrationControllerFamily._dependencies,
          allTransitiveDependencies:
              RegistrationControllerFamily._allTransitiveDependencies,
          carId: carId,
        );

  RegistrationControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.carId,
  }) : super.internal();

  final String carId;

  @override
  FutureOr<Registration> runNotifierBuild(
    covariant RegistrationController notifier,
  ) {
    return notifier.build(
      carId,
    );
  }

  @override
  Override overrideWith(RegistrationController Function() create) {
    return ProviderOverride(
      origin: this,
      override: RegistrationControllerProvider._internal(
        () => create()..carId = carId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        carId: carId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<RegistrationController, Registration>
      createElement() {
    return _RegistrationControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RegistrationControllerProvider && other.carId == carId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, carId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RegistrationControllerRef
    on AutoDisposeAsyncNotifierProviderRef<Registration> {
  /// The parameter `carId` of this provider.
  String get carId;
}

class _RegistrationControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<RegistrationController,
        Registration> with RegistrationControllerRef {
  _RegistrationControllerProviderElement(super.provider);

  @override
  String get carId => (origin as RegistrationControllerProvider).carId;
}

String _$mockRegistrationControllerHash() =>
    r'32c1221b0f2767e415ff878ae23bafc9409413af';

abstract class _$MockRegistrationController
    extends BuildlessAutoDisposeAsyncNotifier<Registration> {
  late final String carId;

  FutureOr<Registration> build(
    String carId,
  );
}

/// See also [MockRegistrationController].
@ProviderFor(MockRegistrationController)
const mockRegistrationControllerProvider = MockRegistrationControllerFamily();

/// See also [MockRegistrationController].
class MockRegistrationControllerFamily
    extends Family<AsyncValue<Registration>> {
  /// See also [MockRegistrationController].
  const MockRegistrationControllerFamily();

  /// See also [MockRegistrationController].
  MockRegistrationControllerProvider call(
    String carId,
  ) {
    return MockRegistrationControllerProvider(
      carId,
    );
  }

  @override
  MockRegistrationControllerProvider getProviderOverride(
    covariant MockRegistrationControllerProvider provider,
  ) {
    return call(
      provider.carId,
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
  String? get name => r'mockRegistrationControllerProvider';
}

/// See also [MockRegistrationController].
class MockRegistrationControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<MockRegistrationController,
        Registration> {
  /// See also [MockRegistrationController].
  MockRegistrationControllerProvider(
    String carId,
  ) : this._internal(
          () => MockRegistrationController()..carId = carId,
          from: mockRegistrationControllerProvider,
          name: r'mockRegistrationControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mockRegistrationControllerHash,
          dependencies: MockRegistrationControllerFamily._dependencies,
          allTransitiveDependencies:
              MockRegistrationControllerFamily._allTransitiveDependencies,
          carId: carId,
        );

  MockRegistrationControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.carId,
  }) : super.internal();

  final String carId;

  @override
  FutureOr<Registration> runNotifierBuild(
    covariant MockRegistrationController notifier,
  ) {
    return notifier.build(
      carId,
    );
  }

  @override
  Override overrideWith(MockRegistrationController Function() create) {
    return ProviderOverride(
      origin: this,
      override: MockRegistrationControllerProvider._internal(
        () => create()..carId = carId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        carId: carId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<MockRegistrationController,
      Registration> createElement() {
    return _MockRegistrationControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MockRegistrationControllerProvider && other.carId == carId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, carId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MockRegistrationControllerRef
    on AutoDisposeAsyncNotifierProviderRef<Registration> {
  /// The parameter `carId` of this provider.
  String get carId;
}

class _MockRegistrationControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<MockRegistrationController,
        Registration> with MockRegistrationControllerRef {
  _MockRegistrationControllerProviderElement(super.provider);

  @override
  String get carId => (origin as MockRegistrationControllerProvider).carId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
