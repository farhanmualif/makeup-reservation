import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:reservastion/common/failure.dart';
import 'package:reservastion/model/token_model.dart';

class TokenServices {
  var client = http.Client();

  Future getToken(
      {required String orderId,
      required String idPacket,
      required double price}) async {
    try {
      var response = await http.post(
          Uri.parse(
            "https://nextjs-midtrans-api-example-o2x4fdoph-farhan-mualifs-projects.vercel.app/api",
          ),
          headers: <String, String>{
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "order_id": orderId,
            "id_packet": idPacket,
            "gross_amount": price
          }));
      print("cek response: ${response.body}");
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        return right(TokenModel(token: jsonResponse['token']));
      } else {
        return left(ServerFailure(
            data: response.body,
            code: response.statusCode,
            message: 'Unknown Error'));
      }
    } catch (e) {
      return Exception(e);
    }
  }
}
