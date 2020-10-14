import 'dart:io';

import 'package:app_loja_virtual/models/cep_aberto_address.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

const token = 'e2003f5ec2f79cf3c229e58a869438c0';

class CepAbertoService {
  Future<CepAbertoAddress> getAddressFromCep(String cep) async {
    final cleanCep = cep.replaceAll('.', '').replaceAll('-', '');

    final endpoint = "https://www.cepaberto.com/api/v3/cep?cep=$cleanCep";
    final Dio dio = Dio();

    dio.options.headers[HttpHeaders.authorizationHeader] = 'Token token=$token';

    try {
      final response = await dio.get<Map<String, dynamic>>(endpoint);
      if (response.data.isEmpty) {
        return Future.error('CEP Invalido');
      }
      debugPrint(response.data.toString());
      //debugPrint(response.data['cidade']['nome']);

      final CepAbertoAddress address = CepAbertoAddress.fromMap(response.data);
      return address;
    } on DioError catch (e, ex) {
      debugPrint("$e >>> $ex");
      return Future.error('Erro ao buscar CEP');
    } catch (e, ex) {
      debugPrint("$e >>> $ex");
      return Future.error('Erro CEP');
    }
  }
}
