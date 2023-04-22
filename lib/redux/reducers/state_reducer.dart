import 'package:anime_app/model/Title.dart';
import 'package:anime_app/state/app_state.dart';
import 'package:anime_app/redux/actions/actions.dart';
import 'package:anime_app/state/lib_state.dart';

AppState stateReducer(AppState state, dynamic action) {
  if (action is GetRandomTitleAction) {
    List<AnimeTitle> _list = state.lib_state.list.data;
    var _info = state.lib_state.list;
    _list.addAll(action.list);
    AppState newState = AppState(
        lib_state: AnimeState(
            list: ListAnimeState(
                filtered: _info.filtered,
                genres: _info.genres,
                liked: _info.liked,
                error: false,
                loading: false,
                data: _list,
                search: _info.search,
                recentLikes: _info.recentLikes,
                currentIndex: _info.currentIndex,
                history: _info.data.sublist(0, _info.currentIndex + 1))));
    return newState;
  } else if (action is NextTitleAction) {
    var _info = state.lib_state.list;

    AppState newState = AppState(
        lib_state: AnimeState(
            list: ListAnimeState(
      filtered: _info.filtered,
      genres: _info.genres,
      liked: _info.liked,
      error: false,
      loading: false,
      data: _info.data,
      search: _info.search,
      recentLikes: _info.recentLikes,
      history: _info.data.sublist(
          0,
          _info.currentIndex < _info.data.length
              ? _info.currentIndex + 2
              : _info.currentIndex + 1),
      currentIndex: _info.currentIndex + 1,
    )));
    return newState;
  } else if (action is ReloadTitlesAction) {
    var _info = state.lib_state.list;

    AppState newState = AppState(
        lib_state: AnimeState(
            list: ListAnimeState(
                filtered: _info.filtered,
                genres: _info.genres,
                liked: _info.liked,
                error: false,
                loading: true,
                data: _info.data,
                history: _info.data,
                search: _info.search,
                recentLikes: _info.recentLikes,
                currentIndex: _info.currentIndex)));
    return newState;
  } else if (action is ClearRecentLikesAction) {
    var _info = state.lib_state.list;

    AppState newState = AppState(
        lib_state: AnimeState(
            list: ListAnimeState(
                filtered: _info.filtered,
                genres: _info.genres,
                liked: _info.liked,
                error: false,
                loading: _info.loading,
                data: _info.data,
                history: _info.data,
                search: _info.search,
                currentIndex: _info.currentIndex,
                recentLikes: 0)));
    return newState;
  } else if (action is ToggleLikeAction) {
    var _info = state.lib_state.list;

    List<AnimeTitle> data = _info.data;
    List<AnimeTitle> liked = _info.liked;
    List<AnimeTitle> search = _info.search;
    List<AnimeTitle> filtered = _info.filtered;
    List<AnimeTitle> history = _info.history;

    if (liked.contains(action.title)) {
      liked.remove(action.title);
    } else {
      liked.add(action.title);
    }

    AppState newState = AppState(
        lib_state: AnimeState(
            list: ListAnimeState(
                filtered: filtered,
                genres: _info.genres,
                liked: liked,
                error: false,
                loading: _info.loading,
                data: data,
                history: history,
                search: search,
                currentIndex: _info.currentIndex,
                recentLikes: _info.recentLikes)));
    return newState;
  } else if (action is LikedTitleAction) {
    var _info = state.lib_state.list;

    AnimeTitle title = AnimeTitle.init();

    List<AnimeTitle> data = _info.data;
    List<AnimeTitle> liked = _info.liked;
    List<AnimeTitle> search = _info.search;
    List<AnimeTitle> filtered = _info.filtered;
    List<AnimeTitle> history = _info.history;

    var item = data.firstWhere((element) => element.id == action.id);

    if (item.isLiked) {
      item.isLiked = false;
    } else {
      item.isLiked = true;
    }
    if (liked.contains(item)) {
      liked.remove(item);
    } else {
      liked.add(item);
    }

    AppState newState = AppState(
        lib_state: AnimeState(
            list: ListAnimeState(
                filtered: _info.filtered,
                genres: _info.genres,
                liked: _info.liked,
                error: false,
                loading: _info.loading,
                data: _info.data,
                history: _info.data,
                search: _info.search,
                currentIndex: _info.currentIndex,
                recentLikes: _info.recentLikes + 1)));
    return newState;
  } else if (action is ClearFilterHistoryAction) {
    var _info = state.lib_state.list;
    AppState newState = AppState(
        lib_state: AnimeState(
            list: ListAnimeState(
                filtered: [],
                genres: _info.genres,
                liked: _info.liked,
                error: false,
                loading: _info.loading,
                data: _info.data,
                history: _info.data,
                search: _info.search,
                currentIndex: _info.currentIndex,
                recentLikes: _info.recentLikes)));
    return newState;
  } else if (action is SearchTitlesAction) {
    var _info = state.lib_state.list;
    AppState newState = AppState(
        lib_state: AnimeState(
            list: ListAnimeState(
                filtered: _info.filtered,
                genres: _info.genres,
                liked: _info.liked,
                error: false,
                loading: _info.loading,
                data: _info.data,
                history: _info.data,
                search: action.titles,
                currentIndex: _info.currentIndex,
                recentLikes: _info.recentLikes)));
    return newState;
  } else if (action is ReloadFilteredTitlesAction) {
    var _info = state.lib_state.list;
    AppState newState = AppState(
        lib_state: AnimeState(
            list: ListAnimeState(
                filtered: _info.filtered,
                genres: _info.genres,
                liked: _info.liked,
                error: false,
                loading: _info.loading,
                data: _info.data,
                history: _info.data,
                search: _info.search,
                currentIndex: 0,
                recentLikes: _info.recentLikes)));
    return newState;
  } else if (action is SetAuthIDAction) {
    var _info = state.lib_state.list;
    AppState newState = AppState(
        lib_state: AnimeState(
            list: ListAnimeState(
                authId: action.id,
                filtered: _info.filtered,
                genres: _info.genres,
                liked: _info.liked,
                error: false,
                loading: _info.loading,
                data: _info.data,
                history: _info.data,
                search: _info.search,
                currentIndex: _info.currentIndex,
                recentLikes: _info.recentLikes)));
    return newState;
  } else if (action is FilteredTitlesAction) {
    var _info = state.lib_state.list;

    var sameGenre = _info.filtered;
    sameGenre.addAll(action.list);

    // print(action.list);
    _info.filtered.addAll(action.list);
    AppState newState = AppState(
        lib_state: AnimeState(
            list: ListAnimeState(
                filtered: action.same ? action.list : sameGenre,
                genres: _info.genres,
                liked: _info.liked,
                error: false,
                loading: _info.loading,
                data: _info.data,
                history: _info.data,
                search: _info.search,
                currentIndex: _info.currentIndex,
                recentLikes: _info.recentLikes)));
    return newState;
  } else if (action is ClearSearchHistory) {
    var _info = state.lib_state.list;
    AppState newState = AppState(
        lib_state: AnimeState(
            list: ListAnimeState(
                filtered: _info.filtered,
                genres: _info.genres,
                liked: _info.liked,
                error: false,
                loading: _info.loading,
                data: _info.data,
                history: _info.data,
                search: [],
                currentIndex: _info.currentIndex,
                recentLikes: _info.recentLikes)));
    return newState;
  } else if (action is GetAllGenres) {
    var _info = state.lib_state.list;
    AppState newState = AppState(
        lib_state: AnimeState(
            list: ListAnimeState(
                filtered: _info.filtered,
                genres: action.genres,
                liked: _info.liked,
                error: false,
                loading: _info.loading,
                data: _info.data,
                history: _info.data,
                search: _info.search,
                currentIndex: _info.currentIndex,
                recentLikes: _info.recentLikes)));
    return newState;
  } else {
    return state;
  }
}
