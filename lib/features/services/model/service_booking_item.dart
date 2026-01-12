import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceBookingItem {
  // ===== Firestore names (đúng theo toMap() của dichvuModel) =====
  static const String col = 'service_bookings';

  static const String fUserId = 'userId';
  static const String fServiceTitle = 'serviceTitle';
  static const String fServiceItems = 'serviceItems';
  static const String fPetName = 'petName';
  static const String fStatus = 'status';
  static const String fPrice = 'price';

  // fallback time: date + timeMinutes
  static const String fDate = 'date'; // Timestamp (00:00)
  static const String fTimeMinutes = 'timeMinutes'; // int

  // optional nếu sau này cậu có startAt/endAt
  static const String fStartAt = 'startAt'; // Timestamp?
  static const String fEndAt = 'endAt'; // Timestamp?

  final String id;
  final String userId;

  final String serviceTitle;
  final List<String> serviceItems;
  final String petName;

  final String status;
  final DateTime startAt;
  final DateTime endAt;

  final int price;

  const ServiceBookingItem({
    required this.id,
    required this.userId,
    required this.serviceTitle,
    required this.serviceItems,
    required this.petName,
    required this.status,
    required this.startAt,
    required this.endAt,
    required this.price,
  });

  DateTime get dayOnly => DateTime(startAt.year, startAt.month, startAt.day);

  static int _asInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString()) ?? 0;
  }

  static DateTime _readDate(dynamic v) {
    if (v is Timestamp) return v.toDate();
    if (v is DateTime) return v;
    if (v == null) return DateTime.fromMillisecondsSinceEpoch(0);
    return DateTime.tryParse(v.toString()) ??
        DateTime.fromMillisecondsSinceEpoch(0);
  }

  static DateTime _combineDateAndMinutes(DateTime date, int minutes) {
    final h = (minutes ~/ 60).clamp(0, 23);
    final m = (minutes % 60).clamp(0, 59);
    return DateTime(date.year, date.month, date.day, h, m);
  }

  static DateTime _extractStartAt(Map<String, dynamic> m) {
    final s = m[fStartAt];
    if (s is Timestamp) return s.toDate();

    final date = _readDate(m[fDate]);
    final mins = _asInt(m[fTimeMinutes]);
    return _combineDateAndMinutes(date, mins);
  }

  static DateTime _extractEndAt(Map<String, dynamic> m, DateTime startAt) {
    final e = m[fEndAt];
    if (e is Timestamp) return e.toDate();
    return startAt.add(const Duration(hours: 1));
  }

  factory ServiceBookingItem.fromDoc(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final m = doc.data();

    final startAt = _extractStartAt(m);
    final endAt = _extractEndAt(m, startAt);

    final title = (m[fServiceTitle] ?? '').toString();
    final items = List<String>.from(m[fServiceItems] ?? const []);
    final pet = (m[fPetName] ?? '').toString();

    return ServiceBookingItem(
      id: doc.id,
      userId: (m[fUserId] ?? '').toString(),
      serviceTitle: title,
      serviceItems: items,
      petName: pet,
      status: (m[fStatus] ?? 'pending').toString(),
      startAt: startAt,
      endAt: endAt,
      price: _asInt(m[fPrice]),
    );
  }
}
