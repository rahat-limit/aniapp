import 'package:anime_app/partials/lib_item.dart';
import 'package:anime_app/partials/loading_items.dart';
import 'package:anime_app/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class HistoryContent extends StatelessWidget {
  const HistoryContent({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        var info = state.lib_state.list;
        List<Widget> list = info.history.map((title) {
          return LibItem(
            title: title,
            loading: info.loading,
            index: info.currentIndex,
          );
        }).toList();

        bool loading = state.lib_state.list.loading;
        return SingleChildScrollView(
            child: loading
                ? const LoadingItems()
                : Column(
                    children: list.reversed.toList(),
                  ));
      },
    );
  }
}
