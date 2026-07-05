import 'package:flutter_riverpod/flutter_riverpod.dart';
export 'providers.dart';

final screenIndexProvider = StateProvider<int>((ref) {
  return 0;
});

final loginIndexProvider = StateProvider<int>((ref) {
  return 0;
});

final moreDataPopupProvider = StateProvider((ref) {
  return "";
});