import 'package:anime_app/model/Title.dart';
import 'package:anime_app/partials/info_small_button.dart';
import 'package:anime_app/partials/lib_item.dart';
import 'package:anime_app/partials/loading_items.dart';
import 'package:anime_app/provider/anime_library.dart';
import 'package:anime_app/redux/actions/actions.dart';
import 'package:anime_app/state/app_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';

class SearchScreen extends StatefulWidget {
  static const pageRoute = '/search';
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController textController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  ScrollController _scrollViewController = ScrollController();
  late Store<AppState> store;
  bool searchActive = false;

  // ignore: non_constant_identifier_names
  List<AnimeTitle> data = [];

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null && mounted) {
        searchActive =
            Provider.of<AnimeLibrary>(context, listen: false).searchActive;
        store = StoreProvider.of<AppState>(context);
        data = [
          ...store.state.lib_state.list.data,
          ...store.state.lib_state.list.filtered,
          ...store.state.lib_state.list.liked,
          ...store.state.lib_state.list.search,
        ];
        _scrollController = ScrollController();
        _scrollViewController = ScrollController();
        textController = TextEditingController();
        store.dispatch(ClearSearchHistory());
      }
    });
  }

  @override
  void dispose() {
    textController.dispose();
    _scrollController.dispose();
    _scrollViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 30, bottom: 20),
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Expanded(
                  child: Text(
                    'Уже нашли?',
                    overflow: TextOverflow.fade,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: InfoButton(),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: CupertinoSearchTextField(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                placeholder: 'Search',
                controller: textController,
                onSubmitted: (value) {
                  store.dispatch(getSearchTitles(value, data));

                  textController.clear();
                  if (_scrollViewController.positions.isNotEmpty) {
                    _scrollViewController
                        .jumpTo(_scrollViewController.position.minScrollExtent);
                  }
                  Provider.of<AnimeLibrary>(context, listen: false)
                      .disactiveRefreshListTimes();
                  Provider.of<AnimeLibrary>(context, listen: false)
                      .activeSearch();
                }),
          ),
          StoreConnector<AppState, AppState>(
              converter: (store) => store.state,
              builder: (context, state) {
                bool loading = state.lib_state.list.loading;
                var data = state.lib_state.list.search;
                return !Provider.of<AnimeLibrary>(context, listen: true)
                        .searchActive
                    // GENRES
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: ListView.builder(
                              controller: _scrollController,
                              itemCount: state.lib_state.list.filtered.length,
                              itemBuilder: (context, index) {
                                return LibItem(
                                  loading: state.lib_state.list.loading,
                                  title: state.lib_state.list.filtered[index],
                                );
                              }),
                        ),
                      )
                    // SEARCH
                    : Expanded(
                        child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: ListView.builder(
                              controller: _scrollViewController,
                              shrinkWrap: true,
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return LibItem(
                                    title: data[index],
                                    loading: state.lib_state.list.loading);
                              },
                            )),
                      );
              })
        ],
      )),
    );
  }
}
