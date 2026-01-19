import 'package:flutter/material.dart';
import 'dart:math' as math;

class MLPredictionsScreen extends StatefulWidget {
  const MLPredictionsScreen({super.key});

  @override
  State<MLPredictionsScreen> createState() => _MLPredictionsScreenState();
}

class _MLPredictionsScreenState extends State<MLPredictionsScreen> {
  String? _selectedPredictionType;
  bool _isPredicting = false;
  Map<String, dynamic>? _predictionResult;

  final List<PredictionType> _predictionTypes = [
    PredictionType(
      id: 'age',
      title: 'Eser Yaşı Tahmini',
      description: 'Fotoğraftan eserin tahmini yaşını hesaplar',
      icon: Icons.access_time,
      color: Colors.blue,
    ),
    PredictionType(
      id: 'civilization',
      title: 'Medeniyet Tahmini',
      description: 'Eserin hangi medeniyete ait olduğunu tahmin eder',
      icon: Icons.public,
      color: Colors.green,
    ),
    PredictionType(
      id: 'material',
      title: 'Malzeme Analizi',
      description: 'Eserin yapım malzemesini AI ile tespit eder',
      icon: Icons.science,
      color: Colors.orange,
    ),
    PredictionType(
      id: 'value',
      title: 'Değer Tahmini',
      description: 'Eserin tahmini piyasa değerini hesaplar',
      icon: Icons.monetization_on,
      color: Colors.amber,
    ),
    PredictionType(
      id: 'restoration',
      title: 'Restorasyon İhtiyacı',
      description: 'Eserin restorasyon gereksiniminizi analiz eder',
      icon: Icons.build,
      color: Colors.red,
    ),
    PredictionType(
      id: 'authenticity',
      title: 'Orijinallik Skoru',
      description: 'Eserin özgünlük oranını AI ile değerlendirir',
      icon: Icons.verified,
      color: Colors.purple,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('📊 Tahmin Algoritmaları'),
        elevation: 2,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple[700]!, Colors.purple[500]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: _predictionResult != null
          ? _buildResultView()
          : _buildPredictionTypeSelector(),
    );
  }

