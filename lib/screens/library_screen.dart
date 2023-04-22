import 'package:anime_app/model/Title.dart';
import 'package:anime_app/partials/collection_content.dart';
import 'package:anime_app/partials/history_content.dart';
import 'package:anime_app/provider/anime_library.dart';
import 'package:anime_app/redux/actions/actions.dart';
import 'package:anime_app/services/file_system.dart';
import 'package:anime_app/state/app_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class LibraryScreen extends StatefulWidget {
  static const pageRoute = '/library';
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final controller = PageController(viewportFraction: 1, keepPage: true);
  int _activeIndex = 0;
  List<String> _tabBarTitles = ['Коллекция', 'История'];
  final List<Widget> _tabBarContentPages = [
    const CollectionContent(),
    const HistoryContent(),
  ];
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null && mounted) {
        var store = StoreProvider.of<AppState>(context);
        List<AnimeTitle> data = [
          ...store.state.lib_state.list.data,
          ...store.state.lib_state.list.filtered,
          ...store.state.lib_state.list.liked,
          ...store.state.lib_state.list.search,
        ];
        store.dispatch(ClearRecentLikesAction());
        if (store.state.lib_state.list.data.length < 5) {
          store.dispatch(getRandomTitles(times: 5, data: data));
          store.dispatch(ReloadTitlesAction());
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 30, bottom: 20),
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    _tabBarTitles[_activeIndex],
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: SmoothPageIndicator(
                    controller: controller,
                    count: _tabBarContentPages.length,
                    effect: const ExpandingDotsEffect(
                        dotWidth: 21,
                        dotHeight: 21,
                        activeDotColor: Color(0xFFF9B8686)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: PageView.builder(
              controller: controller,
              itemCount: _tabBarContentPages.length,
              onPageChanged: (value) {
                setState(() {
                  _activeIndex = value;
                });
              },
              itemBuilder: (context, index) {
                return _tabBarContentPages[index % _tabBarContentPages.length];
              },
            ),
          )),
        ],
      ),
    );
  }
}