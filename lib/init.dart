import 'package:librarian_frontend/api/google_books_api.dart';
import 'package:librarian_frontend/providers/google_books_api_provider.dart';

class LibrarianProviders {
  void initialize() {
    googleBooksAPIProvider = const GoogleBooksApiProvider();
  }

  GoogleBooksApiProvider? googleBooksAPIProvider;
}

class LibrarianApis {
  void initialize(final LibrarianProviders providers) {
    googleBooksAPI = GoogleBooksApi(providers.googleBooksAPIProvider);
  }

  GoogleBooksApi? googleBooksAPI;
}
