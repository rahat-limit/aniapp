<h1 align="center"> KANA </h1> <br>
<p align="center">
    <img alt="" title="GitPoint" src="https://github.com/rahat-limit/aniapp/blob/master/git-assets/playstore.png" width="450">
</p>

<p align="center">
  Simple Anime Search app in your pocket. Built with Flutter.
</p>

<p align="center">
<!--  Link to AppStore  -->
<!--   <a href="/">
    <img alt="Download on the App Store" title="App Store" src="http://i.imgur.com/0n2zqHD.png" width="140">
  </a> -->

  <a href="https://play.google.com/store/apps/details?id=com.anime_app">
    <img alt="Get it on Google Play" title="Google Play" src="http://i.imgur.com/mtGRPuM.png" width="140">
  </a>
</p>

## Introduction
Welcome to my respository, which I created due to practice of learning flutter. Here you can easily take a look at some images of app itself and read more info about it. Hope you like it🤙

**Available for Android.**

<p align="center">
  <img src = "https://github.com/rahat-limit/aniapp/blob/master/git-assets/1024_500.png" width=600>
</p>

## ✖️ Features

A few of the things you can do with Notio:

* [Firebase Authentication](https://firebase.google.com) 
* [Firestore DataBase](https://firebase.google.com)
* [Additional Functions as Verify, Reset, Delete.](https://firebase.google.com)
* [Local Storage](https://pub.dev/packages/)
* [State-management Redux with Provider](https://pub.dev/packages/flutter_redux)
* [Rest Api Usage](https://github.com/anilibria/docs/blob/master/api_v2.md#-gettitle)
* [AdMob](https://admob.google.com/home/)

<p align="center">
    <img src="https://www.gstatic.com/devrel-devsite/prod/vfe8699a5d354c41f3f953a7a9794768d4d2f39d37577d5708b5539be069912e1/firebase/images/lockup.svg" width=200>
    <img src="https://anipin.ru/wp-content/uploads/2021/11/6tyok0gydrq-1024x1024.jpg" width=200>
    <img src="https://d33wubrfki0l68.cloudfront.net/0834d0215db51e91525a25acf97433051f280f2f/c30f5/img/redux.svg" width=200>
    <img src="https://logowik.com/content/uploads/images/google-admob6870.jpg" width=200>
</p>

## ✖️ Splash Screen and Home Page
<p align='center'>
    <image src='https://github.com/rahat-limit/aniapp/blob/master/git-assets/-2147483648_-210891.jpg' width='200'/>
    <image src='https://github.com/rahat-limit/aniapp/blob/main/git-assets/IMG_20230506_204750_545.jpg' width='200'/>
</p>

## ✖️ Authentication
Base authentication using providers as email/password and google.
```dart
  Future signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken, idToken: gAuth.idToken);
    await FirebaseAuth.instance.signInWithCredential(credential);
  }
```
<p align='center'>
    <image src='https://github.com/rahat-limit/aniapp/blob/main/git-assets/Screenshot_1684586494.png' width='200'/>
</p>

## ✖️ DIO
For this task, I chose DIO Http Client package due to simple, useful and fully supported workflow.

```dart
  ThunkAction<AppState> getRandomTitles(
    {int times = 5, required List<AnimeTitle> data}) {
  return (Store store) async {
    try {
      List<AnimeTitle> list = [];
      var apiService = ApiServices();
      await apiService
          .getRandomTitleQuery(5, data)
          .then((value) => list = value);
      store.dispatch(GetRandomTitleAction(list: list));
    } on DioError catch (e) {
      if (e.response != null) {
        rethrow;
      }
    }
  };
  Future getRandomTitleQuery(int times, List<AnimeTitle> items) async {
    try {
      final anilibria = Anilibria(Uri.parse(startPoint));
      List<AnimeTitle> list = [];
      for (int i = 0; i < times; i++) {
        AnimeTitle title = AnimeTitle.init();
        final element = await anilibria.getRandomTitle(filter: list_filters);
        Response additionalResponse = await _dio.get(
            'https://kitsu.io/api/edge/anime?fields[anime]=averageRating,ageRating,youtubeVideoId&filter[slug]=${element.code}');
        AnimeTitle existTitle =
            items.firstWhere((elem) => elem.id == element.id, orElse: () {
          title = AnimeTitle(
              id: element.id ?? 0,
              code: element.code ?? 'no_code',
              names: {
                "ru": element.names!.ru ?? '',
                "en": element.names!.en ?? '',
              },
              description:
                  element.description == null ? '' : element.description!,
              announce: element.announce ?? '',
              team: {
                "voice": element.team!.voice,
                "translator": element.team!.translator,
                "editing": element.team!.editing,
                "decor": element.team!.decor,
                "timing": element.team!.timing
              },
              genres: (element.genres == null || element.genres!.isEmpty)
                  ? []
                  : element.genres,
              season: {
                "string": element.season!.string ?? '',
                "code": element.season!.code ?? 1,
                "year": element.season!.year ?? 2000,
                "week_day": element.season!.weekDay ?? 0
              },
              status: {
                "string": element.status!.string ?? '',
                "code": element.status!.code ?? 0
              },
              posters: {
                "small": {
                  "url": element.posters!.small!.url ?? '',
                  "raw_base64_file": element.posters!.small!.rawBase64File ?? ''
                },
                "medium": {
                  "url": element.posters!.medium!.url ?? '',
                  "raw_base64_file":
                      element.posters!.medium!.rawBase64File ?? ''
                },
                "original": {
                  "url": element.posters!.original!.url ?? '',
                  "raw_base64_file":
                      element.posters!.original!.rawBase64File ?? ''
                }
              },
              type: {
                "full_string": element.type!.fullString ?? '',
                "code": element.type!.code ?? 0,
                "string": element.type!.string ?? '',
                "episodes": element.type!.series ?? 0,
                "length": element.type!.length ?? 0
              },
              player: {
                "alternative_player": element.player!.alternativePlayer ?? '',
                "host": element.player!.host ?? '',
                "episodes": {
                  "first": element.player!.series!.first ?? 1,
                  "last": element.player!.series!.last ?? 1,
                  "string": element.player!.series!.string ?? ''
                },
              },
              rating: additionalResponse.data['data'].length != 0
                  ? additionalResponse.data['data'][0]['attributes']
                          ['averageRating'] ??
                      'no_rate'
                  : 'no_rate',
              ageRating: additionalResponse.data['data'].length != 0
                  ? (getAgeRating(additionalResponse.data['data'][0]
                          ['attributes']['ageRating'] ??
                      ''))
                  : 'no_rate',
              trailer: '');
          return title;
        });

        list.add(existTitle);
      }
      return list;
    } on DioError catch (e) {
      if (e.response != null) {
        rethrow;
      }
    }
  }
}
```
<p align="center">
  <img src = "https://github.com/rahat-limit/aniapp/blob/main/git-assets/Screenshot_1683719492.png" width=200>
</p>

## ✖️ More Images
<p align="center">
  <img src = "https://github.com/rahat-limit/aniapp/blob/main/git-assets/IMG_20230506_204750_106.jpg" width=200>
  <img src = "https://github.com/rahat-limit/aniapp/blob/main/git-assets/IMG_20230506_204750_196.jpg" width=200>
</p>
<h3>Thank you to all! Please hire me... 🙏</h3>

