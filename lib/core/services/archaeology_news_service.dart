import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';

final archaeologyNewsServiceProvider = Provider((ref) => ArchaeologyNewsService());

class NewsArticle {
  final String id;
  final String title;
  final String content;
  final String category;
  final String date;
  final String source;
  final String? imageUrl;

  NewsArticle({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.date,
    required this.source,
    this.imageUrl,
  });

  factory NewsArticle.fromMap(Map<String, dynamic> map) {
    return NewsArticle(
      id: map['id'],
      title: map['title'] ?? '',
      content: map['description'] ?? '',
      category: map['civilization'] ?? '',
      date: map['time_of_day'] ?? '',
      source: map['season'] ?? '',
      imageUrl: map['image_url'],
    );
  }
}

class ArchaeologyNewsService {
  Future<List<NewsArticle>> getAllNews() async {
    final db = await AppDatabase().database;
    
    final existing = await db.query('daily_life_scenes', where: 'scene_type = ?', whereArgs: ['archaeology_news']);
    if (existing.isEmpty) {
      await insertSampleNews();
    }
    
    final results = await db.query('daily_life_scenes', where: 'scene_type = ?', whereArgs: ['archaeology_news'], orderBy: 'created_at DESC');
    return results.map((map) => NewsArticle.fromMap(map)).toList();
  }

  Future<void> insertSampleNews() async {
    final db = await AppDatabase().database;
    
    final news = [
      {
        'id': 'news_1',
        'scene_type': 'archaeology_news',
        'title': 'Mısır\'da Yeni Bir Piramit Odası Keşfedildi',
        'description': 'Giza\'daki Büyük Piramit\'te kozmik ışınlar kullanılarak yapılan taramalar, daha önce bilinmeyen gizli bir oda ortaya çıkardı. Uzunluğu 9 metre olan bu oda, 4500 yıl sonra ilk kez tespit edildi. Araştırmacılar, odanın yapısal bir amaçla mı yoksa bir hazine odası olarak mı kullanıldığını araştırıyor.',
        'civilization': 'Arkeoloji',
        'time_of_day': '5 Ocak 2026',
        'season': 'Nature Journal',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'news_2',
        'scene_type': 'archaeology_news',
        'title': 'Pompei\'de Yeni Fresk Resimleri Bulundu',
        'description': 'İtalya\'daki Pompei antik kentinde yapılan kazılarda, Truva Savaşı\'nı betimleyen muhteşem fresk resimleri bulundu. MS 79\'daki Vezüv patlamasında küllere gömülen bu eserler, Roma sanatının zirvesini gösteriyor. Paris ve Helen\'in hikayesini anlatan renkli sahneler mükemmel durumda.',
        'civilization': 'Restorasyon',
        'time_of_day': '3 Ocak 2026',
        'season': 'Archaeological Institute',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'news_3',
        'scene_type': 'archaeology_news',
        'title': 'Göbeklitepe\'de Yeni Yapılar Gün Yüzüne Çıktı',
        'description': 'Dünyanın bilinen en eski tapınak kompleksi Göbeklitepe\'de, 10 yeni dikilitaş bulundu. MÖ 9600\'e tarihlenen bu yapılar, tarımdan önce organize dinsel yapıların varlığını kanıtlıyor. T harfi şeklindeki dikilitaşlarda hayvan kabartmaları dikkat çekiyor.',
        'civilization': 'Kazı',
        'time_of_day': '2 Ocak 2026',
        'season': 'Türk Arkeoloji Enstitüsü',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'news_4',
        'scene_type': 'archaeology_news',
        'title': 'Antik Yunan Gemisi Sağlam Bulundu',
        'description': 'Karadeniz\'in derinliklerinde, 2400 yıllık bir Yunan ticaret gemisi keşfedildi. Oksijensiz ortam sayesinde ahşap gemi neredeyse kusursuz korunmuş. Bu, bilinen en eski sağlam gemi enkaz bulgularından biri. Amforaları hâlâ yerinde duruyor.',
        'civilization': 'Sualtı Arkeolojisi',
        'time_of_day': '28 Aralık 2025',
        'season': 'Maritime Archaeology',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'news_5',
        'scene_type': 'archaeology_news',
        'title': 'Maya Şehri LiDAR ile Haritalandı',
        'description': 'Guatemala\'daki yağmur ormanlarında, LiDAR teknolojisi kullanılarak binlerce Maya yapısı keşfedildi. 60.000\'den fazla ev, saray, piramit ve yol tespit edildi. Bu bulgular, Maya medeniyetinin düşünülenden çok daha büyük olduğunu gösteriyor.',
        'civilization': 'Teknoloji',
        'time_of_day': '25 Aralık 2025',
        'season': 'Science Magazine',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'news_6',
        'scene_type': 'archaeology_news',
        'title': 'Roma Dönemi Mozaik Villası Keşfedildi',
        'description': 'İngiltere\'de bir çiftçi, tarlasında Roma dönemine ait lüks bir villa keşfetti. Zemin mozaikleri, hipokaust (zemin altı ısıtma) sistemi ve hamamlar mükemmel durumda. Villa, MS 3-4. yüzyılda zengin bir Roma ailesi tarafından kullanılmış.',
        'civilization': 'Kazı',
        'time_of_day': '20 Aralık 2025',
        'season': 'British Museum',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
    ];

    for (final article in news) {
      await db.insert('daily_life_scenes', article);
    }
  }
}
