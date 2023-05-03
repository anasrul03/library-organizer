import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

String apiKey = dotenv.env['API_KEY']!;

// List<String> genre = [
//   "fiction",
//   "architecture",
//   "music",
//   "computers",
//   "history",
//   "humor",
// ];

List<String> genre = [
  // "Antiques+&+Collectibles",
  // "Literary+Collections",
  // "Architecture",
  // "Literary+Criticism",
  "Art",
  "Mathematics",
  // "Bibles",
  "Medical",
  "Biography+&+Autobiography",
  "Music",
  // "Body+Mind+&+Spirit",
  "Nature",
  "Business+&+Economics",
  // "Performing+Arts",
  "Comics+&+Graphic+Novels",
  "Pets",
  "Computers",
  // "Philosophy",
  "Cooking",
  // "Photography",
  "Crafts+&+Hobbies", //
  "Poetry", //
  "Design", //
  // "Political+Science",
  "Drama",
  "Psychology",
  "Education", //
  "Reference",
  "Family+&+Relationships",
  "Religion",
  "Fiction",
  "Science", //
  // "Foreign+Language+Study",
  "Self-Help",
  "Games+&+Activities", //
  // "Social+Science",
  "Gardening", //
  "Sports+&+Recreation",
  "Health+&+Fitness",
  // "Study+Aids",
  "History", //
  "Technology+&+Engineering",
  "House+&+Home", //
  "Transportation", //
  "Humor",
  "Travel",
  // "Juvenile+Fiction",
  // "True+Crime",
  // "Juvenile+Nonfiction",
  // "Young+Adult+Fiction",
  "Language+Arts+&+Disciplines",
  // "Young+Adult+Nonfiction",
  "Law",
];

class BookListService {
  Future<ApiBookList> fetchBookList(
      String genre, int startIndex, int maxResults) async {
    final response = await http.get(
      Uri.parse(
          'https://www.googleapis.com/books/v1/volumes?q=subject:$genre&maxResults=$maxResults&startIndex=$startIndex&key=$apiKey'),
    );

    if (response.statusCode == 200) {
      print(response.statusCode);
      // print(response.body);
      return ApiBookList.fromJson(response.body);
    } else {
      print(response.statusCode);
      // print(response.body);
      throw Exception('Error, try again');
    }
  }
}

class ApiBookList {
  ApiBookList({
    required this.items,
    required this.totalItems,
  });
  late final List<Items> items;
  late final int totalItems;

  factory ApiBookList.fromJson(String str) =>
      ApiBookList.fromMap(json.decode(str));

  ApiBookList.fromMap(Map<String, dynamic>? json) {
    items = List.from(json?['items']).map((e) => Items.fromJson(e)).toList();
    totalItems = json?['totalItems'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['items'] = items.map((e) => e.toJson()).toList();
    _data['totalItems'] = totalItems;
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
    id = json['id'] ?? '';
    volumeInfo = VolumeInfo.fromJson(json['volumeInfo'] ?? []);
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
    this.title,
    required this.industryIdentifiers,
    required this.categories,
    this.imageLinks,
  });
  late final String? title;
  late final List<IndustryIdentifiers> industryIdentifiers;
  late final List<String> categories;
  late final ImageLinks? imageLinks;

  VolumeInfo.fromJson(Map<String, dynamic> json) {
    title = json['title'] ?? '';
    industryIdentifiers = List.from(json['industryIdentifiers'] ?? [])
        .map((e) => IndustryIdentifiers.fromJson(e))
        .toList();
    categories = List.castFrom<dynamic, String>(json['categories'] ?? []);
    imageLinks = ImageLinks.fromJson(json['imageLinks'] ?? {});
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['industryIdentifiers'] =
        industryIdentifiers.map((e) => e.toJson()).toList();
    _data['categories'] = categories;
    _data['imageLinks'] = imageLinks?.toJson();
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
    type = json['type'] ?? '';
    identifier = json['identifier'] ?? '';
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
  late final String? smallThumbnail;
  late final String? thumbnail;

  ImageLinks.fromJson(Map<String, dynamic>? json) {
    smallThumbnail = json?['smallThumbnail'] as String?;
    thumbnail = json?['thumbnail'] as String?;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['smallThumbnail'] = smallThumbnail ?? '';
    _data['thumbnail'] = thumbnail ?? '';
    return _data;
  }
}
