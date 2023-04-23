import 'package:anime_app/model/Title.dart';
import 'package:anime_app/provider/anime_library.dart';
import 'package:anime_app/redux/actions/actions.dart';
import 'package:anime_app/state/app_state.dart';
import 'package:anime_app/state/lib_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';

class CardViewer extends StatefulWidget {
  const CardViewer({super.key});

  @override
  State<CardViewer> createState() => _CardViewerState();
}

class _CardViewerState extends State<CardViewer> {
  bool _clicked = false;
  bool _flag = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          var store = StoreProvider.of<AppState>(context);
          List<AnimeTitle> data = [
            ...store.state.lib_state.list.data,
            ...store.state.lib_state.list.filtered,
            ...store.state.lib_state.list.liked,
            ...store.state.lib_state.list.search,
          ];
          ListAnimeState lib = state.lib_state.list;
          bool loading = state.lib_state.list.loading;
          List<Widget> loadList = [
            Center(
              child: Container(
                  margin: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 0, top: 10),
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDC7C7),
                    borderRadius: BorderRadius.circular(30),
                  )),
            ),
          ];
          List<Widget> list = lib.data
              .map(
                (item) => GestureDetector(
                  onDoubleTap: () async {
                    if (!_flag) {
                      bool fl = item.isLiked;
                      var likedTitle =
                          Provider.of<AnimeLibrary>(context, listen: false)
                              .toggleToLikedProvider(item.id, data);
                      store.dispatch(storeOnDevice(
                          likedTitle, store.state.lib_state.list.liked, fl));
                      setState(() {
                        _flag = true;
                        _clicked = true;
                      });
                    }
                  },
                  child: Center(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://anilibria.tv${item.posters['original'] == null ? '' : item.posters['original']['url']}',
                            placeholder: (context, url) => Image.asset(
                              'assets/images/load_frame.png',
                              width: MediaQuery.of(context).size.width - 40,
                              scale: 0.8,
                              fit: BoxFit.fill,
                            ),
                            fit: BoxFit.fill,
                            width: MediaQuery.of(context).size.width - 40,
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: _clicked && _flag ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 350),
                          child: Center(
                            child: Icon(
                              CupertinoIcons.heart_fill,
                              color:
                                  item.isLiked ? Colors.red : Colors.grey[700],
                              size: 65,
                            ),
                          ),
                          onEnd: () {
                            setState(() {
                              _clicked = false;
                            });
                          },
                        ),
                        Positioned(
                          width: 80,
                          height: 35,
                          top: 20,
                          right: 20,
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  lib.data[lib.currentIndex].rating != 'no_rate'
                                      ? const Color(0xFF89CF70)
                                      : Colors.transparent,
                            ),
                            child: Center(
                                child: lib.data[lib.currentIndex].rating !=
                                        'no_rate'
                                    ? Text(
                                        '${lib.data[lib.currentIndex].rating}%',
                                        style: const TextStyle(
                                          fontFamily: 'RateFont',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20,
                                          color: Colors.white,
                                          letterSpacing: .8,
                                        ),
                                      )
                                    : null),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
              .toList();

          return Expanded(
            flex: 17,
            child: loading
                ? loadList[0]
                : CardSwiper(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 20, top: 10),
                    scale: 1,
                    initialIndex: lib.currentIndex <= lib.data.length
                        ? lib.currentIndex
                        : lib.currentIndex - 1,
                    numberOfCardsDisplayed: 2,
                    isVerticalSwipingEnabled: false,
                    isLoop: false,
                    isDisabled: loading ? true : false,
                    direction: CardSwiperDirection.left,
                    cardsCount: lib.data.length,
                    onSwipe: (
                      int previousIndex,
                      int? currentIndex,
                      CardSwiperDirection direction,
                    ) {
                      setState(() {
                        _flag = false;
                      });

                      store.dispatch(getRandomTitles(data: data));
                      store.dispatch(ReloadTitlesAction());
                      store.dispatch(NextTitleAction());
                      return true;
                    },
                    cardBuilder: (context, index) {
                      return list[index];
                    },
                  ),
          );
        });
  }
}
