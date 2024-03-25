import 'dart:io';

import 'package:app_movie/api/services.dart';
import 'package:app_movie/main.dart';
import 'package:app_movie/model/movie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchMovie extends StatefulWidget {
  const SearchMovie({super.key});

  @override
  State<SearchMovie> createState() => _SearchMovieState();
}

class _SearchMovieState extends State<SearchMovie> {
  final TextEditingController _searchController = TextEditingController();
  List<Movie> _searchResult = [];
  bool _isLoading = false;

  final ApiService _apiService = ApiService();

  _searchMovies(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Movie> searchResult = await _apiService.searchListMovie(query);
      setState(() {
        _searchResult = searchResult;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Tìm kiếm"),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  _searchMovies(value);
                },
                decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(255, 192, 192, 192),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none),
                    hintText: "eg. The Dark Knight",
                    prefixIcon: const Icon(Icons.search)),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : _buildSearchResult(),
              )
            ],
          )),
    );
  }

  Widget _buildSearchResult() {
    if (_searchResult.isEmpty) {
      return const Center(
        child: Text('No results found.'),
      );
    }

    return ListView.builder(
      itemCount: _searchResult.length,
      itemBuilder: (BuildContext context, int index) {
        Movie movie = _searchResult[index];
        return ListTile(
          title: Text(
            movie.title!,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            movie.releaseDate!.substring(0, 4),
            style: const TextStyle(color: Colors.white60),
          ),
          trailing: Text(
            double.parse(movie.voteAverage!).toStringAsFixed(1),
            style: const TextStyle(color: Colors.amber, fontSize: 14),
          ),
          leading: ClipRRect(
            child: CachedNetworkImage(
              imageUrl: 'https://image.tmdb.org/t/p/w500${movie.backdropPath}',
              imageBuilder: (context, imageProvider) {
                return Container(
                  width: mq.width * .3,
                  height: mq.height * .5,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
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
                height: mq.height,
                child: Center(
                  child: Platform.isAndroid
                      ? const CircularProgressIndicator()
                      : const CupertinoActivityIndicator(),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                width: mq.width * .3,
                height: mq.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/img_not_found.jpg'),
                  ),
                ),
              ),
            ),
          ),
          onTap: () {
            // Navigate to movie detail page or do something else with the movie
          },
        );
      },
    );
  }
}
