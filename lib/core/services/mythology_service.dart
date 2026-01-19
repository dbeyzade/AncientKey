import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';

final mythologyServiceProvider = Provider((ref) => MythologyService());

class MythologyEntry {
  final String id;
  final String civilization;
  final String deityName;
  final String? role;
  final String? description;
  final String? symbols;
  final String? relatedMyths;
  final String? imageUrl;
  final DateTime createdAt;

  MythologyEntry({
    required this.id,
    required this.civilization,
    required this.deityName,
    this.role,
    this.description,
    this.symbols,
    this.relatedMyths,
    this.imageUrl,
    required this.createdAt,
  });

  factory MythologyEntry.fromMap(Map<String, dynamic> map) {
    return MythologyEntry(
      id: map['id'],
      civilization: map['civilization'],
      deityName: map['deity_name'],
      role: map['role'],
      description: map['description'],
      symbols: map['symbols'],
      relatedMyths: map['related_myths'],
      imageUrl: map['image_url'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
    );
  }

  List<String> get symbolsList => 
      symbols?.split(',').map((e) => e.trim()).toList() ?? [];

  List<String> get mythsList => 
      relatedMyths?.split('|').map((e) => e.trim()).toList() ?? [];
}

class MythologyService {
  final _uuid = const Uuid();

  Future<void> addEntry(MythologyEntry entry) async {
    final db = await AppDatabase().database;
    await db.insert('mythology', {
      'id': entry.id,
      'civilization': entry.civilization,
      'deity_name': entry.deityName,
      'role': entry.role,
      'description': entry.description,
      'symbols': entry.symbols,
      'related_myths': entry.relatedMyths,
      'image_url': entry.imageUrl,
      'created_at': entry.createdAt.millisecondsSinceEpoch,
    });
  }

