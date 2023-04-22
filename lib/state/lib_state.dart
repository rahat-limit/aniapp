import 'package:anime_app/model/Title.dart';

class AnimeState {
  ListAnimeState list;

  AnimeState({required this.list});

  factory AnimeState.initial() => AnimeState(
        list: ListAnimeState.initial(),
      );
}

class ListAnimeState {
  dynamic error;
  bool loading = true;
  List<AnimeTitle> data;
  List<AnimeTitle> history;
  List<AnimeTitle> liked;
  List<AnimeTitle> search;
  List<AnimeTitle> filtered;
  List<dynamic> genres;
  String authId = 'no_acc';

  int currentIndex;
  int recentLikes;

  ListAnimeState(
      {required this.error,
      required this.loading,
      required this.data,
      required this.history,
      required this.liked,
      required this.search,
      required this.filtered,
      required this.recentLikes,
      required this.genres,
      this.currentIndex = 0,
      this.authId = 'no_acc'});

  factory ListAnimeState.initial() => ListAnimeState(
      error: null,
      loading: true,
      data: [],
      history: [],
      liked: [],
      search: [],
      filtered: [],
      genres: [],
      recentLikes: 0,
      authId: 'no_acc');
}
