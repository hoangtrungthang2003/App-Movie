import 'package:app_movie/model/cast_list.dart';
import 'package:app_movie/model/movie_image.dart';

class MovieDetail {
  final String? id;
  final String? title;
  final String? backdropPath;
  final String? budget;
  final String? homePage;
  final String? originalTitle;
  final String? overview;
  final String? releaseDate;
  final String? runtime;
  final String? voteAverage;
  final String? voteCount;

  String? trailerId; // Making it nullable

  MovieImage movieImage;

  List<Cast> castList;

  MovieDetail({
    this.id,
    this.title,
    this.backdropPath,
    this.budget,
    this.homePage,
    this.originalTitle,
    this.overview,
    this.releaseDate,
    this.runtime,
    this.voteAverage,
    this.voteCount,
    this.trailerId, // Added trailerId to the constructor
    required this.movieImage, // Making movieImage required
    required this.castList, // Making castList required
  });

  factory MovieDetail.fromJson(dynamic json) {
    if (json == null) {
      return MovieDetail(
        movieImage: MovieImage(backdrops: [], posters: []),
        castList: [],
      );
    }

    return MovieDetail(
      id: json['id']?.toString(),
      title: json['title'],
      backdropPath: json['backdrop_path'],
      budget: json['budget']?.toString(),
      homePage: json['home_page'],
      originalTitle: json['original_title'],
      overview: json['overview'],
      releaseDate: json['release_date'],
      runtime: json['runtime']?.toString(),
      voteAverage: json['vote_average']?.toString(),
      voteCount: json['vote_count']?.toString(),
      trailerId:
          json['trailer_id'], // Assuming trailer_id is a property in your JSON
      movieImage: MovieImage.fromJson(json['movie_image']),
      castList: (json['cast_list'] as List<dynamic>?)
              ?.map((c) => Cast.fromJson(c))
              ?.toList() ??
          [],
    );
  }
  String getFormattedRuntime() {
    if (runtime == null) return '';

    int? totalMinutes = int.tryParse(runtime!);
    if (totalMinutes == null || totalMinutes <= 0) return '';

    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;

    if (hours > 0 && minutes > 0) {
      return '$hours' + 'h' + ' ' + '$minutes' + 'm';
    } else if (hours > 0) {
      return '$hours' + 'h';
    } else if (minutes > 0) {
      return '$minutes' + 'm';
    } else {
      return '';
    }
  }
}
