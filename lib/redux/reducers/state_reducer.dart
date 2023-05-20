import 'package:anime_app/model/Title.dart';
import 'package:anime_app/services/file_system.dart';
import 'package:anime_app/state/app_state.dart';
import 'package:anime_app/redux/actions/actions.dart';
import 'package:anime_app/state/lib_state.dart';

Future setInfo(String ids) async {
  await FileSystem().writeData(ids);
}

AppState stateReducer(AppState state, dynamic action) {
  if (action is GetRandomTitleAction) {
    List<AnimeTitle> list = state.lib_state.list.data;
    var info = state.lib_state.list;
    list.addAll(action.list);
    AppState newState = AppState(
        lib_state: AnimeState(
            list: ListAnimeState(
                filtered: info.filtered,
                genres: info.genres,
                liked: info.liked,
                error: false,
                loading: false,
                data: list,
                search: info.search,
                recentLikes: info.recentLikes,
                currentIndex: info.currentIndex,
                history: info.data.sublist(0, info.currentIndex + 1))));
    return newState;
  } else if (action is NextTitleAction) {
    var info = state.lib_state.list;

    AppState newState = AppState(
        lib_state: AnimeState(
            list: ListAnimeState(
      filtered: info.filtered,
      genres: info.genres,
      liked: info.liked,
      error: false,
      loading: false,
      data: info.data,
      search: info.search,
      recentLikes: info.recentLikes,
      history: info.data.sublist(
          0,
          info.currentIndex < info.data.length
              ? info.currentIndex + 2
              : info.currentIndex + 1),
      currentIndex: info.currentIndex + 1,
    )));
    return newState;
  } else if (action is GetStoredTitlesAction) {
    var info = state.lib_state.list;

    AppState newState = AppState(
        lib_state: AnimeState(
            list: ListAnimeState(
                filtered: info.filtered,
                genres: info.genres,
                liked: action.titles,
                error: false,
                loading: info.loading,
                data: info.data,
                history: info.data,
                search: info.search,
                recentLikes: info.recentLikes,
                currentIndex: info.currentIndex)));
    return newState;
  } else if (action is ReloadTitlesAction) {
    var info = state.lib_state.list;

    AppState newState = AppState(
        lib_state: AnimeState(
            list: ListAnimeState(
                filtered: info.filtered,
                genres: info.genres,
                liked: info.liked,
                error: false,
                loading: true,
                data: info.data,
                history: info.data,
                search: info.search,
                recentLikes: info.recentLikes,
                currentIndex: info.currentIndex)));
    return newState;
  } else if (action is ClearRecentLikesAction) {
    var info = state.lib_state.list;

    AppState newState = AppState(
        lib_state: AnimeState(
            list: ListAnimeState(
                filtered: info.filtered,
                genres: info.genres,
                liked: info.liked,
                error: false,
                loading: info.loading,
                data: info.data,
                history: info.data,
                search: info.search,
                currentIndex: info.currentIndex,
                recentLikes: 0)));
    return newState;
  } else if (action is ToggleLikeAction) {
    var info = state.lib_state.list;

    List<AnimeTitle> data = info.data;
    List<AnimeTitle> liked = info.liked;
    List<AnimeTitle> search = info.search;
    List<AnimeTitle> filtered = info.filtered;
    List<AnimeTitle> history = info.history;

    if (liked.contains(action.title)) {
      liked.remove(action.title);
      var ids = '';

      for (int i = 0; i < liked.length; i++) {
        // if (liked[i] != action.title) {
        String sep = '';
        if (i + 1 != liked.length) sep = ',';
        ids = '$ids${liked[i].id}$sep';
        // }
      }

      setInfo(ids);
      // remove from storage
    } else {
      liked.add(action.title);
      var ids = '';

      for (int i = 0; i < liked.length; i++) {
        // if (liked[i] != action.title) {
        String sep = '';
        if (i + 1 != liked.length) sep = ',';
        ids = '$ids${liked[i].id}$sep';
        // }
      }

      setInfo(ids);
      // add to storage
    }

    AppState newState = AppState(
        lib_state: AnimeState(
            list: ListAnimeState(
                filtered: filtered,
                genres: info.genres,
                liked: liked,
                error: false,
                loading: info.loading,
                data: data,
                history: history,
                search: search,
                currentIndex: info.currentIndex,
                recentLikes:
                    !action.col ? info.recentLikes + 1 : info.recentLikes)));
    return newState;
  } else if (action is ClearFilterHistoryAction) {
    var info = state.lib_state.list;
    AppState newState = AppState(
        lib_state: AnimeState(
            list: ListAnimeState(
                filtered: [],
                genres: info.genres,
                liked: info.liked,
                error: false,
                loading: info.loading,
                data: info.data,
                history: info.data,
                search: info.search,
                currentIndex: info.currentIndex,
                recentLikes: info.recentLikes)));
    return newState;
  } else if (action is SearchTitlesAction) {
    var info = state.lib_state.list;
    AppState newState = AppState(
        lib_state: AnimeState(
            list: ListAnimeState(
                filtered: info.filtered,
                genres: info.genres,
                liked: info.liked,
                error: false,
                loading: info.loading,
                data: info.data,
                history: info.data,
                search: action.titles,
                currentIndex: info.currentIndex,
                recentLikes: info.recentLikes)));
    return newState;
  } else if (action is ReloadFilteredTitlesAction) {
    var info = state.lib_state.list;
    AppState newState = AppState(
        lib_state: AnimeState(
            list: ListAnimeState(
                filtered: info.filtered,
                genres: info.genres,
                liked: info.liked,
                error: false,
                loading: info.loading,
                data: info.data,
                history: info.data,
                search: info.search,
                currentIndex: 0,
                recentLikes: info.recentLikes)));
    return newState;
  } else if (action is SetAuthIDAction) {
    var info = state.lib_state.list;
    AppState newState = AppState(
        lib_state: AnimeState(
            list: ListAnimeState(
                authId: action.id,
                filtered: info.filtered,
                genres: info.genres,
                liked: info.liked,
                error: false,
                loading: info.loading,
                data: info.data,
                history: info.data,
                search: info.search,
                currentIndex: info.currentIndex,
                recentLikes: info.recentLikes)));
    return newState;
  } else if (action is FilteredTitlesAction) {
    var info = state.lib_state.list;

    var sameGenre = info.filtered;
    sameGenre.addAll(action.list);

    info.filtered.addAll(action.list);
    AppState newState = AppState(
        lib_state: AnimeState(
            list: ListAnimeState(
                filtered: action.same ? action.list : sameGenre,
                genres: info.genres,
                liked: info.liked,
                error: false,
                loading: info.loading,
                data: info.data,
                history: info.data,
                search: info.search,
                currentIndex: info.currentIndex,
                recentLikes: info.recentLikes)));
    return newState;
  } else if (action is ClearSearchHistory) {
    var info = state.lib_state.list;
    AppState newState = AppState(
        lib_state: AnimeState(
            list: ListAnimeState(
                filtered: info.filtered,
                genres: info.genres,
                liked: info.liked,
                error: false,
                loading: info.loading,
                data: info.data,
                history: info.data,
                search: [],
                currentIndex: info.currentIndex,
                recentLikes: info.recentLikes)));
    return newState;
  } else if (action is GetAllGenres) {
    var info = state.lib_state.list;
    AppState newState = AppState(
        lib_state: AnimeState(
            list: ListAnimeState(
                filtered: info.filtered,
                genres: action.genres,
                liked: info.liked,
                error: false,
                loading: info.loading,
                data: info.data,
                history: info.data,
                search: info.search,
                currentIndex: info.currentIndex,
                recentLikes: info.recentLikes)));
    return newState;
  } else {
    return state;
  }
}
