import 'package:anime_app/screens/divider_screen.dart';
import 'package:flutter/material.dart';

class IntroScreen extends StatefulWidget {
  static const pageRoute = '/intro';

  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Image.asset('assets/images/intro.png')),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, left: 35, right: 35, bottom: 10),
              child: Row(
                children: const [
                  Flexible(
                      child: Text(
                    'Аниме Подборка',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                  )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Row(children: const [
                Flexible(
                  child: Text(
                    'Углубитесь в мир японской анимации с нами!',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
                  ),
                )
              ]),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  color: const Color(0xFF2F2F2F),
                  borderRadius: BorderRadius.circular(50),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, DividerScreen.pageRoute);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 70),
                      decoration: const BoxDecoration(),
                      child: const Center(
                          child: Text(
                        'Далее',
                        style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w300,
                            color: Colors.white),
                      )),
                    ),
                  ),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
