import 'package:anime_app/model/Title.dart';
import 'package:anime_app/provider/anime_library.dart';
import 'package:anime_app/redux/actions/actions.dart';
import 'package:anime_app/screens/account_screen.dart';
import 'package:anime_app/screens/home_screen.dart';
import 'package:anime_app/screens/library_screen.dart';
import 'package:anime_app/screens/search_screen.dart';
import 'package:anime_app/screens/signin_screen.dart';
import 'package:anime_app/state/app_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

class DividerScreen extends StatefulWidget {
  static const pageRoute = '/divider';

  @override
  State<DividerScreen> createState() => _DividerScreenState();
}

class _DividerScreenState extends State<DividerScreen> {
  int _pageIndex = 0;
  List<Widget> _pages = [
    HomeScreen(),
    LibraryScreen(),
    SearchScreen(),
    AccountScreen()
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
        Provider.of<AnimeLibrary>(context, listen: false).signedIn();

        store.dispatch(getGenres());
        store.dispatch(getRandomTitles(data: data));
        store.dispatch(getFilteredTitles(
            genre: 'Боевые исскуства', same: true, data: data));
        store.dispatch(ReloadTitlesAction());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Provider.of<AnimeLibrary>(context).isAuth
          ? Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, bottom: 40, top: 20),
              child: StoreConnector<AppState, AppState>(
                converter: (store) => store.state,
                builder: (context, state) => GNav(
                  color: Colors.black,
                  activeColor: Colors.white70,
                  gap: 10,
                  padding: const EdgeInsets.all(15),
                  tabBackgroundColor: const Color(0xFFF9B8686),
                  onTabChange: (value) {
                    switch (value) {
                      case 0:
                        {
                          setState(() {
                            _pageIndex = 0;
                          });
                        }
                        break;
                      case 1:
                        {
                          setState(() {
                            _pageIndex = 1;
                          });
                        }
                        break;
                      case 2:
                        {
                          setState(() {
                            _pageIndex = 2;
                          });
                        }
                        break;
                      case 3:
                        {
                          setState(() {
                            _pageIndex = 3;
                          });
                        }
                        break;
                      default:
                        {
                          setState(() {
                            _pageIndex = 0;
                          });
                        }
                        break;
                    }
                  },
                  tabs: [
                    const GButton(
                      icon: CupertinoIcons.home,
                      text: 'Home',
                      iconSize: 24,
                    ),
                    GButton(
                        icon: CupertinoIcons.heart,
                        text: 'Library',
                        leading: state.lib_state.list.recentLikes != 0
                            ? Badge(
                                label: Text(
                                  state.lib_state.list.recentLikes.toString(),
                                  style: TextStyle(fontSize: 12),
                                ),
                                backgroundColor:
                                    Color.fromARGB(255, 232, 98, 89),
                                child: Icon(
                                  CupertinoIcons.heart,
                                  size: 24,
                                  color: _pageIndex == 1
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              )
                            : null),
                    const GButton(
                      icon: CupertinoIcons.search,
                      text: 'Search',
                      iconSize: 24,
                    ),
                    const GButton(
                      icon: Icons.person,
                      text: 'Account',
                      iconSize: 24,
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _pages[_pageIndex];
          } else {
            return SignInScreen();
          }
        },
      ),
    );
  }
}
