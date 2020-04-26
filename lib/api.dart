import 'dart:convert';
import 'dart:io';

const apiCategory = {
  'name': "Currency",
  'route': "currency",
};

class Api {
  final HttpClient _httpClient = HttpClient();
  final String _url = 'flutter.udacity.com';

  Future<List> getUnits(String category) async {
    final Uri _uri = Uri.https(_url, '/$category');
    final _jsonData = await _getJsonData(_uri);

    if (_jsonData == null || _jsonData['units'] == null) {
      print("Error in getting units!!");
      return null;
    }

    return _jsonData['units'];
  }

  Future<Map<String, List>> _getJsonData(Uri uri) async {
    try {
      final _httpRequest = await _httpClient.getUrl(uri);
      final _httpResponse = await _httpRequest.close();

      if (_httpResponse.statusCode != HttpStatus.ok) {
        print("Error in getting units!!");
        return null;
      }

      final _responseBody = await _httpResponse.transform(utf8.decoder).join();

      return json.decode(_responseBody);
    } on Exception catch (e) {
      print('$e');
      return null;
    }
  }
}
