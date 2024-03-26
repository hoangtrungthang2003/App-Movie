import 'dart:io';

import 'package:app_movie/bloc/genre_event.dart';
import 'package:app_movie/bloc/genrebloc.dart';
import 'package:app_movie/bloc/movie_event.dart';
import 'package:app_movie/bloc/movie_state.dart';
import 'package:app_movie/bloc/moviebloc.dart';
import 'package:app_movie/main.dart';
import 'package:app_movie/model/movie.dart';
import 'package:app_movie/screen/movie_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllMovie extends StatefulWidget {
  final int genreId;
  final String genreName;
  const AllMovie({super.key, required this.genreId, required this.genreName});

  @override
  State<AllMovie> createState() => _AllMovieState();
}

class _AllMovieState extends State<AllMovie> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GenreBloc>(
          create: (_) => GenreBloc()..add(const GenreEventStarted()),
        ),
        BlocProvider<MovieBloc>(
          create: (_) =>
              MovieBloc()..add(MovieEventStarted(widget.genreId, '')),
        ),
      ],
      child: _buildGenre(context),
    );
  }

  Widget _buildGenre(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.genreName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state is MovieLoading) {
              return const Center();
            } else if (state is MovieLoaded) {
              List<Movie> movieList = state.movieList;
              return SizedBox(
                height: mq.height,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 4.0, // Khoảng cách giữa các hàng
                    crossAxisSpacing: 4.0,
                    childAspectRatio: .5, // Khoảng cách giữa các cột
                  ),
                  itemCount: movieList.length,
                  itemBuilder: (context, index) {
                    Movie movie = movieList[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MovieDetailScreen(movie: movie),
                              ),
                            );
                          },
                          child: ClipRRect(
                            child: CachedNetworkImage(
                              imageUrl:
                                  'https://image.tmdb.org/t/p/original${movie.backdropPath}',
                              imageBuilder: (context, imageProvider) {
                                return Container(
                                  width: mq.width * .3,
                                  height: mq.height * .25,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                              placeholder: (context, url) => SizedBox(
                                width: mq.width * .3,
                                height: mq.height * .25,
                                child: Center(
                                  child: Platform.isAndroid
                                      ? const CircularProgressIndicator()
                                      : const CupertinoActivityIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: mq.width * .3,
                                height: mq.height * .25,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/img_not_found.jpg'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        SizedBox(
                          width: mq.width * .3,
                          child: Text(
                            movie.title!.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'muli',
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 14,
                              ),
                              const Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 14,
                              ),
                              const Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 14,
                              ),
                              const Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 14,
                              ),
                              const Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 14,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                double.parse(movie.voteAverage!)
                                    .toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Color.fromARGB(115, 255, 255, 255),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
