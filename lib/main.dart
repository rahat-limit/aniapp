import 'package:anime_app/provider/anime_library.dart';
import 'package:anime_app/redux/reducers/state_reducer.dart';
import 'package:anime_app/screens/account_screen.dart';
import 'package:anime_app/screens/divider_screen.dart';
import 'package:anime_app/screens/intro_screen.dart';
import 'package:anime_app/screens/library_screen.dart';
import 'package:anime_app/screens/reset_screen.dart';
import 'package:anime_app/screens/search_screen.dart';
import 'package:anime_app/screens/signin_screen.dart';
import 'package:anime_app/screens/signup_screen.dart';
import 'package:anime_app/screens/title_page_screen.dart';
import 'package:anime_app/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AnimeLibrary())],
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  var store = Store(stateReducer,
      initialState: AppState.initial(), middleware: [thunkMiddleware]);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xFFE8E8E8),
            primaryColor: const Color(0xFFE8E8E8),
            appBarTheme: const AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.light,
              ),
            )),
        home: IntroScreen(),
        routes: {
          IntroScreen.pageRoute: (context) => IntroScreen(),
          DividerScreen.pageRoute: (context) => DividerScreen(),
          SignInScreen.pageRoute: (context) => SignInScreen(),
          SignUpScreen.pageRoute: (context) => SignUpScreen(),
          ResetScreen.pageRoute: (context) => const ResetScreen(),
          LibraryScreen.pageRoute: (context) => const LibraryScreen(),
          AccountScreen.pageRoute: (context) => const AccountScreen(),
          SearchScreen.pageRoute: (context) => const SearchScreen(),
          TitlePage.pageRoute: (context) => const TitlePage(),
        },
      ),
    );
  }
}
