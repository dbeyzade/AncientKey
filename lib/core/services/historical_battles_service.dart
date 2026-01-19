import '../database/app_database.dart';

class HistoricalBattle {
  final String id;
  final String name;
  final String sides;
  final String description;
  final String? commanders;
  final String? date;
  final String? outcome;
  final String? imageUrl;

  HistoricalBattle({
    required this.id,
    required this.name,
    required this.sides,
    required this.description,
    this.commanders,
    this.date,
    this.outcome,
    this.imageUrl,
  });

  factory HistoricalBattle.fromMap(Map<String, dynamic> map) {
    return HistoricalBattle(
      id: map['id'],
      name: map['title'] ?? '',
      sides: map['civilization'] ?? 'Bilinmeyen',
      description: map['description'] ?? '',
      commanders: map['activities'],
      date: map['time_of_day'],
      outcome: map['season'],
      imageUrl: map['image_url'],
    );
  }
}

class HistoricalBattlesService {
  Future<List<HistoricalBattle>> getAllBattles() async {
    final db = await AppDatabase().database;
    
    final existing = await db.query('daily_life_scenes', where: 'scene_type = ?', whereArgs: ['battle']);
    if (existing.isEmpty) {
      await insertSampleBattles();
    }
    
    final results = await db.query('daily_life_scenes', where: 'scene_type = ?', whereArgs: ['battle'], orderBy: 'time_of_day DESC');
    return results.map((map) => HistoricalBattle.fromMap(map)).toList();
  }

