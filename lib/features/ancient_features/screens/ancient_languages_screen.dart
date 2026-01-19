import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/ancient_languages_service.dart';

class AncientLanguagesScreen extends ConsumerStatefulWidget {
  const AncientLanguagesScreen({super.key});

  @override
  ConsumerState<AncientLanguagesScreen> createState() =>
      _AncientLanguagesScreenState();
}

class _AncientLanguagesScreenState extends ConsumerState<AncientLanguagesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  AncientLanguage? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languagesAsync = ref.watch(ancientLanguagesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedLanguage == null
              ? 'Antik Dil Öğrenimi'
              : _selectedLanguage!.name,
        ),
        elevation: 2,
        actions: [
          if (_selectedLanguage != null)
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _selectedLanguage = null;
                });
              },
              tooltip: 'Dil listesine dön',
            ),
        ],
        bottom: _selectedLanguage != null
            ? TabBar(
                controller: _tabController,
                tabs: [
                  Tab(icon: Icon(Icons.text_fields), text: 'Alfabe'),
                  Tab(icon: Icon(Icons.book), text: 'Kelimeler'),
                  Tab(icon: Icon(Icons.chat_bubble), text: 'Cümleler'),
                ],
              )
            : null,
      ),
      body: languagesAsync.when(
        data: (languages) {
          if (_selectedLanguage == null) {
            return _buildLanguageList(languages);
          } else {
            return _buildLanguageDetail(_selectedLanguage!);
          }
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red),
              SizedBox(height: 16),
              Text('Diller yüklenirken bir hata oluştu'),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.refresh(ancientLanguagesProvider),
                child: Text('Tekrar Dene'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageList(List<AncientLanguage> languages) {
    return ListView(
      padding: EdgeInsets.all(12),
      children: [
        // Başlık ve Açıklama
        Card(
          color: Colors.blue[50],
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.school, color: Colors.blue[700], size: 32),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Antik Dilleri Keşfedin',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  'Tarih boyunca kullanılmış önemli dilleri öğrenin. Her dilin alfabesini, temel kelimelerini ve ünlü cümlelerini keşfedin.',
                  style: TextStyle(fontSize: 14, color: Colors.blue[800]),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),

        // Diller Listesi
        ...languages.map((language) => _buildLanguageCard(language)),
      ],
    );
  }

  Widget _buildLanguageCard(AncientLanguage language) {
    Color cardColor;
    IconData icon;

    switch (language.difficulty) {
      case 'Başlangıç':
        cardColor = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'Orta':
        cardColor = Colors.orange;
        icon = Icons.adjust;
        break;
      case 'İleri':
        cardColor = Colors.red;
        icon = Icons.star;
        break;
      default:
        cardColor = Colors.blue;
        icon = Icons.language;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() {
            _selectedLanguage = language;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [cardColor.withOpacity(0.7), cardColor.withOpacity(0.5)],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.translate, color: cardColor, size: 28),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            language.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            language.civilization,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icon, size: 16, color: cardColor),
                          SizedBox(width: 4),
                          Text(
                            language.difficulty,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: cardColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  language.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.95),
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.history,
                      size: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    SizedBox(width: 4),
                    Text(
                      language.period,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    SizedBox(width: 16),
                    Icon(
                      Icons.text_fields,
                      size: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        language.writingSystem,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedLanguage = language;
                      });
                    },
                    icon: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 18,
                    ),
                    label: Text(
                      'Öğrenmeye Başla',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(0.2),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageDetail(AncientLanguage language) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildAlphabetTab(language),
        _buildVocabularyTab(language),
        _buildPhrasesTab(language),
      ],
    );
  }

  Widget _buildAlphabetTab(AncientLanguage language) {
    if (language.alphabet.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info_outline, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Bu dil için alfabe bilgisi henüz eklenmedi',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.all(12),
      children: [
        Card(
          color: Colors.purple[50],
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.text_fields, color: Colors.purple[700]),
                    SizedBox(width: 8),
                    Text(
                      language.writingSystem,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[900],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Her harfin sesini ve kullanımını öğrenin',
                  style: TextStyle(fontSize: 13, color: Colors.purple[700]),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12),
        ...language.alphabet.map(
          (letter) => Card(
            margin: EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.purple[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  letter.symbol,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[900],
                  ),
                ),
              ),
              title: Text(
                letter.transliteration,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Text('Telaffuz: ${letter.pronunciation}'),
                  Text(
                    letter.meaning,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVocabularyTab(AncientLanguage language) {
    if (language.vocabulary.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info_outline, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Bu dil için kelime bilgisi henüz eklenmedi',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    // Kelimeleri kategoriye göre grupla
    final categories = <String, List<LanguageWord>>{};
    for (var word in language.vocabulary) {
      categories.putIfAbsent(word.category, () => []).add(word);
    }

    return ListView(
      padding: EdgeInsets.all(12),
      children: [
        Card(
          color: Colors.teal[50],
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.book, color: Colors.teal[700]),
                    SizedBox(width: 8),
                    Text(
                      'Temel Kelime Dağarcığı',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[900],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  '${language.vocabulary.length} kelime - ${categories.length} kategori',
                  style: TextStyle(fontSize: 13, color: Colors.teal[700]),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12),
        ...categories.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Text(
                  entry.key,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[800],
                  ),
                ),
              ),
              ...entry.value.map(
                (word) => Card(
                  margin: EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal[100],
                      child: Text(
                        word.ancient[0],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[900],
                        ),
                      ),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            word.ancient,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            word.modern,
                            style: TextStyle(
                              color: Colors.teal[700],
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        '🗣️ ${word.pronunciation}',
                        style: TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildPhrasesTab(AncientLanguage language) {
    if (language.phrases.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info_outline, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Bu dil için cümle örnekleri henüz eklenmedi',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.all(12),
      children: [
        Card(
          color: Colors.amber[50],
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.chat_bubble, color: Colors.amber[800]),
                    SizedBox(width: 8),
                    Text(
                      'Ünlü Cümleler ve İfadeler',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber[900],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Tarihte iz bırakmış önemli cümleler',
                  style: TextStyle(fontSize: 13, color: Colors.amber[800]),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12),
        ...language.phrases.map(
          (phrase) => Card(
            margin: EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.amber.withOpacity(0.3), width: 2),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber[200]!),
                    ),
                    child: Text(
                      phrase.ancient,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber[900],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.translate, size: 18, color: Colors.grey[600]),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          phrase.modern,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.record_voice_over,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          phrase.pronunciation,
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 18,
                          color: Colors.blue[700],
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            phrase.context,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.blue[900],
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
