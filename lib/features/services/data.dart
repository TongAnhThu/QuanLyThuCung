import 'package:cloud_firestore/cloud_firestore.dart';

class SeedServices {
  static Future<void> run() async {
    final fs = FirebaseFirestore.instance;
    final batch = fs.batch();

    // ====== DỊCH VỤ LẺ (base price theo loài) ======
    final singles = <Map<String, dynamic>>[
      {
        'id': 'svc_tam_say',
        'name': 'Tắm + sấy',
        'dogBase': 20000,
        'catBase': 18000,
      },
      {
        'id': 'svc_cat_mong',
        'name': 'Cắt móng',
        'dogBase': 8000,
        'catBase': 8000,
      },
      {
        'id': 'svc_vs_tai',
        'name': 'Vệ sinh tai',
        'dogBase': 7000,
        'catBase': 7000,
      },
      {
        'id': 'svc_vs_mat',
        'name': 'Vệ sinh mắt',
        'dogBase': 6000,
        'catBase': 6000,
      },
      {
        'id': 'svc_duong_long',
        'name': 'Dưỡng lông',
        'dogBase': 15000,
        'catBase': 14000,
      },
      {
        'id': 'svc_nhuom_long',
        'name': 'Nhuộm lông',
        'dogBase': 25000,
        'catBase': 24000,
      },
      {
        'id': 'svc_tia_long',
        'name': 'Tỉa lông',
        'dogBase': 22000,
        'catBase': 20000,
      },
      {
        'id': 'svc_chai_long',
        'name': 'Chải lông',
        'dogBase': 12000,
        'catBase': 11000,
      },
    ];

    for (final s in singles) {
      final ref = fs.collection('services').doc(s['id'] as String);
      batch.set(ref, {
        'kind': 'single',
        'name': s['name'],
        'dogBase': s['dogBase'],
        'catBase': s['catBase'],
        'isActive': true,
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    // ====== COMBO (raw + resolved để tính giá) ======
    final combos = <Map<String, dynamic>>[
      {
        'id': 'combo_goi_1',
        'name': 'Gói 1',
        'itemsRaw': ['Tắm', 'Sấy', 'Chải lông', 'Cắt móng'],
        'itemsResolved': ['Tắm + sấy', 'Chải lông', 'Cắt móng'],
      },
      {
        'id': 'combo_goi_2',
        'name': 'Gói 2',
        'itemsRaw': ['Gói 1', 'Nhuộm lông'],
        'itemsResolved': ['Tắm + sấy', 'Chải lông', 'Cắt móng', 'Nhuộm lông'],
      },
      {
        'id': 'combo_goi_3',
        'name': 'Gói 3',
        'itemsRaw': ['Gói 1', 'Nhuộm lông', 'Dưỡng lông'],
        'itemsResolved': [
          'Tắm + sấy',
          'Chải lông',
          'Cắt móng',
          'Nhuộm lông',
          'Dưỡng lông',
        ],
      },
      {
        'id': 'combo_full',
        'name': 'FULL',
        'itemsRaw': [
          'Tắm',
          'Sấy',
          'Chải lông',
          'Cắt móng',
          'Nhuộm',
          'Dưỡng lông',
          'Tỉa lông',
        ],
        'itemsResolved': [
          'Tắm + sấy',
          'Chải lông',
          'Cắt móng',
          'Nhuộm lông',
          'Dưỡng lông',
          'Tỉa lông',
        ],
      },
    ];

    for (final c in combos) {
      final ref = fs.collection('services').doc(c['id'] as String);
      batch.set(ref, {
        'kind': 'combo',
        'name': c['name'],
        'itemsRaw': c['itemsRaw'],
        'itemsResolved': c['itemsResolved'],
        'isActive': true,
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    await batch.commit();
  }
}
