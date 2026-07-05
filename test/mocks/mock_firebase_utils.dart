// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found here:
// https://github.com/firebase/flutterfire/blob/master/packages/firebase_auth/firebase_auth/LICENSE

// ignore: depend_on_referenced_packages
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_accelerator/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// import 'mocks.dart';
import 'remote_config_mock.dart';

typedef Callback = void Function(MethodCall call);

void setupFirebaseMocks([Callback? customHandlers]) {
  TestWidgetsFlutterBinding.ensureInitialized();

  setupFirebaseCoreMocks();
}

void setUpRemoteConfigMocks() {
  when(
    mockRemoteConfigPlatform.delegateFor(
      app: anyNamed('app'),
    ),
  ).thenAnswer((_) => mockRemoteConfigPlatform);
  when(
    mockRemoteConfigPlatform.setInitialValues(
      remoteConfigValues: anyNamed('remoteConfigValues'),
    ),
  ).thenAnswer((_) => mockRemoteConfigPlatform);

  // TODO: Define here the remote config values you want to return
  when(mockRemoteConfigPlatform.getBool(RemoteConfigKeys.showTestButton)).thenReturn(true);
  when(mockRemoteConfigPlatform.getString(RemoteConfigKeys.testButtonDetails))
      .thenReturn("{\"text\":\"text\", \"snackbar\":\"snackbar\"}");
}

class RemoteConfigKeys {
  static const showTestButton = 'showTestButton';
  static const testButtonDetails = 'testButtonDetails';
  static const testButtonDetailsText = 'text';
  static const testButtonDetailsSnackbar = 'snackbar';
}