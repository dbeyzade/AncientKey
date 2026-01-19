import 'package:flutter/material.dart';

class MyCollectionsScreen extends StatefulWidget {
  const MyCollectionsScreen({super.key});

  @override
  State<MyCollectionsScreen> createState() => _MyCollectionsScreenState();
}

class _MyCollectionsScreenState extends State<MyCollectionsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Koleksiyonlarım'),
        elevation: 2,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.favorite), text: 'Favoriler'),
            Tab(icon: Icon(Icons.bookmark), text: 'Kaydedilenler'),
            Tab(icon: Icon(Icons.history), text: 'Geçmiş'),
            Tab(icon: Icon(Icons.note), text: 'Notlarım'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFavoritesTab(),
          _buildSavedTab(),
          _buildHistoryTab(),
          _buildNotesTab(),
        ],
      ),
    );
  }

  Widget _buildFavoritesTab() {
    final favorites = [
      CollectionItem('Truva Savaşı', 'Savaş', Icons.shield, Colors.red),
      CollectionItem('Piramitlerin Sırları', 'Mimari', Icons.landscape, Colors.orange),
      CollectionItem('Yunan Mitolojisi', 'Mitoloji', Icons.auto_stories, Colors.blue),
      CollectionItem('Roma Gladyatörleri', 'Eğlence', Icons.sports, Colors.deepOrange),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final item = favorites[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: item.color.withOpacity(0.2),
              child: Icon(item.icon, color: item.color),
            ),
            title: Text(item.title),
            subtitle: Text(item.subtitle),
            trailing: IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              onPressed: () {},
            ),
          ),
        );
      },
    );
  }

  Widget _buildSavedTab() {
    final saved = [
      CollectionItem('İpek Yolu Rotası', 'Ticaret', Icons.route, Colors.brown),
      CollectionItem('Antik Yunan Felsefesi', 'Eğitim', Icons.school, Colors.indigo),
      CollectionItem('Maya Takvimi', 'Bilim', Icons.calendar_today, Colors.green),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: saved.length,
      itemBuilder: (context, index) {
        final item = saved[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: item.color.withOpacity(0.2),
              child: Icon(item.icon, color: item.color),
            ),
            title: Text(item.title),
            subtitle: Text(item.subtitle),
            trailing: IconButton(
              icon: Icon(Icons.bookmark, color: item.color),
              onPressed: () {},
            ),
          ),
        );
      },
    );
  }

  Widget _buildHistoryTab() {
    final history = [
      HistoryItem('Antik Roma Turu', '2 saat önce', Icons.location_city, Colors.red),
      HistoryItem('Mısır Piramitleri', '1 gün önce', Icons.landscape, Colors.orange),
      HistoryItem('Yunan Mitolojisi Quiz', '2 gün önce', Icons.quiz, Colors.blue),
      HistoryItem('İpek Yolu Keşfi', '3 gün önce', Icons.explore, Colors.brown),
      HistoryItem('Spartacus Hikayesi', '1 hafta önce', Icons.auto_stories, Colors.purple),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: item.color.withOpacity(0.2),
              child: Icon(item.icon, color: item.color),
            ),
            title: Text(item.title),
            subtitle: Row(
              children: [
                const Icon(Icons.access_time, size: 14),
                const SizedBox(width: 4),
                Text(item.time),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.replay),
              onPressed: () {},
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotesTab() {
    final notes = [
      Note(
        'Roma İmparatorluğu Notlarım',
        'Augustus MÖ 27\'de ilk imparator oldu. Pax Romana dönemi...',
        '5 Ocak 2026',
        Colors.red,
      ),
      Note(
        'Antik Mısır Araştırması',
        'Piramitler MÖ 2580-2560 arası inşa edildi. İşçiler gönüllü...',
        '3 Ocak 2026',
        Colors.orange,
      ),
      Note(
        'Yunan Felsefesi',
        'Sokrates "Kendini bil" dedi. Platon İdealar Teorisi...',
        '1 Ocak 2026',
        Colors.blue,
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notes.length + 1,
      itemBuilder: (context, index) {
        if (index == notes.length) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Yeni Not Ekle'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.red[600],
              ),
            ),
          );
        }

        final note = notes[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: note.color, width: 4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          note.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    note.content,
                    style: TextStyle(color: Colors.grey[700]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    note.date,
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CollectionItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  CollectionItem(this.title, this.subtitle, this.icon, this.color);
}

class HistoryItem {
  final String title;
  final String time;
  final IconData icon;
  final Color color;

  HistoryItem(this.title, this.time, this.icon, this.color);
}

class Note {
  final String title;
  final String content;
  final String date;
  final Color color;

  Note(this.title, this.content, this.date, this.color);
}
