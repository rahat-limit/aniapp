import 'package:anime_app/model/Title.dart';
import 'package:anime_app/services/api_services.dart';
import 'package:anime_app/services/file_system.dart';
import 'package:anime_app/state/app_state.dart';
import 'package:dio/dio.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

String startPoint = 'https://api.anilibria.tv/v2';

class GetSearchTitlesAction {
  final List<AnimeTitle> list;
  GetSearchTitlesAction({required this.list});
}

class GetRandomTitleAction {
  final List<AnimeTitle> list;

  GetRandomTitleAction({required this.list});
}

class ToggleLikeAction {
  AnimeTitle title;
  bool col;
  ToggleLikeAction(this.title, this.col);
}

class NextTitleAction {}

class ReloadTitlesAction {}

class ClearRecentLikesAction {}

class ClearFilterHistoryAction {}

class SearchTitlesAction {
  List<AnimeTitle> titles;
  SearchTitlesAction(this.titles);
}

class LikedTitleAction {
  final int id;
  LikedTitleAction(this.id);
}

class FilteredTitlesAction {
  List<AnimeTitle> list;
  bool same;
  FilteredTitlesAction(this.list, this.same);
}

class ReloadFilteredTitlesAction {}

class SetAuthIDAction {
  String id;
  SetAuthIDAction(this.id);
}

class GetStoredTitlesAction {
  List<AnimeTitle> titles;
  GetStoredTitlesAction(this.titles);
}

ThunkAction<AppState> getStoreOnDeviceTitles(String ids) {
  return (Store store) async {
    List<AnimeTitle> titles = [];
    try {
      await ApiServices().getLikedFromStoreTitles(ids).then((value) {
        if (value != null) {
          titles = value;
        }
      });
    } catch (e) {
      print(e);
    }
    store.dispatch(GetStoredTitlesAction(titles));
  };
}

ThunkAction<AppState> storeOnDevice(AnimeTitle title, List<AnimeTitle> liked,
    [bool col = false]) {
  return (Store store) async {
    var ids = '';
    for (int i = 0; i < liked.length; i++) {
      if (liked[i] != title) {
        String sep = '';
        if (i + 1 != liked.length) sep = ',';
        ids = '$ids${liked[i].id}$sep';
      }
    }

    await FileSystem().writeData(ids);
    await FileSystem().readData().then((value) {
      print(value);
    });
    store.dispatch(ToggleLikeAction(title, col));
  };
}

ThunkAction<AppState> getFilteredTitles(
    {String genre = '',
    int after = 0,
    required bool same,
    required List<AnimeTitle> data}) {
  return (Store store) async {
    List<AnimeTitle> _list = [];
    var apiService = new ApiServices();
    await apiService
        .getSearchTitlesQuery(genre, true, data, after)
        .then((item) => _list = item);
    store.dispatch(FilteredTitlesAction(_list, same));
  };
}

ThunkAction<AppState> getRandomTitles(
    {int times = 5, required List<AnimeTitle> data}) {
  return (Store store) async {
    try {
      List<AnimeTitle> _list = [];
      var apiService = ApiServices();
      await apiService
          .getRandomTitleQuery(5, data)
          .then((value) => _list = value);
      store.dispatch(GetRandomTitleAction(list: _list));
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.message);
      }
    }
  };
}

class EndedTitlesAction {
  List<AnimeTitle> titles;
  EndedTitlesAction(this.titles);
}

class RandTitlesAction {
  List<AnimeTitle> titles;
  RandTitlesAction(this.titles);
}

class ClearSearchHistory {}

ThunkAction<AppState> getSearchTitles(
    String searchText, List<AnimeTitle> data) {
  return (Store store) async {
    List<AnimeTitle> newList = [];
    var apiService = new ApiServices();
    await apiService
        .getSearchTitlesQuery(searchText, false, data)
        .then((item) => newList = item);
    store.dispatch(SearchTitlesAction(newList));
  };
}

class GetAllGenres {
  List<dynamic> genres;
  GetAllGenres(this.genres);
}

ThunkAction<AppState> getGenres() {
  return (Store store) async {
    List<dynamic> _genres = [];
    var apiService = new ApiServices();
    await apiService.getAllGenresQuery().then((value) => _genres = value);
    store.dispatch(GetAllGenres(_genres));
  };
}
