import 'dart:convert';
import 'package:http/http.dart' as http;

Future<dynamic> searchPlaces(String apiKey, String query) async {
  const baseUrl = 'https://nominatim.openstreetmap.org/search';
  const format = 'json';
  const int limit = 10;
  const int adminLevel = 8;

  // print(Uri.parse('$baseUrl?format=$format&limit=$limit&adminLevel=$adminLevel&q=$query&key=$apiKey'));
  final response = await http.get(
    Uri.parse('$baseUrl?format=$format&limit=$limit&adminLevel=$adminLevel&q=$query&key=$apiKey'),
  );

  if (response.statusCode == 200) {
    // Xử lý dữ liệu JSON
    List<dynamic> places = json.decode(response.body);
    // print(places);
    // for (var place in places) {
    //   print('Tên địa điểm: ${place['display_name']}');
    //   print('Tọa độ: (${place['lat']}, ${place['lon']})');
    //   print('----------------------------------------');
    // }

    return places;
  } else {
    print('Lỗi ${response.statusCode}: ${response.reasonPhrase}');
  }
}

// void main() {
//   // Thay thế 'YOUR_API_KEY' bằng khóa API của bạn từ OpenStreetMap.
//   final apiKey = 'YOUR_API_KEY';
//   final query = 'Thanh liêm'; // Từ khóa tìm kiếm
//
//   searchPlaces(apiKey, query);
// }
