import 'package:flutter/material.dart';

class GoldMiningTechniquesScreen extends StatelessWidget {
  const GoldMiningTechniquesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎓 Altın Çıkarma Teknikleri'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildIntroCard(),
          const SizedBox(height: 16),
          _buildTechniqueCard(
            context,
            title: '1. Pan Eldeme (Gold Panning)',
            icon: Icons.pie_chart,
            color: Colors.amber,
            description:
                'En temel ve yaygın altın arama yöntemi. Özel bir pan (tabak) kullanılarak sedimentlerden altın ayrıştırılır.',
            steps: [
              'Geniş ve düz dipli altın panı edinin (plastik veya metal)',
              'Dere yatağından torba kumu ve çakıl toplayın',
              'Panı 2/3 oranında doldurun',
              'Pana su ekleyin ve malzemeyi iyice karıştırın',
              'Büyük taş ve kayaları elle ayıklayın',
              'Panu dairesel hareketlerle sallayın',
              'Hafif malzemeler yüzeye çıkar, onları dökün',
              'Su ekleyerek ve sallayarak işlemi tekrarlayın',
              'Siyah kum (magnetit) ve ağır mineraller dipte kalacak',
              'Son aşamada altın parçacıkları görünür hale gelir',
            ],
            tips: [
              'Sabırlı olun, acele etmeyin',
              'Panı 45 derece açıyla tutun',
              'Dairesel hareket yaparken hafifçe sallamak önemli',
              'Siyah kumun içinde altın parçacıkları parlak sarı renkte olur',
              'Mıknatıs kullanarak magnetit ayrıştırabilirsiniz',
            ],
          ),
          _buildTechniqueCard(
            context,
            title: '2. Sluice Box (Yıkama Oluğu)',
            icon: Icons.water,
            color: Colors.blue,
            description:
                'Akışkan suyun kullanıldığı, daha büyük miktarda malzeme işlemeye yarayan yöntem.',
            steps: [
              'Sluice box\'ı dere akıntısına 5-7 derece eğimle yerleştirin',
              'Alt kısmına riffle (çıkıntı) ve matris (halı) yerleştirin',
              'Su akışının düzgün olduğundan emin olun',
              'Sedimenti yavaşça oluğa dökün',
              'Su ve sediment karışımı riffle üzerinden geçecek',
              'Ağır mineraller ve altın riffle arkalarında birikecek',
              'Periyodik olarak birikintileri kontrol edin',
              'Matrizden toplanan malzemeyi pan ile son eleme yapın',
            ],
            tips: [
              'Suyun çok hızlı akmasına izin vermeyin, altın kaçabilir',
              'Riffle derinliği çok önemli, çok sığ olmamalı',
              'Mat veya halı kullanmak yakalama oranını artırır',
              'Küçük taneli altınlar için çok ince riffle kullanın',
            ],
          ),
          _buildTechniqueCard(
            context,
            title: '3. Metal Dedektör',
            icon: Icons.radar,
            color: Colors.orange,
            description:
                'Toprak içindeki ve kayalar arasındaki daha büyük altın parçalarını (nugget) bulmak için kullanılır.',
            steps: [
              'VLF veya PI teknolojili altın dedektörü edinin',
              'Dedektörü üretici talimatlarına göre ayarlayın',
              'Zemin dengeleme (ground balance) yapın',
              'Başlığı yerde 2-5 cm yükseklikte tutun',
              'Yavaş ve düzenli hareketlerle tara',
              'Sinyal aldığınızda işaretleyin',
              'Küçük bir kazı aleti ile dikkatli kazın',
              'Bulunan cismi kontrol edin',
            ],
            tips: [
              'Altına hassas özel dedektörler kullanın (gold-specific)',
              'Yüksek mineralli topraklarda PI (Pulse Induction) tipi tercih edin',
              'Düşük frekanslı dedektörler daha derine iner',
              'Eski maden bölgelerinde ve dere yataklarında tara',
              'Kulaklık kullanmak zayıf sinyalleri daha iyi duymanızı sağlar',
            ],
          ),
          _buildTechniqueCard(
            context,
            title: '4. Dry Washing (Kuru Yıkama)',
            icon: Icons.air,
            color: Colors.brown,
            description:
                'Su olmayan çöl bölgelerinde kullanılan, hava basıncıyla altın ayırma yöntemi.',
            steps: [
              'Dry washer makinesini düz zemine kurun',
              'Makineyi çalıştırın (elektrikli veya benzinli motor)',
              'Kuru sedimenti yavaşça besleyiciye dökün',
              'Hava akımı hafif malzemeleri uzaklaştırır',
              'Ağır mineraller ve altın riffle içinde birikir',
              'Birikintileri toplayın',
              'Son elemeyi pan ile yapın',
            ],
            tips: [
              'Malzeme tamamen kuru olmalı, nemli toprak çalışmaz',
              'Rüzgar olmayan günlerde çalışın',
              'Küçük taneli altınlar için zor bir yöntem',
            ],
          ),
          _buildTechniqueCard(
            context,
            title: '5. Dredging (Tarama)',
            icon: Icons.engineering,
            color: Colors.teal,
            description:
                'Dere yatağının altındaki tortuları emmek için kullanılan motorlu ekipman.',
            steps: [
              'Suction dredge ekipmanı edinin (izin gerekli)',
              'Dalış ekipmanı ile dere yatağına inin',
              'Emme başlığını dere tabanına tutun',
              'Motor tortuları emerek sluice\'a gönderir',
              'Ağır mineraller sluice\'da birikir',
              'Periyodik olarak sluice\'ı temizleyin',
            ],
            tips: [
              'Yasal olarak izin gerektirir, yasalara uyun',
              'Çevre dostu çalışın, doğaya zarar vermeyin',
              'Derin yataklara ulaşabilir, verimli bir yöntem',
              'Profesyonel ekipman ve deneyim gerektirir',
            ],
          ),
          _buildSafetyCard(),
          _buildLegalCard(),
          _buildToolsCard(),
        ],
      ),
    );
  }

  Widget _buildIntroCard() {
    return Card(
      color: Colors.grey[900],
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.info, color: Colors.black, size: 30),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Altın Arama Temelleri',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Altın arama (gold prospecting) doğada placer (alüvyon) altın bulmak için yapılan faaliyettir. Bu rehber size temel teknikleri öğretecektir.',
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.withOpacity(0.3)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '⚠️ Önemli Bilgiler:',
                    style: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Altın çok ağır bir metaldir (yoğunluk: 19.3 g/cm³)\n'
                    '• Su ve sedimentle taşınırken en ağır olduğu için en alta çöker\n'
                    '• Dere kıvrımlarının iç kısmında birikir\n'
                    '• Kayaların arkasında ve çatlakarda toplanır\n'
                    '• Siyah kum (magnetit) genellikle altınla beraberdir',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechniqueCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required String description,
    required List<String> steps,
    required List<String> tips,
  }) {
    return Card(
      color: Colors.grey[900],
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.black),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          subtitle: Text(
            description,
            style: const TextStyle(color: Colors.white60, fontSize: 13),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📋 Adımlar:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...steps.asMap().entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.2),
                              shape: BoxShape.circle,
                              border: Border.all(color: color),
                            ),
                            child: Center(
                              child: Text(
                                '${entry.key + 1}',
                                style: TextStyle(
                                  color: color,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  const Text(
                    '💡 İpuçları:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...tips.map((tip) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(color: Colors.amber)),
                            Expanded(
                              child: Text(
                                tip,
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyCard() {
    return Card(
      color: Colors.red[900],
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.warning, color: Colors.white, size: 30),
                SizedBox(width: 12),
                Text(
                  'Güvenlik Önlemleri',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              '⚠️ Mutlaka Dikkat Edilmesi Gerekenler:',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Tek başınıza gitmeyin, yanınızda mutlaka biri olsun\n'
              '• Hava durumunu kontrol edin, ani sel riskine dikkat\n'
              '• İlk yardım çantası taşıyın\n'
              '• Cep telefonu ve şarj aleti yanınızda olsun\n'
              '• Güneş kremi ve şapka kullanın\n'
              '• Bol su ve yiyecek götürün\n'
              '• Tehlikeli bölgelere ve derin sulara girmeyin\n'
              '• Yaban hayvanlarına karşı dikkatli olun\n'
              '• Yerel halk ve yetkililere nereye gittiğinizi bildirin',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegalCard() {
    return Card(
      color: Colors.blue[900],
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.gavel, color: Colors.white, size: 30),
                SizedBox(width: 12),
                Text(
                  'Yasal Uyarılar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              '⚖️ Hukuki Bilgiler:',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Türkiye\'de altın arama için MTA\'dan izin gereklidir\n'
              '• Milli parklar ve korunan alanlarda yasaktır\n'
              '• Özel arazilerde malik izni şarttır\n'
              '• Bulduğunuz altını beyan etmeniz gerekebilir\n'
              '• Çevreye zarar vermek suçtur\n'
              '• Tarihi eser alanlarında kazı yasaktır\n'
              '• Dredging için özel izin ve malzeme lisansı gerekir\n'
              '• Yerel yönetmeliklere uyun',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolsCard() {
    return Card(
      color: Colors.grey[900],
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.shopping_bag, color: Colors.amber, size: 30),
                SizedBox(width: 12),
                Text(
                  'Gerekli Malzemeler',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              '🛠️ Başlangıç Ekipmanları:',
              style: TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Altın panı (10-14 inç plastik veya metal)\n'
              '• Sınıflayıcı/elekler (2mm, 4mm, 8mm)\n'
              '• Küçük kaşık veya kepçe\n'
              '• Snuffer bottle (altın toplama şişesi)\n'
              '• Mıknatıs (magnetit ayırmak için)\n'
              '• Büyüteç\n'
              '• Kova veya torbalar\n'
              '• Eldiven ve çizme\n'
              '• Not defteri (buluntularınızı kaydedin)',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            const Text(
              '🔧 İleri Seviye Ekipmanlar:',
              style: TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Sluice box\n'
              '• Metal dedektör (VLF veya PI)\n'
              '• Mini dredge\n'
              '• Dry washer\n'
              '• Blue bowl concentrator\n'
              '• Crevicing tools (çatlak temizleme aletleri)\n'
              '• GPS cihazı',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
