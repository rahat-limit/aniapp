import 'package:anime_app/partials/load_divider.dart';
import 'package:flutter/material.dart';

class LoadingItems extends StatelessWidget {
  const LoadingItems({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> _loadList = List.generate(5, (index) {
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
                    SizedBox(
                      height: 5,
                    ),
                    LoadDivider(
                        width: MediaQuery.of(context).size.width / 2.4,
                        height: 10),
                    SizedBox(
                      height: 8,
                    ),
                    LoadDivider(
                        width: MediaQuery.of(context).size.width / 2.8,
                        height: 8),
                    SizedBox(height: 8),
                    LoadDivider(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 80),
                  ],
                ),
              ))
            ]),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Divider(
                thickness: 1.5,
              ),
            )
          ],
        ),
      );
    });
    return Column(children: _loadList);
  }
}
