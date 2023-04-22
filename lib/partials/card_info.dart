import 'package:anime_app/model/Title.dart';
import 'package:anime_app/partials/info_small_button.dart';
import 'package:anime_app/screens/title_page_screen.dart';
import 'package:anime_app/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class CardInfo extends StatelessWidget {
  const CardInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          List<AnimeTitle> data = state.lib_state.list.data;
          bool loading = state.lib_state.list.loading;
          int currentIndex = state.lib_state.list.currentIndex;
          return Container(
              padding: const EdgeInsets.only(
                  top: 35, left: 25, right: 25, bottom: 0),
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 12,
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                loading
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        height: 28,
                                        decoration: BoxDecoration(
                                            color: const Color(0xFFDDC7C7),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      )
                                    : GestureDetector(
                                        onTap: () => Navigator.of(context)
                                            .pushNamed(TitlePage.pageRoute,
                                                arguments: {
                                              'title': data[currentIndex]
                                            }),
                                        child: Text(
                                          data[currentIndex].names['ru'],
                                          style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                SizedBox(
                                  height: loading ? 10 : 5,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: loading
                                          ? Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.5,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFDDC7C7),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            )
                                          : Text(
                                              data[currentIndex].names['en'],
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey[700]),
                                              overflow: TextOverflow.fade,
                                              maxLines: 2,
                                            ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    loading
                                        ? const SizedBox()
                                        : Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 12),
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Text(
                                              data[currentIndex].ageRating !=
                                                      'no_rate'
                                                  ? data[currentIndex].ageRating
                                                  : "?",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          ),
                                  ],
                                ),
                                SizedBox(
                                  height: loading ? 10 : 5,
                                ),
                                loading
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.8,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            color: const Color(0xFFDDC7C7),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      )
                                    : const SizedBox(),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        !loading
                                            ? '- ' +
                                                data[currentIndex]
                                                    .type['full_string']
                                            : '',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    ]),
              ));
        },
      ),
    );
  }
}
