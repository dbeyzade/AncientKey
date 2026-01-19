import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';

final expertInterviewsServiceProvider = Provider((ref) => ExpertInterviewsService());

class ExpertInterview {
  final String id;
  final String expertName;
  final String title;
  final String expertise;
  final String content;
  final String date;
  final String? imageUrl;

  ExpertInterview({
    required this.id,
    required this.expertName,
    required this.title,
    required this.expertise,
    required this.content,
    required this.date,
    this.imageUrl,
  });

  factory ExpertInterview.fromMap(Map<String, dynamic> map) {
    return ExpertInterview(
      id: map['id'],
      expertName: map['title'] ?? '',
      title: map['civilization'] ?? '',
      expertise: map['season'] ?? '',
      content: map['description'] ?? '',
      date: map['time_of_day'] ?? '',
      imageUrl: map['image_url'],
    );
  }
}

class ExpertInterviewsService {
  Future<List<ExpertInterview>> getAllInterviews() async {
    final db = await AppDatabase().database;
    
    final existing = await db.query('daily_life_scenes', where: 'scene_type = ?', whereArgs: ['expert_interview']);
    if (existing.isEmpty) {
      await insertSampleInterviews();
    }
    
    final results = await db.query('daily_life_scenes', where: 'scene_type = ?', whereArgs: ['expert_interview']);
    return results.map((map) => ExpertInterview.fromMap(map)).toList();
  }

  Future<void> insertSampleInterviews() async {
    final db = await AppDatabase().database;
    
    final interviews = [
      {
        'id': 'interview_1',
        'scene_type': 'expert_interview',
        'title': 'Prof. Dr. Ahmet Yıldız',
        'civilization': 'Antik Mısır Piramitlerinin Sırları',
        'season': 'Mısırbilimci',
        'time_of_day': '15 Aralık 2025',
        'description': 'Piramitlerin inşası hâlâ büyük bir gizemdir. Son araştırmalar, antik Mısırlıların iç rampalar kullanmış olabileceğini gösteriyor. Bu sistem, taşların yükseklere daha verimli taşınmasını sağlardı. Ayrıca, işçilerin gönüllü olduğu ve iyi beslendiği ortaya çıktı.',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'interview_2',
        'scene_type': 'expert_interview',
        'title': 'Dr. Zeynep Kaya',
        'civilization': 'Roma İmparatorluğu\'nun Çöküşü',
        'season': 'Klasik Arkeolog',
        'time_of_day': '10 Aralık 2025',
        'description': 'Roma\'nın çöküşü tek bir nedene bağlanamaz. Ekonomik sorunlar, askeri baskılar, siyasi istikrarsızlık ve göç dalgaları bir araya geldi. Özellikle 5. yüzyılda barbar kavimlerinin baskısı artarken, iç karışıklıklar imparatorluğu zayıflattı.',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'interview_3',
        'scene_type': 'expert_interview',
        'title': 'Prof. Dr. Mehmet Demir',
        'civilization': 'Truva Savaşı: Efsane mi Gerçek mi?',
        'season': 'Eski Çağ Tarihçisi',
        'time_of_day': '5 Aralık 2025',
        'description': 'Truva gerçekten var oldu ve tahrip edildi. Ancak Homer\'in anlattığı savaş büyük olasılıkla efsanelerle süslenmiş. Arkeolojik bulgular MÖ 1200 civarında büyük bir yıkımı doğruluyor. Truva Atı ise muhtemelen bir metafordur.',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'interview_4',
        'scene_type': 'expert_interview',
        'title': 'Dr. Ayşe Yılmaz',
        'civilization': 'Antik Yunan Demokrasisinin Doğuşu',
        'season': 'Siyaset Bilimci',
        'time_of_day': '1 Aralık 2025',
        'description': 'Atina demokrasisi modern demokrasiden çok farklıydı. Kadınlar, köleler ve yabancılar oy kullanamazdı. Ancak vatandaşlar doğrudan karar alırlardı. Bu sistem, günümüz temsili demokrasisine ilham verdi.',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'interview_5',
        'scene_type': 'expert_interview',
        'title': 'Prof. Dr. Can Öztürk',
        'civilization': 'İpek Yolu: Medeniyetler Arası Köprü',
        'season': 'Ticaret Tarihi Uzmanı',
        'time_of_day': '25 Kasım 2025',
        'description': 'İpek Yolu sadece ticaret yolu değildi. Fikirler, dinler, teknolojiler ve sanat bu yoldan yayıldı. Budizm Çin\'e, kağıt Batı\'ya böyle ulaştı. Bu yol, küreselleşmenin ilk örneğiydi.',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
    ];

    for (final interview in interviews) {
      await db.insert('daily_life_scenes', interview);
    }
  }
}
