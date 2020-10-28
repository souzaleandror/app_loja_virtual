import 'package:app_loja_virtual/helpers/extensions.dart';
import 'package:app_loja_virtual/models/address.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum StoreStatus { closed, open, closing }

class Store {
  String name;
  String image;
  String phone;
  Address address;
  Map<String, Map<String, TimeOfDay>> opening;
  StoreStatus status;

  String get addressText =>
      '${address.street}, ${address.number} ${address.complement.isNotEmpty ? address.complement : ""}, ${address.district} ${address.city} ${address.state} ${address.zipCode} ';

  String get openingText {
    return '${'Seg-Sex: ${formattedPeriod(opening['monfri'])}\n'}${'Sab: ${formattedPeriod(opening['saturday'])}\n'}${'Dom: ${formattedPeriod(opening['sunday'])}\n'}';
  }

  String get cleanPhone => phone.replaceAll(RegExp(r"[^\d]"), "");

  String formattedPeriod(Map<String, TimeOfDay> period) {
    if (period == null) return 'Fechado';
    return '${period['from'].formatted()} - ${period['to'].formatted()}';
  }

  Store.fromDocument(DocumentSnapshot doc) {
    name = doc.data()['name'] as String;
    image = doc.data()['image'] as String;
    phone = doc.data()['phone'] as String;
    address = Address.fromMap(doc.data()['address'] as Map<String, dynamic>);

    opening = (doc.data()['opening'] as Map<String, dynamic>).map((key, value) {
      final timeString = value as String;
      if (timeString != null && timeString.isNotEmpty) {
        final splitted = timeString.split(RegExp("[:-]"));

        return MapEntry(
          key,
          {
            "from": TimeOfDay(
              hour: int.parse(splitted[0]),
              minute: int.parse(splitted[1]),
            ),
            "to": TimeOfDay(
              hour: int.parse(splitted[2]),
              minute: int.parse(splitted[3]),
            ),
          },
        );
      } else {
        return MapEntry(key, null);
      }

      // SATURDAY: 8:00-17:00
      // SUNDAY:   12:00-18:00

      // SATURDAY: FROM: 8:00 TO 17:00
      // SUNDAY:   FROM; 12:00 TO 18:00
    });

    updateStatus();
  }

  void updateStatus() {
    final weekDay = DateTime.now().weekday;
    Map<String, TimeOfDay> period;
    if (weekDay >= 1 && weekDay <= 5) {
      period = opening['monfri'];
    } else if (weekDay == 6) {
      period = opening['saturday'];
    } else {
      period = opening['sunday'];
    }

    final now = TimeOfDay.now();
    debugPrint(now.toString());
    debugPrint(period.toString());

    if (period == null) {
      status = StoreStatus.closed;
    } else if (period['from'].toMinutes() < now.toMinutes() &&
        period['to'].toMinutes() - 15 > now.toMinutes()) {
      status = StoreStatus.open;
    } else if (period['from'].toMinutes() < now.toMinutes() &&
        period['to'].toMinutes() > now.toMinutes()) {
      status = StoreStatus.closing;
    } else {
      status = StoreStatus.closed;
    }
    debugPrint(status.toString());
  }

  String get statusText {
    switch (status) {
      case StoreStatus.open:
        return 'Aberto';
        break;
      case StoreStatus.closing:
        return 'Fechando';
        break;
      case StoreStatus.closed:
        return 'Fechado';
        break;
      default:
        return '';
    }
  }
}
