import 'package:librarian_frontend/models/entity.dart';

class SearchParams extends Entity<SearchParams> {
  final String? title;
  final String? author;
  final String? year;
  final String? publisher;
  final String? isbn;
  SearchParams({
    this.title,
    this.author,
    this.year,
    this.publisher,
    this.isbn,
  });

  @override
  factory SearchParams.createEmpty() => SearchParams(
        title: '',
        author: '',
        year: '',
        publisher: '',
        isbn: '',
      );

  @override
  Entity<SearchParams> copyWith({
    final String? title,
    final String? author,
    final String? year,
    final String? publisher,
    final String? isbn,
  }) =>
      SearchParams(
        title: title ?? this.title,
        author: author ?? this.author,
        year: year ?? this.year,
        publisher: publisher ?? this.publisher,
        isbn: isbn ?? this.isbn,
      );

  @override
  bool get isNotValid => !isValid;

  @override
  bool get isValid =>
      title != null &&
      author != null &&
      year != null &&
      publisher != null &&
      isbn != null;

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'title': title,
        'author': author,
        'year': year,
        'publisher': publisher,
        'isbn': isbn,
      };

  @override
  SearchParams.fromJson(final dynamic json)
      : title = json['title'],
        author = json['author'],
        year = json['year'],
        publisher = json['publisher'],
        isbn = json['isbn'];
}
