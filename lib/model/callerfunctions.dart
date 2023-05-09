import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;

Future<Map<String, dynamic>> graphqlQuery(
    String query, Map<String, dynamic> variables) async {
  String theUrl = 'http://127.0.0.1:5000/graphql';
  if (!kIsWeb) {
    theUrl = 'http://10.0.2.2:5000/graphql';
  }
  final response = await http.post(
    Uri.parse(theUrl),
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'query': query,
      'variables': variables,
    }),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load data');
  }
}

const baseUrl = 'api.mangadex.org';
Future<http.Response> fetchTitle(title) {
  final queryParameters = {"title": title};
  final uri = Uri.https(baseUrl, '/manga', queryParameters);
  return http.get(uri);
}

Future<Map<String, dynamic>> fetchStatistics(String mangaId) async {
  var url = Uri.parse('https://api.mangadex.org/statistics/manga/' + mangaId);
  var response = await http.get(url);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load data');
  }
}

Future<http.Response> fetchGreatest(order, {String title = ' '}) {
  Map<String, dynamic> queryParameters = {};
  order.forEach((key, value) {
    queryParameters["order[" + key + "]"] = value;
  });
  queryParameters['title'] = title;

  final uri = Uri.https(baseUrl, '/manga', queryParameters);
  return http.get(uri);
}

Future<http.Response> fetchTitleAdvanced(includedTags, excludedTags) {
  final queryParameters = {
    "includedTags[]": includedTags,
    "excludedTags[]": excludedTags,
  };
  final uri = Uri.https(baseUrl, '/manga', queryParameters);
  return http.get(uri);
}

Future<http.Response> fetchCoverArt(coverId) {
  final uri = Uri.https(baseUrl, '/cover/' + coverId);
  return http.get(uri);
}

Future<http.Response> fetchTags() {
  final uri = Uri.https(baseUrl, '/manga/tag');
  return http.get(uri);
}

Future<http.Response> fetchChapters(id, {int offset = 0, int limit = 100}) {
  Map<String, dynamic> queryParameters = {
    'order[volume]': 'asc',
    'order[chapter]': 'asc',
    "translatedLanguage[]": "en"
  };
  queryParameters['offset'] = offset.toString();
  queryParameters['limit'] = limit.toString();
  final uri = Uri.https(baseUrl, '/manga/' + id + '/feed', queryParameters);
  return http.get(uri);
}

Future<Map<String, dynamic>> makeGetRequest(String chapterId) async {
  var url = Uri.parse('https://api.mangadex.org/at-home/server/' + chapterId);
  var response = await http.get(url);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load data');
  }
}
