import 'dart:async';
import 'dart:convert';

import 'package:flutter_peliculas_app/src/models/actores_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_peliculas_app/src/models/pelicula_model.dart';

class PeliculasProvider {
  String _apikey = 'bdd333faccd95d970a6055f2ee0a8b21';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';
  int _pages = 0;
  bool _cargando = false;

  List<Pelicula> _populares = new List();

  final _popularesStreamController =
      StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamController.stream;

  void disposeStream() {
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> _procesarResp(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apikey,
      'language': _language,
    });

    return await _procesarResp(url);
  }

  Future<List<Pelicula>> getPopular() async {
    if (_cargando) return [];
    _cargando = true;
    _pages++;
    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _pages.toString(),
    });
    final resp = await _procesarResp(url);

    _populares.addAll(resp);
    popularesSink(_populares);
    _cargando = false;
    return resp;
  }

  Future<List<Actor>> getCast(String peliId) async {
    final url = Uri.https(_url, '3/movie/$peliId/credits', {
      'api_key': _apikey,
      'language': _language,
    });

    final resp = await http.get(url);
    final decodecData = json.decode(resp.body);

    final cast = new Actores.fromJsonList(decodecData['cast']);

    return cast.actores;
  }

  Future<List<Pelicula>> buscarPelicula(String query) async {
    final url = Uri.https(_url, '3/search/movie', {
      'api_key': _apikey,
      'language': _language,
      'query': query,
    });

    return await _procesarResp(url);
  }
}
