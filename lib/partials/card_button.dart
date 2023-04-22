import 'package:anime_app/model/Title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CardButton extends StatelessWidget {
  AnimeTitle title;
  CardButton(this.title);

  @override
  Widget build(BuildContext context) {
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
                String _url = title.code;
                String url = 'https://www.anilibria.tv/release/';
                if (await canLaunchUrl(Uri.parse(url + _url + '.html'))) {
                  await launchUrl(Uri.parse(url + _url + '.html'));
                } else {
                  throw "Could not launch " +
                      "https://kodikdb.com/find-player?$_url";
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
