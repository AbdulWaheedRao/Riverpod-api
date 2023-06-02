import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_api/albumstate.dart';
import 'package:flutter_riverpod_api/apiprovider.dart';

class AlbumStateNotifier extends StateNotifier<AlbumState> {
  AlbumStateNotifier() : super(AlbumInitialState());
  AlbumAPIProvider apiProvider = AlbumAPIProvider();
  void fetchAlbum() async {
    state = AlbumLoadingState();
    try {
      var album = await apiProvider.fetchAlbums();
      state = AlbumLoadedState(albums: album);
    } catch (e) {
      state = AlbumErrorState(errorMessage: e.toString());
    }
  }
}
