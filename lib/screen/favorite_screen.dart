import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteMoviesScreen extends StatefulWidget {
  final List<String> favoriteMovies;

  const FavoriteMoviesScreen({Key? key, required this.favoriteMovies})
      : super(key: key);

  @override
  _FavoriteMoviesScreenState createState() => _FavoriteMoviesScreenState();
}

class _FavoriteMoviesScreenState extends State<FavoriteMoviesScreen> {
  late List<String> _favoriteMovies;

  @override
  void initState() {
    super.initState();
    _favoriteMovies = List.from(widget.favoriteMovies);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Movies'),
      ),
      body: _favoriteMovies.isNotEmpty
          ? ListView.separated(
              itemCount: _favoriteMovies.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                String movieTitle = _favoriteMovies[index];
                return ListTile(
                  title: Text(movieTitle),
                  trailing: IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      _removeMovieFromFavorites(movieTitle);
                    },
                  ),
                );
              },
            )
          : Center(
              child: Text('No favorite movies yet!'),
            ),
    );
  }

  void _removeMovieFromFavorites(String movieTitle) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> updatedFavorites =
        (prefs.getStringList('favoriteMovies') ?? [])..remove(movieTitle);
    await prefs.setStringList('favoriteMovies', updatedFavorites);
    setState(() {
      _favoriteMovies.remove(movieTitle);
    });
    _checkAndDeleteSharedPreferencesIfEmpty(updatedFavorites);
  }

  void _checkAndDeleteSharedPreferencesIfEmpty(
      List<String> updatedFavorites) async {
    if (updatedFavorites.isEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('favoriteMovies');
    }
  }
}
