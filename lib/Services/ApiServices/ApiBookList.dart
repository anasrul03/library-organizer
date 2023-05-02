import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

String apiKey = dotenv.env['API_KEY']!;

List<String> genre = [
  "fiction",
  "architecture",
  "music",
  "computers",
  "history",
  "humor",
];

//   List<String> genre = [
//     "antiques+&+collectibles",
//     "literary+collections",
//     "architecture",
//     "literary+criticism",
//     "art",
//     "mathematics",
//     "bibles",
//     "medical",
//     "biography+&+autobiography",
//     "music",
//     "body+mind+&+spirit",
//     "nature",
//     "business+&+economics",
//     "performing+arts",
//     "comics+&+graphic+novels",
//     "pets",
//     "computers",
//     "philosophy",
//     "cooking",
//     "photography",
//     "crafts+&+hobbies",
//     "poetry",
//     "design",
//     "political+science",
//     "drama",
//     "psychology",
//     "education",
//     "reference",
//     "family+&+relationships",
//     "religion",
//     "fiction",
//     "science",
//     "foreign+language+study",
//     "self-help",
//     "games+&+activities",
//     "social+science",
//     "gardening",
//     "sports+&+recreation",
//     "health+&+fitness",
//     "study+aids",
//     "history",
//     "technology+&+engineering",
//     "house+&+home",
//     "transportation",
//     "humor",
//     "travel",
//     "juvenile+fiction",
//     "true+crime",
//     "juvenile+nonfiction",
//     "young+adult+fiction",
//     "language+arts+&+disciplines",
//     "young+adult+nonfiction",
//     "law",
//   ];

class BookListService {
  Future<ApiBookList> fetchBookList(String genre) async {
    final response = await http.get(
      Uri.parse(
          'https://www.googleapis.com/books/v1/volumes?q=subject:$genre&maxResults=18&key=$apiKey'),
    );

    if (response.statusCode == 200) {
      print(response.statusCode);
      print(response.body);
      return ApiBookList.fromJson(response.body);
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception('Error, try again');
    }
  }
}

class ApiBookList {
  ApiBookList({
    required this.items,
  });
  late final List<Items> items;

  factory ApiBookList.fromJson(String str) =>
      ApiBookList.fromMap(json.decode(str));

  ApiBookList.fromMap(Map<String, dynamic> json) {
    items = List.from(json['items']).map((e) => Items.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['items'] = items.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Items {
  Items({
    required this.id,
    required this.volumeInfo,
  });
  late final String id;
  late final VolumeInfo volumeInfo;

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    volumeInfo = VolumeInfo.fromJson(json['volumeInfo']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['volumeInfo'] = volumeInfo.toJson();
    return _data;
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
    required this.categories,
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
  late final List<String> categories;
  late final String maturityRating;
  late final ImageLinks imageLinks;
  late final String language;

  VolumeInfo.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    authors = List.castFrom<dynamic, String>(json['authors']);
    publisher = json['publisher'];
    publishedDate = json['publishedDate'];
    description = json['description'];
    industryIdentifiers = List.from(json['industryIdentifiers'])
        .map((e) => IndustryIdentifiers.fromJson(e))
        .toList();
    categories = List.castFrom<dynamic, String>(json['categories']);
    maturityRating = json['maturityRating'];
    imageLinks = ImageLinks.fromJson(json['imageLinks']);
    language = json['language'];
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
    _data['categories'] = categories;
    _data['maturityRating'] = maturityRating;
    _data['imageLinks'] = imageLinks.toJson();
    _data['language'] = language;
    return _data;
  }
}

class IndustryIdentifiers {
  IndustryIdentifiers({
    required this.type,
    required this.identifier,
  });
  late final String type;
  late final String identifier;

  IndustryIdentifiers.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    identifier = json['identifier'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['type'] = type;
    _data['identifier'] = identifier;
    return _data;
  }
}

class ImageLinks {
  ImageLinks({
    required this.smallThumbnail,
    required this.thumbnail,
  });
  late final String smallThumbnail;
  late final String thumbnail;

  ImageLinks.fromJson(Map<String, dynamic> json) {
    smallThumbnail = json['smallThumbnail'];
    thumbnail = json['thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['smallThumbnail'] = smallThumbnail;
    _data['thumbnail'] = thumbnail;
    return _data;
  }
}
