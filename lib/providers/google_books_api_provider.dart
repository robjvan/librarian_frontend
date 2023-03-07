import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:librarian_frontend/utilities/api_keys.dart';

@immutable
class GoogleBooksApiProvider {
  static const String _apiUrl =
      'https://www.googleapis.com/books/v1/volumes?q=';
  static const String _secondaryApiUrl =
      'https://www.googleapis.com/books/v1/volumes?q=';
  const GoogleBooksApiProvider();

  Future<http.Response> getBookDataFromISBN(final String? isbn) => http
      .get(
        Uri.parse(
          '${_apiUrl}isbn:$isbn&maxResults=40&key=$googleApiKey',
        ),
      );

  Future<http.Response> getBookDataFromISBNOtherUrl(final String? isbn) =>
      http.get(
        Uri.parse(
          '${_secondaryApiUrl}ISBN:$isbn&maxResults=40&key=$googleApiKey',
        ),
      );

  Future<http.Response> getBookDataFromQueryUrl(
    final String queryString,
  ) async =>
      http.get(
        Uri.parse(
          '$_apiUrl$queryString&maxResults=40&key=$googleApiKey',
        ),
      );
}
