import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';

final civilizationComparisonServiceProvider = Provider((ref) => CivilizationComparisonService());

class Civilization {
  final String id;
  final String name;
  final String period;
  final String region;
  final String technology;
  final String architecture;
  final String art;
  final String religion;
  final String government;
  final String military;
  final String economy;
  final String writing;
  final String achievements;
  final String? imageUrl;

  Civilization({
    required this.id,
    required this.name,
    required this.period,
    required this.region,
    required this.technology,
    required this.architecture,
    required this.art,
    required this.religion,
    required this.government,
    required this.military,
    required this.economy,
    required this.writing,
    required this.achievements,
    this.imageUrl,
  });

  factory Civilization.fromMap(Map<String, dynamic> map) {
    return Civilization(
      id: map['id'],
      name: map['title'] ?? '',
      period: map['time_of_day'] ?? '',
      region: map['season'] ?? '',
      technology: map['activities']?.split('|||')[0] ?? '',
      architecture: map['activities']?.split('|||')[1] ?? '',
      art: map['activities']?.split('|||')[2] ?? '',
      religion: map['activities']?.split('|||')[3] ?? '',
      government: map['civilization'] ?? '',
      military: map['description']?.split('|||')[0] ?? '',
      economy: map['description']?.split('|||')[1] ?? '',
      writing: map['description']?.split('|||')[2] ?? '',
      achievements: map['description']?.split('|||')[3] ?? '',
      imageUrl: map['image_url'],
    );
  }
}

class CivilizationComparisonService {
  Future<List<Civilization>> getAllCivilizations() async {
    final db = await AppDatabase().database;
    
    final existing = await db.query('daily_life_scenes', where: 'scene_type = ?', whereArgs: ['civilization']);
    if (existing.isEmpty) {
      await insertSampleCivilizations();
    }
    
    final results = await db.query('daily_life_scenes', where: 'scene_type = ?', whereArgs: ['civilization']);
    return results.map((map) => Civilization.fromMap(map)).toList();
  }

