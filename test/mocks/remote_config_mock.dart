// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// Source:
// https://github.com/firebase/flutterfire/blob/master/packages/firebase_remote_config/firebase_remote_config/test/firebase_remote_config_test.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config_platform_interface/firebase_remote_config_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

MockFirebaseRemoteConfig mockRemoteConfigPlatform = MockFirebaseRemoteConfig();

class MockFirebaseRemoteConfig extends Mock
    with
        // ignore: prefer_mixin
        MockPlatformInterfaceMixin
    implements
        TestFirebaseRemoteConfigPlatform {
  MockFirebaseRemoteConfig() {
    TestFirebaseRemoteConfigPlatform();
  }

  @override
  FirebaseRemoteConfigPlatform delegateFor({FirebaseApp? app}) {
    return super.noSuchMethod(
      Invocation.method(#delegateFor, [], {#app: app}),
      returnValue: TestFirebaseRemoteConfigPlatform(),
      returnValueForMissingStub: TestFirebaseRemoteConfigPlatform(),
    );
  }

  @override
  FirebaseRemoteConfigPlatform setInitialValues({Map? remoteConfigValues}) {
    return super.noSuchMethod(
      Invocation.method(
        #setInitialValues,
        [],
        {#remoteConfigValues: remoteConfigValues},
      ),
      returnValue: TestFirebaseRemoteConfigPlatform(),
      returnValueForMissingStub: TestFirebaseRemoteConfigPlatform(),
    );
  }

  @override
  Future<bool> activate() {
    return super.noSuchMethod(
      Invocation.method(#activate, []),
      returnValue: Future<bool>.value(true),
      returnValueForMissingStub: Future<bool>.value(true),
    );
  }

  @override
  Future<void> ensureInitialized() {
    return super.noSuchMethod(
      Invocation.method(#ensureInitialized, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value(),
    );
  }

  @override
  Future<void> fetch() {
    return super.noSuchMethod(
      Invocation.method(#fetch, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value(),
    );
  }

  @override
  Future<bool> fetchAndActivate() {
    return super.noSuchMethod(
      Invocation.method(#fetchAndActivate, []),
      returnValue: Future<bool>.value(true),
      returnValueForMissingStub: Future<bool>.value(true),
    );
  }

  @override
  Future<void> setConfigSettings(RemoteConfigSettings? remoteConfigSettings) {
    return super.noSuchMethod(
      Invocation.method(#setConfigSettings, [remoteConfigSettings]),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value(),
    );
  }

  @override
  Future<void> setDefaults(Map<String, dynamic>? defaultParameters) {
    return super.noSuchMethod(
      Invocation.method(#setDefaults, [defaultParameters]),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value(),
    );
  }

  @override
  Map<String, RemoteConfigValue> getAll() {
    return super.noSuchMethod(
      Invocation.method(#getAll, []),
      returnValue: <String, RemoteConfigValue>{},
      returnValueForMissingStub: <String, RemoteConfigValue>{},
    );
  }

  @override
  bool getBool(String key) {
    return super.noSuchMethod(
      Invocation.method(#getBool, [key]),
      returnValue: true,
      returnValueForMissingStub: true,
    );
  }

  @override
  int getInt(String key) {
    return super.noSuchMethod(
      Invocation.method(#getInt, [key]),
      returnValue: 8,
      returnValueForMissingStub: 8,
    );
  }

  @override
  String getString(String key) {
    return super.noSuchMethod(
      Invocation.method(#getString, [key]),
      returnValue: 'foo',
      returnValueForMissingStub: 'foo',
    );
  }

  @override
  double getDouble(String key) {
    return super.noSuchMethod(
      Invocation.method(#getDouble, [key]),
      returnValue: 8.8,
      returnValueForMissingStub: 8.8,
    );
  }

  @override
  RemoteConfigValue getValue(String key) {
    return super.noSuchMethod(
      Invocation.method(#getValue, [key]),
      returnValue: RemoteConfigValue(
        <int>[],
        ValueSource.valueStatic,
      ),
      returnValueForMissingStub: RemoteConfigValue(
        <int>[],
        ValueSource.valueStatic,
      ),
    );
  }

  @override
  RemoteConfigFetchStatus get lastFetchStatus {
    return super.noSuchMethod(
      Invocation.getter(#lastFetchStatus),
      returnValue: RemoteConfigFetchStatus.success,
      returnValueForMissingStub: RemoteConfigFetchStatus.success,
    );
  }

  @override
  DateTime get lastFetchTime {
    return super.noSuchMethod(
      Invocation.getter(#lastFetchTime),
      returnValue: DateTime(2020),
      returnValueForMissingStub: DateTime(2020),
    );
  }

  @override
  RemoteConfigSettings get settings {
    return super.noSuchMethod(
      Invocation.getter(#settings),
      returnValue: RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ),
      returnValueForMissingStub: RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );
  }
}

class TestFirebaseRemoteConfigPlatform extends FirebaseRemoteConfigPlatform {
  TestFirebaseRemoteConfigPlatform() : super();

  void instanceFor({
    FirebaseApp? app,
    Map<dynamic, dynamic>? pluginConstants,
    // ignore: no-empty-block
  }) {}

  @override
  FirebaseRemoteConfigPlatform delegateFor({FirebaseApp? app}) {
    return this;
  }

  @override
  FirebaseRemoteConfigPlatform setInitialValues({
    Map<dynamic, dynamic>? remoteConfigValues,
  }) {
    return this;
  }
}