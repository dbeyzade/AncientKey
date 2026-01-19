import 'package:flutter/material.dart';

class CommunityForumScreen extends StatefulWidget {
  const CommunityForumScreen({super.key});

  @override
  State<CommunityForumScreen> createState() => _CommunityForumScreenState();
}

class _CommunityForumScreenState extends State<CommunityForumScreen> {
  final List<ForumTopic> topics = [
    ForumTopic(
      id: '1',
      title: 'Piramitlerin İnşası Hakkında Teorileriniz?',
      author: 'TarihSevdalısı',
      category: 'Antik Mısır',
      replies: 47,
      views: 1234,
      lastActivity: '2 saat önce',
    ),
    ForumTopic(
      id: '2',
      title: 'Roma İmparatorluğu\'nun En Büyük Hatası Neydi?',
      author: 'RomaHayrını',
      category: 'Antik Roma',
      replies: 89,
      views: 2567,
      lastActivity: '5 saat önce',
    ),
    ForumTopic(
      id: '3',
      title: 'Truva Atı Gerçekten Var Mıydı?',
      author: 'MitolojiFanı',
      category: 'Antik Yunan',
      replies: 63,
      views: 1890,
      lastActivity: '1 gün önce',
    ),
    ForumTopic(
      id: '4',
      title: 'İpek Yolu\'nun Günümüze Etkileri',
      author: 'TicaretTarihçisi',
      category: 'Genel',
      replies: 34,
      views: 876,
      lastActivity: '2 gün önce',
    ),
    ForumTopic(
      id: '5',
      title: 'En İyi Antik Tarih Belgeseli Önerileriniz?',
      author: 'DokümantarAvcısı',
      category: 'Genel',
      replies: 128,
      views: 3421,
      lastActivity: '3 saat önce',
    ),
    ForumTopic(
      id: '6',
      title: 'Göbeklitepe Keşfinin Önemi',
      author: 'AnadoluArkeologu',
      category: 'Arkeoloji',
      replies: 56,
      views: 1567,
      lastActivity: '6 saat önce',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Topluluk Forumu'),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildCategoryChip('Tümü', true),
                _buildCategoryChip('Antik Mısır', false),
                _buildCategoryChip('Antik Roma', false),
                _buildCategoryChip('Antik Yunan', false),
                _buildCategoryChip('Arkeoloji', false),
                _buildCategoryChip('Genel', false),
              ],
            ),
          ),

          // Topics List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: topics.length,
              itemBuilder: (context, index) {
                return _buildTopicCard(topics[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Yeni Konu'),
        backgroundColor: Colors.indigo[600],
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {},
        selectedColor: Colors.indigo[600],
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildTopicCard(ForumTopic topic) {
    final categoryColors = {
      'Antik Mısır': Colors.orange,
      'Antik Roma': Colors.red,
      'Antik Yunan': Colors.blue,
      'Arkeoloji': Colors.brown,
      'Genel': Colors.indigo,
    };

    final color = categoryColors[topic.category] ?? Colors.indigo;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      topic.category,
                      style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                topic.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.grey[300],
                    child: Icon(Icons.person, size: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    topic.author,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const Spacer(),
                  Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    topic.lastActivity,
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.comment, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${topic.replies} yanıt',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.visibility, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${topic.views} görüntüleme',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ForumTopic {
  final String id;
  final String title;
  final String author;
  final String category;
  final int replies;
  final int views;
  final String lastActivity;

  ForumTopic({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.replies,
    required this.views,
    required this.lastActivity,
  });
}
