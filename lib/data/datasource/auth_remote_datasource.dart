import 'dart:convert';
import 'dart:developer';

// import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import '../../core/constant/api.dart';
import 'package:flutter_hrispro/data/datasource/auth_local_datasource.dart';
import 'package:flutter_hrispro/data/model/response/auth_response_model.dart';
import 'package:http/http.dart' as http;

import '../model/response/user_response_model.dart';

class AuthRemoteDatasource {
  Future<Either<String, AuthResponseModel>> login(
    String username,
    String password,
  ) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/api/login');
    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'email': username, 'password': password}),
    );

    log("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      return Right(AuthResponseModel.fromJson(response.body));
    } else {
      return const Left('Failed to login');
    }
  }

  //logout
  Future<Either<String, String>> logout() async {
    final authData = await AuthLocalDatasource().getAuthData();
    final url = Uri.parse('${ApiConstants.baseUrl}/api/logout');
    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authData?.token}',
      },
    );

    if (response.statusCode == 200) {
      return const Right('Logout success');
    } else {
      return const Left('Failed to logout');
    }
  }

  Future<Either<String, UserResponseModel>> updateProfileRegisterFace(
    String embedding,
  ) async {
    final authData = await AuthLocalDatasource().getAuthData();
    final url = Uri.parse('${ApiConstants.baseUrl}/api/update-profile');
    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer ${authData?.token}'
      ..fields['face_embedding'] = embedding;

    final response = await request.send();
    final responseString = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return Right(UserResponseModel.fromJson(responseString));
    } else {
      return const Left('Failed to update profile');
    }
  }

  Future<void> updateFcmToken(String fcmToken) async {
    final authData = await AuthLocalDatasource().getAuthData();
    final url = Uri.parse('${ApiConstants.baseUrl}/api/update-fcm-token');
    await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authData?.token}',
      },
      body: jsonEncode({'fcm_token': fcmToken}),
    );
  }
}
