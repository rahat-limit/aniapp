import 'package:anime_app/model/Title.dart';
import 'package:anime_app/partials/card_button.dart';
import 'package:anime_app/partials/card_info.dart';
import 'package:anime_app/partials/card_viewer.dart';
import 'package:anime_app/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CardViewer(),
          CardInfo(),
          SizedBox(
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
