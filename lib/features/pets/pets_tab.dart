import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '/models/thu_cung_model.dart';

enum SortBy { priceAsc, priceDesc, ageAsc, ageDesc }

class _PetRow {
  final ThuCungModel pet;
  final String breed;
  const _PetRow({required this.pet, required this.breed});
}

class PetsTab extends StatefulWidget {
  const PetsTab({super.key});

  @override
  State<PetsTab> createState() => _PetsTabState();
}

class _PetsTabState extends State<PetsTab> {
  static const Color kPrimaryDark = Color(0xFF1E90FF);
  static const Color kSoftBg = Color(0xFFE8F2FF);

  static const double kMaxAgeMonths = 18.0;

  String _selectedPetType = 'dog';
  final TextEditingController _searchCtrl = TextEditingController();

  SortBy _sortBy = SortBy.priceAsc;

  RangeValues _priceRange = const RangeValues(0, 0);

  RangeValues _ageRange = const RangeValues(0, kMaxAgeMonths);

  String _selectedBreed = 'Tất cả';

  Set<String> _breedsCache = {};
  int _maxPriceCache = 0;

  bool _rangesInitialized = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _petStream() {
    return FirebaseFirestore.instance
        .collection('pets')
        .where('type', isEqualTo: _selectedPetType)
        .snapshots();
  }

  bool _matchSearch(String text, String keyword) {
    final t = text.toLowerCase().trim();
    final k = keyword.toLowerCase().trim();
    if (k.isEmpty) return true;
    return t.contains(k);
  }

