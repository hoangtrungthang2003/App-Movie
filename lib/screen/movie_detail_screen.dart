import 'dart:io';
import 'package:app_movie/screen/favorite_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app_movie/api/services.dart';
import 'package:app_movie/bloc/movie_detail_bloc.dart';
import 'package:app_movie/bloc/movie_detail_event.dart';
import 'package:app_movie/bloc/movie_detail_state.dart';
import 'package:app_movie/model/cast_list.dart';
import 'package:app_movie/model/movie.dart';
import 'package:app_movie/model/movie_detail.dart';
import 'package:app_movie/model/screen_shot.dart';
import 'package:app_movie/screen/booking_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late YoutubePlayerController _youtubeController;
  bool _isVideoPlaying = false;
  bool isClick = false;
  bool isClick2 = false;
  Color isWhite = Colors.white;
  List<String> favoriteMovies = [];

  @override
  void initState() {
    super.initState();
    _youtubeController = YoutubePlayerController(
      initialVideoId: '',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    _restoreFavoriteMovies(); // Gọi phương thức để khôi phục danh sách phim yêu thích từ SharedPreferences
  }

  _restoreFavoriteMovies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteMovies = prefs.getStringList('favoriteMovies') ?? [];
    });
  }

  _saveFavoriteMovies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favoriteMovies', favoriteMovies);
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          MovieDetailBloc()..add(MovieDetailEventStated(widget.movie.id!)),
      child: PopScope(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              _buildDetailBody(context),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: const TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: const Color.fromRGBO(20, 20, 20, 1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailBody(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<MovieDetailBloc, MovieDetailState>(
        builder: (context, state) {
          if (state is MovieDetailLoading) {
            return Center(
              child: Platform.isAndroid
                  ? const CircularProgressIndicator()
                  : const CupertinoActivityIndicator(),
            );
          } else if (state is MovieDetailLoaded) {
            MovieDetail movieDetail = state.detail;

            return Stack(
              children: <Widget>[
                ClipPath(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    child: _isVideoPlaying
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height / 2,
                            width: double.infinity,
                            child: Center(
                              child: YoutubePlayer(
                                controller: _youtubeController,
                                showVideoProgressIndicator: true,
                              ),
                            ),
                          )
                        : CachedNetworkImage(
                            imageUrl:
                                'https://image.tmdb.org/t/p/original/${movieDetail.backdropPath}',
                            height: MediaQuery.of(context).size.height / 2,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: Platform.isAndroid
                                  ? const CircularProgressIndicator()
                                  : const CupertinoActivityIndicator(),
                            ),
                            errorWidget: (context, url, error) => Container(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      title: Row(
                        children: [
                          Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(20, 20, 20, 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  "IMDB",
                                  style: TextStyle(
                                    fontSize: 19,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "${movieDetail.voteAverage!}/10",
                                  style: const TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 120),
                      child: Column(
                        children: [
                          _isVideoPlaying
                              ? Container()
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isVideoPlaying = true;
                                      _youtubeController
                                          .load(movieDetail.trailerId!);
                                      _youtubeController.play();
                                    });
                                  },
                                  child: const Center(
                                    child: Column(
                                      children: <Widget>[
                                        Icon(
                                          Icons.play_circle_outline,
                                          color: Colors.yellow,
                                          size: 65,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 160,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(height: 20),
                                Text(
                                  movieDetail.title!.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'muli',
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "${movieDetail.releaseDate!} • ${movieDetail.getFormattedRuntime()} • ${movieDetail.genre![0].name} • ${movieDetail.genre![1].name}",
                                  style: const TextStyle(
                                      fontSize: 17, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _isVideoPlaying = true;
                                      _youtubeController
                                          .load(movieDetail.trailerId!);
                                      _youtubeController.play();
                                    });
                                  },
                                  icon: const Icon(Icons.play_arrow),
                                  label: const Text(
                                    "Play",
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        const Color.fromRGBO(20, 20, 20, 1),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // var movieId = widget.movie.id.toString();
                                    // downloadYoutubeVideoById(
                                    //     movieId);
                                  },
                                  icon: const Icon(Icons.download),
                                  label: const Text("Download"),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        const Color.fromRGBO(20, 20, 20, 1),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // setState(() {
                                    //   isClick2 =
                                    //       !isClick2; // Chuyển đổi trạng thái khi nút được nhấn
                                    //   isWhite = isClick2
                                    //       ? Colors.red
                                    //       : Colors
                                    //           .white; // Thay đổi màu sắc dựa trên trạng thái
                                    // });

                                    if (movieDetail.title != null) {
                                      setState(() {
                                        favoriteMovies.add(movieDetail.title!);
                                        _saveFavoriteMovies(); // Lưu trữ danh sách phim yêu thích
                                        print(
                                            "Added ${movieDetail.title} to favorites");
                                      });
                                    } else {
                                      print("Movie title is null");
                                    }
                                  },
                                  icon: Icon(
                                    Icons.favorite,
                                    color: isWhite,
                                  ),
                                  label: const Text(
                                    "Favotite",
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        const Color.fromRGBO(20, 20, 20, 1),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.share),
                                  label: const Text(
                                    "Share",
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        const Color.fromRGBO(20, 20, 20, 1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookingScreen(
                                      movieName: movieDetail.title!,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.money_rounded),
                              label: const Text(
                                "Mua vé xem phim",
                              ),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FavoriteMoviesScreen(
                                      favoriteMovies: favoriteMovies),
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                              onTap: () {
                                setState(() {
                                  if (isClick == true) {
                                    isClick = false;
                                  } else {
                                    isClick = true;
                                  }
                                });
                              },
                              child: isClick
                                  ? Text(
                                      movieDetail.overview!,
                                      style: const TextStyle(
                                          fontFamily: 'muli',
                                          color: Colors.white),
                                    )
                                  : Text(
                                      movieDetail.overview!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontFamily: 'muli',
                                          color: Colors.white),
                                    )),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Screenshots'.toUpperCase(),
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          SizedBox(
                            height: 155,
                            child: ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const VerticalDivider(
                                color: Colors.transparent,
                                width: 5,
                              ),
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  movieDetail.movieImage.backdrops.length,
                              itemBuilder: (context, index) {
                                Screenshot image =
                                    movieDetail.movieImage.backdrops[index];
                                return Container(
                                  child: Card(
                                    elevation: 3,
                                    borderOnForeground: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                        placeholder: (context, url) => Center(
                                          child: Platform.isAndroid
                                              ? const CircularProgressIndicator()
                                              : const CupertinoActivityIndicator(),
                                        ),
                                        imageUrl:
                                            'https://image.tmdb.org/t/p/w500${image.imagePath}',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            height: 110,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (context, index) =>
                                  VerticalDivider(
                                color: Colors.transparent,
                                width: 5,
                              ),
                              itemCount: movieDetail.castList.length,
                              itemBuilder: (context, index) {
                                Cast cast = movieDetail.castList[index];
                                return Container(
                                  child: Column(
                                    children: <Widget>[
                                      Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        elevation: 3,
                                        child: ClipRRect(
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                'https://image.tmdb.org/t/p/w200${cast.profilePath}',
                                            imageBuilder:
                                                (context, imageBuilder) {
                                              return Container(
                                                width: 80,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(100)),
                                                  image: DecorationImage(
                                                    image: imageBuilder,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              );
                                            },
                                            placeholder: (context, url) =>
                                                Container(
                                              width: 80,
                                              height: 80,
                                              child: Center(
                                                child: Platform.isAndroid
                                                    ? CircularProgressIndicator()
                                                    : CupertinoActivityIndicator(),
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                              width: 80,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/img_not_found.jpg'),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Center(
                                          child: Text(
                                            cast.name!.toUpperCase(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 8,
                                              fontFamily: 'muli',
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Center(
                                          child: Text(
                                            cast.character!.toUpperCase(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 8,
                                              fontFamily: 'muli',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
