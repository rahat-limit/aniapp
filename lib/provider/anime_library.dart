import 'package:anime_app/model/Title.dart';
import 'package:flutter/material.dart';

class AnimeLibrary extends ChangeNotifier {
  bool _isAuth = false;
  bool _refreshList = false;
  int _refreshListTimes = 0;
  List<AnimeTitle> liked = [];
  int get refreshListTimes => _refreshListTimes;
  bool get refreshList => _refreshList;
  bool _searchActive = false;
  bool get searchActive => _searchActive;
  bool get isAuth => _isAuth;

  AnimeTitle toggleToLikedProvider(int id, List<AnimeTitle> titles) {
    AnimeTitle title = titles.firstWhere((element) => element.id == id);
    title.isLiked = !title.isLiked;
    return title;
  }

  void activeRefreshListTimes() {
    _refreshListTimes += 1;
    notifyListeners();
  }

  void disactiveRefreshListTimes() {
    _refreshListTimes = 0;
    notifyListeners();
  }

  void activeRefreshList() {
    _refreshList = true;
    notifyListeners();
  }

  void disactiveRefreshList() {
    _refreshList = false;
    notifyListeners();
  }

  void activeSearch() {
    _searchActive = true;
    notifyListeners();
  }

  void disActiveSearch() {
    _searchActive = false;
    notifyListeners();
  }

  void signedIn() {
    _isAuth = true;
    notifyListeners();
  }

  void signOut() {
    _isAuth = false;
    notifyListeners();
  }
}