  Widget _buildPetImage(String path) {
    if (path.startsWith('http')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(
          Icons.broken_image_outlined,
          size: 40,
          color: Colors.grey,
        ),
      );
    }
    return Image.asset(
      path,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const Icon(
        Icons.broken_image_outlined,
        size: 40,
        color: Colors.grey,
      ),
    );
  }

  String _money(int v) {
    final s = v.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final pos = s.length - i;
      buf.write(s[i]);
      if (pos > 1 && pos % 3 == 1) buf.write('.');
    }
    return '${buf.toString()} đ';
  }

  String _sortLabel(SortBy s) {
    switch (s) {
      case SortBy.priceAsc:
        return 'Giá ↑';
      case SortBy.priceDesc:
        return 'Giá ↓';
      case SortBy.ageAsc:
        return 'Tuổi ↑';
      case SortBy.ageDesc:
        return 'Tuổi ↓';
    }
  }

  Widget _tagChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: kSoftBg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.blueGrey.withOpacity(0.12)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
      ),
    );
  }

  bool _isDefaultFilters(double maxPriceD) {
    if (!_rangesInitialized) return true;

    final isSortDefault = _sortBy == SortBy.priceAsc;

    final isPriceDefault = (_priceRange.start <= 0.0) &&
        ((_priceRange.end - maxPriceD).abs() < 0.001);

    final isAgeDefault = (_ageRange.start <= 0.0) &&
        ((_ageRange.end - kMaxAgeMonths).abs() < 0.001);

    final isBreedDefault = _selectedBreed == 'Tất cả';

    return isSortDefault && isPriceDefault && isAgeDefault && isBreedDefault;
  }

  void _syncFromModal({
    required SortBy sort,
    required RangeValues price,
    required RangeValues age,
    required String breed,
  }) {
    setState(() {
      _sortBy = sort;
      _priceRange = price;
      _ageRange = age;
      _selectedBreed = breed;
      _rangesInitialized = true;
    });
  }

  void _openFilterSheet({
    required Set<String> breeds,
    required int maxPrice,
  }) {
    final safeBreeds = {'Tất cả', ...breeds}.toList()..sort();

    SortBy sort = _sortBy;
    RangeValues price = _priceRange;
    RangeValues age = _ageRange;
    String breed = _selectedBreed;

    final double maxPriceD = (maxPrice <= 0 ? 1 : maxPrice).toDouble();
    final double maxAgeD = kMaxAgeMonths;

    RangeValues clampRange(RangeValues v, double max) {
      final s = v.start.clamp(0.0, max);
      final e = v.end.clamp(0.0, max);
      return RangeValues(s <= e ? s : e, e);
    }

    price = clampRange(price, maxPriceD);
    age = clampRange(age, maxAgeD);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            Widget box(Widget child) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey[50],
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: child,
              );
            }

            Widget sortChip(String text, SortBy v) {
              final isSel = sort == v;
              return ChoiceChip(
                label: Text(text),
                selected: isSel,
                onSelected: (_) {
                  setModalState(() => sort = v);
                  _syncFromModal(sort: sort, price: price, age: age, breed: breed);
                },
                selectedColor: kPrimaryDark.withOpacity(0.12),
                side: BorderSide(color: isSel ? kPrimaryDark : Colors.grey.shade300),
                labelStyle: TextStyle(
                  fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                  color: Colors.black87,
                ),
              );
            }

            return DraggableScrollableSheet(
              initialChildSize: 0.75,
              minChildSize: 0.45,
              maxChildSize: 0.92,
              builder: (context, scrollCtrl) {
                return Container(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                  ),
                  child: ListView(
                    controller: scrollCtrl,
                    children: [
                      Center(
                        child: Container(
                          width: 42,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Bộ lọc & Sắp xếp',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 12),

                      box(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Sắp xếp', style: TextStyle(fontWeight: FontWeight.w800)),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                sortChip('Giá ↑', SortBy.priceAsc),
                                sortChip('Giá ↓', SortBy.priceDesc),
                                sortChip('Tuổi ↑', SortBy.ageAsc),
                                sortChip('Tuổi ↓', SortBy.ageDesc),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      box(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Giá (VNĐ)', style: TextStyle(fontWeight: FontWeight.w800)),
                            const SizedBox(height: 8),
                            Text(
                              '${_money(price.start.toInt())} — ${_money(price.end.toInt())}',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            RangeSlider(
                              values: price,
                              min: 0,
                              max: maxPriceD,
                              divisions: 100,
                              labels: RangeLabels(
                                _money(price.start.toInt()),
                                _money(price.end.toInt()),
                              ),
                              onChanged: (v) {
                                setModalState(() => price = clampRange(v, maxPriceD));
                                _syncFromModal(sort: sort, price: price, age: age, breed: breed);
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      box(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Tuổi (tháng)', style: TextStyle(fontWeight: FontWeight.w800)),
                            const SizedBox(height: 8),
                            Text(
                              '${age.start.toInt()} — ${age.end.toInt()} tháng',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            RangeSlider(
                              values: age,
                              min: 0,
                              max: maxAgeD,
                              divisions: 18,
                              labels: RangeLabels(
                                '${age.start.toInt()}',
                                '${age.end.toInt()}',
                              ),
                              onChanged: (v) {
                                setModalState(() => age = clampRange(v, maxAgeD));
                                _syncFromModal(sort: sort, price: price, age: age, breed: breed);
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      if (_selectedPetType == 'dog')
                        box(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Giống chó (breed)', style: TextStyle(fontWeight: FontWeight.w800)),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: safeBreeds.map((b) {
                                  final isSel = breed == b;
                                  return ChoiceChip(
                                    label: Text(b),
                                    selected: isSel,
                                    onSelected: (_) {
                                      setModalState(() => breed = b);
                                      _syncFromModal(sort: sort, price: price, age: age, breed: breed);
                                    },
                                    selectedColor: kPrimaryDark.withOpacity(0.12),
                                    labelStyle: TextStyle(
                                      fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                    side: BorderSide(color: isSel ? kPrimaryDark : Colors.grey.shade300),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 14),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setModalState(() {
                                  sort = SortBy.priceAsc;
                                  price = RangeValues(0, maxPriceD);
                                  age = const RangeValues(0, kMaxAgeMonths);
                                  breed = 'Tất cả';
                                });
                                _syncFromModal(sort: sort, price: price, age: age, breed: breed);
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              child: const Text('Đặt lại'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryDark,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              child: const Text('Đóng'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyword = _searchCtrl.text;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black.withOpacity(0.06)),
                    ),
                    child: TextField(
                      controller: _searchCtrl,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        hintText: 'Tìm kiếm thú cưng...',
                        prefixIcon: Icon(Icons.search, color: kPrimaryDark),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () => _openFilterSheet(
                    breeds: _breedsCache,
                    maxPrice: _maxPriceCache,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      color: kPrimaryDark,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: kPrimaryDark.withOpacity(0.22),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.tune, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black.withOpacity(0.06)),
              ),
              child: Row(
                children: [
                  Expanded(child: _buildPetTypeSegment('dog', 'Chó')),
                  Expanded(child: _buildPetTypeSegment('cat', 'Mèo')),
                ],
              ),
            ),
          ),

          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black.withOpacity(0.06)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _petStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Lỗi: ${snapshot.error}'));
                  }

                  final docs = snapshot.data?.docs ?? [];

                  final breeds = <String>{};
                  int maxPrice = 0;

                  for (final d in docs) {
                    final data = d.data();
                    final b = (data['breed'] ?? '').toString().trim();
                    if (b.isNotEmpty) breeds.add(b);

                    final rawPrice = data['price'];
                    final int price = (rawPrice is int)
                        ? rawPrice
                        : (rawPrice is double)
                            ? rawPrice.toInt()
                            : int.tryParse((rawPrice ?? '0').toString()) ?? 0;

                    if (price > maxPrice) maxPrice = price;
                  }

                  _breedsCache = breeds;
                  _maxPriceCache = maxPrice;

                  final double maxPriceD = (maxPrice <= 0 ? 1 : maxPrice).toDouble();
                  final double maxAgeD = kMaxAgeMonths;

                  if (!_rangesInitialized) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!mounted) return;
                      setState(() {
                        _rangesInitialized = true;
                        _priceRange = RangeValues(0, maxPriceD);
                        _ageRange = const RangeValues(0, kMaxAgeMonths);
                      });
                    });
                  }

                  final RangeValues priceR = _rangesInitialized
                      ? RangeValues(
                          _priceRange.start.clamp(0.0, maxPriceD),
                          _priceRange.end.clamp(0.0, maxPriceD),
                        )
                      : RangeValues(0, maxPriceD);

                  final RangeValues ageR = RangeValues(
                    _ageRange.start.clamp(0.0, maxAgeD),
                    _ageRange.end.clamp(0.0, maxAgeD),
                  );

                  final rows = docs
                      .map((d) {
                        final model = ThuCungModel.tuDoc(d);
                        final breed = (d.data()['breed'] ?? '').toString().trim();
                        return _PetRow(pet: model, breed: breed);
                      })
                      .where((x) {
                        final p = x.pet;

                        if (!_matchSearch(p.ten, keyword)) return false;

                        if (p.gia < priceR.start || p.gia > priceR.end) return false;

                        if (p.tuoiThang < ageR.start || p.tuoiThang > ageR.end) return false;

                        if (_selectedPetType == 'dog' && _selectedBreed != 'Tất cả') {
                          if (x.breed != _selectedBreed) return false;
                        }

                        return true;
                      })
                      .toList();

                  rows.sort((a, b) {
                    final pa = a.pet;
                    final pb = b.pet;
                    switch (_sortBy) {
                      case SortBy.priceAsc:
                        return pa.gia.compareTo(pb.gia);
                      case SortBy.priceDesc:
                        return pb.gia.compareTo(pa.gia);
                      case SortBy.ageAsc:
                        return pa.tuoiThang.compareTo(pb.tuoiThang);
                      case SortBy.ageDesc:
                        return pb.tuoiThang.compareTo(pa.tuoiThang);
                    }
                  });

                  if (rows.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search_off, size: 54, color: Colors.grey[500]),
                          const SizedBox(height: 10),
                          const Text('Không có thú cưng phù hợp'),
                          const SizedBox(height: 10),
                          OutlinedButton.icon(
                            onPressed: () => _openFilterSheet(
                              breeds: _breedsCache,
                              maxPrice: _maxPriceCache,
                            ),
                            icon: const Icon(Icons.tune),
                            label: const Text('Chỉnh bộ lọc'),
                          ),
                        ],
                      ),
                    );
                  }

                  final bool showChips = !_isDefaultFilters(maxPriceD);

                  return Column(
                    children: [
                      if (showChips) ...[
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _tagChip(_sortLabel(_sortBy)),
                              const SizedBox(width: 8),
                              _tagChip(
                                'Giá: ${_money(priceR.start.toInt())} - ${_money(priceR.end.toInt())}',
                              ),
                              const SizedBox(width: 8),
                              _tagChip(
                                'Tuổi: ${ageR.start.toInt()}-${ageR.end.toInt()} tháng',
                              ),
                              if (_selectedPetType == 'dog' && _selectedBreed != 'Tất cả') ...[
                                const SizedBox(width: 8),
                                _tagChip('Giống: $_selectedBreed'),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                      Expanded(
                        child: ListView.separated(
                          itemCount: rows.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, index) => _buildPetCard(rows[index].pet),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetTypeSegment(String type, String label) {
    final isSelected = _selectedPetType == type;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        if (_selectedPetType == type) return;

        setState(() {
          _selectedPetType = type;

          _rangesInitialized = false;
          _priceRange = const RangeValues(0, 0);
          _ageRange = const RangeValues(0, kMaxAgeMonths);
          _selectedBreed = 'Tất cả';
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryDark : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPetCard(ThuCungModel pet) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/pet-detail',
            arguments: {
              'id': pet.id,
              'type': pet.loai,
              'name': pet.ten,
              'age': pet.tuoiThang,
              'price': pet.gia,
              'image': pet.hinhAnh,
              'ghiChu': pet.ghiChu,
              'images': pet.images,
              'gioiTinh': pet.gioiTinh,
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black.withOpacity(0.06)),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: 86,
                  height: 86,
                  color: kSoftBg,
                  child: _buildPetImage(pet.hinhAnh),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet.ten,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _tagChip('Tuổi: ${pet.tuoiHienThi}'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      pet.giaHienThi,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: kPrimaryDark,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.chevron_right, size: 26, color: Colors.grey[600]),
            ],
          ),
        ),
      ),
    );
  }
}
