import 'package:anime_app/state/lib_state.dart';

// @immutable
class AppState {
  AnimeState lib_state;

  AppState({
    required this.lib_state,
  });

  factory AppState.initial() => AppState(
        lib_state: AnimeState.initial(),
      );

  AppState copyWith({
    required AnimeState lib_state,
  }) {
    return AppState(
      lib_state: lib_state ?? this.lib_state,
    );
  }
}
