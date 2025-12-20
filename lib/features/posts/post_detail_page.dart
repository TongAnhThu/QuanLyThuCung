import 'package:flutter/material.dart';

class PostDetailPage extends StatefulWidget {
  static const String routeName = '/post-detail';
  const PostDetailPage({super.key});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  // ====== BLUE THEME (đồng bộ tone mới) ======
  static const Color kPrimary = Color(0xFF7AB9FF);
  static const Color kPrimaryDark = Color(0xFF1E90FF);
  static const Color kSoftBg = Color(0xFFE8F2FF);

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

  Widget _imageFallback() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                kPrimary.withOpacity(0.40),
                kPrimaryDark.withOpacity(0.55),
              ],
            ),
          ),
        ),
        Center(
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
      ],
    );
  }

  // ✅ Ảnh gọn cho mobile + có thể dùng radius=0 khi dính liền card
  Widget _buildPostImage(String? imagePathOrUrl, {double radius = 16}) {
    final src = (imagePathOrUrl ?? '').trim();
    final hasImage = src.isNotEmpty;
    final isNetwork = src.startsWith('http://') || src.startsWith('https://');

    final w = MediaQuery.of(context).size.width;
    final h = (w * 0.45).clamp(150.0, 190.0);

    final child = hasImage
        ? (isNetwork
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
                ))
        : _imageFallback();

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        height: h,
        width: double.infinity,
        child: Container(color: kSoftBg, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final post = (args is Map<String, String>) ? args : <String, String>{};

    final title = post['title'] ?? 'Bài viết';
    final content = post['content'] ?? '';
    final source = post['source'] ?? '';
    final image = post['image']; // optional: assets hoặc link

    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F7),
      appBar: AppBar(
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        backgroundColor: kPrimaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ CARD LIỀN MẠCH: Ảnh + tiêu đề + nội dung
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ✅ TITLE trên cùng
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              height: 1.15,
                              color: Color(0xFF13353F),
                            ),
                          ),
                        ),

                        // ✅ ẢNH nằm dưới title
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _buildPostImage(image, radius: 16),
                        ),

                        const SizedBox(height: 12),

                        // ✅ CONTENT
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Text(
                            content,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[850],
                              height: 1.6,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Source (giữ card riêng nhỏ gọn)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.black.withOpacity(0.05)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 18,
                        color: kPrimaryDark,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          source,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Like FAB kiểu nổi
          Positioned(
            bottom: 22,
            right: 18,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                  elevation: 10,
                  shadowColor: Colors.black26,
                  shape: const CircleBorder(),
                  color: _isLiked ? const Color(0xFFFF6B6B) : Colors.white,
                  child: InkWell(
                    onTap: _toggleLike,
                    customBorder: const CircleBorder(),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Icon(
                        _isLiked ? Icons.favorite : Icons.favorite_border,
                        color: _isLiked ? Colors.white : kPrimaryDark,
                        size: 28,
                      ),
                    ),
                  ),
                ),
                if (_likes > 0) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.10),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
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
    );
  }
}
