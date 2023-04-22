import 'package:anime_app/model/Title.dart';
import 'package:anime_app/provider/anime_library.dart';
import 'package:anime_app/redux/actions/actions.dart';
import 'package:anime_app/state/app_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';

class InfoButton extends StatefulWidget {
  final double width;
  final double height;

  const InfoButton({this.width = 24, this.height = 24});

  @override
  State<InfoButton> createState() => _InfoButtonState();
}

class _InfoButtonState extends State<InfoButton> {
  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    List<AnimeTitle> data = [
      ...store.state.lib_state.list.data,
      ...store.state.lib_state.list.filtered,
      ...store.state.lib_state.list.liked,
      ...store.state.lib_state.list.search,
    ];
    int _genre = 0;
    const double _kItemExtent = 32.0;
    List<dynamic> _genres = store.state.lib_state.list.genres as List<dynamic>;
    void _showDialog(Widget child) {
      showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) => Container(
                height: 216,
                padding: const EdgeInsets.only(top: 6.0),
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                color: CupertinoColors.systemBackground.resolveFrom(context),
                child: SafeArea(
                  top: false,
                  child: child,
                ),
              ));
    }

    void _showActionSheet(BuildContext context) {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: const Text('Фильтр'),
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: () => _showDialog(CupertinoPicker(
                magnification: 1.22,
                squeeze: 1.2,
                useMagnifier: true,
                itemExtent: _kItemExtent,
                onSelectedItemChanged: (int selectedItem) {
                  setState(() {
                    // if (mounted) {
                    _genre = selectedItem;
                    // }
                  });
                },
                children: List<Widget>.generate(_genres.length, (int index) {
                  return Center(
                    child: Text(
                      _genres[index],
                    ),
                  );
                }),
              )),
              child: const Text('Выберите жанр аниме:'),
            ),
            CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: () {
                store.dispatch(getFilteredTitles(
                    genre: _genres[_genre].toString(), same: true, data: data));
                Provider.of<AnimeLibrary>(context, listen: false)
                    .disActiveSearch();
                Provider.of<AnimeLibrary>(context, listen: false)
                    .activeRefreshList();
                Provider.of<AnimeLibrary>(context, listen: false)
                    .disactiveRefreshListTimes();

                Navigator.pop(context);
              },
              child: const Text('Выбрать'),
            ),
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Отмена'),
            ),
          ],
        ),
      );
    }

    return InkWell(
        radius: 30,
        borderRadius: BorderRadius.circular(10),
        splashColor: Colors.grey[650],
        onTap: () => _showActionSheet(context),
        child: Container(
          margin: const EdgeInsets.only(top: 5),
          width: widget.width,
          height: widget.height,
          child: Icon(Icons.filter_list),
        ));
  }
}
