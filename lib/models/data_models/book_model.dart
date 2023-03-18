// import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/models/entity.dart';

class Book extends Entity<Book> {
  final List<String>? authors;
  final String? sortAuthor;
  final String? title;
  final String? sortTitle;
  final String? publisher;
  final String id;
  final String? thumbnail;
  final String? description;

  final String? isbn13;
  final String? isbn10;

  final int? pageCount;
  final String? publishYear;
  final int? readCount;
  final double? rating;

  final bool? isMature;
  final bool? haveRead;
  final bool? inFavesList;
  final bool? inWishList;
  final bool? inShoppingList;

  Book({
    required this.thumbnail,
    required this.description,
    required this.isbn13,
    required this.isbn10,
    required this.isMature,
    required this.authors,
    required this.sortAuthor,
    required this.title,
    required this.sortTitle,
    required this.publisher,
    required this.id,
    required this.pageCount,
    required this.publishYear,
    required this.readCount,
    required this.rating,
    required this.haveRead,
    required this.inFavesList,
    required this.inWishList,
    required this.inShoppingList,
  });

  @override
  factory Book.createEmpty() => Book(
        authors: const <String>[],
        sortAuthor: '',
        sortTitle: '',
        title: '',
        publisher: '',
        id: '',
        description: '',
        thumbnail: '',
        pageCount: 0,
        publishYear: '0',
        readCount: 0,
        rating: 0,
        haveRead: false,
        inFavesList: false,
        inWishList: false,
        inShoppingList: false,
        isbn13: '',
        isbn10: '',
        isMature: false,
      );

