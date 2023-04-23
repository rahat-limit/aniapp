import 'package:anime_app/model/Title.dart';
import 'package:anime_app/screens/title_page_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LibItem extends StatelessWidget {
  final AnimeTitle title;
  bool loading;
  int index;
  LibItem({
    super.key,
    required this.title,
    required this.loading,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .pushNamed(TitlePage.pageRoute, arguments: {'title': title});
        },
        child: Container(
          padding:
              const EdgeInsets.only(top: 10.0, left: 10, right: 10, bottom: 0),
          child: Column(
            children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: loading
                      ? Image.asset(
                          'assets/images/load_frame.png',
                          height: 150,
                          fit: BoxFit.contain,
                        )
                      : CachedNetworkImage(
                          imageUrl:
                              'https://anilibria.tv${title.posters['medium']['url']}',
                          placeholder: (context, url) => Image.asset(
                            'assets/images/load_frame.png',
                            scale: 1,
                            height: 150,
                            fit: BoxFit.contain,
                          ),
                          height: 150,
                          fit: BoxFit.contain,
                        ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loading ? '' : title.names['ru'],
                        maxLines: 3,
                        style: const TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Text(loading
                                ? ''
                                : title.type['full_string'] +
                                    (title.rating != 'no_rate'
                                        ? '• ${title.rating}%'
                                        : '')),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        title.description,
                        maxLines: 5,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700]),
                      )
                    ],
                  ),
                ))
              ]),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 0),
                child: Divider(
                  thickness: 1.5,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
