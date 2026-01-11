import 'package:flutter/material.dart';

class PetDetailPage extends StatefulWidget {
  static const String routeName = '/pet-detail';

  final Map<String, dynamic> pet;

  const PetDetailPage({super.key, required this.pet});

  @override
  State<PetDetailPage> createState() => _PetDetailPageState();
}

class _PetDetailPageState extends State<PetDetailPage> {
  static const Color kAccent = Color(0xFF0D8F87);

  late final PageController _imgCtrl;
  int _imgIndex = 0;

  static const String kHotlinePhone = "0900708400"; 

  String _str(dynamic v) => (v ?? '').toString();

  int _int(dynamic v) {
    if (v is int) return v;
    if (v is double) return v.toInt();
    return int.tryParse((v ?? '0').toString()) ?? 0;
  }

  String _formatVnd(int value) {
    final s = value.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final pos = s.length - i;
      buf.write(s[i]);
      if (pos > 1 && pos % 3 == 1) buf.write('.');
    }
    return '${buf.toString()} đ';
  }

  String _ageLabel(int months) {
    if (months <= 0) return '0 tháng';
    if (months < 12) return '$months tháng';
    final y = months ~/ 12;
    final m = months % 12;
    if (m == 0) return '$y năm';
    return '$y năm $m tháng';
  }

  
  List<String> _getImages() {
    final pet = widget.pet;

    final rawImages = pet['images'];
    if (rawImages is List) {
      final list = rawImages
          .map((e) => (e ?? '').toString().trim())
          .where((s) => s.isNotEmpty)
          .toList();
      if (list.isNotEmpty) return list;
    }

    final one = (pet['image'] ?? '').toString().trim();
    if (one.isEmpty) return [];

    final list = one
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    return list.isNotEmpty ? list : [one];
  }

  Widget _petImage(String path) {
    if (path.isEmpty) {
      return Container(
        color: Colors.grey[300],
        alignment: Alignment.center,
        child: Icon(Icons.pets, size: 120, color: Colors.grey[600]),
      );
    }

    if (path.startsWith('http')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: Colors.grey[300],
          alignment: Alignment.center,
          child: Icon(Icons.broken_image_outlined, size: 80, color: Colors.grey[600]),
        ),
      );
    }

    return Image.asset(
      path,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: Colors.grey[300],
        alignment: Alignment.center,
        child: Icon(Icons.broken_image_outlined, size: 80, color: Colors.grey[600]),
      ),
    );
  }

  String _prettyNote(String s) {
    final t = s.trim();
    if (t.isEmpty) return '';
    return t.replaceAll('\r\n', '\n').replaceAll(RegExp(r'\n{3,}'), '\n\n');
  }

  @override
  void initState() {
    super.initState();
    _imgCtrl = PageController();
  }

  @override
  void dispose() {
    _imgCtrl.dispose();
    super.dispose();
  }

  void _openGallery({required List<String> images, required int initialIndex}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _PetGalleryPage(
          images: images,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  void _openContactSheet({
    required String petName,
    required String priceText,
  }) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        Widget tile({
          required IconData icon,
          required String title,
          required String subtitle,
          required VoidCallback onTap,
        }) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: kAccent.withOpacity(0.10),
              child: Icon(icon, color: kAccent),
            ),
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
            subtitle: Text(subtitle),
            onTap: () {
              Navigator.pop(ctx);
              onTap();
            },
          );
        }

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 6),
              const Text(
                "Liên hệ cửa hàng",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              tile(
                icon: Icons.call,
                title: "Gọi điện",
                subtitle: kHotlinePhone,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Gọi: $kHotlinePhone")),
                  );
                },
              ),
              tile(
                icon: Icons.chat_bubble_outline,
                title: "Chat trong app",
                subtitle: "Mở màn hình chat (nếu có)",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Chưa gắn trang chat")),
                  );
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final pet = widget.pet;

    final name = _str(pet['name']);

    final gioiTinhRaw = _str(pet['gioiTinh'] ?? pet['gender']);
    final gioiTinh = gioiTinhRaw.trim().isEmpty ? 'Không rõ' : gioiTinhRaw.trim();

    final images = _getImages();

    final ageMonths = _int(pet['age']);
    final price = _int(pet['price']);

    final ghiChuRaw = _str(pet['ghiChu']);
    final ghiChu = _prettyNote(ghiChuRaw);

    final ageText = _ageLabel(ageMonths);
    final priceText = _formatVnd(price);

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.52,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (images.isEmpty)
                  _petImage('')
                else
                  PageView.builder(
                    controller: _imgCtrl,
                    itemCount: images.length,
                    onPageChanged: (i) => setState(() => _imgIndex = i),
                    itemBuilder: (_, i) => GestureDetector(
                      onTap: () => _openGallery(images: images, initialIndex: i),
                      child: _petImage(images[i]),
                    ),
                  ),

                IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.08),
                          Colors.black.withOpacity(0.38),
                        ],
                      ),
                    ),
                  ),
                ),

                if (images.length > 1)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 14,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(images.length, (i) {
                            final active = i == _imgIndex;
                            return InkWell(
                              onTap: () {
                                _imgCtrl.animateToPage(
                                  i,
                                  duration: const Duration(milliseconds: 260),
                                  curve: Curves.easeOut,
                                );
                              },
                              borderRadius: BorderRadius.circular(999),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: active ? 18 : 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  color: active ? Colors.white : Colors.white70,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          Positioned(
            top: screenHeight * 0.52,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
              ),
              padding: const EdgeInsets.only(
                top: 78,
                left: 20,
                right: 20,
                bottom: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thông tin chi tiết',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 10),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        ghiChu.isNotEmpty ? ghiChu : 'Chưa có mô tả cho $name.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[800],
                          height: 1.55,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _openContactSheet(
                        petName: name,
                        priceText: priceText,
                      ),
                      icon: const Icon(Icons.call),
                      label: const Text('Liên hệ'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: screenHeight * 0.52 - 60,
            left: 20,
            right: 20,
            child: Card(
              elevation: 10,
              shadowColor: Colors.black.withOpacity(0.12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                priceText,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: kAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: kAccent.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: kAccent.withOpacity(0.22)),
                          ),
                          child: Text(
                            gioiTinh,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: kAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(child: _buildInfoChip(Icons.cake_outlined, ageText)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: kAccent),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PetGalleryPage extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const _PetGalleryPage({
    required this.images,
    required this.initialIndex,
  });

  @override
  State<_PetGalleryPage> createState() => _PetGalleryPageState();
}

class _PetGalleryPageState extends State<_PetGalleryPage> {
  late final PageController _ctrl;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _ctrl = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _img(String path) {
    if (path.startsWith('http')) {
      return Image.network(path, fit: BoxFit.contain);
    }
    return Image.asset(path, fit: BoxFit.contain);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('${_index + 1}/${widget.images.length}'),
      ),
      body: PageView.builder(
        controller: _ctrl,
        itemCount: widget.images.length,
        onPageChanged: (i) => setState(() => _index = i),
        itemBuilder: (_, i) => Center(
          child: InteractiveViewer(
            minScale: 1,
            maxScale: 4,
            child: _img(widget.images[i]),
          ),
        ),
      ),
    );
  }
}
