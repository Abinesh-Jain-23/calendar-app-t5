import 'package:dio/dio.dart';

class ApiService {
  final dio = Dio();

  Future<List> getEvents() async {
    final response =
        await dio.get('https://calendar-api-a5m2.onrender.com/get_requests');
    return response.data;
  }

  post(List events) async {
    final response = await dio.post(
      'https://calendar-api-a5m2.onrender.com/create-event',
      data: events,
    );
    return response.data;
  }
}
