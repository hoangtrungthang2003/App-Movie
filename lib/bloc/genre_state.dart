import 'package:app_movie/model/genre.dart';
import 'package:equatable/equatable.dart';

abstract class GenreState extends Equatable {
  const GenreState();

  @override
  List<Object> get props => [];
}

class GenreLoading extends GenreState {}

class GenreLoaded extends GenreState {
  final List<Genre> genreList;
  const GenreLoaded(this.genreList);

  @override
  List<Object> get props => [genreList];
}

class GenreError extends GenreState {}