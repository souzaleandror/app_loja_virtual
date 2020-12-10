import 'package:app_loja_virtual/models/credit_card.dart';
import 'package:app_loja_virtual/models/user_model.dart';
import 'package:cloud_functions/cloud_functions.dart';

class CieloPayment {
  final FirebaseFunctions functions = FirebaseFunctions.instance;

  Future<void> authorize(
      {CreditCard creditCard,
      num price,
      String orderId,
      UserModel user}) async {
    try {
      final Map<String, dynamic> dataSale = {
        'merchantOrderId': orderId,
        'amount': (price * 100).toInt(),
        'softDescriptor': 'Loja Daniel',
        'installments': 1,
        'creditCard': creditCard.toJson(),
        'cpf': user.cpf,
        'paymentType': 'CreditCard',
      };

      final HttpsCallable callable =
          functions.httpsCallable('authorizeCreditCard');
      final response = await callable.call(dataSale);
      print(response);
      print(response.data);
    } catch (e, ex) {
      print("$e >>> $ex");
    }
  }
}
