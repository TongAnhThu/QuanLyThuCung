import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/post_model.dart';

class PostDetailPage extends StatefulWidget {
  static const String routeName = '/post-detail';
  const PostDetailPage({super.key});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  static const Color kPrimary = Color(0xFF7AB9FF);
  static const Color kPrimaryDark = Color(0xFF1E90FF);
  static const Color kSoftBg = Color(0xFFE8F2FF);
  static const Color kPageBg = Color(0xFFF1F4F7);

  int _likes = 0;
  bool _isLiked = false;

  void _toggleLike() {
    setState(() {
      if (_isLiked) {
        _likes = (_likes - 1).clamp(0, 999999);
        _isLiked = false;
      } else {
        _likes++;
        _isLiked = true;
      }
    });
  }

  String _fmt(DateTime? dt) {
    if (dt == null) return '';
    final d = dt.toLocal();
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    final hh = d.hour.toString().padLeft(2, '0');
    final min = d.minute.toString().padLeft(2, '0');
    return '$dd/$mm/$yyyy • $hh:$min';
  }

  // Optional: làm content dễ đọc hơn (tách "1) 2)" thành đoạn)
  String _prettyContent(String s) {
    final t = s.replaceAll('\r\n', '\n').trim();
    return t.replaceAllMapped(RegExp(r'\s*(\d+\))\s*'), (m) {
      return '\n\n${m.group(1)} ';
    }).trim();
  }

  Widget _imageFallback() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [kPrimary.withOpacity(0.35), kPrimaryDark.withOpacity(0.55)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.pets, size: 44, color: Colors.white.withOpacity(0.95)),
            const SizedBox(height: 8),
            Text(
              'Pet Tips',
              style: TextStyle(
                color: Colors.white.withOpacity(0.95),
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostImage(BuildContext context, String? imagePathOrUrl, {double radius = 16}) {
    final src = (imagePathOrUrl ?? '').trim();
    if (src.isEmpty) return const SizedBox.shrink(); // ✅ không có ảnh => ẩn luôn

    final isNetwork = src.startsWith('http://') || src.startsWith('https://');
    final w = MediaQuery.of(context).size.width;
    final h = (w * 0.48).clamp(160.0, 210.0);

    final img = isNetwork
        ? Image.network(
            src,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            errorBuilder: (_, __, ___) => _imageFallback(),
          )
        : Image.asset(
            src,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            errorBuilder: (_, __, ___) => _imageFallback(),
          );

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        height: h,
        width: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(color: kSoftBg),
          child: img,
        ),
      ),
    );
  }

  Widget _metaPill({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.5,
              color: Colors.grey[800],
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final postId = (args is String) ? args : '';

    if (postId.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Thiếu id bài viết')),
      );
    }

    final docRef = FirebaseFirestore.instance.collection('posts').doc(postId);

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: docRef.snapshots(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snap.hasError) {
          return Scaffold(body: Center(child: Text('Lỗi tải bài viết: ${snap.error}')));
        }

        final doc = snap.data;
        if (doc == null || !doc.exists) {
          return const Scaffold(body: Center(child: Text('Bài viết không tồn tại')));
        }

        final post = PostModel.fromDoc(doc);

        final title = post.title.isNotEmpty ? post.title : 'Bài viết';
        final timeText = _fmt(post.createdAt);
        final source = post.sourceName.trim().isEmpty ? 'Nguồn: (chưa có)' : post.sourceName;
        final content = _prettyContent(post.content);
        final image = post.image; // ✅ đã có field image (null hoặc string)

        return Scaffold(
          backgroundColor: kPageBg,
          appBar: AppBar(
            title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
            backgroundColor: kPrimaryDark,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _toggleLike,
            backgroundColor: _isLiked ? const Color(0xFFFF5A6A) : Colors.white,
            child: Icon(
              _isLiked ? Icons.favorite : Icons.favorite_border,
              color: _isLiked ? Colors.white : kPrimaryDark,
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ CARD CHÍNH: title -> meta -> (khoảng trống) -> image -> (khoảng trống) -> content
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                    border: Border.all(color: Colors.black.withOpacity(0.04)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              height: 1.18,
                              color: Color(0xFF13353F),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // ✅ meta: thời gian + nguồn
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              if (timeText.isNotEmpty) _metaPill(icon: Icons.schedule, text: timeText),
                              _metaPill(icon: Icons.person_outline, text: source),
                            ],
                          ),

                          // ✅ khoảng trống giữa tiêu đề/meta và ảnh
                          const SizedBox(height: 16),

                          // ✅ ảnh dưới tiêu đề (tuỳ bài có/không)
                          _buildPostImage(context, image, radius: 16),

                          // ✅ khoảng trống giữa ảnh và content (đúng ý cậu)
                          if ((image ?? '').trim().isNotEmpty) const SizedBox(height: 16),

                          Text(
                            content,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[850],
                              height: 1.65,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ✅ card “nguồn” gọn
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: kSoftBg,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.black.withOpacity(0.05)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, size: 18, color: kPrimaryDark),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          source,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[800],
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (_likes > 0) ...[
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: kPrimary.withOpacity(0.35)),
                          ),
                          child: Text(
                            '$_likes',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: kPrimaryDark,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
