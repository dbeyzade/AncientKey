import '../database/app_database.dart';

class Model3D {
  final String id;
  final String mapId;
  final String name;
  final String? description;
  final String modelUrl;
  final String? textureUrl;
  final double scale;
  final bool downloaded;

  Model3D({
    required this.id,
    required this.mapId,
    required this.name,
    this.description,
    required this.modelUrl,
    this.textureUrl,
    this.scale = 1.0,
    this.downloaded = false,
  });

  factory Model3D.fromMap(Map<String, dynamic> map) {
    return Model3D(
      id: map['id'],
      mapId: map['map_id'],
      name: map['name'],
      description: map['description'],
      modelUrl: map['model_url'],
      textureUrl: map['texture_url'],
      scale: map['scale'] ?? 1.0,
      downloaded: map['downloaded'] == 1,
    );
  }
}

class Models3DService {
  Future<List<Model3D>> getAllModels() async {
    final db = await AppDatabase().database;
    
    // Check if models exist
    final existing = await db.query('models_3d');
    if (existing.isEmpty) {
      await insertSampleModels();
    }
    
    final results = await db.query('models_3d', orderBy: 'name ASC');
    return results.map((map) => Model3D.fromMap(map)).toList();
  }

  Future<void> insertSampleModels() async {
    final db = await AppDatabase().database;
    
    final models = [
      {'name': 'Parthenon (Atina)', 'description': 'Yunan tanrıçası Athena\'ya adanmış antik tapınak', 'civilization': 'Yunan'},
      {'name': 'Koloseum (Roma)', 'description': 'Roma İmparatorluğu\'nun en büyük amfitiyatrosu', 'civilization': 'Roma'},
      {'name': 'Giza Piramitleri', 'description': 'Keops Piramidi ve Sfenks 3D modeli', 'civilization': 'Mısır'},
      {'name': 'Ayasofya', 'description': 'Bizans mimarisi başyapıtı', 'civilization': 'Bizans'},
      {'name': 'Machu Picchu', 'description': 'İnka İmparatorluğu\'nun kayıp şehri', 'civilization': 'İnka'},
      {'name': 'Petra Hazinesi', 'description': 'Kayalara oyulmuş Nabati başyapıtı', 'civilization': 'Nabati'},
      {'name': 'Stonehenge', 'description': 'Neolitik taş anıt', 'civilization': 'Neolitik'},
      {'name': 'Angkor Wat', 'description': 'Khmer İmparatorluğu\'nun tapınak kompleksi', 'civilization': 'Khmer'},
      {'name': 'Efes Celsus Kütüphanesi', 'description': 'Roma dönemi kütüphanesi', 'civilization': 'Roma'},
      {'name': 'Babil Asma Bahçeleri', 'description': 'Dünyanın Yedi Harikası\'ndan biri (rekonstrüksiyon)', 'civilization': 'Babil'},
      {'name': 'Truva Atı', 'description': 'Efsanevi Truva Atı rekonstrüksiyonu', 'civilization': 'Yunan'},
      {'name': 'Moai Heykelleri (Paskalya Adası)', 'description': 'Rapa Nui\'nin dev taş heykelleri', 'civilization': 'Polinezya'},
      {'name': 'Knossos Sarayı', 'description': 'Minos medeniyetinin saray kompleksi', 'civilization': 'Minos'},
      {'name': 'Ziggurat (Ur)', 'description': 'Sümer ziggurat mabedi', 'civilization': 'Sümer'},
      {'name': 'Pantheon (Roma)', 'description': 'Roma\'nın en iyi korunmuş antik binası', 'civilization': 'Roma'},
      {'name': 'Teotihuacan Piramitleri', 'description': 'Güneş ve Ay Piramitleri', 'civilization': 'Aztek'},
      {'name': 'Karnak Tapınağı', 'description': 'Antik Mısır\'ın en büyük tapınak kompleksi', 'civilization': 'Mısır'},
      {'name': 'Borobudur', 'description': 'Dünyanın en büyük Budist tapınağı', 'civilization': 'Java'},
      {'name': 'Persepolis', 'description': 'Pers İmparatorluğu\'nun başkenti', 'civilization': 'Pers'},
      {'name': 'Forum Romanum', 'description': 'Antik Roma\'nın merkezi meydanı', 'civilization': 'Roma'},
      {'name': 'Akropolis (Atina)', 'description': 'Antik Yunan\'ın kutsal tepesi', 'civilization': 'Yunan'},
      {'name': 'Abu Simbel Tapınakları', 'description': 'Ramses II\'nin dev tapınakları', 'civilization': 'Mısır'},
      {'name': 'Topkapı Sarayı', 'description': 'Osmanlı padişahlarının sarayı', 'civilization': 'Osmanlı'},
      {'name': 'Versailles Sarayı', 'description': 'Fransız monarşisinin görkemli sarayı', 'civilization': 'Fransa'},
      {'name': 'Taj Mahal', 'description': 'Hint-İslam mimarisinin incisi', 'civilization': 'Babür'},
      {'name': 'Çin Seddi', 'description': 'Dünyanın en uzun savunma yapısı', 'civilization': 'Çin'},
      {'name': 'Terrakotta Ordusu', 'description': 'Qin Shi Huang\'ın terrakotta askerleri', 'civilization': 'Çin'},
      {'name': 'Notre Dame Katedrali', 'description': 'Gotik mimari başyapıtı', 'civilization': 'Fransa'},
      {'name': 'Süleymaniye Camii', 'description': 'Mimar Sinan\'ın şaheseri', 'civilization': 'Osmanlı'},
      {'name': 'Chichen Itza', 'description': 'Maya piramidi ve astronomik gözlemevi', 'civilization': 'Maya'},
    ];

    for (int i = 0; i < models.length; i++) {
      final model = models[i];
      await db.insert('models_3d', {
        'id': 'model_${i + 1}',
        'map_id': 'default',
        'name': model['name'],
        'description': model['description'],
        'model_url': 'https://example.com/models/${model['civilization']?.toLowerCase()}_${i + 1}.glb',
        'texture_url': 'https://example.com/textures/${model['civilization']?.toLowerCase()}_${i + 1}.jpg',
        'scale': 1.0,
        'downloaded': 0,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }
}
