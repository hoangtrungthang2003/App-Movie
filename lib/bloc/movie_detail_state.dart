import 'package:app_movie/model/movie_detail.dart';
import 'package:equatable/equatable.dart';

abstract class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object> get props => [];
}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailError extends MovieDetailState {}

class MovieDetailLoaded extends MovieDetailState {
  final MovieDetail detail;
  const MovieDetailLoaded(this.detail);

  @override
  List<Object> get props => [detail];
}
