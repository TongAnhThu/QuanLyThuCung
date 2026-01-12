import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/post_model.dart';
import 'post_detail_page.dart';

class PostsTab extends StatelessWidget {
  const PostsTab({super.key});

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

  @override
  Widget build(BuildContext context) {
    final col = FirebaseFirestore.instance.collection('posts');

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: col.orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(child: Text('Lỗi tải bài viết: ${snap.error}'));
        }

        final docs = snap.data?.docs ?? [];
        if (docs.isEmpty) {
          return const Center(child: Text('Chưa có bài viết nào'));
        }

        final posts = docs.map((d) => PostModel.fromDoc(d)).toList();

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          itemCount: posts.length,
          itemBuilder: (context, index) => _PostCard(
            post: posts[index],
            timeText: _fmt(posts[index].createdAt),
          ),
        );
      },
    );
  }
}

class _PostCard extends StatelessWidget {
  final PostModel post;
  final String timeText;
  const _PostCard({required this.post, required this.timeText});

  @override
  Widget build(BuildContext context) {
    final source = post.sourceName.trim().isEmpty ? 'Nguồn: (chưa có)' : post.sourceName;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.pushNamed(
          context,
          PostDetailPage.routeName,
          arguments: post.id,
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      post.content,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                    ),
                    const SizedBox(height: 10),

                    // ✅ Source + Time
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            source,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        if (timeText.isNotEmpty) ...[
                          const SizedBox(width: 10),
                          Icon(Icons.schedule, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            timeText,
                            style: TextStyle(fontSize: 12.5, color: Colors.grey[600]),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey[600]),
            ],
          ),
        ),
      ),
    );
  }
}
