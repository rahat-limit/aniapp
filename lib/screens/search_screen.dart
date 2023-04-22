import 'dart:async';
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

class SearchScreen extends StatefulWidget {
  static const pageRoute = '/search';
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final GlobalKey _widgetKey = new GlobalKey();
  TextEditingController textController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();
  ScrollController _scrollViewController = new ScrollController();
  bool searchActive = false;

  double _scrollPosition = 0;
  double _scrollViewPosition = 0;
  int reload_times = 0;
  int currentMax = 50;
  List<AnimeTitle> _filteredList = [];
  List<AnimeTitle> data = [];

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null && mounted) {
        searchActive =
            Provider.of<AnimeLibrary>(context, listen: false).searchActive;
        var store = StoreProvider.of<AppState>(context);
        data = [
          ...store.state.lib_state.list.data,
          ...store.state.lib_state.list.filtered,
          ...store.state.lib_state.list.liked,
          ...store.state.lib_state.list.search,
        ];
        reload_times = 0;
        _scrollController = ScrollController();
        _scrollViewController = ScrollController();
        _scrollController.addListener(_scrollListener);
        _scrollViewController.addListener(_scrollViewListener);
        textController = TextEditingController();
        store.dispatch(ClearSearchHistory());
      }
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });

    var store = StoreProvider.of<AppState>(context);

    if (_scrollPosition == _scrollController.position.maxScrollExtent) {
      reload_times++;
      var old_state = store.state.lib_state.list.filtered;

      store.dispatch(
        getFilteredTitles(
            genre: store.state.lib_state.list.genres[0].toString(),
            after: reload_times * currentMax,
            data: data,
            same: false),
      );
      setState(() {});
    }
  }

  _scrollViewListener() {
    var store = StoreProvider.of<AppState>(context);

    setState(() {
      _scrollViewPosition = _scrollViewController.position.pixels;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<AnimeLibrary>(context, listen: true).refreshList) {
      if (_scrollController.positions.isNotEmpty) {
        setState(() {
          _scrollController.jumpTo(_scrollController.position.minScrollExtent);
        });
        Timer(const Duration(seconds: 2), () {
          Provider.of<AnimeLibrary>(context, listen: false)
              .disactiveRefreshList();
        });
      }
    }

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
                  StoreProvider.of<AppState>(context)
                      .dispatch(getSearchTitles(value, data));

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
          Container(
            child: StoreConnector<AppState, AppState>(
                converter: (store) => store.state,
                builder: (context, state) {
                  bool loading = state.lib_state.list.loading;
                  List<Widget> _list = state.lib_state.list.search
                      .map(
                        (e) => e == null
                            ? const SizedBox()
                            : LibItem(
                                title: e,
                                loading: state.lib_state.list.loading,
                                index: state.lib_state.list.currentIndex),
                      )
                      .toList();
                  return !Provider.of<AnimeLibrary>(context).searchActive
                      ? Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: ListView.builder(
                                controller: _scrollController,
                                itemCount: state.lib_state.list.filtered.length,
                                itemBuilder: (context, index) {
                                  return LibItem(
                                      loading: state.lib_state.list.loading,
                                      title:
                                          state.lib_state.list.filtered[index],
                                      index: index);
                                }),
                          ),
                        )
                      : Expanded(
                          child: loading
                              ? const SingleChildScrollView(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    child: LoadingItems(),
                                  ),
                                )
                              : SingleChildScrollView(
                                  controller: _scrollViewController,
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Column(
                                        children: _list,
                                      )),
                                ));
                }),
          )
        ],
      )),
    );
  }
}
