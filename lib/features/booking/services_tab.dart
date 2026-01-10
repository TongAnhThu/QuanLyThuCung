import 'package:flutter/material.dart';
import '../booking/service_booking_sheet.dart';
import '../../../theme/home_colors.dart';


class ServicesTab extends StatefulWidget {
  const ServicesTab({super.key});

  @override
  State<ServicesTab> createState() => _ServicesTabState();
}

class _ServicesTabState extends State<ServicesTab> {
  String _selectedSpecies = 'dog';
  String _selectedWeight = '<5kg';

  final List<String> _weights = const ['<5kg', '<10kg', '<20kg', '>=20kg'];

  final List<Map<String, dynamic>> _combos = const [
    {'name': 'Gói 1', 'items': ['Tắm', 'Sấy', 'Chải lông', 'Cắt móng']},
    {'name': 'Gói 2', 'items': ['Gói 1', 'Nhuộm lông']},
    {'name': 'Gói 3', 'items': ['Gói 1', 'Nhuộm lông', 'Dưỡng lông']},
    {
      'name': 'FULL',
      'items': ['Tắm', 'Sấy', 'Chải lông', 'Cắt móng', 'Nhuộm', 'Dưỡng lông', 'Tỉa lông']
    },
  ];

  final List<String> _singleServices = const [
    'Tắm + sấy',
    'Cắt móng',
    'Vệ sinh tai',
    'Vệ sinh mắt',
    'Dưỡng lông',
    'Nhuộm lông',
    'Tỉa lông',
    'Chải lông',
  ];

  Future<void> _openBookingSheet({
    required String title,
    required List<String> items,
    int? price,
  }) async {
    final res = await showServiceBookingSheet(
      context: context,
      primaryColor: HomeColors.primaryDark,
      serviceTitle: title,
      serviceItems: items,
      species: _selectedSpecies,
      weight: _selectedWeight,
      price: price,
    );

    if (!mounted || res == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Đã nhận: ${res.serviceTitle} • ${res.petName} • ${_formatDate(res.date)} ${_formatTime(res.time)}',
        ),
      ),
    );
  }

  Map<String, List<String>> get _comboMap {
    final map = <String, List<String>>{};
    for (final c in _combos) {
      map[c['name'] as String] = List<String>.from(c['items'] as List);
    }
    return map;
  }

  List<String> _resolveComboToServiceLabels(String comboName) {
    final visited = <String>{};

    List<String> expand(String name) {
      if (visited.contains(name)) return const [];
      visited.add(name);

      final raw = _comboMap[name];
      if (raw == null) return [name];

      final out = <String>[];
      for (final x in raw) {
        if (_comboMap.containsKey(x)) {
          out.addAll(expand(x));
        } else {
          out.add(x);
        }
      }
      return out;
    }

    final flat = expand(comboName).map((e) => e.trim()).toList();

    final normalized = flat.map((e) {
      if (e == 'Nhuộm') return 'Nhuộm lông';
      if (e == 'Tắm' || e == 'Sấy') return e;
      return e;
    }).toList();

    final hasBathOrDry = normalized.contains('Tắm') || normalized.contains('Sấy');
    final cleaned = normalized.where((e) => e != 'Tắm' && e != 'Sấy').toList();
    if (hasBathOrDry) cleaned.insert(0, 'Tắm + sấy');

    final seen = <String>{};
    final distinct = <String>[];
    for (final e in cleaned) {
      if (seen.add(e)) distinct.add(e);
    }
    return distinct;
  }

  int _estimateComboPrice(String comboName) {
    final services = _resolveComboToServiceLabels(comboName);
    int total = 0;
    for (final s in services) {
      total += _priceForService(s);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: _buildSpeciesCard('dog', Icons.pets, 'Chó')),
                    const SizedBox(width: 12),
                    Expanded(child: _buildSpeciesCard('cat', Icons.flutter_dash, 'Mèo')),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Cân nặng', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _weights.map((w) => _buildWeightCard(w)).toList(),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Combo dịch vụ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    Text('Kéo ngang để xem', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 155,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _combos.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) => _buildComboCard(_combos[index]),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Dịch vụ lẻ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Column(children: _singleServices.map(_buildSingleServiceItem).toList()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpeciesCard(String species, IconData icon, String label) {
    final isSelected = _selectedSpecies == species;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: isSelected ? 4 : 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => setState(() => _selectedSpecies = species),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 28, color: isSelected ? HomeColors.primaryDark : Colors.grey[700]),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? HomeColors.primaryDark : Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeightCard(String label) {
    final isSelected = _selectedWeight == label;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => setState(() => _selectedWeight = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? HomeColors.primaryDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: HomeColors.primaryDark.withOpacity(0.35)),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? HomeColors.primaryDark.withOpacity(0.20)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.fitness_center, size: 18, color: isSelected ? Colors.white : HomeColors.primaryDark),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[800],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComboCard(Map<String, dynamic> combo) {
    final comboName = combo['name'] as String;
    final items = List<String>.from(combo['items'] as List);

    final resolved = _resolveComboToServiceLabels(comboName);
    final estPrice = _estimateComboPrice(comboName);

    return SizedBox(
      width: 230,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _openBookingSheet(title: comboName, items: resolved, price: estPrice),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.spa_outlined, color: HomeColors.primaryDark),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        comboName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Ước tính: ${_formatPrice(estPrice)}',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.grey[800]),
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: items
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                children: [
                                  const Icon(Icons.check, size: 16, color: HomeColors.primaryDark),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      e,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: HomeColors.primaryDark.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'Nhấn để đặt lịch',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: HomeColors.primaryDark),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSingleServiceItem(String label) {
    final price = _priceForService(label);
    final priceText = _formatPrice(price);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _openBookingSheet(title: label, items: [label], price: price),
      child: Card(
        margin: const EdgeInsets.only(bottom: 10),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.spa_outlined, color: HomeColors.primaryDark),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                priceText,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: HomeColors.primaryDark,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  int _priceForService(String service) {
    final species = _selectedSpecies;

    final dogBase = <String, int>{
      'Tắm + sấy': 20000,
      'Cắt móng': 8000,
      'Vệ sinh tai': 7000,
      'Vệ sinh mắt': 6000,
      'Dưỡng lông': 15000,
      'Nhuộm lông': 25000,
      'Tỉa lông': 22000,
      'Chải lông': 12000,
    };

    final catBase = <String, int>{
      'Tắm + sấy': 18000,
      'Cắt móng': 8000,
      'Vệ sinh tai': 7000,
      'Vệ sinh mắt': 6000,
      'Dưỡng lông': 14000,
      'Nhuộm lông': 24000,
      'Tỉa lông': 20000,
      'Chải lông': 11000,
    };

    final base = species == 'dog' ? (dogBase[service] ?? 10000) : (catBase[service] ?? 10000);

    final increment = _weightIncrement();
    final price = base + increment;
    return (price / 1000).round() * 1000;
  }

  int _weightIncrement() {
    switch (_selectedWeight) {
      case '<5kg':
        return 0;
      case '<10kg':
        return 10000;
      case '<20kg':
        return 25000;
      case '>=20kg':
        return 40000;
      default:
        return 0;
    }
  }

  String _formatPrice(int price) {
    final s = price.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idx = s.length - i;
      buf.write(s[i]);
      final rem = (idx - 1) % 3;
      if (rem == 0 && i != s.length - 1) buf.write('.');
    }
    return '${buf.toString()} đ';
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}
