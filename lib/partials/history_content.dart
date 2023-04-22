import 'package:anime_app/model/Title.dart';
import 'package:anime_app/partials/lib_item.dart';
import 'package:anime_app/partials/load_divider.dart';
import 'package:anime_app/partials/loading_items.dart';
import 'package:anime_app/redux/actions/actions.dart';
import 'package:anime_app/state/app_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class HistoryContent extends StatelessWidget {
  const HistoryContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          var _info = state.lib_state.list;
          List<Widget> _list = _info.history.map((title) {
            return LibItem(
              title: title,
              loading: _info.loading,
              index: _info.currentIndex,
            );
          }).toList();

          List<AnimeTitle> data = state.lib_state.list.data;
          bool loading = state.lib_state.list.loading;
          return Container(
            child: SingleChildScrollView(
                child: loading
                    ? LoadingItems()
                    : Column(
                        children: _list.reversed.toList(),
                      )),
          );
        },
      ),
    );
  }
}
