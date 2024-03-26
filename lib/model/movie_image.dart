import 'package:app_movie/model/screen_shot.dart';
import 'package:equatable/equatable.dart';

class MovieImage extends Equatable {
  final List<Screenshot> backdrops;
  final List<Screenshot> posters;

  const MovieImage({required this.backdrops, required this.posters});

  factory MovieImage.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const MovieImage(backdrops: [], posters: []);
    }

    return MovieImage(
      backdrops: (json['backdrops'] as List<dynamic>?)
              ?.map((b) => Screenshot.fromJson(b as Map<String, dynamic>))
              .toList() ??
          [],
      posters: (json['posters'] as List<dynamic>?)
              ?.map((b) => Screenshot.fromJson(b as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props => [backdrops, posters];
}
