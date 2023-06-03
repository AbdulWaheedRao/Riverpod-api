import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'album.dart';
import 'albumstate.dart';
import 'provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Consumer(
          builder: (context, ref, child) {
            var state = ref.watch(albumStateProvider);
            if (state is AlbumInitialState) {
              return const AlbumInitialWidget();
            } else if (state is AlbumLoadingState) {
              return const AlbumLoadingWidget();
            } else if (state is AlbumLoadedState) {
              return AlbumLoadedWidget(albums: state.albums!);
            } else {
              return AlbumErrorWidget(
                errorMessage: (state as AlbumErrorState).errorMessage,
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(albumStateProvider.notifier).fetchAlbum(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AlbumInitialWidget extends StatelessWidget {
  const AlbumInitialWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Click To Load Data'),
    );
  }
}

class AlbumLoadingWidget extends StatelessWidget {
  const AlbumLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class AlbumLoadedWidget extends StatelessWidget {
  const AlbumLoadedWidget({required this.albums, super.key});
  final List<Album> albums;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        itemCount: albums.length,
        itemBuilder: (context, index) => ListTile(
          leading: CircleAvatar(
            child: Text(albums[index].id.toString()),
          ),
          title: Text(albums[index].title!),
          subtitle: Text(albums[index].userId.toString()),
        ),
      ),
    );
  }
}

class AlbumErrorWidget extends StatelessWidget {
  const AlbumErrorWidget({required this.errorMessage, super.key});
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.red,
        child: Text(errorMessage),
      ),
    );
  }
}
