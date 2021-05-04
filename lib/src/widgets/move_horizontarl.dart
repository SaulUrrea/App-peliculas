import 'package:flutter/material.dart';
import 'package:flutter_peliculas_app/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Pelicula> peliculas;
  final Function peliculasSiguientes;

  MovieHorizontal({
    @required this.peliculas,
    @required this.peliculasSiguientes,
  });
  final _pageController = PageController(initialPage: 1, viewportFraction: 0.3);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          (_pageController.position.maxScrollExtent - 200)) {
        peliculasSiguientes();
      }
    });

    return Container(
      height: _screenSize.height * 0.25,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        // children: _tarjetas(context),
        itemCount: peliculas.length,
        itemBuilder: (context, index) => _tarjeta(context, peliculas[index]),
      ),
    );
  }

  Widget _tarjeta(BuildContext context, Pelicula pelicula) {
    pelicula.idUnico = '${pelicula.id}-poster';

    final _tarjeta = Container(
      margin: EdgeInsets.only(right: 10),
      child: Column(
        children: [
          Hero(
            tag: pelicula.idUnico,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                  placeholder: AssetImage('assets/img/loading.gif'),
                  fit: BoxFit.cover,
                  height: 150,
                  image: NetworkImage(pelicula.getPosterImg())),
            ),
          ),
          SizedBox(height: 5),
          Text(
            pelicula.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );
    return GestureDetector(
      child: _tarjeta,
      onTap: () {
        Navigator.pushNamed(context, 'detalle', arguments: pelicula);
      },
    );
  }

  // List<Widget> _tarjetas(BuildContext context) {
  //   List<Widget> tarjetas = [];

  //   peliculas.forEach((element) {
  //     var widgetTemp = Container(
  //       margin: EdgeInsets.only(right: 10),
  //       child: Column(
  //         children: [
  //           ClipRRect(
  //             borderRadius: BorderRadius.circular(20),
  //             child: FadeInImage(
  //                 placeholder: AssetImage('assets/img/loading.gif'),
  //                 fit: BoxFit.cover,
  //                 height: 150,
  //                 image: NetworkImage(element.getPosterImg())),
  //           ),
  //           SizedBox(height: 5),
  //           Text(
  //             element.title,
  //             overflow: TextOverflow.ellipsis,
  //             style: Theme.of(context).textTheme.caption,
  //           )
  //         ],
  //       ),
  //     );

  //     tarjetas.add(widgetTemp);
  //   });

  //   return tarjetas;
  // }
}
