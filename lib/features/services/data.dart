import 'package:cloud_firestore/cloud_firestore.dart';

class SeedServices {
  static Future<void> run({bool force = false}) async {
    final fs = FirebaseFirestore.instance;

    // Đổi version để dễ kiểm soát
    final metaRef = fs.collection('app_meta').doc('services_seed_v2');

    if (!force) {
      final metaSnap = await metaRef.get();
      if (metaSnap.exists) {
        final anySvc = await fs.collection('services').limit(1).get();
        if (anySvc.docs.isNotEmpty) return; // đã seed rồi
      }
    }

    // =========================
    // 1) DỊCH VỤ LẺ (single)
    // =========================
    final singles = <Map<String, dynamic>>[
      {
        'id': 'svc_tam_say',
        'name': 'Tắm + sấy',
        'dogBase': 30000,
        'catBase': 28000,
        'durationMin': 45,
        'desc': 'Tắm sạch + sấy khô cơ bản. Giá có thể tăng theo cân nặng.',
        'tags': ['grooming', 'bath'],
      },
      {
        'id': 'svc_tam_thuoc',
        'name': 'Tắm thuốc trị ve/rận',
        'dogBase': 45000,
        'catBase': 42000,
        'durationMin': 55,
        'desc': 'Tắm với thuốc chuyên dụng hỗ trợ ve/rận.',
        'tags': ['grooming', 'bath', 'treatment'],
      },
      {
        'id': 'svc_cat_mong',
        'name': 'Cắt móng',
        'dogBase': 15000,
        'catBase': 15000,
        'durationMin': 10,
        'desc': 'Cắt móng gọn, an toàn.',
        'tags': ['hygiene'],
      },
      {
        'id': 'svc_vs_tai',
        'name': 'Vệ sinh tai',
        'dogBase': 15000,
        'catBase': 15000,
        'durationMin': 10,
        'desc': 'Làm sạch tai, giảm mùi và ráy tai.',
        'tags': ['hygiene'],
      },
      {
        'id': 'svc_vs_mat',
        'name': 'Vệ sinh mắt',
        'dogBase': 12000,
        'catBase': 12000,
        'durationMin': 8,
        'desc': 'Lau sạch ghèn mắt, giữ vùng mắt khô thoáng.',
        'tags': ['hygiene'],
      },
      {
        'id': 'svc_chai_long',
        'name': 'Chải lông',
        'dogBase': 20000,
        'catBase': 18000,
        'durationMin': 20,
        'desc': 'Chải lông giảm rụng, gỡ lông chết nhẹ.',
        'tags': ['grooming'],
      },
      {
        'id': 'svc_go_roi',
        'name': 'Gỡ rối lông',
        'dogBase': 30000,
        'catBase': 28000,
        'durationMin': 25,
        'desc': 'Gỡ rối lông, xử lý búi rối nhẹ-vừa.',
        'tags': ['grooming'],
      },
      {
        'id': 'svc_tia_tao_kieu',
        'name': 'Tỉa lông tạo kiểu',
        'dogBase': 60000,
        'catBase': 55000,
        'durationMin': 60,
        'desc': 'Tỉa tạo kiểu cơ bản theo giống/nhu cầu.',
        'tags': ['grooming', 'style'],
      },
      {
        'id': 'svc_vat_tuyen_hoi',
        'name': 'Vắt tuyến hôi (chó)',
        'dogBase': 25000,
        'catBase': 0,
        'durationMin': 10,
        'desc': 'Chỉ áp dụng cho chó. Nếu mèo chọn sẽ báo không hỗ trợ.',
        'tags': ['hygiene', 'dog-only'],
      },
      {
        'id': 'svc_khu_mui',
        'name': 'Khử mùi',
        'dogBase': 20000,
        'catBase': 18000,
        'durationMin': 10,
        'desc': 'Xịt/ủ khử mùi nhẹ, giúp thơm lâu hơn.',
        'tags': ['spa'],
      },
      {
        'id': 'svc_hap_dau',
        'name': 'Hấp dầu dưỡng lông',
        'dogBase': 35000,
        'catBase': 32000,
        'durationMin': 20,
        'desc': 'Dưỡng lông mềm mượt, giảm khô xơ.',
        'tags': ['spa'],
      },
      {
        'id': 'svc_vs_rang',
        'name': 'Vệ sinh răng miệng (basic)',
        'dogBase': 25000,
        'catBase': 25000,
        'durationMin': 15,
        'desc': 'Vệ sinh răng miệng cơ bản. Không phải cạo vôi chuyên sâu.',
        'tags': ['health'],
      },
    ];

    // =========================
    // 2) COMBO (combo dùng itemIds)
    // =========================
    final combos = <Map<String, dynamic>>[
      {
        'id': 'combo_co_ban',
        'name': 'Gói Cơ Bản',
        'itemIds': ['svc_tam_say', 'svc_cat_mong', 'svc_vs_tai', 'svc_vs_mat'],
        'discountPercent': 10, // giảm 10%
        'desc': 'Combo vệ sinh cơ bản, hợp cho lịch định kỳ.',
        'tags': ['combo', 'popular'],
      },
      {
        'id': 'combo_spa',
        'name': 'Gói SPA',
        'itemIds': ['svc_tam_say', 'svc_hap_dau', 'svc_go_roi', 'svc_khu_mui'],
        'discountPercent': 12,
        'desc': 'Dưỡng lông + thơm lâu, hợp boss lông dài.',
        'tags': ['combo', 'spa'],
      },
      {
        'id': 'combo_full_groom',
        'name': 'Gói Full Grooming',
        'itemIds': [
          'svc_tam_thuoc',
          'svc_tia_tao_kieu',
          'svc_cat_mong',
          'svc_vs_tai',
          'svc_vs_mat',
          'svc_vs_rang',
        ],
        'discountPercent': 15,
        'desc': 'Combo đầy đủ nhất: sạch, gọn, thơm, tạo kiểu.',
        'tags': ['combo', 'premium'],
      },
      {
        'id': 'combo_nhanh_30p',
        'name': 'Gói Nhanh 30p',
        'itemIds': ['svc_cat_mong', 'svc_vs_tai', 'svc_vs_mat'],
        'discountPercent': 5,
        'desc': 'Combo nhanh gọn cho boss',
        'tags': ['combo'],
      },
    ];

    // =========================
    // 3) Pre-fetch để không reset createdAt
    // =========================
    final ids = <String>[
      ...singles.map((e) => e['id'] as String),
      ...combos.map((e) => e['id'] as String),
    ];

    final snaps = await Future.wait(
      ids.map((id) => fs.collection('services').doc(id).get()),
    );
    final existed = <String>{};
    for (final s in snaps) {
      if (s.exists) existed.add(s.id);
    }

    // Map id -> name để combo có sẵn itemsResolved (hiển thị nhanh)
    final idToName = <String, String>{
      for (final s in singles) (s['id'] as String): (s['name'] as String),
    };

    final batch = fs.batch();

    // singles
    for (final s in singles) {
      final id = s['id'] as String;
      final ref = fs.collection('services').doc(id);

      final data = <String, dynamic>{
        'kind': 'single',
        'name': s['name'],
        'dogBase': s['dogBase'],
        'catBase': s['catBase'],
        'durationMin': s['durationMin'],
        'desc': s['desc'],
        'tags': s['tags'],
        'isActive': true,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // chỉ set createdAt khi doc chưa tồn tại
      if (!existed.contains(id)) {
        data['createdAt'] = FieldValue.serverTimestamp();
      }

      batch.set(ref, data, SetOptions(merge: true));
    }

    // combos
    for (final c in combos) {
      final id = c['id'] as String;
      final ref = fs.collection('services').doc(id);

      final itemIds = List<String>.from(c['itemIds'] as List);
      final itemsResolved = itemIds.map((x) => idToName[x] ?? x).toList();

      final data = <String, dynamic>{
        'kind': 'combo',
        'name': c['name'],
        'itemIds': itemIds,
        'itemsResolved': itemsResolved, // để UI hiện combo gồm gì ngay
        'discountPercent': c['discountPercent'],
        'desc': c['desc'],
        'tags': c['tags'],
        'isActive': true,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (!existed.contains(id)) {
        data['createdAt'] = FieldValue.serverTimestamp();
      }

      batch.set(ref, data, SetOptions(merge: true));
    }

    // meta
    batch.set(metaRef, {
      'seededAt': FieldValue.serverTimestamp(),
      'version': 2,
      'force': force,
    }, SetOptions(merge: true));

    await batch.commit();
  }
}
