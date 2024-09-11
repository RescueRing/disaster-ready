// import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:riverpod/riverpod.dart'; // Add this import statement

// void addToSelectedHS(BuildContext context, String item, WidgetRef ref) {
//    List<String> selectedHS = ref.watch(selectedHSProvider);
//    selectedHS.add(item);
//   // if (!selectedHS.contains(item)) {
//   //   ref.read(selectedHSProvider).state = [...selectedHS, item];
//   // final selectedHS = context.read(selectedHSProvider).state;
//   // if (!selectedHS.contains(item)) {
//   //   context.read(selectedHSProvider).state = [...selectedHS, item];
//   // }
// }

// void removeFromSelectedHS(BuildContext context, String item, WidgetRef ref) {
//  List<String> selectedHS = ref.watch(selectedHSProvider);
//   selectedHS.remove(item);
// }

// final selectedHSProvider = StateProvider<List<String>>((ref) => []);

class MarkedLocationProvider extends StateNotifier<List<Marker>> {
  MarkedLocationProvider()
      : super([const Marker(markerId: MarkerId('1'), position: LatLng(0, 0))]);

  void addMarker(Marker mark) {
    state = [...state, mark];
  }

  void removeMarker(Marker mark) {
    state = state.where((element) => element != mark).toList();
  }
}

final markedLocationProvider =
    StateNotifierProvider<MarkedLocationProvider, List<Marker>>(
        (ref) => MarkedLocationProvider());
