import 'package:flutter/material.dart';

class PostDetailPage extends StatefulWidget {
  static const String routeName = '/post-detail';
  const PostDetailPage({super.key});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  int _likes = 0;
  bool _isLiked = false;

  void _toggleLike() {
    setState(() {
      if (_isLiked) {
        _likes--;
        _isLiked = false;
      } else {
        _likes++;
        _isLiked = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final post = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final title = post['title'] ?? '';
    final content = post['content'] ?? '';
    final source = post['source'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF0D8F87),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  source,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                  elevation: 4,
                  shape: const CircleBorder(),
                  color: _isLiked ? const Color(0xFFFF6B6B) : Colors.white,
                  child: InkWell(
                    onTap: _toggleLike,
                    customBorder: const CircleBorder(),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Icon(
                        _isLiked ? Icons.favorite : Icons.favorite_border,
                        color: _isLiked ? Colors.white : Colors.grey[600],
                        size: 28,
                      ),
                    ),
                  ),
                ),
                if (_likes > 0) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Text(
                      '$_likes',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0D8F87),
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
