import 'package:anime_app/model/Title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class CardButton extends StatelessWidget {
  AnimeTitle title;
  CardButton(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
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
                if (await canLaunchUrl(Uri.parse('$url$url0.html'))) {
                  await launchUrl(Uri.parse('$url$url0.html'));
                } else {
                  throw "Could not launch "
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

    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9B8686),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              )),
          onPressed: () {
            _showActionSheet(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/play.png',
                color: Colors.white,
                width: 30,
                height: 30,
              ),
              const SizedBox(
                width: 10,
              ),
              const Text(
                'Play',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
