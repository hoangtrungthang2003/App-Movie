import 'package:app_movie/api/services.dart';
import 'package:app_movie/bloc/person_bloc/person_event.dart';
import 'package:app_movie/bloc/person_bloc/person_state.dart';
import 'package:app_movie/model/person.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class PersonBloc extends Bloc<PersonEvent, PersonState> {
  PersonBloc() : super(PersonLoading());

  @override
  Stream<PersonState> mapEventToState(PersonEvent event) async* {
    if (event is PersonEventStated) {
      yield* _mapMovieEventStartedToState();
    }
  }

  Stream<PersonState> _mapMovieEventStartedToState() async* {
    final apiRepository = ApiService();
    yield PersonLoading();
    try {
      print('Genrebloc called.');
      final List<Person> movies = await apiRepository.getTrendingPerson();
      yield PersonLoaded(movies);
    } catch (_) {
      yield PersonError();
    }
  }
}