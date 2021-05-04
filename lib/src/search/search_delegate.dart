import 'package:flutter/material.dart';

import '../models/pelicula_model.dart';
import '../providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {
  String seleccion = '';
  final peliculasProvider = new PeliculasProvider();

  final peliculas = [
    'Batman',
    'HarryPotter',
    'Robi',
    'Acuaman',
  ];

  final peliculasRecientes = [
    'Batman',
    'Robi',
    'Acuaman',
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones del appbar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //Imagen o Icono a la izquierda del appbar
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //Crea los resultados que vamos a mostrar
    return Container();
  }

  // @override
  // Widget buildSuggestions(BuildContext context) {
  //   //Crea las sugerencias que aparecen cuando se escribe

  //   final listaSugeridos = (query.isEmpty)
  //       ? peliculasRecientes
  //       : peliculas
  //           .where((element) =>
  //               element.toLowerCase().startsWith(query.toLowerCase()))
  //           .toList();

  //   return ListView.builder(
  //     itemCount: listaSugeridos.length,
  //     itemBuilder: (context, index) {
  //       return ListTile(
  //         leading: Icon(Icons.movie),
  //         title: Text(listaSugeridos[index]),
  //         onTap: () {
  //           seleccion = listaSugeridos[index];
  //           showResults(context);
  //         },
  //       );
  //     },
  //   );
  // }
  @override
  Widget buildSuggestions(BuildContext context) {
    //Crea las sugerencias que aparecen cuando se escribe

    if (query.isEmpty) {
      return Container();
    } else {
      return FutureBuilder(
        future: peliculasProvider.buscarPelicula(query),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<Pelicula> peliculas = snapshot.data;

            return ListView(
              children: peliculas.map((item) {
                return ListTile(
                  leading: FadeInImage(
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    image: NetworkImage(item.getPosterImg()),
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(item.title),
                  subtitle: Text(item.originalTitle),
                  onTap: () {
                    close(context, null);
                    item.idUnico = '';
                    Navigator.pushNamed(context, 'detalle', arguments: item);
                  },
                );
              }).toList(),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    }
  }
}
