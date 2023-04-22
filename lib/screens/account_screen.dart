import 'package:anime_app/provider/anime_library.dart';
import 'package:anime_app/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatelessWidget {
  static const pageRoute = '/account';
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void _submit() async {
      try {
        String response = await AuthService().verifyEmail();
        if (response.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text(
              'Something went wrong',
            ),
            duration: const Duration(milliseconds: 800),
            showCloseIcon: true,
            closeIconColor: Colors.white,
            backgroundColor: Theme.of(context).errorColor,
          ));
        }
      } catch (e) {
        print(e);
      }
    }

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        var data = snapshot.data;
        if (snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/user.png',
                      width: 60,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      data!.email.toString(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    FirebaseAuth.instance.currentUser!.emailVerified
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('Почта подтверждена'),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.verified)
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.all(12),
                                        backgroundColor: Colors.grey[700]),
                                    child: const Text('Подтвердить почту',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500)),
                                    onPressed: _submit,
                                  ),
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 40.0),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(12),
                                    backgroundColor: Colors.redAccent.shade400),
                                child: const Text('Выйти',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    )),
                                onPressed: () {
                                  Provider.of<AnimeLibrary>(context,
                                          listen: false)
                                      .signOut();
                                  FirebaseAuth.instance.signOut();
                                }),
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
          );
        } else {
          return const Center(
            child: Text('You are not registered!'),
          );
        }
      },
    );
  }
}