  Future<List<MythologyEntry>> getEntriesByCivilization(String civilization) async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'mythology',
      where: 'civilization = ?',
      whereArgs: [civilization],
      orderBy: 'deity_name ASC',
    );
    return results.map((e) => MythologyEntry.fromMap(e)).toList();
  }

  Future<List<MythologyEntry>> searchEntries(String query) async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'mythology',
      where: 'deity_name LIKE ? OR description LIKE ? OR role LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'deity_name ASC',
    );
    return results.map((e) => MythologyEntry.fromMap(e)).toList();
  }

  Future<List<String>> getAllCivilizations() async {
    final db = await AppDatabase().database;
    final results = await db.rawQuery(
      'SELECT DISTINCT civilization FROM mythology ORDER BY civilization',
    );
    return results.map((e) => e['civilization'] as String).toList();
  }

  Future<MythologyEntry?> getEntryById(String id) async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'mythology',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (results.isEmpty) return null;
    return MythologyEntry.fromMap(results.first);
  }

  Future<List<MythologyEntry>> getAllEntries() async {
    final db = await AppDatabase().database;
    
    // Check if data exists, if not insert sample data
    final count = await db.query('mythology');
    if (count.isEmpty) {
      await insertSampleDeities();
    }
    
    final results = await db.query(
      'mythology',
      orderBy: 'civilization ASC, deity_name ASC',
    );
    return results.map((e) => MythologyEntry.fromMap(e)).toList();
  }

  Future<void> insertSampleDeities() async {
    final db = await AppDatabase().database;
    
    final deities = [
      // Yunan Mitolojisi
      {'civilization': 'Yunan', 'deity_name': 'Zeus', 'role': 'Tanrıların Kralı, Gök ve Yıldırım Tanrısı', 'description': 'Olimpos\'un en güçlü tanrısı. Gökyüzü, hava olayları ve adaletin efendisi.', 'symbols': 'Yıldırım, kartal, meşe ağacı', 'related_myths': 'Titanlar\'a karşı savaş|Europa\'nın kaçırılması'},
      {'civilization': 'Yunan', 'deity_name': 'Hera', 'role': 'Tanrıların Kraliçesi, Evlilik ve Aile Tanrıçası', 'description': 'Zeus\'un eşi ve kız kardeşi. Evliliğin, kadınların ve doğumun koruyucusu.', 'symbols': 'Tavus kuşu, nar, aslan', 'related_myths': 'Herakles\'e düşmanlık|Argos\'un 100 gözlü bekçisi'},
      {'civilization': 'Yunan', 'deity_name': 'Poseidon', 'role': 'Deniz, Deprem ve Atlar Tanrısı', 'description': 'Denizlerin hükümdarı. Üç dişli mızrağıyla dalgaları ve depremleri kontrol eder.', 'symbols': 'Trident, at, yunuslar', 'related_myths': 'Atlantis efsanesi|Odysseus\'un yolculuğu'},
      {'civilization': 'Yunan', 'deity_name': 'Athena', 'role': 'Bilgelik, Savaş Stratejisi ve Zanaatlar Tanrıçası', 'description': 'Zeus\'un başından doğan tanrıça. Savaş stratejisi, zeka ve zanaatların koruyucusu.', 'symbols': 'Baykuş, zeytin ağacı, kalkan', 'related_myths': 'Atina\'nın kurucusu|Arachne ile dokuma yarışması'},
      {'civilization': 'Yunan', 'deity_name': 'Apollo', 'role': 'Güneş, Müzik, Şiir ve Kehanet Tanrısı', 'description': 'Işığın, sanatların ve gerçeğin tanrısı. Delfi kehanetiyle geleceği bildirir.', 'symbols': 'Lir, defne ağacı, güneş arabası', 'related_myths': 'Python yılanını öldürmesi|Daphne\'nin defneye dönüşmesi'},
      {'civilization': 'Yunan', 'deity_name': 'Artemis', 'role': 'Av, Vahşi Doğa ve Ay Tanrıçası', 'description': 'Apollo\'nun ikiz kardeşi. Avcılığın, vahşi hayvanların ve bekarlığın koruyucusu.', 'symbols': 'Yay ve ok, geyik, hilal', 'related_myths': 'Aktaion\'un cezalandırılması|Kallisto mitolojisi'},
      {'civilization': 'Yunan', 'deity_name': 'Ares', 'role': 'Savaş ve Şiddet Tanrısı', 'description': 'Savaşın vahşi ve kanlı yönünün tanrısı. Athena\'nın aksine stratejiden ziyade güç kullanır.', 'symbols': 'Kılıç, mızrak, köpek', 'related_myths': 'Aphrodite ile aşk ilişkisi|Amazonlar efsanesi'},
      {'civilization': 'Yunan', 'deity_name': 'Aphrodite', 'role': 'Aşk, Güzellik ve Tutku Tanrıçası', 'description': 'Deniz köpüğünden doğan tanrıça. Aşk, güzellik ve cinsel arzuların hükümdarı.', 'symbols': 'Güvercin, gül, deniz kabuğu', 'related_myths': 'Paris\'in seçimi|Eros ve Psyche'},
      {'civilization': 'Yunan', 'deity_name': 'Hephaestus', 'role': 'Ateş, Demircilik ve Zanaatlar Tanrısı', 'description': 'Tanrıların demircisi. İlahi silahlar ve zırhlar üretir.', 'symbols': 'Çekiç, örs, ateş', 'related_myths': 'Olimpos\'tan atılması|Pandora\'yı yaratması'},
      {'civilization': 'Yunan', 'deity_name': 'Hermes', 'role': 'Haberci Tanrı, Yolcular ve Tüccarların Koruyucusu', 'description': 'Tanrıların habercisi. Hızlı ve kurnaz, ölüleri yeraltına götürür.', 'symbols': 'Kanatlı sandalet, caduceus', 'related_myths': 'Argus\'u öldürmesi|Lir icadı'},
      {'civilization': 'Yunan', 'deity_name': 'Demeter', 'role': 'Hasat, Tarım ve Bereket Tanrıçası', 'description': 'Tarımın ve hasadın tanrıçası. Mevsimlerin değişiminden sorumludur.', 'symbols': 'Buğday başağı, hasat sepeti, orak', 'related_myths': 'Persephone\'nin kaçırılması|Mevsimlerin kökeni'},
      {'civilization': 'Yunan', 'deity_name': 'Hades', 'role': 'Yeraltı Dünyası ve Ölüler Tanrısı', 'description': 'Yeraltı aleminin hükümdarı. Ölülerin ruhlarını yönetir.', 'symbols': 'Bereket boynuzu, Cerberus', 'related_myths': 'Persephone ile evliliği|Orpheus\'un ziyareti'},
      
      // Mısır Mitolojisi
      {'civilization': 'Mısır', 'deity_name': 'Ra', 'role': 'Güneş Tanrısı, Yaratıcı', 'description': 'En güçlü Mısır tanrısı. Her gün güneş teknesinde gökyüzünde yolculuk eder.', 'symbols': 'Güneş diski, şahin', 'related_myths': 'Yaratılış miti|Her gece Apophis ile savaş'},
      {'civilization': 'Mısır', 'deity_name': 'Osiris', 'role': 'Yeraltı, Ölüm ve Diriliş Tanrısı', 'description': 'Mısır\'ın ilk firavunu. Ölümden sonra dirildi ve yeraltının kralı oldu.', 'symbols': 'Crook ve flail, yeşil ten', 'related_myths': 'Set tarafından öldürülmesi ve dirilişi'},
      {'civilization': 'Mısır', 'deity_name': 'Isis', 'role': 'Sihir, Annelik ve Şifa Tanrıçası', 'description': 'En güçlü büyücü tanrıça. Osiris\'in eşi ve Horus\'un annesi.', 'symbols': 'Taht, ankh, kanatlar', 'related_myths': 'Osiris\'i diriltmesi|Ra\'nın gizli ismini öğrenmesi'},
      {'civilization': 'Mısır', 'deity_name': 'Horus', 'role': 'Gökyüzü, Krallık ve Koruma Tanrısı', 'description': 'Şahin başlı tanrı. Firavonların koruyucusu ve meşruiyetinin simgesi.', 'symbols': 'Şahin, Horus\'un gözü', 'related_myths': 'Set ile mücadelesi|Babasının öcünü alması'},
      {'civilization': 'Mısır', 'deity_name': 'Anubis', 'role': 'Mumyalama ve Ölülerin Koruyucusu', 'description': 'Çakal başlı tanrı. Ölüleri mumyalar ve yeraltına rehberlik eder.', 'symbols': 'Çakal, mumyalama aletleri', 'related_myths': 'Kalp tartma töreni|Osiris\'in mumyalanması'},
      {'civilization': 'Mısır', 'deity_name': 'Thoth', 'role': 'Bilgelik, Yazı ve Ay Tanrısı', 'description': 'İbis başlı tanrı. Bilimin, yazının ve hesabın mucidi.', 'symbols': 'İbis, papirüs tomarı, kalem', 'related_myths': 'Hiyerogliflerin yaratılması|Ölülerin yargılanması'},
      {'civilization': 'Mısır', 'deity_name': 'Set', 'role': 'Kaos, Çöl ve Fırtına Tanrısı', 'description': 'Kaos ve kargaşanın tanrısı. Osiris\'in katili ama aynı zamanda Ra\'nın koruyucusu.', 'symbols': 'Was asası, garip hayvan formu', 'related_myths': 'Osiris cinayeti|Horus ile savaşı'},
      {'civilization': 'Mısır', 'deity_name': 'Bastet', 'role': 'Evler, Kadınlar ve Kedi Tanrıçası', 'description': 'Kedi tanrıça. Evlerin, kadınların ve doğurganlığın koruyucusu.', 'symbols': 'Kedi, sistrum', 'related_myths': 'Aslan Sekhmet\'in yumuşak hali'},
      {'civilization': 'Mısır', 'deity_name': 'Hathor', 'role': 'Aşk, Güzellik, Müzik ve Neşe Tanrıçası', 'description': 'İnek boynuzlu tanrıça. Aşk, dans, şarap ve müziğin efendisi.', 'symbols': 'İnek boynuzları, sistrum, ayna', 'related_myths': 'Ra\'nın gözü olarak insanları cezalandırması'},
      {'civilization': 'Mısır', 'deity_name': 'Ptah', 'role': 'Yaratıcı, Zanaatkar Tanrısı', 'description': 'Memphis\'in tanrısı. Düşünce ve kelimeyle dünyayı yarattı.', 'symbols': 'Was asası, djed sütunu', 'related_myths': 'Dünyayı düşünceyle yaratması'},
      
      // Norse Mitolojisi
      {'civilization': 'Norse', 'deity_name': 'Odin', 'role': 'Tanrıların Allfather\'ı, Bilgelik ve Savaş', 'description': 'Asgard\'ın hükümdarı. Bilgelik için gözünü feda etti, runları öğrenmek için asıldı.', 'symbols': 'Gungnir mızrağı, iki kuzgun, sekiz bacaklı at', 'related_myths': 'Yggdrasil\'e asılması|Ragnarok kehaneti'},
      {'civilization': 'Norse', 'deity_name': 'Thor', 'role': 'Gök Gürültüsü, Şimşek ve Güç Tanrısı', 'description': 'En popüler Norse tanrısı. Mjolnir çekiciyle devlere karşı savaşır.', 'symbols': 'Mjolnir çekici, keçi arabası, güç kemeri', 'related_myths': 'Jormungandr yılanıyla savaşı|Devlere karşı maceraları'},
      {'civilization': 'Norse', 'deity_name': 'Loki', 'role': 'Hile, Kaos ve Değişim Tanrısı', 'description': 'Şekil değiştiren tanrı. Hem tanrılara yardım eder hem de onlara ihanet eder.', 'symbols': 'Balık ağı, ateş', 'related_myths': 'Baldur\'un ölümü|Ragnarok\'u tetiklemesi'},
      {'civilization': 'Norse', 'deity_name': 'Freyja', 'role': 'Aşk, Güzellik, Savaş ve Sihir Tanrıçası', 'description': 'Vanir tanrıçası. Savaşta ölen kahramanların yarısını alır.', 'symbols': 'Brisingamen kolyesi, kedi arabası, şahin tüyü', 'related_myths': 'Brisingamen\'i kazanması|Seidr büyücülüğü'},
      {'civilization': 'Norse', 'deity_name': 'Freyr', 'role': 'Bereket, Barış ve Refah Tanrısı', 'description': 'Freyja\'nın kardeşi. Hasat, güneş ışığı ve barışın tanrısı.', 'symbols': 'Altın domuz, sihirli gemi', 'related_myths': 'Gerd ile evliliği için kılıcını feda etmesi'},
      {'civilization': 'Norse', 'deity_name': 'Týr', 'role': 'Savaş, Adalet ve Kahramanlık Tanrısı', 'description': 'Tek kollu savaş tanrısı. Fenrir kurdunu bağlamak için elini feda etti.', 'symbols': 'Kılıç, adalet terazisi', 'related_myths': 'Elini Fenrir\'e kaybetmesi'},
      
      // Hindu Mitolojisi  
      {'civilization': 'Hindu', 'deity_name': 'Brahma', 'role': 'Yaratıcı Tanrı', 'description': 'Trimurti\'nin yaratıcısı. Dört başlı tanrı, evrenin yaratıcısı.', 'symbols': 'Dört baş, lotus çiçeği, Vedalar', 'related_myths': 'Evrenin yaratılışı'},
      {'civilization': 'Hindu', 'deity_name': 'Vishnu', 'role': 'Koruyucu Tanrı', 'description': 'Evrenin koruyucusu. Avatar\'lar halinde dünyaya inerek kaosu düzeltir.', 'symbols': 'Dört kol, çakra, shankha', 'related_myths': 'Rama ve Krishna avatar\'ları|Samudra manthan'},
      {'civilization': 'Hindu', 'deity_name': 'Shiva', 'role': 'Yıkıcı ve Dönüştürücü Tanrı', 'description': 'Trimurti\'nin yıkıcısı. Yıkım ve yeniden doğuşun tanrısı.', 'symbols': 'Trident, damaru davulu, üçüncü göz', 'related_myths': 'Tandava dansı|Zehrin yutulması'},
      {'civilization': 'Hindu', 'deity_name': 'Lakshmi', 'role': 'Zenginlik, Refah ve Şans Tanrıçası', 'description': 'Vishnu\'nun eşi. Maddi ve manevi refahın tanrıçası.', 'symbols': 'Lotus, altın sikkeler, fil', 'related_myths': 'Okyanus çalkalanmasından doğuşu'},
      {'civilization': 'Hindu', 'deity_name': 'Saraswati', 'role': 'Bilgi, Sanat ve Müzik Tanrıçası', 'description': 'Brahma\'nın eşi. Bilgelik, öğrenim ve yaratıcılığın tanrıçası.', 'symbols': 'Veena, kitap, kuğu', 'related_myths': 'Ganga nehrinin yaratılışı'},
      {'civilization': 'Hindu', 'deity_name': 'Ganesha', 'role': 'Engellerin Kaldırıcı, Bilgelik Tanrısı', 'description': 'Fil başlı tanrı. Yeni başlangıçların ve bilgeliğin koruyucusu.', 'symbols': 'Fil başı, fare, modak tatlısı', 'related_myths': 'Başının kesilmesi ve fil başı takılması'},
      {'civilization': 'Hindu', 'deity_name': 'Hanuman', 'role': 'Maymun Tanrı, Güç ve Bağlılık', 'description': 'Maymun savaşçı tanrı. Rama\'ya sonsuz sadakatiyle tanınır.', 'symbols': 'Gada, dağ, maymun kuyruğu', 'related_myths': 'Ramayana\'daki kahramanlıkları'},
      {'civilization': 'Hindu', 'deity_name': 'Kali', 'role': 'Yıkım, Zaman ve Değişim Tanrıçası', 'description': 'Shiva\'nın güçlü formu. Şiddet ve dönüşümün tanrıçası.', 'symbols': 'Kafatasları, kılıç, kanlı dil', 'related_myths': 'Raktabija\'yı yenmesi'},
      {'civilization': 'Hindu', 'deity_name': 'Durga', 'role': 'Savaşçı Tanrıça, Kötülüğe Karşı Koruyucu', 'description': 'Sekiz kollu savaşçı tanrıça. Mahishasura\'yı yenen güçlü tanrıça.', 'symbols': 'Aslan, silahlar, lotus', 'related_myths': 'Mahishasura\'yı öldürmesi'},
      
      // Mezopotamya Mitolojisi
      {'civilization': 'Mezopotamya', 'deity_name': 'Anu', 'role': 'Gök Tanrısı, Tanrıların Kralı', 'description': 'Pantheon\'un başkanı. Gökyüzünün ve ilahi otoritenin tanrısı.', 'symbols': 'Yıldızlı taç, aslan', 'related_myths': 'Tiamat yaratılış miti'},
      {'civilization': 'Mezopotamya', 'deity_name': 'Enlil', 'role': 'Hava, Rüzgar ve Fırtına Tanrısı', 'description': 'Güçlü tanrı. Rüzgarları ve fırtınaları kontrol eder.', 'symbols': 'Fırtına, tablet', 'related_myths': 'Tufan efsanesi'},
      {'civilization': 'Mezopotamya', 'deity_name': 'Enki', 'role': 'Su, Bilgelik ve Yaratıcılık Tanrısı', 'description': 'Tatlı suların tanrısı. İnsanlığın yaratıcısı ve koruyucusu.', 'symbols': 'Su akıntıları, balık', 'related_myths': 'İnsanlığı yaratması|Tufan\'da Ziusudra\'yı uyarması'},
      {'civilization': 'Mezopotamya', 'deity_name': 'Inanna', 'role': 'Aşk, Savaş ve Venüs Tanrıçası', 'description': 'Güçlü tanrıça. Hem aşkın hem de savaşın efendisi.', 'symbols': 'Sekiz kollu yıldız, aslan', 'related_myths': 'Yeraltına inişi|Dumuzi ile aşk'},
      {'civilization': 'Mezopotamya', 'deity_name': 'Marduk', 'role': 'Babil\'in Baş Tanrısı, Yaratıcı', 'description': 'Babil\'in koruyucusu. Tiamat\'ı yenerek dünyayı yarattı.', 'symbols': 'Ejderha, yıldırım', 'related_myths': 'Enuma Eliş yaratılış destanı'},
      {'civilization': 'Mezopotamya', 'deity_name': 'Ishtar', 'role': 'Aşk ve Savaş Tanrıçası', 'description': 'Aşk ve savaşın güçlü tanrıçası. Venüs yıldızının kişileştirilmesi.', 'symbols': 'Aslan, sekiz kollu yıldız', 'related_myths': 'Gılgamış Destanı\'nda rolü'},
      {'civilization': 'Mezopotamya', 'deity_name': 'Shamash', 'role': 'Güneş ve Adalet Tanrısı', 'description': 'Güneş tanrısı. Adaletin ve gerçeğin sembolü.', 'symbols': 'Güneş diski, testere', 'related_myths': 'Hammurabi\'ye kanunları vermesi'},
    ];

    for (int i = 0; i < deities.length; i++) {
      final deity = deities[i];
      await db.insert('mythology', {
        'id': 'deity_${i + 1}',
        ...deity,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }
}
