import 'package:anime_app/model/Title.dart';
import 'package:anime_app/partials/title_option.dart';
import 'package:anime_app/provider/anime_library.dart';
import 'package:anime_app/redux/actions/actions.dart';
import 'package:anime_app/state/app_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TitlePage extends StatefulWidget {
  static const pageRoute = '/title-page';
  const TitlePage({super.key});

  @override
  State<TitlePage> createState() => _TitlePageState();
}

class _TitlePageState extends State<TitlePage> {
  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    List<AnimeTitle> data = [
      ...store.state.lib_state.list.data,
      ...store.state.lib_state.list.filtered,
      ...store.state.lib_state.list.liked,
      ...store.state.lib_state.list.search,
    ];
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, AnimeTitle>;
    final AnimeTitle? title = args['title'];
    bool isLiked = false;
    if (data.contains(title)) {
      isLiked = data.firstWhere((element) => element == title).isLiked;
    }

    var user = FirebaseAuth.instance.currentUser;
    String teams = '';
    String genres = '';
    for (int i = 0; i < title!.team['voice'].length; i++) {
      teams = teams +
          title.team['voice'][i] +
          (i != title.team['voice'].length - 1 ? ', ' : '');
    }
    if (title.genres != null) {
      for (int i = 0; i < title.genres!.length; i++) {
        genres = genres +
            title.genres![i] +
            (i != title.genres!.length - 1 ? ', ' : '');
      }
    }
    void _showActionSheet(BuildContext context) {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: const Text(
              'По правилам платформы мы не можем показать видеоматериал, но есть прямая ссылка на видео для вашего удобства:)'),
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: () async {
                String url0 = title.code;
                String url = 'https://www.anilibria.tv/release/';
                if (await canLaunchUrl(Uri.parse(url + url0 + '.html'))) {
                  await launchUrl(Uri.parse(url + url0 + '.html'));
                } else {
                  throw "Could not launch " +
                      "https://kodikdb.com/find-player?$url0";
                }
              },
              child: const Text('Смотреть'),
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

    void _additshowActionSheet(BuildContext context) {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Пожаловаться'),
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

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 10,
              height: 15,
            ),
            SizedBox(
              height: 30,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl:
                      'https://anilibria.tv${title.posters['medium']['url']}',
                  placeholder: (context, url) => Image.asset(
                    'assets/images/load_frame.png',
                    width: 260,
                    scale: 0.8,
                    fit: BoxFit.fill,
                  ),
                  fit: BoxFit.fill,
                  width: 260,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          title.names['ru'].toString(),
                          style: const TextStyle(
                              fontSize: 23, fontWeight: FontWeight.w600),
                        ),
                      ),
                      GestureDetector(
                        child: StoreConnector<AppState, AppState>(
                            converter: (store) => store.state,
                            builder: (context, state) {
                              var data = [
                                ...state.lib_state.list.data,
                                ...state.lib_state.list.filtered,
                                ...state.lib_state.list.search
                              ];
                              return Icon(
                                isLiked
                                    ? CupertinoIcons.heart_fill
                                    : CupertinoIcons.heart,
                                color: Colors.red,
                                size: 28,
                              );
                            }),
                        onTap: () {
                          setState(() {
                            isLiked = !isLiked;
                          });
                          var likedTitle =
                              Provider.of<AnimeLibrary>(context, listen: false)
                                  .toggleToLikedProvider(title.id, data);
                          store.dispatch(storeOnDevice(likedTitle,
                              store.state.lib_state.list.liked, true));
                        },
                      ),
                    ]),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(children: [
                const SizedBox(
                  width: 38,
                ),
                Flexible(
                    child: Text(
                  title.names['en'],
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700]),
                )),
              ]),
            ),
            title.announce != null && title.announce != ''
                ? Container(
                    margin: const EdgeInsets.only(left: 30, right: 30, top: 15),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.red),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red[200]),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/megaphone.png',
                            width: 32,
                            height: 32,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Text(
                              title.announce.toString(),
                              style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white),
                            ),
                          ),
                        ]),
                  )
                : const SizedBox(),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(children: [
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xFF363434),
                          padding: const EdgeInsets.symmetric(vertical: 17),
                          shape: const StadiumBorder()),
                      onPressed: () {
                        _showActionSheet(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/play.png',
                            width: 25,
                            height: 25,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            'Play',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )
                        ],
                      )),
                ),
                const SizedBox(
                  width: 5,
                ),
                Container(
                  width: 45,
                  height: 45,
                  child: InkWell(
                      onTap: () {
                        _additshowActionSheet(context);
                      },
                      radius: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/images/more.png',
                          width: 23,
                          height: 23,
                        ),
                      )),
                )
              ]),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Column(
                    children: [
                      TitleOption(
                          url: 'assets/images/flag.png',
                          text:
                              '${title.season["string"] == null ? '' : title.season["string"].toString() + ','} ${title.season["year"] == null ? '' : title.season["year"]} г.'),
                      TitleOption(
                          url: 'assets/images/video.png',
                          text: title.type['full_string']),
                      TitleOption(url: 'assets/images/group.png', text: teams),
                      TitleOption(url: 'assets/images/group.png', text: genres),
                    ],
                  )),
                ],
              ),
            ),
            title.rating != 'no_rate'
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Divider(
                          thickness: .8,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'Рейтинг',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'RateFont',
                            letterSpacing: 1),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 30),
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/review.png',
                              width: 70,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              (double.parse(title.rating) / 10)
                                  .toStringAsFixed(1),
                              style: const TextStyle(
                                  fontFamily: 'RateFont', fontSize: 44),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Divider(
                          thickness: .8,
                          color: Colors.grey[400],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  )
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Описание:',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    title.description,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700]),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
