import 'dart:io';

import 'package:app_movie/bloc/genre_event.dart';
import 'package:app_movie/bloc/genre_state.dart';
import 'package:app_movie/bloc/genrebloc.dart';
import 'package:app_movie/bloc/movie_event.dart';
import 'package:app_movie/bloc/movie_state.dart';
import 'package:app_movie/bloc/moviebloc.dart';
import 'package:app_movie/main.dart';
import 'package:app_movie/model/genre.dart';
import 'package:app_movie/model/movie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuildWidgetCategory extends StatefulWidget {
  final int selectedGenre;

  const BuildWidgetCategory({super.key, this.selectedGenre = 28});

  @override
  BuildWidgetCategoryState createState() => BuildWidgetCategoryState();
}

class BuildWidgetCategoryState extends State<BuildWidgetCategory> {
  late int selectedGenre;

  @override
  void initState() {
    super.initState();
    selectedGenre = widget.selectedGenre;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GenreBloc>(
          create: (_) => GenreBloc()..add(const GenreEventStarted()),
        ),
        BlocProvider<MovieBloc>(
          create: (_) => MovieBloc()..add(MovieEventStarted(selectedGenre, '')),
        ),
      ],
      child: _buildGenre(context),
    );
  }

  Widget _buildGenre(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        BlocBuilder<GenreBloc, GenreState>(
          builder: (context, state) {
            if (state is GenreLoading) {
              return Center(
                child: Platform.isAndroid
                    ? const CircularProgressIndicator()
                    : const CupertinoActivityIndicator(),
              );
            } else if (state is GenreLoaded) {
              List<Genre> genres = state.genreList;
              return SizedBox(
                height: 45,
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      const VerticalDivider(
                    color: Colors.transparent,
                    width: 5,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: genres.length,
                  itemBuilder: (context, index) {
                    Genre genre = genres[index];
                    return Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              Genre genre = genres[index];
                              selectedGenre = genre.id!;
                              context
                                  .read<MovieBloc>()
                                  .add(MovieEventStarted(selectedGenre, ''));
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black45,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(25),
                              ),
                              color: (genre.id == selectedGenre)
                                  ? Colors.red
                                  : Colors.white,
                            ),
                            child: Text(
                              genre.name!.toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: (genre.id == selectedGenre)
                                    ? Colors.white
                                    : Colors.black45,
                                fontFamily: 'muli',
                              ),
                            ),
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
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'movies'.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'muli',
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'show all'.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white54,
                    fontFamily: 'muli',
                  ),
                ),
              ),
            ],
          ),
        ),
        BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state is MovieLoading) {
              return const Center();
            } else if (state is MovieLoaded) {
              List<Movie> movieList = state.movieList;
              return SizedBox(
                height: mq.height * .31,
                child: ListView.separated(
                  separatorBuilder: (context, index) => const VerticalDivider(
                      color: Colors.transparent, width: 5),
                  scrollDirection: Axis.horizontal,
                  itemCount: movieList.length,
                  itemBuilder: (context, index) {
                    Movie movie = movieList[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         MovieDetailScreen(movie: movie),
                            //   ),
                            // );
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
                        const SizedBox(
                          height: 10,
                        ),
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
                                movie.voteAverage!,
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
      ],
    );
  }
}
