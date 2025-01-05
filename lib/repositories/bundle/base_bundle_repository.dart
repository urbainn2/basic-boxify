import 'package:http/http.dart' as http;

abstract class BaseBundleRepository {
  Future<http.Response> fetchBundles(String userId);
}
