import '../database/app_database.dart';

class HistoricalDocument {
  final String id;
  final String title;
  final String? author;
  final String? dateWritten;
  final String? language;
  final String? documentType;
  final String? content;
  final String? translation;
  final String? significance;
  final String? imageUrl;

  HistoricalDocument({
    required this.id,
    required this.title,
    this.author,
    this.dateWritten,
    this.language,
    this.documentType,
    this.content,
    this.translation,
    this.significance,
    this.imageUrl,
  });

  factory HistoricalDocument.fromMap(Map<String, dynamic> map) {
    return HistoricalDocument(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      dateWritten: map['date_written'],
      language: map['language'],
      documentType: map['document_type'],
      content: map['content'],
      translation: map['translation'],
      significance: map['significance'],
      imageUrl: map['image_url'],
    );
  }
}

class HistoricalDocumentsService {
  Future<List<HistoricalDocument>> getAllDocuments() async {
    final db = await AppDatabase().database;
    final results = await db.query('historical_documents', orderBy: 'title ASC');
    return results.map((map) => HistoricalDocument.fromMap(map)).toList();
  }

  Future<List<HistoricalDocument>> getDocumentsByType(String type) async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'historical_documents',
      where: 'document_type = ?',
      whereArgs: [type],
      orderBy: 'title ASC',
    );
    return results.map((map) => HistoricalDocument.fromMap(map)).toList();
  }

  Future<void> insertSampleDocuments() async {
    final db = await AppDatabase().database;
    
    // Check if documents already exist
    final count = await db.query('historical_documents');
    if (count.isNotEmpty) return;

    final documents = [
      // Antik Mısır
      {'id': 'doc1', 'title': 'Rosetta Taşı Yazıtı', 'author': 'Ptolemaios V', 'date_written': 'MÖ 196', 'language': 'Mısır Hiyeroglifleri, Demotik, Antik Yunanca', 'document_type': 'Ferman', 'content': 'Ptolemaios V Epiphanes\'in kutsallığını ilan eden üç dilde yazılmış ferman.', 'translation': 'Ptolemaios V\'in tanrısal yetkilerini ve Mısır\'a katkılarını öven resmi bildiri.', 'significance': 'Mısır hiyerogliflerinin çözülmesinde anahtar rol oynadı.', 'image_url': 'https://example.com/rosetta.jpg'},
      {'id': 'doc2', 'title': 'Ölüler Kitabı', 'author': 'Anonim', 'date_written': 'MÖ 1550-1070', 'language': 'Hiyeroglifler', 'document_type': 'Dini Metin', 'content': 'Ölülerin öteki dünyaya geçişi için büyüler ve dualar içeren papirüs tomarları.', 'translation': 'Ra-Horakhti\'ye övgü, Osiris\'e dualar ve öbür dünyadaki yargılama için formüller.', 'significance': 'Antik Mısır\'ın ölüm sonrası inanışlarını anlatan en önemli kaynak.'},
      {'id': 'doc3', 'title': 'Kahun Papirüsleri', 'author': 'Antik Mısır Hekimleri', 'date_written': 'MÖ 1800', 'language': 'Hiyeratik', 'document_type': 'Tıbbi Metin', 'content': 'Kadın sağlığı, doğum ve jinekoloji hakkında tıbbi bilgiler.', 'translation': 'Hamilelik testi, doğum komplikasyonları ve tedavi yöntemleri.', 'significance': 'Bilinen en eski jinekolojik tıbbi metin.'},
      {'id': 'doc4', 'title': 'Ebers Papirüsü', 'author': 'Anonim', 'date_written': 'MÖ 1550', 'language': 'Hiyeratik', 'document_type': 'Tıbbi Metin', 'content': '700\'den fazla büyü ve ilaç reçetesi içeren kapsamlı tıbbi metin.', 'translation': 'Kalp hastalıkları, diyabet, cilt hastalıkları ve yaralanmalar için tedaviler.', 'significance': 'Antik Mısır tıbbının en kapsamlı kaynağı.'},
      {'id': 'doc5', 'title': 'Edwin Smith Papirüsü', 'author': 'İmhotep (muhtemel)', 'date_written': 'MÖ 1600', 'language': 'Hiyeratik', 'document_type': 'Tıbbi Metin', 'content': 'Travma ve cerrahi tedaviler hakkında 48 vaka çalışması.', 'translation': 'Kafatası kırıkları, omurga yaralanmaları ve diğer travmatik yaralanmalar için sistematik inceleme.', 'significance': 'Bilinen en eski cerrahi metin.'},
      
      // Mezopotamya
      {'id': 'doc6', 'title': 'Gılgamış Destanı', 'author': 'Sin-liqe-unninni', 'date_written': 'MÖ 2100-1200', 'language': 'Akadca Çivi Yazısı', 'document_type': 'Edebi Eser', 'content': 'Uruk kralı Gılgamış\'ın ölümsüzlük arayışını anlatan destan.', 'translation': 'Gılgamış ve Enkidu\'nun maceraları, Tufan hikayesi ve ölümsüzlük arayışı.', 'significance': 'Dünyanın en eski bilinen edebi eseri.'},
      {'id': 'doc7', 'title': 'Hammurabi Kanunları', 'author': 'Hammurabi', 'date_written': 'MÖ 1754', 'language': 'Akadca', 'document_type': 'Hukuk Metni', 'content': '282 maddeden oluşan antik hukuk kodu.', 'translation': 'Göze göz, dişe diş prensibi ve diğer ceza ve hukuk kuralları.', 'significance': 'En eski ve en kapsamlı yazılı hukuk sistemlerinden biri.'},
      {'id': 'doc8', 'title': 'Enuma Eliş', 'author': 'Anonim', 'date_written': 'MÖ 18. yüzyıl', 'language': 'Akadca', 'document_type': 'Yaratılış Destanı', 'content': 'Babil yaratılış miti - Marduk\'un Tiamat\'ı yenmesi.', 'translation': 'Tanrılar arası savaş ve dünyanın yaratılışı destanı.', 'significance': 'Babil dininin ve kozmolojisinin temel metni.'},
      {'id': 'doc9', 'title': 'Sümer Kral Listesi', 'author': 'Anonim', 'date_written': 'MÖ 2100', 'language': 'Sümerce', 'document_type': 'Tarihsel Kayıt', 'content': 'Sümer şehir devletlerinin krallarını ve hükümdarlık sürelerini listeleyen metin.', 'translation': 'Tufandan önce ve sonraki krallar listesi ve hükümdarlık süreleri.', 'significance': 'Antik Mezopotamya kronolojisi için önemli kaynak.'},
      {'id': 'doc10', 'title': 'İnanna\'nın Yeraltı Dünyasına İnişi', 'author': 'Anonim', 'date_written': 'MÖ 3000', 'language': 'Sümerce', 'document_type': 'Mit', 'content': 'Tanrıça İnanna\'nın yeraltı dünyasına yolculuğu.', 'translation': 'İnanna\'nın yedi kapıdan geçişi ve Ereşkigal ile karşılaşması.', 'significance': 'Mezopotamya mitolojisinin önemli metni.'},
      
      // Antik Yunan
      {'id': 'doc11', 'title': 'İlyada', 'author': 'Homeros', 'date_written': 'MÖ 8. yüzyıl', 'language': 'Antik Yunanca', 'document_type': 'Destan', 'content': 'Truva Savaşı\'nın son yılını anlatan epik şiir.', 'translation': 'Akhilleus\'un öfkesi ve Truva\'nın düşüşü.', 'significance': 'Batı edebiyatının temel taşlarından biri.'},
      {'id': 'doc12', 'title': 'Odysseia', 'author': 'Homeros', 'date_written': 'MÖ 8. yüzyıl', 'language': 'Antik Yunanca', 'document_type': 'Destan', 'content': 'Odysseus\'un Truva Savaşı sonrası on yıllık eve dönüş yolculuğu.', 'translation': 'Kyklops, Kirke, Seirenlere ve diğer tehlikelere karşı maceralar.', 'significance': 'Macera edebiyatının ilk örneklerinden.'},
      {'id': 'doc13', 'title': 'Devlet', 'author': 'Platon', 'date_written': 'MÖ 380', 'language': 'Antik Yunanca', 'document_type': 'Felsefi Metin', 'content': 'Adalet, ideal devlet ve felsefe kralları hakkında diyaloglar.', 'translation': 'Mağara alegorisi ve ideal toplum düzeni tartışmaları.', 'significance': 'Batı felsefesinin en etkili eserlerinden.'},
      {'id': 'doc14', 'title': 'Nikomakhos\'a Etik', 'author': 'Aristoteles', 'date_written': 'MÖ 350', 'language': 'Antik Yunanca', 'document_type': 'Felsefi Metin', 'content': 'İyi yaşam, erdem ve mutluluk üzerine inceleme.', 'translation': 'Orta yol doktrini ve eudaimonia (iyi yaşam) anlayışı.', 'significance': 'Etik felsefesinin temel metinlerinden.'},
      {'id': 'doc15', 'title': 'Historiai (Tarih)', 'author': 'Herodotos', 'date_written': 'MÖ 430', 'language': 'Antik Yunanca', 'document_type': 'Tarih Yazımı', 'content': 'Pers Savaşları ve dönemin kültürleri hakkında kapsamlı inceleme.', 'translation': 'Yunan-Pers çatışmaları ve antik dünya coğrafyası.', 'significance': 'Batı tarih yazımının kurucusu sayılır.'},
      
      // Roma
      {'id': 'doc16', 'title': 'De Bello Gallico (Galya Savaşları)', 'author': 'Julius Caesar', 'date_written': 'MÖ 58-49', 'language': 'Latince', 'document_type': 'Tarih/Askeri Rapor', 'content': 'Caesar\'ın Galya\'daki askeri seferlerinin günlüğü.', 'translation': 'Galya kabileleri, savaş stratejileri ve fetihler.', 'significance': 'Birinci elden askeri tarih kaynağı.'},
      {'id': 'doc17', 'title': 'Aeneis', 'author': 'Vergilius', 'date_written': 'MÖ 29-19', 'language': 'Latince', 'document_type': 'Destan', 'content': 'Truvalı kahraman Aeneas\'ın Roma\'nın kuruluşuna giden yolculuğu.', 'translation': 'Truva\'nın düşüşünden Roma\'nın mitolojik kökenlerine.', 'significance': 'Roma ulusal destanı.'},
      {'id': 'doc18', 'title': 'Dönüşümler (Metamorphoses)', 'author': 'Ovidius', 'date_written': 'MS 8', 'language': 'Latince', 'document_type': 'Mitolojik Şiir', 'content': '250 den fazla Yunan ve Roma miti içeren epik şiir.', 'translation': 'Yaratılıştan Julius Caesar\'a kadar mitolojik dönüşümler.', 'significance': 'Klasik mitolojinin en kapsamlı kaynağı.'},
      {'id': 'doc19', 'title': 'Doğa Üzerine (De Rerum Natura)', 'author': 'Lucretius', 'date_written': 'MÖ 50', 'language': 'Latince', 'document_type': 'Felsefi Şiir', 'content': 'Epikurosçu felsefe ve atomcu teori.', 'translation': 'Maddenin doğası ve evrenin işleyişi hakkında şiirsel inceleme.', 'significance': 'Antik bilimsel düşüncenin önemli eseri.'},
      {'id': 'doc20', 'title': 'On İki Sezar\'ın Yaşamı', 'author': 'Suetonius', 'date_written': 'MS 121', 'language': 'Latince', 'document_type': 'Biyografi', 'content': 'Julius Caesar\'dan Domitianus\'a Roma imparatorlarının biyografileri.', 'translation': 'İmparatorların özel yaşamları, siyasi kararları ve skandalları.', 'significance': 'Roma imparatorluk dönemi için birinci el kaynak.'},
      
      // Çin
      {'id': 'doc21', 'title': 'Tao Te Ching', 'author': 'Laozi', 'date_written': 'MÖ 6. yüzyıl', 'language': 'Klasik Çince', 'document_type': 'Felsefi/Dini Metin', 'content': 'Taoizmin temel metni - Tao (Yol) felsefesi.', 'translation': '81 kısa bölümde doğal düzen ve yaşam bilgeliği.', 'significance': 'Taoist felsefenin temeli.'},
      {'id': 'doc22', 'title': 'Analektler (Lunyu)', 'author': 'Konfüçyüs\'ün öğrencileri', 'date_written': 'MÖ 5. yüzyıl', 'language': 'Klasik Çince', 'document_type': 'Felsefi Metin', 'content': 'Konfüçyüs\'ün öğretileri ve sözleri.', 'translation': 'Ahlak, yönetim ve toplumsal ilişkiler üzerine aforizmalar.', 'significance': 'Konfüçyüsçülüğün temel kaynağı.'},
      {'id': 'doc23', 'title': 'Savaş Sanatı (Sunzi Bingfa)', 'author': 'Sun Tzu', 'date_written': 'MÖ 5. yüzyıl', 'language': 'Klasik Çince', 'document_type': 'Askeri Strateji', 'content': 'Askeri strateji ve taktikler üzerine traktat.', 'translation': 'Savaşın psikolojisi, deception ve strateji ilkeleri.', 'significance': 'Dünyanın en eski ve etkili askeri stratejisi.'},
      {'id': 'doc24', 'title': 'Tarih Kayıtları (Shiji)', 'author': 'Sima Qian', 'date_written': 'MÖ 109-91', 'language': 'Klasik Çince', 'document_type': 'Tarih', 'content': 'Çin\'in mitolojik dönemden Han hanedanlığına kapsamlı tarihi.', 'translation': 'İmparatorlar, hanedanlar ve önemli olayların kronolojisi.', 'significance': 'Geleneksel Çin tarih yazımının modeli.'},
      {'id': 'doc25', 'title': 'I Ching (Değişimler Kitabı)', 'author': 'Anonim', 'date_written': 'MÖ 1000-750', 'language': 'Klasik Çince', 'document_type': 'Kehanet/Felsefe', 'content': '64 heksagram ile fal ve kozmolojik felsefe.', 'translation': 'Yin-yang dengesi ve değişim prensibi.', 'significance': 'Çin felsefesinin en eski metinlerinden.'},
      
      // Hindistan
      {'id': 'doc26', 'title': 'Rigveda', 'author': 'Anonim', 'date_written': 'MÖ 1500-1200', 'language': 'Vedik Sanskritçe', 'document_type': 'Dini İlahi', 'content': '1,028 Vedik ilahi içeren en eski Hindu metni.', 'translation': 'Tanrılara övgü ve kozmolojik ilahiler.', 'significance': 'Hint-Avrupa dillerinin en eski yazılı örneği.'},
      {'id': 'doc27', 'title': 'Upanişadlar', 'author': 'Çeşitli bilgeler', 'date_written': 'MÖ 800-200', 'language': 'Sanskritçe', 'document_type': 'Felsefi/Dini', 'content': 'Hindu felsefesinin temel öğretileri.', 'translation': 'Brahman, Atman ve moksha (kurtuluş) kavramları.', 'significance': 'Hindu ve Budist felsefesinin temeli.'},
      {'id': 'doc28', 'title': 'Bhagavad Gita', 'author': 'Vyasa (geleneksel)', 'date_written': 'MÖ 5.-2. yüzyıl', 'language': 'Sanskritçe', 'document_type': 'Felsefi/Dini Şiir', 'content': 'Mahabharata\'nın bir parçası - Krishna ve Arjuna arasında diyalog.', 'translation': 'Dharma, yoga ve ruhsal öğretiler.', 'significance': 'Hinduizmin en kutsal metinlerinden.'},
      {'id': 'doc29', 'title': 'Ramayana', 'author': 'Valmiki', 'date_written': 'MÖ 5.-4. yüzyıl', 'language': 'Sanskritçe', 'document_type': 'Destan', 'content': 'Rama\'nın Sita\'yı kurtarma hikayesi.', 'translation': 'İdeal kral ve ideal erkek örneği olarak Rama.', 'significance': 'Hindu edebiyatının temel destanı.'},
      {'id': 'doc30', 'title': 'Arthashastra', 'author': 'Kautilya (Chanakya)', 'date_written': 'MÖ 4.-2. yüzyıl', 'language': 'Sanskritçe', 'document_type': 'Siyaset Bilimi', 'content': 'Devlet yönetimi, ekonomi ve diplomasi üzerine traktat.', 'translation': 'Krallık yönetimi, casusluk ve realpolitik.', 'significance': 'Antik dönemin en kapsamlı siyaset bilimi eseri.'},
      
      // İslam Dönemi
      {'id': 'doc31', 'title': 'Kitab al-Hiyal (Mekanik Aletler Kitabı)', 'author': 'Banu Musa Kardeşler', 'date_written': '9. yüzyıl', 'language': 'Arapça', 'document_type': 'Bilimsel', 'content': '100 mekanik alet ve otomat tasarımı.', 'translation': 'Su saatleri, otomatik kapılar ve mekanik aletler.', 'significance': 'İslam Altın Çağı mühendisliğinin önemli eseri.'},
      {'id': 'doc32', 'title': 'Kitab al-Jabr (Cebir Kitabı)', 'author': 'Al-Khwarizmi', 'date_written': '820', 'language': 'Arapça', 'document_type': 'Matematik', 'content': 'Cebir ve denklem çözme yöntemleri.', 'translation': 'İkinci derece denklemler ve cebirsel yöntemler.', 'significance': 'Modern cebirin temeli.'},
      {'id': 'doc33', 'title': 'Kitab al-Manazir (Optik Kitabı)', 'author': 'Ibn al-Haytham (Alhazen)', 'date_written': '1011-1021', 'language': 'Arapça', 'document_type': 'Bilimsel', 'content': 'Işık, görme ve optik üzerine yedi ciltlik çalışma.', 'translation': 'Işığın yansıması, kırılması ve gözün anatomisi.', 'significance': 'Modern optiğin ve bilimsel yöntemin temeli.'},
      {'id': 'doc34', 'title': 'Kanun fi\'t-Tıbb (Tıp Kanunu)', 'author': 'İbn Sina (Avicenna)', 'date_written': '1025', 'language': 'Arapça', 'document_type': 'Tıbbi', 'content': 'Beş kitaptan oluşan tıbbi ansiklopedi.', 'translation': 'Anatomi, hastalıklar, ilaçlar ve cerrahi.', 'significance': 'Yüzyıllarca Avrupa ve İslam dünyasında standart tıp metni.'},
      {'id': 'doc35', 'title': 'Mukaddime', 'author': 'İbn Haldun', 'date_written': '1377', 'language': 'Arapça', 'document_type': 'Tarih Felsefesi', 'content': 'Toplum bilimi ve tarih felsefesi.', 'translation': 'Medeniyetlerin yükseliş ve çöküşü, sosyolojik analiz.', 'significance': 'Modern sosyolojinin öncüsü sayılır.'},
      
      // Maya ve Aztek
      {'id': 'doc36', 'title': 'Popol Vuh', 'author': 'Kiche Maya', 'date_written': '16. yüzyıl (Latın alfabesiyle)', 'language': 'Kiche Maya', 'document_type': 'Mit/Tarih', 'content': 'Maya yaratılış miti ve Kiche halkının tarihi.', 'translation': 'Tanrıların insanı yaratması ve İkiz Kahramanlar destanı.', 'significance': 'Maya mitolojisinin en önemli kaynağı.'},
      {'id': 'doc37', 'title': 'Dresden Codex', 'author': 'Maya Yazmanları', 'date_written': '11-12. yüzyıl', 'language': 'Maya Hiyeroglifleri', 'document_type': 'Astronomi/Din', 'content': 'Astronomi tabloları, din törenleri ve kehanet.', 'translation': 'Venüs döngüleri, tutulma tahminleri ve takvim.', 'significance': 'Hayatta kalan en eski Maya el yazması.'},
      {'id': 'doc38', 'title': 'Codex Mendoza', 'author': 'Aztek Yazmanları', 'date_written': '1541', 'language': 'Nahuatl', 'document_type': 'Tarih/Vergi', 'content': 'Aztek imparatorluğu tarihi ve vergi kayıtları.', 'translation': 'Tenochtitlan\'ın kuruluşu, fetihler ve haraç listesi.', 'significance': 'Aztek toplumu hakkında önemli kaynak.'},
      
      // Vikingler
      {'id': 'doc39', 'title': 'Prose Edda', 'author': 'Snorri Sturluson', 'date_written': '1220', 'language': 'Eski İskandinav', 'document_type': 'Mitoloji', 'content': 'Norse mitolojisi ve şiir sanatı kılavuzu.', 'translation': 'Odin, Thor, Loki ve diğer tanrıların hikayeleri.', 'significance': 'Norse mitolojisinin en kapsamlı kaynağı.'},
      {'id': 'doc40', 'title': 'Beowulf', 'author': 'Anonim', 'date_written': '8-11. yüzyıl', 'language': 'Eski İngilizce', 'document_type': 'Destan', 'content': 'Kahraman Beowulf\'un canavarlarla savaşı.', 'translation': 'Grendel, Grendel\'in annesi ve ejderha ile mücadele.', 'significance': 'Eski İngilizce edebiyatının en önemli eseri.'},
      
      // Orta Çağ
      {'id': 'doc41', 'title': 'Canterbury Hikayeleri', 'author': 'Geoffrey Chaucer', 'date_written': '1387-1400', 'language': 'Orta İngilizce', 'document_type': 'Edebi', 'content': 'Canterbury\'ye giden hacıların anlattığı 24 hikaye.', 'translation': 'Ortaçağ İngiliz toplumunun farklı kesimlerinden karakterler.', 'significance': 'Orta İngilizce edebiyatının başyapıtı.'},
      {'id': 'doc42', 'title': 'İlahi Komedya', 'author': 'Dante Alighieri', 'date_written': '1308-1320', 'language': 'İtalyanca', 'document_type': 'Destan', 'content': 'Cehennem, Araf ve Cennet\'ten geçiş.', 'translation': 'Dante\'nin manevi yolculuğu ve ortaçağ kozmolojisi.', 'significance': 'İtalyan edebiyatının başyapıtı.'},
      {'id': 'doc43', 'title': 'Magna Carta', 'author': 'İngiliz Baronları', 'date_written': '1215', 'language': 'Latince', 'document_type': 'Yasal Belge', 'content': 'Kral John\'un yetkilerini sınırlayan anayasal belge.', 'translation': 'Baronların hakları ve kralın yetkilerinin sınırlandırılması.', 'significance': 'Modern anayasal demokrasinin temeli.'},
      
      // Rönesans
      {'id': 'doc44', 'title': 'Prens (Il Principe)', 'author': 'Niccolò Machiavelli', 'date_written': '1513', 'language': 'İtalyanca', 'document_type': 'Siyasi Traktat', 'content': 'Siyasi güç ve liderlik üzerine pragmatik analiz.', 'translation': 'Gücü ele geçirme ve koruma stratejileri.', 'significance': 'Modern siyaset biliminin kurucusu.'},
      {'id': 'doc45', 'title': 'Utopia', 'author': 'Thomas More', 'date_written': '1516', 'language': 'Latince', 'document_type': 'Felsefi Roman', 'content': 'İdeal toplum ve sosyal düzen hayali.', 'translation': 'Utopya adasında ideal devlet düzeni.', 'significance': 'Ütopik edebiyatın ilk örneklerinden.'},
      
      // Osmanlı
      {'id': 'doc46', 'title': 'Kanunname-i Sultani', 'author': 'Fatih Sultan Mehmed', 'date_written': '1477-1481', 'language': 'Osmanlı Türkçesi', 'document_type': 'Hukuk', 'content': 'Osmanlı devlet düzeni ve kanunları.', 'translation': 'İdari teşkilat, ceza hukuku ve devlet yönetimi.', 'significance': 'Osmanlı hukuk sisteminin temeli.'},
      {'id': 'doc47', 'title': 'Seyahatname', 'author': 'Evliya Çelebi', 'date_written': '1640-1680', 'language': 'Osmanlı Türkçesi', 'document_type': 'Gezi Yazısı', 'content': '10 ciltlik seyahat günlüğü.', 'translation': 'Osmanlı topraklarında şehirler, halklar ve kültürler.', 'significance': '17. yüzyıl Osmanlı toplumu için benzersiz kaynak.'},
      {'id': 'doc48', 'title': 'Kutadgu Bilig', 'author': 'Yusuf Has Hacib', 'date_written': '1069-1070', 'language': 'Karahanlı Türkçesi', 'document_type': 'Siyasi/Felsefi', 'content': 'Türk dilinde ilk siyasetname.', 'translation': 'Hükümdar için mutluluk veren bilgi - yönetim ilkeleri.', 'significance': 'Türk edebiyatının ilk büyük eseri.'},
      
      // Japonya
      {'id': 'doc49', 'title': 'Genji Monogatari (Genji\'nin Hikayesi)', 'author': 'Murasaki Shikibu', 'date_written': '11. yüzyıl', 'language': 'Japonca', 'document_type': 'Roman', 'content': 'Prens Genji\'nin yaşamı ve aşkları.', 'translation': 'Heian dönemi saray yaşamı ve Japon estetiği.', 'significance': 'Dünyanın ilk romanlarından biri.'},
      {'id': 'doc50', 'title': 'Hagakure (Yaprakların Gölgesinde)', 'author': 'Yamamoto Tsunetomo', 'date_written': '1716', 'language': 'Japonca', 'document_type': 'Samuray Kodu', 'content': 'Bushido - samuray yaşam tarzı ve felsefesi.', 'translation': 'Ölüm kabulü, sadakat ve onur üzerine öğretiler.', 'significance': 'Samuray etiğinin klasik metni.'},
    ];

    for (var doc in documents) {
      await db.insert('historical_documents', {
        ...doc,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }
}
