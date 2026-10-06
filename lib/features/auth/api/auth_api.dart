import '../../../core/api/client.dart';
import '../../../core/api/endpoints.dart';
import '../../../core/storage/secure_storage.dart';

class AuthApi {
  final ApiClient _client = ApiClient.instance;

  Future<ApiResponse<SavedUser>> login({
    required String email,
    required String password,
  }) async {
    return _client.post<SavedUser>(
      endpoint: ApiEndpoints.login,
      body: {'email': email, 'password': password},
      mockDataProvider: () {
        final name = email.split('@').first;
        return SavedUser(name: name, email: email);
      },
    );
  }

  Future<ApiResponse<SavedUser>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    return _client.post<SavedUser>(
      endpoint: ApiEndpoints.register,
      body: {'name': name, 'email': email, 'password': password},
      mockDataProvider: () => SavedUser(name: name, email: email),
    );
  }
}
