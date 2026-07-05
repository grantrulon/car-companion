import 'package:car_companion/data/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


/* 
Widget to decorate other widgets with visibility based on user-car role (Driver/Owner)
*/
class RoleWrapper extends ConsumerWidget {
  const RoleWrapper({ super.key, required this.role, required this.child });
  final Widget child;
  final String role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (role == roleOwner) {
      return child;
    } else {
      return SizedBox.shrink();
    }
  }
}
