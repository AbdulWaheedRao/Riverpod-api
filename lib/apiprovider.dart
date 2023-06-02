import 'dart:convert';

import 'package:http/http.dart';

import 'album.dart';

extension APIResponse on Response {
  bool isSuccess() => statusCode == 200;
  bool isCreated() => statusCode == 201;
}

abstract class ApiProvider {
  final baseUrl = 'https://jsonplaceholder.typicode.com';
  String get apiUrl;
  Uri getUrl({String endPoint = ''}) => Uri.parse(baseUrl + apiUrl + endPoint);

  _fetch({String endPoint = ''}) async {
    var response = await get(getUrl(endPoint: endPoint));
    if (response.isSuccess()) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  _insert(Map<String, dynamic> map) async {
    var response = await post(getUrl(), body: jsonEncode(map));
    //print('Status Code : ${response.statusCode}');
    return response.isCreated();
  }

  _update({required Map<String, dynamic> map, required String endPoint}) async {
    var response = await put(getUrl(endPoint: endPoint), body: jsonEncode(map));
    print(response.statusCode);
    return response.isSuccess();
  }

  _delete({required String endPoint}) async {
    var response = await delete(getUrl(endPoint: endPoint));
    return response.isSuccess();
  }
}

class AlbumAPIProvider extends ApiProvider {
  @override
  String get apiUrl => '/albums';

  Future<Album> fetchAlbum(String endPoint) async {
    var map = await _fetch(endPoint: endPoint);
    return Album.fromJson(map);
  }

  Future<List<Album>> fetchAlbums() async {
    var listMap = await _fetch() as List;
    return listMap.map((map) => Album.fromJson(map)).toList();
  }

  Future<bool> insertAlbum(Album album) async {
    return await _insert(album.toJson());
  }

  Future<bool> updateAlbum(Album album) async {
    return await _update(map: album.toJson(), endPoint: '/100');
  }

  Future<bool> deleteAlbum() async {
    return await _delete(endPoint: '/23');
  }
}