  Widget _buildPredictionTypeSelector() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [Colors.purple[100]!, Colors.purple[50]!],
              ),
            ),
            child: Column(
              children: [
                Icon(Icons.psychology, size: 48, color: Colors.purple[700]),
                SizedBox(height: 12),
                Text(
                  'Makine Öğrenmesi ile Tahmin',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[900],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Yapay zeka algoritmalarımız eseriniz hakkında detaylı analizler yapar',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.purple[700]),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 24),
        Text(
          'Tahmin Türünü Seçin',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16),
        ..._predictionTypes.map((type) => _buildPredictionTypeCard(type)),
      ],
    );
  }

  Widget _buildPredictionTypeCard(PredictionType type) {
    final isSelected = _selectedPredictionType == type.id;
    
    return Card(
      elevation: isSelected ? 8 : 2,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _startPrediction(type),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: isSelected
                ? Border.all(color: type.color, width: 2)
                : null,
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: type.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(type.icon, color: type.color, size: 32),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      type.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startPrediction(PredictionType type) async {
    setState(() {
      _selectedPredictionType = type.id;
      _isPredicting = true;
    });

    // Simulate AI processing
    await Future.delayed(Duration(seconds: 3));

    setState(() {
      _isPredicting = false;
      _predictionResult = _generateMockPrediction(type);
    });
  }

  Map<String, dynamic> _generateMockPrediction(PredictionType type) {
    final random = math.Random();
    
    switch (type.id) {
      case 'age':
        return {
          'title': 'Eser Yaşı Tahmini',
          'mainValue': '${2500 + random.nextInt(1500)} Yıl',
          'confidence': 87 + random.nextInt(12),
          'details': [
            {'label': 'Tahmini Dönem', 'value': 'M.Ö. ${500 + random.nextInt(500)}'},
            {'label': 'Hata Payı', 'value': '± ${50 + random.nextInt(100)} yıl'},
            {'label': 'Tarihleme Yöntemi', 'value': 'Stil Analizi + Karbon Test'},
          ],
        };
      case 'civilization':
        final civilizations = ['Hitit İmparatorluğu', 'Frigya Krallığı', 'Lidya Devleti', 'Roma İmparatorluğu'];
        return {
          'title': 'Medeniyet Tahmini',
          'mainValue': civilizations[random.nextInt(civilizations.length)],
          'confidence': 82 + random.nextInt(15),
          'details': [
            {'label': 'Bölge', 'value': 'Anadolu'},
            {'label': 'Alternatif', 'value': civilizations[(random.nextInt(civilizations.length))]},
            {'label': 'Stil Özellikleri', 'value': 'Geometrik desenler'},
          ],
        };
      case 'material':
        final materials = ['Mermer', 'Bronz', 'Terrakota', 'Altın Kaplama', 'Granit'];
        return {
          'title': 'Malzeme Analizi',
          'mainValue': materials[random.nextInt(materials.length)],
          'confidence': 91 + random.nextInt(8),
          'details': [
            {'label': 'Saflık', 'value': '${85 + random.nextInt(14)}%'},
            {'label': 'Kaynak Bölgesi', 'value': 'Anadolu Yaylaları'},
            {'label': 'İşleme Tekniği', 'value': 'El Dövme'},
          ],
        };
      case 'value':
        final value = 50000 + random.nextInt(450000);
        return {
          'title': 'Değer Tahmini',
          'mainValue': '${value.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (match) => '${match[1]}.')} ₺',
          'confidence': 73 + random.nextInt(20),
          'details': [
            {'label': 'Açık Artırma Değeri', 'value': '${(value * 1.3).toInt().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (match) => '${match[1]}.')} ₺'},
            {'label': 'Müze Değeri', 'value': '${(value * 1.8).toInt().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (match) => '${match[1]}.')} ₺'},
            {'label': 'Piyasa Trendi', 'value': 'Yükseliş'},
          ],
        };
      case 'restoration':
        return {
          'title': 'Restorasyon İhtiyacı',
          'mainValue': '${random.nextInt(30) + 40}% İhtiyaç',
          'confidence': 88 + random.nextInt(10),
          'details': [
            {'label': 'Aciliyet', 'value': 'Orta Seviye'},
            {'label': 'Tahmini Süre', 'value': '${3 + random.nextInt(6)} Ay'},
            {'label': 'Tahmini Maliyet', 'value': '${15000 + random.nextInt(35000)} ₺'},
          ],
        };
      case 'authenticity':
        return {
          'title': 'Orijinallik Skoru',
          'mainValue': '${85 + random.nextInt(13)}%',
          'confidence': 90 + random.nextInt(9),
          'details': [
            {'label': 'Taklit Riski', 'value': 'Düşük'},
            {'label': 'Dönem Uyumu', 'value': 'Yüksek'},
            {'label': 'Provenance', 'value': 'Doğrulanmış'},
          ],
        };
      default:
        return {};
    }
  }

  Widget _buildResultView() {
    if (_predictionResult == null) return Container();

    final title = _predictionResult!['title'] as String;
    final mainValue = _predictionResult!['mainValue'] as String;
    final confidence = _predictionResult!['confidence'] as int;
    final details = _predictionResult!['details'] as List<Map<String, String>>;

    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [Colors.purple[600]!, Colors.purple[400]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 64),
                SizedBox(height: 16),
                Text(
                  'Analiz Tamamlandı',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 24),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Tahmin Sonucu',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  mainValue,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[700],
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.analytics, color: Colors.green, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Güven Skoru: $confidence%',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                LinearProgressIndicator(
                  value: confidence / 100,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 24),
        Text(
          'Detaylı Bilgiler',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12),
        ...details.map((detail) => Card(
              margin: EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Icon(Icons.info_outline, color: Colors.purple),
                title: Text(detail['label']!),
                trailing: Text(
                  detail['value']!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[700],
                  ),
                ),
              ),
            )),
        SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              _predictionResult = null;
              _selectedPredictionType = null;
            });
          },
          icon: Icon(Icons.refresh),
          label: Text('Yeni Tahmin Yap'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}

class PredictionType {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  PredictionType({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
