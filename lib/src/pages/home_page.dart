import 'package:flutter/material.dart';
import 'package:flutter_peliculas_app/src/models/pelicula_model.dart';
import 'package:flutter_peliculas_app/src/providers/peliculas_provider.dart';
import 'package:flutter_peliculas_app/src/widgets/card_swiper_widget.dart';
import 'package:flutter_peliculas_app/src/widgets/move_horizontarl.dart';
import 'package:flutter_peliculas_app/src/search/search_delegate.dart';

import 'package:flutter_swiper/flutter_swiper.dart';

class HomePage extends StatelessWidget {
  final peliculasProvider = new PeliculasProvider();
  @override
  Widget build(BuildContext context) {
    peliculasProvider.getPopular();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Peliculas App '),
          backgroundColor: Colors.redAccent,
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              },
            )
          ],
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _swiperTarjet(context),
              _footer(context),
            ],
          ),
        ));
  }

  Widget _swiperTarjet(context) {
    return FutureBuilder(
      future: peliculasProvider.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(peliculas: snapshot.data);
        } else {
          return Container(
            height: 400,
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Widget _footer(context) {
    return Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                'Populares',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            SizedBox(height: 10),
            StreamBuilder(
              stream: peliculasProvider.popularesStream,
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                if (snapshot.hasData) {
                  return MovieHorizontal(
                      peliculas: snapshot.data,
                      peliculasSiguientes: peliculasProvider.getPopular);
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ));
  }
}
