import 'package:anilibria/anilibria.dart';
import 'package:anime_app/model/Title.dart';
import 'package:dio/dio.dart';

class ApiServices {
  final Dio _dio = Dio();

  String startPoint = 'https://api.anilibria.tv/v2';
  // ignore: non_constant_identifier_names
  String get_random = '/getRandomTitle';
  List<dynamic> genres = [];
  String media = 'https://kodikdb.com/find-player?';
  // ignore: non_constant_identifier_names
  List<String> list_filters = [
    'id',
    'code',
    'names',
    'description',
    'announce',
    'genres',
    'team',
    'season',
    'status',
    'posters',
    'type',
    'player'
  ];
  String filters =
      'filter=id,code,names,description,announce,genres,team,season,status,posters,type,player';
  // ignore: non_constant_identifier_names
  String get_search = '/v2/searchTitles?search=';
  // ignore: non_constant_identifier_names
  String get_genres = '/getGenres';

  String getAgeRating(String json) {
    String age = '';
    switch (json) {
      case 'G':
        {
          age = '0+';
        }
        break;
      case 'PG':
        {
          age = '12+';
        }
        break;
      case 'R':
        {
          age = '17+';
        }
        break;
      case 'R18':
        {
          age = '18+';
        }
        break;
      case '':
        {
          age = '?';
        }
        break;
    }
    return age;
  }

  Future getLikedFromStoreTitles(String ids) async {
    try {
      List<AnimeTitle> titles = [];
      Response response =
          await _dio.get('$startPoint/getTitles?id_list=$ids&$filters');
      for (int i = 0; i < response.data.length; i++) {
        AnimeTitle title = AnimeTitle.fromJSON(response.data[i]);
        Response additionalResponse = await _dio.get(
            'https://kitsu.io/api/edge/anime?fields[anime]=averageRating,ageRating,youtubeVideoId&filter[slug]=${title.code}');
        if (additionalResponse.data['meta']['count'] != 0 &&
            additionalResponse.data['data'] != null) {
          var title0 = AnimeTitle.additionalInfo(
              title, additionalResponse.data['data'][0]);
          title0.isLiked = true;
          titles.add(title0);
        } else {
          title.isLiked = true;
          titles.add(title);
        }
      }
      return titles;
    } catch (e) {
      rethrow;
    }
  }

// kodik.info/serial/19248/803944eb832adacd4d4bec7d4221f941/720p?translations=false
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

  Future getAllGenresQuery() async {
    try {
      List<dynamic> list = [];
      Response response = await _dio.get(startPoint + get_genres);
      list = response.data;
      return list;
    } on DioError catch (e) {
      if (e.response != null) {
        rethrow;
      }
    }
  }

  Future getSearchTitlesQuery(
      String searchText, bool flag, List<AnimeTitle> data,
      [int after = 0]) async {
    try {
      List<AnimeTitle> list = [];
      if (flag) {
        final anilibria = Anilibria(Uri.parse(startPoint));
        final response = await anilibria.searchTitles(
            after: after,
            genres: [searchText],
            limit: 10,
            filter: list_filters);

        for (var element in response) {
          AnimeTitle title = AnimeTitle.init();

          Response additionalResponse = await _dio.get(
              'https://kitsu.io/api/edge/anime?fields[anime]=averageRating,ageRating,youtubeVideoId&filter[slug]=${element.code}');

          AnimeTitle item =
              data.firstWhere((elem) => elem.id == element.id, orElse: () {
            title = AnimeTitle(
                id: element.id as int,
                code: element.code as String,
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
                    "url": element.posters!.small!.url,
                    "raw_base64_file": element.posters!.small!.rawBase64File
                  },
                  "medium": {
                    "url": element.posters!.medium!.url,
                    "raw_base64_file": element.posters!.medium!.rawBase64File
                  },
                  "original": {
                    "url": element.posters!.original!.url,
                    "raw_base64_file": element.posters!.original!.rawBase64File
                  }
                },
                type: {
                  "full_string": element.type!.fullString,
                  "code": element.type!.code ?? 0,
                  "string": element.type!.string,
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
          list.add(item);
        }
      } else {
        final anilibria = Anilibria(Uri.parse(startPoint));
        final response = await anilibria.searchTitles(
            search: searchText, limit: 15, filter: list_filters);

        for (var element in response) {
          Response additionalResponse = await _dio.get(
              'https://kitsu.io/api/edge/anime?fields[anime]=averageRating,ageRating,youtubeVideoId&filter[slug]=${element.code}');

          list.add(data.firstWhere((elem) => element.id == elem.id, orElse: () {
            return AnimeTitle(
                id: element.id as int,
                code: element.code as String,
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
                    "url": element.posters!.small!.url,
                    "raw_base64_file": element.posters!.small!.rawBase64File
                  },
                  "medium": {
                    "url": element.posters!.medium!.url,
                    "raw_base64_file": element.posters!.medium!.rawBase64File
                  },
                  "original": {
                    "url": element.posters!.original!.url,
                    "raw_base64_file": element.posters!.original!.rawBase64File
                  }
                },
                type: {
                  "full_string": element.type!.fullString,
                  "code": element.type!.code ?? 0,
                  "string": element.type!.string,
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
          }));
        }
      }
      return list;
    } on DioError {
      rethrow;
    }
  }
}