  Future<void> insertSampleCivilizations() async {
    final db = await AppDatabase().database;
    
    final civilizations = [
      {
        'id': 'civ_1',
        'scene_type': 'civilization',
        'title': 'Antik Yunan',
        'time_of_day': 'MÖ 800 - MÖ 146',
        'season': 'Akdeniz Bölgesi',
        'civilization': 'Demokrasi ve Oligarşi',
        'activities': 'Matematik, Felsefe, Astronomi|||Tapınaklar, Tiyatrolar, Agoralar|||Heykeller, Vazolar, Fresk Resimleri|||Çoktanrılı (Zeus, Athena, Poseidon)',
        'description': 'Güçlü Falanks Birliği, Süvari|||Deniz Ticareti, Zeytinyağı, Şarap|||Yunan Alfabesi, Edebiyat|||Demokrasi, Olimpiyatlar, Tiyatro, Felsefe',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'civ_2',
        'scene_type': 'civilization',
        'title': 'Antik Roma',
        'time_of_day': 'MÖ 753 - MS 476',
        'season': 'İtalya ve Akdeniz',
        'civilization': 'Cumhuriyet ve İmparatorluk',
        'activities': 'Hukuk, Mühendislik, Su Kemerleri|||Kemer Mimarisi, Colosseum, Pantheon|||Mozaikler, Büstler, Freskler|||Çoktanrılı (Jupiter, Mars, Venus)',
        'description': 'Lejyon Sistemi, En Güçlü Ordu|||Geniş Ticaret Ağı, Altın Para|||Latin Alfabesi, Edebiyat|||Hukuk Sistemi, Su Kemerleri, Yol Ağı',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'civ_3',
        'scene_type': 'civilization',
        'title': 'Antik Mısır',
        'time_of_day': 'MÖ 3100 - MÖ 30',
        'season': 'Nil Nehri Vadisi',
        'civilization': 'Firavun Teokrasisi',
        'activities': 'Tıp, Mumyalama, Geometri|||Piramitler, Tapınaklar, Sfenksler|||Hiyeroglif Resimler, Heykeller|||Çoktanrılı (Ra, Osiris, Horus)',
        'description': 'Savaş Arabaları, Okçular|||Tarım, Altın, Papirüs Ticareti|||Hiyeroglif Yazısı|||Piramitler, Mumyalama, Takvim',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'civ_4',
        'scene_type': 'civilization',
        'title': 'Mezopotamya',
        'time_of_day': 'MÖ 3500 - MÖ 539',
        'season': 'Dicle ve Fırat Nehirleri',
        'civilization': 'Krallık ve İmparatorluk',
        'activities': 'Çivi Yazısı, Matematik, Zaman Ölçümü|||Zigguratlar, Asma Bahçeler|||Kabartmalar, Silindrik Mühürler|||Çoktanrılı (Marduk, Ishtar)',
        'description': 'Savaş Arabaları, Kaleler|||Tarım, İpek Yolu, Baharat|||Çivi Yazısı, Kil Tabletler|||İlk Yazı, Tekerlek, Hammurabi Yasaları',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'civ_5',
        'scene_type': 'civilization',
        'title': 'Antik Çin',
        'time_of_day': 'MÖ 1600 - MS 220',
        'season': 'Sarı Nehir Bölgesi',
        'civilization': 'İmparatorluk ve Hanedanlıklar',
        'activities': 'Barut, Kağıt, Pusulat|||Çin Seddi, Pagodalar|||Seramik, İpek Resimler|||Konfüçyüs, Taoizm, Ata Tapınması',
        'description': 'Tüfek, Crossbow, Süvari|||İpek Yolu, Porselen, Çay|||Çin Karakterleri|||Kağıt, Barut, Pusulat, Matbaa',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'civ_6',
        'scene_type': 'civilization',
        'title': 'Pers İmparatorluğu',
        'time_of_day': 'MÖ 550 - MÖ 330',
        'season': 'İran Yaylası',
        'civilization': 'İmparatorluk (Satrap Sistemi)',
        'activities': 'Sulama Sistemleri, Yol Ağı|||Persepolis, Sütunlu Saraylar|||Kabartmalar, Halı Dokuma|||Zerdüştlük (Ahura Mazda)',
        'description': 'Ölümsüzler Birliği, Süvari|||Kral Yolu, Gümüş-Altın|||Eski Farsça, Çivi Yazısı|||Tolerans, Posta Sistemi, İnsan Hakları',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'civ_7',
        'scene_type': 'civilization',
        'title': 'Maya Medeniyeti',
        'time_of_day': 'MÖ 2000 - MS 1500',
        'season': 'Orta Amerika',
        'civilization': 'Şehir Devletleri',
        'activities': 'Takvim, Astronomi, Matematik|||Piramitler, Tapınaklar|||Freskler, Heykel|||Çoktanrılı (Kukulkan)',
        'description': 'Obsidian Silahlar, Tuzaklar|||Kakao, Mısır, Nefrit|||Glifler (Hiyeroglif)|||Sıfırın Keşfi, Takvim Sistemi',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'civ_8',
        'scene_type': 'civilization',
        'title': 'Hindistan (Vedik)',
        'time_of_day': 'MÖ 1500 - MÖ 500',
        'season': 'Hint Alt Kıtası',
        'civilization': 'Kast Sistemi',
        'activities': 'Yoga, Ayurveda, Matematik|||Stupalar, Tapınaklar|||Heykeller, Duvar Resimleri|||Hinduizm (Brahma, Vishnu, Shiva)',
        'description': 'Savaş Filleri, Okçular|||Baharat, Pamuk, Değerli Taşlar|||Sanskrit, Brahmi Yazısı|||Yoga, Sıfır, Ondalık Sistem',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
    ];

    for (final civ in civilizations) {
      await db.insert('daily_life_scenes', civ);
    }
  }
}
