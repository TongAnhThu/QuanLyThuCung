import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SeedServices {
  static Future<void> run({bool force = false}) async {
    final fs = FirebaseFirestore.instance;

    // debug: xem app đang trỏ tới project nào
    try {
      debugPrint('🔥 Firestore projectId: ${fs.app.options.projectId}');
    } catch (_) {}

    final metaRef = fs.collection('app_meta').doc('services_seed_v1');

    if (!force) {
      final metaSnap = await metaRef.get();

      // Nếu meta tồn tại, vẫn check xem services có data chưa.
      if (metaSnap.exists) {
        final anySvc = await fs.collection('services').limit(1).get();
        if (anySvc.docs.isNotEmpty) {
          debugPrint('✅ Seed skipped: meta exists + services already seeded');
          return;
        }
        debugPrint('⚠️ Meta exists nhưng services đang rỗng -> seed lại');
      }
    }

    final batch = fs.batch();

    // ====== DỊCH VỤ LẺ ======
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
        // createdAt chỉ set nếu chưa có (merge vẫn ghi lại được, nên cứ để seed 1 lần)
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    // ====== COMBO ======
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

    // meta
    batch.set(metaRef, {
      'seededAt': FieldValue.serverTimestamp(),
      'version': 1,
      'force': force,
    }, SetOptions(merge: true));

    try {
      await batch.commit();
      debugPrint('✅ SeedServices.commit() done');

      final check = await fs.collection('services').get();
      debugPrint('✅ services count = ${check.docs.length}');
    } on FirebaseException catch (e) {
      debugPrint('❌ FirebaseException: ${e.code} | ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('❌ Unknown error: $e');
      rethrow;
    }
  }
}
