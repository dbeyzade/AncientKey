import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';

final dailyLifeServiceProvider = Provider((ref) => DailyLifeService());

class DailyLifeScene {
  final String id;
  final String civilization;
  final String title;
  final String description;
  final String category;
  final String timeOfDay;
  final String activities;
  final String? imageUrl;

  DailyLifeScene({
    required this.id,
    required this.civilization,
    required this.title,
    required this.description,
    required this.category,
    required this.timeOfDay,
    required this.activities,
    this.imageUrl,
  });

  factory DailyLifeScene.fromMap(Map<String, dynamic> map) {
    return DailyLifeScene(
      id: map['id'],
      civilization: map['civilization'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['season'] ?? '',
      timeOfDay: map['time_of_day'] ?? '',
      activities: map['activities'] ?? '',
      imageUrl: map['image_url'],
    );
  }
}

class DailyLifeService {
  Future<List<DailyLifeScene>> getAllScenes() async {
    final db = await AppDatabase().database;
    
    final existing = await db.query('daily_life_scenes', where: 'scene_type = ?', whereArgs: ['daily_life']);
    if (existing.isEmpty) {
      await insertSampleScenes();
    }
    
    final results = await db.query('daily_life_scenes', where: 'scene_type = ?', whereArgs: ['daily_life']);
    return results.map((map) => DailyLifeScene.fromMap(map)).toList();
  }

  Future<List<DailyLifeScene>> getScenesByCategory(String category) async {
    final db = await AppDatabase().database;
    
    final results = await db.query(
      'daily_life_scenes',
      where: 'scene_type = ? AND season = ?',
      whereArgs: ['daily_life', category],
    );
    
    return results.map((map) => DailyLifeScene.fromMap(map)).toList();
  }

