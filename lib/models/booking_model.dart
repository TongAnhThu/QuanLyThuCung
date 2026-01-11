import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class dichvuModel {
  final String id; // docId
  final String userId;

  final String serviceTitle;
  final List<String> serviceItems;
  final String species;
  final String weight;

  final String bookingname;
  final String bookingphone;
  final String petName;

  final DateTime date; // ngày đi
  final TimeOfDay time; // giờ hẹn

  final int? price;
  final String? note;
  final String? pickupPoint;

  final Timestamp? createdAt; // thời điểm tạo lịch (Firestore)

  const dichvuModel({
    required this.id,
    required this.userId,
    required this.serviceTitle,
    required this.serviceItems,
    required this.species,
    required this.weight,
    required this.petName,
    required this.bookingname,
    required this.bookingphone,
    required this.date,
    required this.time,
    required this.createdAt,
    this.price,
    this.note,
    this.pickupPoint,
  });

  int get timeMinutes => time.hour * 60 + time.minute;

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'serviceTitle': serviceTitle,
      'serviceItems': serviceItems,
      'species': species,
      'weight': weight,
      'petName': petName,
      'customerName': bookingname,
      'phone': bookingphone,
      // lưu date dưới dạng Timestamp (00:00 của ngày đó)
      'date': Timestamp.fromDate(DateTime(date.year, date.month, date.day)),
      // giờ hẹn lưu minutes cho gọn
      'timeMinutes': timeMinutes,
      if (price != null) 'price': price,
      if (note != null && note!.trim().isNotEmpty) 'note': note!.trim(),
      if (pickupPoint != null && pickupPoint!.trim().isNotEmpty)
        'pickupPoint': pickupPoint!.trim(),
      'createdAt': createdAt,
    };
  }

  factory dichvuModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    final Timestamp dateTs = (data['date'] as Timestamp?) ?? Timestamp(0, 0);
    final int mins = (data['timeMinutes'] as int?) ?? 0;

    return dichvuModel(
      id: doc.id,
      userId: (data['userId'] ?? '').toString(),
      serviceTitle: (data['serviceTitle'] ?? '').toString(),
      serviceItems: List<String>.from(data['serviceItems'] ?? const []),
      species: (data['species'] ?? 'dog').toString(),
      weight: (data['weight'] ?? '<5kg').toString(),
      petName: (data['petName'] ?? '').toString(),
      bookingname: (data['customerName'] ?? '').toString(),
      bookingphone: (data['phone'] ?? '').toString(),
      date: dateTs.toDate(),
      time: TimeOfDay(hour: mins ~/ 60, minute: mins % 60),
      price: data['price'] is int
          ? data['price'] as int
          : int.tryParse('${data['price']}'),
      note: data['note']?.toString(),
      pickupPoint: data['pickupPoint']?.toString(),
      createdAt: (data['createdAt'] as Timestamp?) ?? Timestamp(0, 0),
    );
  }
}
