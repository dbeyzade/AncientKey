import '../database/app_database.dart';

class Inscription {
  final String id;
  final String mapId;
  final String scriptType;
  final String originalText;
  final String? translation;
  final String? transliteration;
  final String? language;
  final String? dateCarved;
  final String? imageUrl;
  final bool deciphered;

  Inscription({
    required this.id,
    required this.mapId,
    required this.scriptType,
    required this.originalText,
    this.translation,
    this.transliteration,
    this.language,
    this.dateCarved,
    this.imageUrl,
    this.deciphered = false,
  });

  factory Inscription.fromMap(Map<String, dynamic> map) {
    return Inscription(
      id: map['id'],
      mapId: map['map_id'],
      scriptType: map['script_type'],
      originalText: map['original_text'],
      translation: map['translation'],
      transliteration: map['transliteration'],
      language: map['language'],
      dateCarved: map['date_carved'],
      imageUrl: map['image_url'],
      deciphered: map['deciphered'] == 1,
    );
  }
}

class InscriptionsService {
  Future<List<Inscription>> getAllInscriptions() async {
    final db = await AppDatabase().database;
    
    final existing = await db.query('inscriptions');
    if (existing.isEmpty) {
      await insertSampleInscriptions();
    }
    
    final results = await db.query('inscriptions', orderBy: 'script_type ASC');
    return results.map((map) => Inscription.fromMap(map)).toList();
  }

