import 'package:flutter_hrispro/data/model/response/auth_response_model.dart';
import 'package:flutter_hrispro/data/model/response/user_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthLocalDatasource {
  Future<void> saveAuthData(AuthResponseModel data) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('auth_data', data.toJson());
  }

  Future<void> updateAuthData(UserResponseModel data) async {
    final pref = await SharedPreferences.getInstance();
    final authData = await getAuthData();
    if (authData != null) {
      final updatedData = authData.copyWith(user: data.user);
      await pref.setString('auth_data', updatedData.toJson());
    }
  }

  Future<void> removeAuthData() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove('auth_data');
  }

  Future<AuthResponseModel?> getAuthData() async {
    final pref = await SharedPreferences.getInstance();
    final data = pref.getString('auth_data');
    if (data != null) {
      return AuthResponseModel.fromJson(data);
    } else {
      return null;
    }
  }

  Future<bool> isAuth() async {
    final pref = await SharedPreferences.getInstance();
    final data = pref.getString('auth_data');
    return data != null;
  }

  Future<void> saveRememberedEmail(String email) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('remembered_email', email);
  }

  Future<String?> getRememberedEmail() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('remembered_email');
  }

  Future<void> clearRememberedEmail() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove('remembered_email');
  }

  final _secureStorage = const FlutterSecureStorage();

  Future<void> saveSecurePassword(String password) async {
    await _secureStorage.write(key: 'secure_password', value: password);
  }

  Future<String?> getSecurePassword() async {
    return await _secureStorage.read(key: 'secure_password');
  }

  Future<void> clearSecurePassword() async {
    await _secureStorage.delete(key: 'secure_password');
  }
}
