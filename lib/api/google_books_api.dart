import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:librarian_frontend/api/api_utils.dart';
import 'package:librarian_frontend/models/models.dart';
import 'package:librarian_frontend/providers/google_books_api_provider.dart';

class GoogleBooksApi {
  final GoogleBooksApiProvider? _googleBooksAPIProvider;
  GoogleBooksApi(this._googleBooksAPIProvider);

  /// Grab data from API
  Future<APIResponse<dynamic>> searchWithIsbn(final String? isbn) async {
    Response response =
        await _googleBooksAPIProvider!.getBookDataFromISBN(isbn);
    final dynamic _results = <dynamic>[];
    if (response.statusCode != 200) {
      return APIResponse<dynamic>(
        isOk: false,
        result: null,
        status: response.statusCode,
        message: response.body,
      );
    }

    try {
      final dynamic _parsed = jsonDecode(response.body);

      if (_parsed != null) {
        if (_parsed['totalItems'] == 0) {
          //* No results returned
          //* Try different URL. Seriously, it works.
          response =
              await _googleBooksAPIProvider!.getBookDataFromISBNOtherUrl(isbn);
          if (response.statusCode != 200) {
            return APIResponse<dynamic>(
              isOk: false,
              result: null,
              status: response.statusCode,
              message: response.body,
            );
          }
          try {
            final dynamic _secondApiParsed = jsonDecode(response.body);
            if (_secondApiParsed != null) {
              if (_secondApiParsed['totalItems'] == 0) {
                return APIResponse<dynamic>(
                  isOk: false,
                  result: null,
                  status: response.statusCode,
                  message: response.body,
                );
              } else {
                final List<dynamic> _parsedData = _parsed['items'];
                if (_parsedData.isNotEmpty) {
                  for (final dynamic item in _parsedData) {
                    final Book _newBook = Book.fromGBooksJson(item);
                    _results.add(_newBook);
                  }
                }
              }
            }
          } on Exception catch (e) {
            log('$e');
          }
        } else {
          final List<dynamic> _parsedData = _parsed['items'];
          if (_parsedData.isNotEmpty) {
            for (final dynamic item in _parsedData) {
              final Book _newBook = Book.fromGBooksJson(item);
              _results.add(_newBook);
            }
          }
        }
      } else {
        throw Exception('Unexpected reponse from API: ${response.body}');
      }
    } on Exception catch (e) {
      log(e.toString());
      return APIResponse<dynamic>(
        isOk: false,
        status: response.statusCode,
        result: null,
        message: e.toString(),
      );
    }

    return APIResponse<dynamic>(
      isOk: true,
      message: 'OK',
      status: response.statusCode,
      result: _results,
    );
  }

  Future<APIResponse<dynamic>> querySearch(final String queryString) async {
    final Response response =
        await _googleBooksAPIProvider!.getBookDataFromQueryUrl(queryString);
    final dynamic _results = <dynamic>[];
    if (response.statusCode != 200) {
      return APIResponse<dynamic>(
        isOk: false,
        result: null,
        status: response.statusCode,
        message: response.body,
      );
    }

    try {
      final dynamic _parsed = jsonDecode(response.body);

      if (_parsed != null) {
        if (_parsed['totalItems'] == 0) {
          //
        } else {
          final List<dynamic> _parsedData = _parsed['items'];
          if (_parsedData.isNotEmpty) {
            for (final dynamic item in _parsedData) {
              final Book _newBook = Book.fromGBooksJson(item);
              _results.add(_newBook);
            }
          }
        }
      } else {
        throw Exception('Unexpected reponse from API: ${response.body}');
      }
    } on Exception catch (e) {
      log(e.toString());
      return APIResponse<dynamic>(
        isOk: false,
        status: response.statusCode,
        result: null,
        message: e.toString(),
      );
    }

    return APIResponse<dynamic>(
      isOk: true,
      message: 'OK',
      status: response.statusCode,
      result: _results,
    );
  }
}