  Future<void> insertSampleInscriptions() async {
    final db = await AppDatabase().database;
    
    final inscriptions = [
      // Mısır Hiyeroglifleri
      {'script_type': 'Mısır Hiyeroglifleri', 'original_text': '𓅃𓅄𓅓𓆣', 'translation': 'Tanrı Ra\'nın adı ve gücü ebediyen yaşasın', 'transliteration': 'Ra netjer aA', 'language': 'Antik Mısır Dili', 'date_carved': 'MÖ 1500', 'deciphered': 1},
      {'script_type': 'Mısır Hiyeroglifleri', 'original_text': '𓂀𓏤𓆑𓂋𓏏𓊖', 'translation': 'Sonsuz yaşamın kapıları açıktır', 'transliteration': 'anx Dt wAH', 'language': 'Antik Mısır Dili', 'date_carved': 'MÖ 1200', 'deciphered': 1},
      {'script_type': 'Mısır Hiyeroglifleri', 'original_text': '𓊵𓏏𓊪𓅱𓊪𓏏', 'translation': 'Osiris\'in ruhu göklerde yükselsin', 'transliteration': 'Wsir bA pt', 'language': 'Antik Mısır Dili', 'date_carved': 'MÖ 1400', 'deciphered': 1},
      {'script_type': 'Mısır Hiyeroglifleri', 'original_text': '𓋹𓊃𓏤𓆓𓆑', 'translation': 'Firavun, tanrıların sözlerini yazdı', 'transliteration': 'nsw bity mdw nTr', 'language': 'Antik Mısır Dili', 'date_carved': 'MÖ 1350', 'deciphered': 1},
      {'script_type': 'Mısır Hiyeroglifleri', 'original_text': '𓏤𓆓𓂧𓇋𓇋', 'translation': 'İsis\'in sihirli koruması altında', 'transliteration': 'Ast HkAw', 'language': 'Antik Mısır Dili', 'date_carved': 'MÖ 1100', 'deciphered': 1},
      {'script_type': 'Mısır Hiyeroglifleri', 'original_text': '𓊹𓊹𓊹𓏏𓏏𓏏', 'translation': 'Tanrılar meclisi adaleti sağlar', 'transliteration': 'nTrw psDt mAat', 'language': 'Antik Mısır Dili', 'date_carved': 'MÖ 1600', 'deciphered': 1},
      {'script_type': 'Mısır Hiyeroglifleri', 'original_text': '𓋴𓌳𓂦𓏤', 'translation': 'Anubis ölülere rehberlik eder', 'transliteration': 'Inpw sSmw', 'language': 'Antik Mısır Dili', 'date_carved': 'MÖ 1300', 'deciphered': 1},
      {'script_type': 'Mısır Hiyeroglifleri', 'original_text': '𓎛𓏏𓏏𓏥', 'translation': 'Hathor, altın gökyüzünün hanımefendisi', 'transliteration': 'Hwt-Hr nbt pt', 'language': 'Antik Mısır Dili', 'date_carved': 'MÖ 1250', 'deciphered': 1},
      {'script_type': 'Mısır Hiyeroglifleri', 'original_text': '𓊵𓏏𓊪𓆄𓏏', 'translation': 'Thoth bilgeliği kaydeder', 'transliteration': 'DHwty sxA', 'language': 'Antik Mısır Dili', 'date_carved': 'MÖ 1450', 'deciphered': 1},
      {'script_type': 'Mısır Hiyeroglifleri', 'original_text': '𓂋𓏤𓆓𓂧', 'translation': 'Horus, babasının tahtını korur', 'transliteration': 'Hr nxt', 'language': 'Antik Mısır Dili', 'date_carved': 'MÖ 1550', 'deciphered': 1},
      
      // Çivi Yazısı (Cuneiform)
      {'script_type': 'Çivi Yazısı', 'original_text': '𒀭𒈹𒊹', 'translation': 'Kral Hammurabi adalet yasalarını koydurgular', 'transliteration': 'lugal Ha-am-mu-ra-bi', 'language': 'Akadca', 'date_carved': 'MÖ 1750', 'deciphered': 1},
      {'script_type': 'Çivi Yazısı', 'original_text': '𒄀𒂵𒈩𒆠', 'translation': 'Gılgamış, Uruk\'un güçlü kralı', 'transliteration': 'Gilgamesh lugal Uruk', 'language': 'Sümerce', 'date_carved': 'MÖ 2100', 'deciphered': 1},
      {'script_type': 'Çivi Yazısı', 'original_text': '𒀭𒂗𒆤', 'translation': 'Tanrı Enlil fırtınaları gönderir', 'transliteration': 'dingir Enlil IM', 'language': 'Sümerce', 'date_carved': 'MÖ 2500', 'deciphered': 1},
      {'script_type': 'Çivi Yazısı', 'original_text': '𒀭𒈹𒈠', 'translation': 'Tanrıça İnanna göklerde parlar', 'transliteration': 'dingir Inanna an', 'language': 'Sümerce', 'date_carved': 'MÖ 2300', 'deciphered': 1},
      {'script_type': 'Çivi Yazısı', 'original_text': '𒀭𒂗𒆠', 'translation': 'Tanrı Enki bilgeliği verir', 'transliteration': 'dingir Enki gestug', 'language': 'Sümerce', 'date_carved': 'MÖ 2400', 'deciphered': 1},
      {'script_type': 'Çivi Yazısı', 'original_text': '𒊩𒌆𒀭𒈾', 'translation': 'Kraliçe nehir kıyısında tapınak inşa etti', 'transliteration': 'nin id E2 du3', 'language': 'Sümerce', 'date_carved': 'MÖ 2200', 'deciphered': 1},
      {'script_type': 'Çivi Yazısı', 'original_text': '𒀭𒀫𒋙', 'translation': 'Tanrı Marduk Babil\'i koruyor', 'transliteration': 'dingir Marduk KA2.DINGIR.RA', 'language': 'Akadca', 'date_carved': 'MÖ 1200', 'deciphered': 1},
      {'script_type': 'Çivi Yazısı', 'original_text': '𒈗𒊒𒄷', 'translation': 'Kral büyük savaşta zafer kazandı', 'transliteration': 'lugal me3 gal', 'language': 'Akadca', 'date_carved': 'MÖ 1400', 'deciphered': 1},
      
      // Yunan Alfabesi
      {'script_type': 'Antik Yunan', 'original_text': 'ΓΝΩΘΙ ΣΕΑΥΤΟΝ', 'translation': 'Kendini bil', 'transliteration': 'Gnothi seauton', 'language': 'Antik Yunanca', 'date_carved': 'MÖ 400', 'deciphered': 1},
      {'script_type': 'Antik Yunan', 'original_text': 'ΜΗΔΕΝ ΑΓΑΝ', 'translation': 'Her şeyde ölçülü ol', 'transliteration': 'Meden agan', 'language': 'Antik Yunanca', 'date_carved': 'MÖ 450', 'deciphered': 1},
      {'script_type': 'Antik Yunan', 'original_text': 'ΚΑΛΟΣ ΚΑΓΑΘΟΣ', 'translation': 'Güzel ve iyi', 'transliteration': 'Kalos kagathos', 'language': 'Antik Yunanca', 'date_carved': 'MÖ 500', 'deciphered': 1},
      {'script_type': 'Antik Yunan', 'original_text': 'ΕΥΤΥΧΗΣ Ο ΜΑΘΩΝ', 'translation': 'Öğrenen mutludur', 'transliteration': 'Eutykhas ho mathon', 'language': 'Antik Yunanca', 'date_carved': 'MÖ 350', 'deciphered': 1},
      {'script_type': 'Antik Yunan', 'original_text': 'ΑΡΕΤΗ ΠΑΝΤΩΝ ΚΡΑΤΙΣΤΟΝ', 'translation': 'Erdem her şeyden üstündür', 'transliteration': 'Arete panton kratiston', 'language': 'Antik Yunanca', 'date_carved': 'MÖ 420', 'deciphered': 1},
      
      // Latince
      {'script_type': 'Latince', 'original_text': 'SENATUS POPULUSQUE ROMANUS', 'translation': 'Roma Senatosu ve Halkı', 'transliteration': 'S.P.Q.R.', 'language': 'Latince', 'date_carved': 'MÖ 100', 'deciphered': 1},
      {'script_type': 'Latince', 'original_text': 'VENI VIDI VICI', 'translation': 'Geldim, gördüm, yendim', 'transliteration': 'Veni vidi vici', 'language': 'Latince', 'date_carved': 'MÖ 47', 'deciphered': 1},
      {'script_type': 'Latince', 'original_text': 'MEMENTO MORI', 'translation': 'Ölümlü olduğunu hatırla', 'transliteration': 'Memento mori', 'language': 'Latince', 'date_carved': 'MS 100', 'deciphered': 1},
      {'script_type': 'Latince', 'original_text': 'ARS LONGA VITA BREVIS', 'translation': 'Sanat uzun, hayat kısa', 'transliteration': 'Ars longa vita brevis', 'language': 'Latince', 'date_carved': 'MS 50', 'deciphered': 1},
      {'script_type': 'Latince', 'original_text': 'CARPE DIEM', 'translation': 'Günü yaşa/değerlendir', 'transliteration': 'Carpe diem', 'language': 'Latince', 'date_carved': 'MÖ 23', 'deciphered': 1},
      
      // Rune Yazısı
      {'script_type': 'Rune Yazısı', 'original_text': 'ᚠᚢᚦᚬᚱᚴ', 'translation': 'Futhark alfabesi', 'transliteration': 'Futhark', 'language': 'Eski Norse', 'date_carved': 'MS 800', 'deciphered': 1},
      {'script_type': 'Rune Yazısı', 'original_text': 'ᚦᚬᚱ ᚢᛁᚴᛁᚾᚴᚱ', 'translation': 'Thor Vikingler', 'transliteration': 'Thor vikingr', 'language': 'Eski Norse', 'date_carved': 'MS 900', 'deciphered': 1},
      {'script_type': 'Rune Yazısı', 'original_text': 'ᚱᚬᚴᚱ ᚴᚢᚦ', 'translation': 'Runları tanrı yarattı', 'transliteration': 'Rokr gudh', 'language': 'Eski Norse', 'date_carved': 'MS 700', 'deciphered': 1},
      
      // Maya Hiyeroglifleri
      {'script_type': 'Maya Hiyeroglifleri', 'original_text': '𝋡𝋰𝋱', 'translation': 'Kral Pakal\'ın adı', 'transliteration': 'K\'inich Janaab Pakal', 'language': 'Maya Dili', 'date_carved': 'MS 600', 'deciphered': 1},
      {'script_type': 'Maya Hiyeroglifleri', 'original_text': '𝋢𝋣𝋤', 'translation': 'Zaman döngüsü tamamlandı', 'transliteration': 'K\'atun u tzolij', 'language': 'Maya Dili', 'date_carved': 'MS 700', 'deciphered': 1},
      
      // Çin Yazısı
      {'script_type': 'Antik Çin', 'original_text': '知己知彼百戰不殆', 'translation': 'Kendini ve düşmanını tanırsan, yüz savaşta tehlikede olmazsın', 'transliteration': 'Zhījǐ zhībǐ bǎi zhàn bù dài', 'language': 'Klasik Çince', 'date_carved': 'MÖ 500', 'deciphered': 1},
      {'script_type': 'Antik Çin', 'original_text': '學而時習之不亦說乎', 'translation': 'Öğrenmek ve zamanında tekrar etmek, mutluluk değil midir?', 'transliteration': 'Xué ér shí xí zhī bú yì yuè hū', 'language': 'Klasik Çince', 'date_carved': 'MÖ 400', 'deciphered': 1},
      {'script_type': 'Antik Çin', 'original_text': '上善若水', 'translation': 'En yüksek erdem su gibidir', 'transliteration': 'Shàng shàn ruò shuǐ', 'language': 'Klasik Çince', 'date_carved': 'MÖ 600', 'deciphered': 1},
      
      // Sanskritçe
      {'script_type': 'Sanskritçe', 'original_text': 'ॐ मणि पद्मे हूँ', 'translation': 'Nilüfer çiçeğindeki mücevher', 'transliteration': 'Om mani padme hum', 'language': 'Sanskritçe', 'date_carved': 'MS 400', 'deciphered': 1},
      {'script_type': 'Sanskritçe', 'original_text': 'सत्यमेव जयते', 'translation': 'Gerçek her zaman galip gelir', 'transliteration': 'Satyameva jayate', 'language': 'Sanskritçe', 'date_carved': 'MÖ 200', 'deciphered': 1},
      
      // Arap Yazısı
      {'script_type': 'Arap Yazısı', 'original_text': 'بسم الله الرحمن الرحيم', 'translation': 'Rahman ve Rahim olan Allah\'ın adıyla', 'transliteration': 'Bismillahir rahmanir rahim', 'language': 'Arapça', 'date_carved': 'MS 700', 'deciphered': 1},
      {'script_type': 'Arap Yazısı', 'original_text': 'العلم نور والجهل ظلام', 'translation': 'Bilim ışıktır, cehalet karanlıktır', 'transliteration': 'Al-ilm nur wal-jahl zalam', 'language': 'Arapça', 'date_carved': 'MS 900', 'deciphered': 1},
    ];

    for (int i = 0; i < inscriptions.length; i++) {
      final inscription = inscriptions[i];
      await db.insert('inscriptions', {
        'id': 'inscription_${i + 1}',
        'map_id': 'default',
        ...inscription,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }
}
