import 'package:anime_app/model/Title.dart';
import 'package:anime_app/partials/lib_item.dart';
import 'package:anime_app/partials/load_divider.dart';
import 'package:anime_app/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class CollectionContent extends StatelessWidget {
  const CollectionContent({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> loadList = List.generate(5, (index) {
      return Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ClipRRect(
                child: Image.asset(
                  'assets/images/load_frame.png',
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
                    LoadDivider(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 10),
                    const SizedBox(
                      height: 5,
                    ),
                    LoadDivider(
                        width: MediaQuery.of(context).size.width / 2.4,
                        height: 10),
                    const SizedBox(
                      height: 8,
                    ),
                    LoadDivider(
                        width: MediaQuery.of(context).size.width / 2.8,
                        height: 8),
                    const SizedBox(height: 8),
                    LoadDivider(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 80),
                  ],
                ),
              ))
            ]),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Divider(
                thickness: 1.5,
              ),
            )
          ],
        ),
      );
    });

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        var info = state.lib_state.list;

        List<AnimeTitle> data = info.liked;

        bool loading = info.loading;
        return Container(
          child: data.isEmpty
              ? SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Container(
                        margin: const EdgeInsets.only(top: 100),
                        child: Image.asset(
                          'assets/images/sad.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.fill,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      const Text(
                        'Ой, а тут пусто!',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'Добавляй в колекцию дважды нажав на то самое аниме.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[700]),
                        ),
                      )
                    ]))
              : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return loading
                        ? loadList[0]
                        : LibItem(
                            title: data[index],
                            loading: info.loading,
                            index: info.currentIndex,
                          );
                  },
                ),
        );
      },
    );
  }
}
