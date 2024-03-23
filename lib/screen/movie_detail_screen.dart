import 'dart:io';

import 'package:app_movie/bloc/movie_detail_bloc.dart';
import 'package:app_movie/bloc/movie_detail_event.dart';
import 'package:app_movie/bloc/movie_detail_state.dart';
import 'package:app_movie/model/cast_list.dart';
import 'package:app_movie/model/movie.dart';
import 'package:app_movie/model/movie_detail.dart';
import 'package:app_movie/model/screen_shot.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
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
  @override
  void initState() {
    super.initState();
    _youtubeController = YoutubePlayerController(
      initialVideoId: '',
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
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
          body: _buildDetailBody(context),
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
                  ? CircularProgressIndicator()
                  : CupertinoActivityIndicator(),
            );
          } else if (state is MovieDetailLoaded) {
            MovieDetail movieDetail = state.detail;

            return Stack(
              children: <Widget>[
                ClipPath(
                  child: ClipRRect(
                    child: _isVideoPlaying
                        ? YoutubePlayer(
                            controller: _youtubeController,
                            showVideoProgressIndicator: true,
                          )
                        : CachedNetworkImage(
                            imageUrl:
                                'https://image.tmdb.org/t/p/original/${movieDetail.backdropPath}',
                            height: MediaQuery.of(context).size.height / 2,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Platform.isAndroid
                                ? CircularProgressIndicator()
                                : CupertinoActivityIndicator(),
                            errorWidget: (context, url, error) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/img_not_found.jpg'),
                                ),
                              ),
                            ),
                          ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 120),
                      child: GestureDetector(
                        onTap: () {
                          if (_youtubeController != null) {
                            setState(() {
                              _isVideoPlaying = true;
                              _youtubeController.load(movieDetail.trailerId!);
                              _youtubeController.play();
                            });
                          }
                        },
                        child: Center(
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
                    ),
                    SizedBox(
                      height: 160,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 20),
                                Text(
                                  movieDetail.title!.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'muli',
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  movieDetail.releaseDate! +
                                      " " +
                                      "•" +
                                      " " +
                                      movieDetail.getFormattedRuntime() +
                                      " " +
                                      "•" +
                                      " " +
                                      "Drama" +
                                      " " +
                                      "•" +
                                      " " +
                                      "History",
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.play_arrow),
                                label: const Text(
                                  "Play",
                                ),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor:
                                      Color.fromRGBO(20, 20, 20, 1),
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.download),
                                label: Text("Download"),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor:
                                      Color.fromRGBO(20, 20, 20, 1),
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.share),
                                label: const Text(
                                  "Share",
                                ),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor:
                                      Color.fromRGBO(20, 20, 20, 1),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 35,
                            child: Text(
                              movieDetail.overview!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: 'muli', color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Screenshots'.toUpperCase(),
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'muli',
                                    ),
                          ),
                          Container(
                            height: 155,
                            child: ListView.separated(
                              separatorBuilder: (context, index) =>
                                  VerticalDivider(
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
                                              ? CircularProgressIndicator()
                                              : CupertinoActivityIndicator(),
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
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search',
                              hintStyle: TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Color.fromRGBO(20, 20, 20, 1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
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