  Future<void> insertSampleBattles() async {
    final db = await AppDatabase().database;
    
    final battles = [
      {
        'id': 'battle_1',
        'scene_type': 'battle',
        'title': 'Truva Savaşı',
        'civilization': 'Akalar vs Truvalılar',
        'description': 'Efsanevi 10 yıllık kuşatma. Helena için başlayan savaş, Truva Atı ile sona erdi.',
        'activities': 'Agamemnon, Akhilleus, Hektor, Odysseus',
        'time_of_day': 'MÖ 1200',
        'season': 'Truva yıkıldı, Yunan zaferi',
      },
      {
        'id': 'battle_2',
        'scene_type': 'battle',
        'title': 'Kadesh Muharebesi',
        'civilization': 'Mısır vs Hitit',
        'description': 'Tarihin ilk yazılı barış antlaşması ile sonuçlanan büyük savaş.',
        'activities': 'II. Ramses vs III. Muwatalli',
        'time_of_day': 'MÖ 1274',
        'season': 'Beraberlik, barış antlaşması',
      },
      {
        'id': 'battle_3',
        'scene_type': 'battle',
        'title': 'Maraton Muharebesi',
        'civilization': 'Atina vs Pers',
        'description': 'Azınlıktaki Atina ordusu Pers istilasını durdurdu. Maraton koşusunun kökenı.',
        'activities': 'Miltiades vs Datis',
        'time_of_day': 'MÖ 490',
        'season': 'Atina zaferi',
      },
      {
        'id': 'battle_4',
        'scene_type': 'battle',
        'title': 'Thermopylae Geçidi',
        'civilization': 'Sparta vs Pers',
        'description': '300 Spartalının son direniş. Leonidas\'ın kahramanlık destanı.',
        'activities': 'Kral Leonidas vs Kserkes',
        'time_of_day': 'MÖ 480',
        'season': 'Pers zaferi, Sparta\'nın şanlı ölümü',
      },
      {
        'id': 'battle_5',
        'scene_type': 'battle',
        'title': 'Salamis Deniz Savaşı',
        'civilization': 'Yunan vs Pers',
        'description': 'Themistokles\'in taktik dehası ile Pers donanması yok edildi.',
        'activities': 'Themistokles vs Kserkes',
        'time_of_day': 'MÖ 480',
        'season': 'Yunan deniz zaferi',
      },
      {
        'id': 'battle_6',
        'scene_type': 'battle',
        'title': 'Gaugamela Muharebesi',
        'civilization': 'Makedonya vs Pers',
        'description': 'Büyük İskender\'in Pers İmparatorluğunu yıktığı kesin zafer.',
        'activities': 'Büyük İskender vs III. Darius',
        'time_of_day': 'MÖ 331',
        'season': 'Makedonya zaferi, Pers İmparatorluğu sonu',
      },
      {
        'id': 'battle_7',
        'scene_type': 'battle',
        'title': 'Cannae Muharebesi',
        'civilization': 'Kartaca vs Roma',
        'description': 'Hannibal\'in çift kuşatma taktiği ile Roma\'ya verdiği en ağır yenilgi.',
        'activities': 'Hannibal Barkas vs Paullus & Varro',
        'time_of_day': 'MÖ 216',
        'season': 'Kartaca zaferi',
      },
      {
        'id': 'battle_8',
        'scene_type': 'battle',
        'title': 'Zama Muharebesi',
        'civilization': 'Roma vs Kartaca',
        'description': 'Scipio\'nun Hannibal\'i yendiği ve 2. Pön Savaşını bitiren muharebe.',
        'activities': 'Scipio Africanus vs Hannibal',
        'time_of_day': 'MÖ 202',
        'season': 'Roma zaferi',
      },
      {
        'id': 'battle_9',
        'scene_type': 'battle',
        'title': 'Actium Deniz Savaşı',
        'civilization': 'Octavianus vs Antonius & Kleopatra',
        'description': 'Roma İmparatorluğunun doğuşu. Octavianus\'un kesin zaferi.',
        'activities': 'Octavianus (Augustus) vs Antonius & Kleopatra',
        'time_of_day': 'MÖ 31',
        'season': 'Octavianus zaferi, imparatorluk başlangıcı',
      },
      {
        'id': 'battle_10',
        'scene_type': 'battle',
        'title': 'Kızıl Uçurum Savaşı',
        'civilization': 'Cao Cao vs Liu Bei & Sun Quan İttifakı',
        'description': 'Üç Krallık döneminin en ünlü muharebesi. Ateş gemileri ile zafer.',
        'activities': 'Cao Cao vs Zhou Yu & Zhuge Liang',
        'time_of_day': 'MS 208',
        'season': 'İttifak zaferi',
      },
      {
        'id': 'battle_11',
        'scene_type': 'battle',
        'title': 'Teutoburg Ormanı',
        'civilization': 'Germen vs Roma',
        'description': 'Arminius\'un Roma lejyonlarını pusuya düşürdüğü felaket. 3 lejyon yok oldu.',
        'activities': 'Arminius vs Varus',
        'time_of_day': 'MS 9',
        'season': 'Germen zaferi, Roma\'nın en büyük yenilgisi',
      },
      {
        'id': 'battle_12',
        'scene_type': 'battle',
        'title': 'Yarmuk Savaşı',
        'civilization': 'İslam Ordusu vs Bizans',
        'description': 'Müslümanların Suriye\'yi fethettiği altı günlük büyük savaş.',
        'activities': 'Halid bin Velid vs Theodoros Trithurios',
        'time_of_day': 'MS 636',
        'season': 'Müslüman zaferi',
      },
      {
        'id': 'battle_13',
        'scene_type': 'battle',
        'title': 'Tours Muharebesi',
        'civilization': 'Frank vs Endülüs',
        'description': 'Charles Martel\'in İslam genişlemesini Avrupa\'da durdurduğu savaş.',
        'activities': 'Charles Martel vs Abdurrahman el-Gafiki',
        'time_of_day': 'MS 732',
        'season': 'Frank zaferi',
      },
      {
        'id': 'battle_14',
        'scene_type': 'battle',
        'title': 'Talas Savaşı',
        'civilization': 'Abbasi & Türgişler vs Tang',
        'description': 'İpek Yolu kontrolü için Orta Asya\'da yapılan savaş. Kağıt yapımı batıya yayıldı.',
        'activities': 'Ziyad ibn Salih vs Gao Xianzhi',
        'time_of_day': 'MS 751',
        'season': 'Abbasi zaferi',
      },
      {
        'id': 'battle_15',
        'scene_type': 'battle',
        'title': 'Hastings Muharebesi',
        'civilization': 'Norman vs Anglo-Sakson',
        'description': 'William\'ın İngiltere\'yi fethı. İngiliz tarihinin dönüm noktası.',
        'activities': 'William (Fatih) vs II. Harold',
        'time_of_day': 'MS 1066',
        'season': 'Norman zaferi',
      },
      {
        'id': 'battle_16',
        'scene_type': 'battle',
        'title': 'Malazgirt Meydan Savaşı',
        'civilization': 'Selçuklu vs Bizans',
        'description': 'Anadolu\'nun Türklere açılışı. Bizans\'ın geri dönülemez yenilgisi.',
        'activities': 'Alp Arslan vs Romanos Diogenes',
        'time_of_day': 'MS 1071',
        'season': 'Selçuklu büyük zaferi',
      },
      {
        'id': 'battle_17',
        'scene_type': 'battle',
        'title': 'Ain Jalut Savaşı',
        'civilization': 'Memlük vs Moğol',
        'description': 'Moğolların ilk büyük yenilgisi. İslam dünyası kurtarıldı.',
        'activities': 'Kutuz & Baybars vs Kitbuqa',
        'time_of_day': 'MS 1260',
        'season': 'Memlük zaferi',
      },
      {
        'id': 'battle_18',
        'scene_type': 'battle',
        'title': 'Kulikovo Savaşı',
        'civilization': 'Rus vs Altın Orda',
        'description': 'Rus prensliklerinin Moğol boyunduruğuna ilk büyük darbesi.',
        'activities': 'Dmitri Donskoy vs Mamai',
        'time_of_day': 'MS 1380',
        'season': 'Rus zaferi',
      },
      {
        'id': 'battle_19',
        'scene_type': 'battle',
        'title': 'Ankara Muharebesi',
        'civilization': 'Timur vs Osmanlı',
        'description': 'Yıldırım Bayezid\'in esir düştüğü, Osmanlı tarihinin en karanlık günü.',
        'activities': 'Timur vs Yıldırım Bayezid',
        'time_of_day': 'MS 1402',
        'season': 'Timur zaferi, Fetret Devri başlangıcı',
      },
      {
        'id': 'battle_20',
        'scene_type': 'battle',
        'title': 'Agincourt Muharebesi',
        'civilization': 'İngiltere vs Fransa',
        'description': 'İngiliz uzun yaylarının Fransız şövalyelerini yok ettiği savaş.',
        'activities': 'V. Henry vs Charles d\'Albret',
        'time_of_day': 'MS 1415',
        'season': 'İngiliz zaferi',
      },
    ];

    for (final battle in battles) {
      await db.insert('daily_life_scenes', {
        ...battle,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }
}
