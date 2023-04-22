class AnimeTitle {
  final int id;
  final String code;
  final Map<String, dynamic> names;
  final String description;
  final dynamic announce;
  List<dynamic>? genres = [];
  final Map<String, dynamic> team;
  final Map<String, dynamic> season;
  final Map<String, dynamic> status;
  final Map<String, dynamic> posters;
  final Map<String, dynamic> type;
  final Map<String, dynamic> player;
  String rating;
  String ageRating;
  bool isLiked = false;
  String trailer;

  AnimeTitle({
    required this.id,
    required this.code,
    required this.names,
    required this.description,
    required this.announce,
    this.genres,
    required this.team,
    required this.season,
    required this.status,
    required this.posters,
    required this.type,
    required this.player,
    required this.rating,
    required this.ageRating,
    required this.trailer,
    isLiked,
  });

  factory AnimeTitle.init() => AnimeTitle(
      id: -1,
      code: '',
      names: {'names': ''},
      description: 'description',
      announce: 'announce',
      team: {'team': ''},
      season: {'season': ''},
      status: {'status': ''},
      posters: {'posters': ''},
      type: {'type': ''},
      player: {'player': ''},
      rating: 'rating',
      ageRating: 'ageRating',
      trailer: 'trailer');

  factory AnimeTitle.fromJSON(Map<dynamic, dynamic> json) => AnimeTitle(
        id: json['id'] as int,
        code: json['code'] as String,
        names: json['names'] as Map<String, dynamic>,
        description: json['description'] ?? '' as String,
        announce: json['announce'] as dynamic,
        genres: json['genres'] ?? [] as List<dynamic>,
        team: json['team'] as Map<String, dynamic>,
        season: json['season'] as Map<String, dynamic>,
        status: json['status'] as Map<String, dynamic>,
        posters: json['posters'] as Map<String, dynamic>,
        type: json['type'] as Map<String, dynamic>,
        ageRating: 'no_rate',
        rating: 'no_rate',
        trailer: '',
        player: json['player'] as Map<String, dynamic>,
      );
  factory AnimeTitle.additionalInfo(
      AnimeTitle title, Map<dynamic, dynamic> json) {
    String age = '';
    switch (json['ageRating']) {
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
    }
    return AnimeTitle(
        id: title.id,
        code: title.code,
        names: title.names,
        description: title.description,
        announce: title.announce,
        genres: title.genres,
        team: title.team,
        season: title.season,
        status: title.status,
        posters: title.posters,
        type: title.type,
        player: title.player,
        rating: json['averageRating'] != null
            ? double.parse(json['averageRating']).round().toString()
            : 'no_rate' as String,
        ageRating: age as String,
        trailer: json['youtubeVideoId']);
  }
}
