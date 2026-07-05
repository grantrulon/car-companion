import 'package:car_companion/controller/cars_list_data.dart';
import 'package:car_companion/controller/current_car.dart';
import 'package:car_companion/ui/screens/car_list/widgets/car_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CarListScreen extends ConsumerWidget {
  const CarListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carData = ref.watch(asyncCarsListDataProvider);
    ref.watch(currentCarProvider);

    return switch (carData) {
      AsyncData(:final value) => RefreshIndicator(
          onRefresh: () async {
            ref.read(asyncCarsListDataProvider.notifier).fetchUserCars();
          },
          child: ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              ref
                  .read(asyncCarsListDataProvider.notifier)
                  .rearrangeItems(oldIndex, newIndex);
            },
            children: [
              for (final carData in value)
                CarListTile(carData: carData, key: Key(carData.carId))
            ],
          ),
        ),
      AsyncError(:final error) => Text('Error: $error'),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}
