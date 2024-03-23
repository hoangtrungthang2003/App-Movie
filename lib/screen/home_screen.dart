import 'dart:io';
import 'package:app_movie/bloc/movie_event.dart';
import 'package:app_movie/bloc/movie_state.dart';
import 'package:app_movie/bloc/moviebloc.dart';
import 'package:app_movie/bloc/person_bloc/person_bloc.dart';
import 'package:app_movie/bloc/person_bloc/person_event.dart';
import 'package:app_movie/main.dart';
import 'package:app_movie/model/movie.dart';
import 'package:app_movie/screen/category_screen.dart';
import 'package:app_movie/screen/movie_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieBloc>(
          create: (_) => MovieBloc()..add(const MovieEventStarted(0, '')),
        ),
        BlocProvider<PersonBloc>(
          create: (_) => PersonBloc()..add(PersonEventStated()),
        ),
      ],
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            title: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 15),
                  child: const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/logo.jpg'),
                  ),
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                    ),
                    Text("Hoàng Thắng"),
                  ],
                )
              ],
            ),
            centerTitle: false,
            actions: <Widget>[
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 25, 25, 25),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // Xử lý sự kiện khi nhấn vào nút menu
                  },
                  iconSize: 30,
                ),
              ),
              const SizedBox(width: 20),
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 25, 25, 25),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // Xử lý sự kiện khi nhấn vào nút menu
                  },
                  iconSize: 30,
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: _buildBody(context),
          )),
    );
  }

  Widget _buildBody(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                BlocBuilder<MovieBloc, MovieState>(
                  builder: (context, state) {
                    if (state is MovieLoading) {
                      return Center(
                        child: Platform.isAndroid
                            ? const CircularProgressIndicator()
                            : const CupertinoActivityIndicator(),
                      );
                    } else if (state is MovieLoaded) {
                      List<Movie> movies = state.movieList;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CarouselSlider(
                            items: movies.map((movie) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MovieDetailScreen(movie: movie),
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      alignment: Alignment.bottomLeft,
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                'https://image.tmdb.org/t/p/original/${movie.backdropPath}',
                                            fit: BoxFit.cover,
                                            width: mq.width,
                                            height: mq.height / 2,
                                            placeholder: (context, url) =>
                                                Center(
                                              child: Platform.isAndroid
                                                  ? const CircularProgressIndicator()
                                                  : const CupertinoActivityIndicator(),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                              decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/img_not_found.jpg'),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 15, left: 15),
                                          child: Text(
                                            movie.title!.toUpperCase(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              fontFamily: 'muli',
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                            options: CarouselOptions(
                              enableInfiniteScroll: true,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 5),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 800),
                              pauseAutoPlayOnTouch: true,
                              viewportFraction: 0.8,
                              enlargeCenterPage: true,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 12,
                                ),
                                BuildWidgetCategory(),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Center(
                        child: Text('Kiểm tra kết nối internet của bạn!!!'),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
