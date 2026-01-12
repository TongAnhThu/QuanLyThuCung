import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SeedServices {
  /// force=true: luôn ghi đè/merge data
  static Future<void> run({bool force = false}) async {
    final fs = FirebaseFirestore.instance;

    // debug: xem app đang trỏ tới project nào
    try {
      debugPrint('🔥 Firestore projectId: ${fs.app.options.projectId}');
    } catch (_) {}

    // ✅ ĐỔI SANG v2 để seed lại theo data mới
    final metaRef = fs.collection('app_meta').doc('services_seed_v2');

    if (!force) {
      final metaSnap = await metaRef.get();

      // Nếu meta v2 đã có + services đã có data -> skip
      if (metaSnap.exists) {
        final anySvc = await fs.collection('services').limit(1).get();
        if (anySvc.docs.isNotEmpty) {
          debugPrint(
            '✅ Seed skipped: meta v2 exists + services already seeded',
          );
          return;
        }
        debugPrint('⚠️ Meta v2 exists nhưng services rỗng -> seed lại');
      }
    }

    final batch = fs.batch();

    // =========================
    // ✅ DỊCH VỤ LẺ (thực tế hơn)
    // dogBase/catBase là giá base, UI cậu sẽ + theo cân nặng
    // =========================
    final singles = <Map<String, dynamic>>[
      {
        'id': 'svc_tam_say',
        'name': 'Tắm + sấy',
        'dogBase': 80000,
        'catBase': 70000,
      },
      {
        'id': 'svc_tam_kho',
        'name': 'Tắm khô',
        'dogBase': 50000,
        'catBase': 45000,
      },
      {
        'id': 'svc_tam_tri_ve',
        'name': 'Tắm trị ve rận',
        'dogBase': 120000,
        'catBase': 110000,
      },
      {
        'id': 'svc_cat_tia_long',
        'name': 'Cắt tỉa lông',
        'dogBase': 120000,
        'catBase': 110000,
      },
      {
        'id': 'svc_go_roi_long',
        'name': 'Gỡ rối lông',
        'dogBase': 40000,
        'catBase': 40000,
      },
      {
        'id': 'svc_chai_long',
        'name': 'Chải lông',
        'dogBase': 25000,
        'catBase': 22000,
      },
      {
        'id': 'svc_cat_mong',
        'name': 'Cắt móng',
        'dogBase': 15000,
        'catBase': 15000,
      },
      {
        'id': 'svc_vs_tai',
        'name': 'Vệ sinh tai',
        'dogBase': 15000,
        'catBase': 15000,
      },
      {
        'id': 'svc_vs_mat',
        'name': 'Vệ sinh mắt',
        'dogBase': 12000,
        'catBase': 12000,
      },
      {
        'id': 'svc_duong_long',
        'name': 'Ủ dưỡng lông',
        'dogBase': 45000,
        'catBase': 42000,
      },
      {
        'id': 'svc_khu_mui',
        'name': 'Khử mùi + nước hoa',
        'dogBase': 20000,
        'catBase': 20000,
      },
      {
        'id': 'svc_danh_rang',
        'name': 'Đánh răng',
        'dogBase': 25000,
        'catBase': 25000,
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

    // =========================
    // ✅ COMBO (itemsResolved phải khớp name dịch vụ lẻ để tính giá)
    // =========================
    final combos = <Map<String, dynamic>>[
      {
        'id': 'combo_tam_co_ban',
        'name': 'Gói Tắm Cơ Bản',
        'itemsRaw': ['Tắm + sấy', 'Cắt móng', 'Vệ sinh tai', 'Vệ sinh mắt'],
        'itemsResolved': [
          'Tắm + sấy',
          'Cắt móng',
          'Vệ sinh tai',
          'Vệ sinh mắt',
        ],
      },
      {
        'id': 'combo_spa',
        'name': 'Gói Spa Dưỡng Lông',
        'itemsRaw': [
          'Tắm + sấy',
          'Ủ dưỡng lông',
          'Chải lông',
          'Khử mùi + nước hoa',
        ],
        'itemsResolved': [
          'Tắm + sấy',
          'Ủ dưỡng lông',
          'Chải lông',
          'Khử mùi + nước hoa',
        ],
      },
      {
        'id': 'combo_grooming',
        'name': 'Gói Grooming',
        'itemsRaw': [
          'Tắm + sấy',
          'Cắt tỉa lông',
          'Cắt móng',
          'Vệ sinh tai',
          'Vệ sinh mắt',
        ],
        'itemsResolved': [
          'Tắm + sấy',
          'Cắt tỉa lông',
          'Cắt móng',
          'Vệ sinh tai',
          'Vệ sinh mắt',
        ],
      },
      {
        'id': 'combo_tri_ve',
        'name': 'Gói Trị Ve Rận',
        'itemsRaw': [
          'Tắm trị ve rận',
          'Cắt móng',
          'Vệ sinh tai',
          'Khử mùi + nước hoa',
        ],
        'itemsResolved': [
          'Tắm trị ve rận',
          'Cắt móng',
          'Vệ sinh tai',
          'Khử mùi + nước hoa',
        ],
      },
      {
        'id': 'combo_full',
        'name': 'Gói FULL Chăm Sóc',
        'itemsRaw': [
          'Tắm + sấy',
          'Cắt tỉa lông',
          'Gỡ rối lông',
          'Ủ dưỡng lông',
          'Chải lông',
          'Cắt móng',
          'Vệ sinh tai',
          'Vệ sinh mắt',
          'Đánh răng',
          'Khử mùi + nước hoa',
        ],
        'itemsResolved': [
          'Tắm + sấy',
          'Cắt tỉa lông',
          'Gỡ rối lông',
          'Ủ dưỡng lông',
          'Chải lông',
          'Cắt móng',
          'Vệ sinh tai',
          'Vệ sinh mắt',
          'Đánh răng',
          'Khử mùi + nước hoa',
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

    // meta v2
    batch.set(metaRef, {
      'seededAt': FieldValue.serverTimestamp(),
      'version': 2,
      'force': force,
    }, SetOptions(merge: true));

    try {
      await batch.commit();
      debugPrint('✅ SeedServices v2 committed');

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