  @override
  Book copyWith({
    final List<String>? authors,
    final String? sortAuthor,
    final String? sortTitle,
    final String? title,
    final String? publisher,
    final String? id,
    final String? isbn13,
    final String? isbn10,
    final int? pageCount,
    final String? publishYear,
    final double? rating,
    final bool? haveRead,
    final bool? inFavesList,
    final bool? inWishList,
    final bool? inShoppingList,
    final int? readCount,
    final bool? isMature,
    final String? description,
    final String? thumbnail,
  }) =>
      Book(
        authors: authors ?? this.authors,
        sortAuthor: sortAuthor ?? this.sortAuthor,
        sortTitle: sortTitle ?? this.sortTitle,
        title: title ?? this.title,
        publisher: publisher ?? this.publisher,
        id: id ?? this.id,
        pageCount: pageCount ?? this.pageCount,
        publishYear: publishYear ?? this.publishYear,
        rating: rating ?? this.rating,
        haveRead: haveRead ?? this.haveRead,
        inFavesList: inFavesList ?? this.inFavesList,
        inWishList: inWishList ?? this.inWishList,
        inShoppingList: inShoppingList ?? this.inShoppingList,
        readCount: readCount ?? this.readCount,
        thumbnail: thumbnail ?? this.thumbnail,
        description: description ?? this.description,
        isbn13: isbn13 ?? this.isbn13,
        isbn10: isbn10 ?? this.isbn10,
        isMature: isMature ?? this.isMature,
      );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'author': authors,
        'sortAuthor': sortAuthor,
        'sortTitle': sortTitle,
        'title': title,
        'publisher': publisher,
        'id': id,
        'pageCount': pageCount,
        'publishYear': publishYear,
        'rating': rating,
        'hasBeenRead': haveRead,
        'inFavesList': inFavesList,
        'inWishList': inWishList,
        'inShoppingList': inShoppingList,
        'readCount': readCount,
        'thumbnail': thumbnail,
        'description': description,
        'isbn13': isbn13,
        'isbn10': isbn10,
        'isMature': isMature
      };

  @override
  Book.fromGBooksJson(final dynamic json)
      : sortTitle = json['volumeInfo'].toString().contains(RegExp('"title"'))
            ? json['volumeInfo']['title'].startsWith(RegExp('The '))
                //Title start with 'The'
                ? json['volumeInfo']['title'].replaceFirst(RegExp('The '), '')
                // No 'The' in title,
                : json['volumeInfo']['title'].startsWith(RegExp('A '))
                    // Title starts with 'A'
                    ? json['volumeInfo']['title'].replaceFirst(RegExp('A '), '')
                    // No 'The' or 'A' in title
                    : json['volumeInfo']['title'].startsWith(RegExp('An '))
                        // Title start with 'An'
                        ? json['volumeInfo']['title']
                            .replaceFirst(RegExp('An '), '')
                        // Title does not start with 'The', 'A', or 'An'
                        : json['volumeInfo']['title']
            : 'parse-error.title'.tr,
        sortAuthor = json['volumeInfo'].toString().contains('authors')
            ? List<dynamic>.from(json['volumeInfo']['authors'])[0]
                        .split(' ')
                        .length >
                    1
                ? List<dynamic>.from(json['volumeInfo']['authors'])[0]
                            .split(' ')
                            .length >
                        2
                    ? '${List<dynamic>.from(json['volumeInfo']['authors'])[0].split(" ")[2]}, ${List<dynamic>.from(json['volumeInfo']['authors'])[0].split(" ")[0]} ${List<dynamic>.from(json['volumeInfo']['authors'])[0].split(" ")[1]}'
                    : '${List<dynamic>.from(json['volumeInfo']['authors'])[0].split(" ")[1]}, ${List<dynamic>.from(json['volumeInfo']['authors'])[0].split(" ")[0]}'
                : List<dynamic>.from(json['volumeInfo']['authors'])[0]
            : 'parse-error.author'.tr,
        title = json['volumeInfo'].toString().contains('title')
            ? json['volumeInfo']['title']
            : 'parse-error.title'.tr,
        publisher = json['volumeInfo'].toString().contains('publisher')
            ? json['volumeInfo']['publisher']
            : 'parse-error.publisher'.tr,
        id = json['id'] ?? '',
        pageCount = json['volumeInfo'].toString().contains('pageCount')
            ? Entity.parseJsonInt(
                json['volumeInfo']['pageCount'].toString(),
              )
            : 0,
        publishYear = json['volumeInfo'].toString().contains('publishedDate')
            ? json['volumeInfo']['publishedDate'].toString().substring(0, 4)
            : '0',
        rating = 0,
        haveRead = false,
        inFavesList = false,
        inWishList = false,
        inShoppingList = false,
        readCount = 0,
        isbn13 = json['volumeInfo'].toString().contains('industryIdentifiers')
            ? json['volumeInfo']['industryIdentifiers'].length > 1
                ? json['volumeInfo']['industryIdentifiers'][1]['identifier'] ??
                    ''
                : 'null'
            : 'null',
        isbn10 = json['volumeInfo'].toString().contains('industryIdentifiers')
            ? json['volumeInfo']['industryIdentifiers'][0]['identifier'] ??
                'null'
            : 'null',
        description = json['volumeInfo'].toString().contains('description')
            ? json['volumeInfo']['description']
            : '',
        // ignore: avoid_bool_literals_in_conditional_expressions
        isMature = json['volumeInfo'].toString().contains('maturityRating')
            ? json['volumeInfo']['maturityRating'] != 'NOT_MATURE'
            : false,
        thumbnail =
            json['volumeInfo']['imageLinks'].toString().contains('thumbnail')
                ? json['volumeInfo']['imageLinks']['thumbnail']
                        .contains(RegExp('&edge=curl'))
                    ? json['volumeInfo']['imageLinks']['thumbnail']
                        .replaceFirst(RegExp('&edge=curl'), '')
                    : json['volumeInfo']['imageLinks']['thumbnail']
                : 'null',
        authors = json['volumeInfo'].toString().contains('authors')
            ? List<String>.from(json['volumeInfo']['authors'])
            : <String>['parse-error.author'.tr];

  @override
  Book.fromFBJson(final dynamic json)
      : sortTitle = json['sortTitle'] ?? '',
        sortAuthor = json['sortAuthor'] ?? '',
        title = json['title'] ?? '',
        publisher = json['publisher'] ?? '',
        id = json['id'] ?? '',
        pageCount = Entity.parseJsonInt(json['pageCount'].toString()) ?? 0,
        publishYear = json['publishYear'].toString(),
        rating = Entity.parseJsonDouble(json['rating']) ?? 0,
        haveRead = Entity.parseJsonBool(json['haveRead']) ?? false,
        inFavesList = Entity.parseJsonBool(json['inFavesList']) ?? false,
        inWishList = Entity.parseJsonBool(json['inWishList']) ?? false,
        inShoppingList = Entity.parseJsonBool(json['inShoppingList']) ?? false,
        readCount = Entity.parseJsonInt(json['readCount']) ?? 0,
        isbn13 = json['isbn13'].toString(),
        isbn10 = json['isbn10'].toString(),
        description = json['description'] ?? '',
        isMature = Entity.parseJsonBool(json['isMature']) ?? false,
        thumbnail = json['thumbnail'] ?? '',
        authors = List<String>.from(json['authors']);

  @override
  bool get isNotValid => !isValid;

  @override
  bool get isValid => !isNotValid;
}
