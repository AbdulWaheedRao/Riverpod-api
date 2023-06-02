import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_api/albumstate.dart';
import 'package:flutter_riverpod_api/statenotifir.dart';

final albumStateProvider =
    StateNotifierProvider<AlbumStateNotifier, AlbumState>((ref) {
  return AlbumStateNotifier();
});
