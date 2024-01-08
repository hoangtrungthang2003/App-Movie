import 'package:app_movie/api/services.dart';
import 'package:app_movie/bloc/movie_event.dart';
import 'package:app_movie/bloc/movie_state.dart';
import 'package:app_movie/model/movie.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class MovieBloc extends Bloc<MovieEvent, MovieState> {
  MovieBloc() : super(MovieLoading());

  @override
  Stream<MovieState> mapEventToState(MovieEvent event) async* {
    if (event is MovieEventStarted) {
      yield* _mapMovieEventStateToState(event.movieId, event.query);
    }
  }

  Stream<MovieState> _mapMovieEventStateToState(
      int movieId, String query) async* {
    final service = ApiService();
    yield MovieLoading();
    try {
      List<Movie> movieList;
      if (movieId == 0) {
        movieList = await service.getNowPlayingMovie();
      } else {
        //print(movieId);
        movieList = await service.getMovieByGenre(movieId);
      }

      yield MovieLoaded(movieList);
    } on Exception catch (e) {
      print(e);
      yield MovieError();
    }
  }
}