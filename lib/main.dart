import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:librarian_frontend/api/apis.dart';
import 'package:librarian_frontend/firebase_options.dart';
import 'package:librarian_frontend/init.dart';
import 'package:librarian_frontend/middleware/middleware.dart';
import 'package:librarian_frontend/pages/pages.dart';
import 'package:librarian_frontend/providers/providers.dart';
import 'package:librarian_frontend/reducers/reducers.dart';
import 'package:librarian_frontend/routes.dart';
import 'package:librarian_frontend/state.dart';
import 'package:redux/redux.dart';

Store<GlobalAppState>? globalStore;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

const GoogleBooksApiProvider googleBooksApiProvider = GoogleBooksApiProvider();

GoogleBooksApi googleBooksApi = GoogleBooksApi(googleBooksApiProvider);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // if (await Config().isRooted()) {
  //   log('Device is rooted, preventing app start');
  //   runApp(RootWarningDialog()); // TODO(Rob): Enable root blocking
  //   return;
  // }

  final LibrarianProviders librarianProviders = LibrarianProviders();
  librarianProviders.initialize();
  final LibrarianApis librarianApis = LibrarianApis();
  librarianApis.initialize(librarianProviders);

  final List<
          void Function(Store<GlobalAppState>, dynamic, void Function(dynamic))>
      globalAppStateMiddleware =
      buildGlobalAppStateMiddleware(librarianApis.googleBooksAPI);

  globalStore = Store<GlobalAppState>(
    globalAppStateReducer,
    initialState: GlobalAppState.initialState(),
    middleware: globalAppStateMiddleware,
  );

  runApp(LibrarianApp(globalStore));
}

class LibrarianApp extends StatelessWidget {
  final Store<GlobalAppState>? store;
  const LibrarianApp(this.store, [final Key? key]) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return StoreProvider<GlobalAppState>(
      key: const Key('global-store'),
      store: store!,
      child: GetMaterialApp(
        themeMode: ThemeMode.light,
        locale: const Locale('en', 'US'),
        title: 'app-title'.tr,
        theme: ThemeData(
          primaryColor: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        darkTheme: ThemeData.dark().copyWith(
          primaryColor: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: RouteNames.loginScreen,
        getPages: Routes.getPages,
      ),
    );
  }
}
