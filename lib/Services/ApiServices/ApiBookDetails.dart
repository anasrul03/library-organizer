import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

String apiKey = dotenv.env['API_KEY']!;

class BookDetailsService {
  Future<ApiBookDetails> fetchBookDetails(String isbn) async {
    final response = await http.get(
      Uri.parse(
          'https://www.googleapis.com/books/v1/volumes?q=isbn:$isbn&key=$apiKey'),
    );

    if (response.statusCode == 200) {
      print(response.statusCode);
      print(response.body);
      return ApiBookDetails.fromJson(response.body);
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception('Error, try again');
    }
  }
}

class ApiBookDetails {
  ApiBookDetails({
    required this.items,
  });
  late final List<Items> items;

  factory ApiBookDetails.fromJson(String str) =>
      ApiBookDetails.fromMap(json.decode(str) as Map<String, dynamic>?);

  ApiBookDetails.fromMap(Map<String, dynamic>? json) {
    items = List.from(json?['items']).map((e) => Items.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['items'] = items.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Items {
  String? kind;
  String? id;
  String? etag;
  String? selfLink;
  VolumeInfo? volumeInfo;

  Items({this.kind, this.id, this.etag, this.selfLink, this.volumeInfo});

  Items.fromJson(Map<String, dynamic>? json) {
    kind = json?['kind'];
    id = json?['id'];
    etag = json?['etag'];
    selfLink = json?['selfLink'];
    volumeInfo = json?['volumeInfo'] != null
        ? VolumeInfo?.fromJson(json?['volumeInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['kind'] = kind;
    data['id'] = id;
    data['etag'] = etag;
    data['selfLink'] = selfLink;
    data['volumeInfo'] = volumeInfo!.toJson();
    return data;
  }
}

class VolumeInfo {
  VolumeInfo({
    required this.title,
    required this.authors,
    required this.publisher,
    required this.publishedDate,
    required this.description,
    required this.industryIdentifiers,
    required this.pageCount,
    required this.categories,
    this.averageRating,
    required this.maturityRating,
    required this.imageLinks,
    required this.language,
  });
  late final String title;
  late final List<String> authors;
  late final String publisher;
  late final String publishedDate;
  late final String description;
  late final List<IndustryIdentifiers> industryIdentifiers;
  late final int pageCount;
  late final List<String> categories;
  late final dynamic averageRating;
  late final String maturityRating;
  late final ImageLinks imageLinks;
  late final String language;

  VolumeInfo.fromJson(Map<String, dynamic>? json) {
    title = json?['title'] ?? ' ';
    authors = List.castFrom<dynamic, String>(json?['authors'] ?? [' ']);
    publisher = json?['publisher'] ?? ' ';
    publishedDate = json?['publishedDate'] ?? ' ';
    description = json?['description'] ?? ' ';
    industryIdentifiers = List.from(json?['industryIdentifiers'] ?? [' '])
        .map((e) => IndustryIdentifiers.fromJson(e))
        .toList();
    pageCount = json?['pageCount'] ?? 0;
    categories = List.castFrom<dynamic, String>(json?['categories'] ?? [' ']);
    averageRating = json?['averageRating'] ?? null;
    maturityRating = json?['maturityRating'] ?? ' ';
    imageLinks = json?['imageLinks'] != null
        ? ImageLinks.fromJson(json?['imageLinks'])
        : ImageLinks(smallThumbnail: '', thumbnail: '');
    language = json?['language'] ?? ' ';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['authors'] = authors;
    _data['publisher'] = publisher;
    _data['publishedDate'] = publishedDate;
    _data['description'] = description;
    _data['industryIdentifiers'] =
        industryIdentifiers.map((e) => e.toJson()).toList();
    _data['pageCount'] = pageCount;
    _data['categories'] = categories;
    if (averageRating != null) _data['averageRating'] = averageRating;
    _data['maturityRating'] = maturityRating;
    _data['imageLinks'] = imageLinks.toJson();
    _data['language'] = language;
    return _data;
  }
}

class IndustryIdentifiers {
  String? type;
  String? identifier;

  IndustryIdentifiers({this.type, this.identifier});

  IndustryIdentifiers.fromJson(Map<String, dynamic> json) {
    type = json['type'] ?? '';
    identifier = json['identifier'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['type'] = type;
    data['identifier'] = identifier;
    return data;
  }
}

class ImageLinks {
  String? smallThumbnail;
  String? thumbnail;

  ImageLinks({this.smallThumbnail, this.thumbnail});

  ImageLinks.fromJson(Map<String, dynamic>? json) {
    smallThumbnail = json?['smallThumbnail'];
    thumbnail = json?['thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['smallThumbnail'] = smallThumbnail;
    data['thumbnail'] = thumbnail;
    return data;
  }
}