  Future<void> insertSampleScenes() async {
    final db = await AppDatabase().database;
    
    final scenes = [
      // Yemek ve Beslenme
      {
        'id': 'daily_1',
        'scene_type': 'daily_life',
        'civilization': 'Antik Yunan',
        'title': 'Yunanlıların Kahvaltısı',
        'description': 'Yunanlılar güne genellikle şarapla yumuşatılmış ekmek ile başlardı. Zeytinyağı, bal, incir ve peynir kahvaltının vazgeçilmezleriydi.',
        'time_of_day': 'Sabah',
        'season': 'Yemek',
        'activities': 'Ekmek daldırma, Şarap içme, Zeytin yeme',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'daily_2',
        'scene_type': 'daily_life',
        'civilization': 'Antik Roma',
        'title': 'Roma Ziyafeti',
        'description': 'Zengin Romalılar akşam yemeklerinde yan yatarak yemek yerlerdi. Yemekler saat 16:00\'da başlar ve gece geç saatlere kadar sürerdi.',
        'time_of_day': 'Akşam',
        'season': 'Yemek',
        'activities': 'Yan yatarak yemek, Şarap içme, Sohbet',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'daily_3',
        'scene_type': 'daily_life',
        'civilization': 'Antik Mısır',
        'title': 'Mısır Sofrasında',
        'description': 'Mısırlılar arpa ekmeği, balık, soğan ve bira ile beslenirdi. Zenginler ise et, kuş, bal ve şarap tüketirdi.',
        'time_of_day': 'Öğle',
        'season': 'Yemek',
        'activities': 'Ekmek yapımı, Balık pişirme, Bira içme',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },

      // Giyim
      {
        'id': 'daily_4',
        'scene_type': 'daily_life',
        'civilization': 'Antik Yunan',
        'title': 'Yunan Giysileri',
        'description': 'Yunanlılar chiton ve himation adı verilen bez parçalarını vücutlarına sararlardı. Kadınlar daha uzun ve renkli giysiler giyerdi.',
        'time_of_day': 'Sabah',
        'season': 'Giyim',
        'activities': 'Giysi giyme, Broş takma, Sandalet bağlama',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'daily_5',
        'scene_type': 'daily_life',
        'civilization': 'Antik Roma',
        'title': 'Toga Giyme Töreni',
        'description': 'Roma vatandaşlarının simgesi olan toga, özenle sarılması gereken beyaz yün kumaştı. Gençler 16 yaşında ilk togalarını giyerlerdi.',
        'time_of_day': 'Sabah',
        'season': 'Giyim',
        'activities': 'Toga sarma, Ayakkabı giyme, Tören hazırlığı',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'daily_6',
        'scene_type': 'daily_life',
        'civilization': 'Antik Mısır',
        'title': 'Mısır Keten Giysileri',
        'description': 'Mısır\'ın sıcak ikliminde insanlar ince keten kumaşlardan yapılmış giysiler giyerdi. Peruklar ve makyaj günlük rutinin önemli parçasıydı.',
        'time_of_day': 'Sabah',
        'season': 'Giyim',
        'activities': 'Keten giyme, Peruk takma, Göz makyajı',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },

      // Eğlence
      {
        'id': 'daily_7',
        'scene_type': 'daily_life',
        'civilization': 'Antik Yunan',
        'title': 'Olimpik Oyunlar',
        'description': 'Yunanlılar dört yılda bir Olimpia\'da toplanır, atletizm yarışları düzenlerlerdi. Kazanan atletler kahramanlara has bir onur kazanırdı.',
        'time_of_day': 'Öğleden Sonra',
        'season': 'Eğlence',
        'activities': 'Atletizm, Güreş, Disk atma',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'daily_8',
        'scene_type': 'daily_life',
        'civilization': 'Antik Roma',
        'title': 'Colosseum Gladyatörleri',
        'description': 'Romalılar Colosseum\'da gladyatör dövüşlerini izlerdi. Bu gösteriler sabahtan akşama kadar sürerdi ve bedava ekmek dağıtılırdı.',
        'time_of_day': 'Öğleden Sonra',
        'season': 'Eğlence',
        'activities': 'Gladyatör izleme, Alkışlama, Ekmek yeme',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'daily_9',
        'scene_type': 'daily_life',
        'civilization': 'Antik Mısır',
        'title': 'Nil\'de Tekne Gezisi',
        'description': 'Zengin Mısırlılar Nil Nehri\'nde papirüs teknelerle gezintiye çıkar, balık tutar ve su kuşları avlarlardı.',
        'time_of_day': 'Öğleden Sonra',
        'season': 'Eğlence',
        'activities': 'Tekne gezisi, Balık tutma, Kuş avlama',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },

      // Ev Yaşamı
      {
        'id': 'daily_10',
        'scene_type': 'daily_life',
        'civilization': 'Antik Yunan',
        'title': 'Yunan Evi',
        'description': 'Yunan evleri avlu etrafında inşa edilirdi. Kadınlar evde dokuma yapar, çocuklara bakar ve yemek pişirirdi.',
        'time_of_day': 'Gün Boyu',
        'season': 'Ev Yaşamı',
        'activities': 'Dokuma, Çocuk bakımı, Yemek pişirme',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'daily_11',
        'scene_type': 'daily_life',
        'civilization': 'Antik Roma',
        'title': 'Roma Villası',
        'description': 'Zengin Romalıların villaları bahçe, havuz ve mozaiklerle süslüydü. Köleler ev işlerini yapar, efendilerine hizmet ederdi.',
        'time_of_day': 'Gün Boyu',
        'season': 'Ev Yaşamı',
        'activities': 'Bahçe bakımı, Havuz temizliği, Mozaik yapımı',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'daily_12',
        'scene_type': 'daily_life',
        'civilization': 'Antik Mısır',
        'title': 'Mısır Köy Evi',
        'description': 'Sıradan Mısırlılar kerpiç evlerde yaşardı. Damlar düzdü ve sıcak gecelerde damda uyunurdu.',
        'time_of_day': 'Gün Boyu',
        'season': 'Ev Yaşamı',
        'activities': 'Kerpiç yapımı, Dam temizliği, Uyku',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },

      // Çalışma Hayatı
      {
        'id': 'daily_13',
        'scene_type': 'daily_life',
        'civilization': 'Antik Yunan',
        'title': 'Agora\'da Ticaret',
        'description': 'Yunanlılar şehir meydanı olan agora\'da alışveriş yapar, tartışır ve politika konuşurdu.',
        'time_of_day': 'Sabah',
        'season': 'Çalışma',
        'activities': 'Pazarlık, Sohbet, Politik tartışma',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'daily_14',
        'scene_type': 'daily_life',
        'civilization': 'Antik Roma',
        'title': 'Forum\'da İş Hayatı',
        'description': 'Roma Forum\'u iş, hukuk ve siyasetin merkezi idi. Avukatlar dava savunur, tüccarlar ticaret yapardı.',
        'time_of_day': 'Sabah',
        'season': 'Çalışma',
        'activities': 'Dava savunma, Ticaret, Siyaset',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'daily_15',
        'scene_type': 'daily_life',
        'civilization': 'Antik Mısır',
        'title': 'Piramit İnşaatı',
        'description': 'Binlerce işçi piramit inşaatında çalışırdı. İşçilere yemek, barınma ve sağlık hizmeti sağlanırdı.',
        'time_of_day': 'Gün Boyu',
        'season': 'Çalışma',
        'activities': 'Taş taşıma, İnşaat, Organizasyon',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },

      // Hijyen ve Bakım
      {
        'id': 'daily_16',
        'scene_type': 'daily_life',
        'civilization': 'Antik Yunan',
        'title': 'Yunan Hamamları',
        'description': 'Yunanlılar soğuk su ile yıkanır, vücutlarını zeytinyağı ile ovarlardı. Spor sonrası hamam rutini önemliydi.',
        'time_of_day': 'Öğleden Sonra',
        'season': 'Hijyen',
        'activities': 'Yıkanma, Yağ sürme, Kazıma',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'daily_17',
        'scene_type': 'daily_life',
        'civilization': 'Antik Roma',
        'title': 'Roma Termal Hamamları',
        'description': 'Romalılar günde birkaç saat hamamda geçirirdi. Sıcak, ılık ve soğuk su havuzları vardı. Sosyalleşme merkezi idi.',
        'time_of_day': 'Öğleden Sonra',
        'season': 'Hijyen',
        'activities': 'Termal banyo, Masaj, Sosyalleşme',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'daily_18',
        'scene_type': 'daily_life',
        'civilization': 'Antik Mısır',
        'title': 'Mısır Temizlik Ritüelleri',
        'description': 'Mısırlılar vücut temizliğine çok önem verirdi. Natron ile yıkanır, mür ve buhur ile kokular kullanırlardı.',
        'time_of_day': 'Sabah',
        'season': 'Hijyen',
        'activities': 'Natron banyosu, Koku sürme, Traş',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },

      // Eğitim
      {
        'id': 'daily_19',
        'scene_type': 'daily_life',
        'civilization': 'Antik Yunan',
        'title': 'Yunan Okulu',
        'description': 'Erkek çocuklar 7 yaşından itibaren okula giderdi. Okuma, yazma, müzik, atletizm ve matematik öğrenirlerdi.',
        'time_of_day': 'Sabah',
        'season': 'Eğitim',
        'activities': 'Okuma-yazma, Lir çalma, Atletizm',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'daily_20',
        'scene_type': 'daily_life',
        'civilization': 'Antik Roma',
        'title': 'Roma Eğitimi',
        'description': 'Zengin Roma çocukları özel öğretmenlerden ders alırdı. Latin, Yunanca, retorik ve hukuk öğrenirlerdi.',
        'time_of_day': 'Sabah',
        'season': 'Eğitim',
        'activities': 'Latin dersi, Retorik, Hukuk',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
    ];

    for (final scene in scenes) {
      await db.insert('daily_life_scenes', scene);
    }
  }
}
