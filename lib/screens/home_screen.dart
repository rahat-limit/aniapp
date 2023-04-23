import 'package:anime_app/model/Title.dart';
import 'package:anime_app/partials/card_button.dart';
import 'package:anime_app/partials/card_info.dart';
import 'package:anime_app/partials/card_viewer.dart';
import 'package:anime_app/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const CardViewer(),
          const CardInfo(),
          const SizedBox(
            height: 10,
          ),
          state.lib_state.list.loading
              ? CardButton(AnimeTitle.init())
              : CardButton(
                  state.lib_state.list.data[state.lib_state.list.currentIndex]),
        ],
      ),
    ));
  }
}
