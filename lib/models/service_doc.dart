import 'package:cloud_firestore/cloud_firestore.dart';

enum ServiceKind { single, combo }

class ServiceDoc {
  final String id;
  final ServiceKind kind;
  final String name;

  // single
  final int? dogBase;
  final int? catBase;

  // combo
  final List<String> itemsRaw;
  final List<String> itemsResolved;

  final bool isActive;

  const ServiceDoc({
    required this.id,
    required this.kind,
    required this.name,
    required this.dogBase,
    required this.catBase,
    required this.itemsRaw,
    required this.itemsResolved,
    required this.isActive,
  });

  factory ServiceDoc.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    final kindStr = (data['kind'] ?? 'single').toString();

    final kind = kindStr == 'combo' ? ServiceKind.combo : ServiceKind.single;

    return ServiceDoc(
      id: doc.id,
      kind: kind,
      name: (data['name'] ?? '').toString(),
      dogBase: data['dogBase'] is int
          ? data['dogBase'] as int
          : int.tryParse('${data['dogBase']}'),
      catBase: data['catBase'] is int
          ? data['catBase'] as int
          : int.tryParse('${data['catBase']}'),
      itemsRaw: List<String>.from(data['itemsRaw'] ?? const []),
      itemsResolved: List<String>.from(data['itemsResolved'] ?? const []),
      isActive: (data['isActive'] as bool?) ?? true,
    );
  }
}
