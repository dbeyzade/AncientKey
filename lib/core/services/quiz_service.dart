import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';
import 'achievement_service.dart';

final quizServiceProvider = Provider((ref) => QuizService(ref));

class QuizQuestion {
  final String id;
  final String? mapId;
  final String category;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;
  final String difficulty;

  QuizQuestion({
    required this.id,
    this.mapId,
    required this.category,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    this.difficulty = 'orta',
  });

  factory QuizQuestion.fromMap(Map<String, dynamic> map) {
    // Check if we are reading from the new table or the old one
    if (map.containsKey('option_a')) {
      // New table structure
      return QuizQuestion(
        id: map['id'],
        mapId: map['map_id'],
        category: map['category'] ?? 'Genel',
        question: map['question'] ?? '',
        options: [
          map['option_a'] ?? '',
          map['option_b'] ?? '',
          map['option_c'] ?? '',
          map['option_d'] ?? '',
        ],
        // Assuming correct_answer is stored as '0', '1', '2', '3' or indices
        correctAnswerIndex: int.tryParse(map['correct_answer']?.toString() ?? '0') ?? 0,
        explanation: map['explanation'] ?? '',
        difficulty: map['difficulty'] ?? 'orta',
      );
    } else {
      // Fallback for old structure if migration hasn't run fully or for compatibility
      final optionsStr = map['activities'] as String? ?? '';
      final options = optionsStr.split('|||');
      
      return QuizQuestion(
        id: map['id'],
        mapId: map['map_id'],
        category: map['civilization'] ?? 'Genel',
        question: map['title'] ?? '',
        options: options.length >= 4 ? options : ['A', 'B', 'C', 'D'],
        correctAnswerIndex: int.tryParse(map['time_of_day']?.toString() ?? '0') ?? 0,
        explanation: map['description'] ?? '',
        difficulty: map['season'] ?? 'orta',
      );
    }
  }
}

class QuizResult {
  final String id;
  final String quizId;
  final int score;
  final int totalQuestions;
  final DateTime completedAt;

  QuizResult({
    required this.id,
    required this.quizId,
    required this.score,
    required this.totalQuestions,
    required this.completedAt,
  });

  factory QuizResult.fromMap(Map<String, dynamic> map) {
    return QuizResult(
      id: map['id'],
      quizId: map['quiz_id'],
      score: map['score'],
      totalQuestions: map['total_questions'],
      completedAt: DateTime.fromMillisecondsSinceEpoch(map['completed_at']),
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quiz_id': quizId,
      'score': score,
      'total_questions': totalQuestions,
      'completed_at': completedAt.millisecondsSinceEpoch,
    };
  }
}

class QuizService {
  final Ref ref;
  final _uuid = const Uuid();

  QuizService(this.ref);

  Future<List<QuizQuestion>> getAllQuestions() async {
    final db = await AppDatabase().database;
    
    // First try to fetch from the specific quiz_questions table
    var results = await db.query('quiz_questions');
    
    if (results.isEmpty) {
      // If empty, verify if we need to migrate or insert samples
      await insertSampleQuestions();
      results = await db.query('quiz_questions');
    }
    
    return results.map((map) => QuizQuestion.fromMap(map)).toList();
  }

  Future<List<QuizQuestion>> getQuestionsByCategory(String category) async {
    final db = await AppDatabase().database;
    
    final results = await db.query(
      'quiz_questions',
      where: 'category = ?',
      whereArgs: [category],
    );
    
    return results.map((map) => QuizQuestion.fromMap(map)).toList();
  }

  Future<void> saveQuizResult(int score, int totalQuestions) async {
    final db = await AppDatabase().database;
    
    final result = QuizResult(
      id: _uuid.v4(),
      quizId: 'quiz_session_${DateTime.now().millisecondsSinceEpoch}',
      score: score,
      totalQuestions: totalQuestions,
      completedAt: DateTime.now(),
    );
    
    await db.insert('quiz_results', result.toMap());
    
    // Check for achievements based on score
    if (score >= totalQuestions * 10 * 0.8) { // 80% success
      final achievementService = ref.read(achievementServiceProvider);
      await achievementService.unlockAchievement('quiz_master');
    }
  }

  Future<void> insertSampleQuestions() async {
    final db = await AppDatabase().database;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    
    final questions = [
      // Antik Yunan
      {
        'id': 'quiz_1',
        'category': 'Antik Yunan',
        'question': 'Parthenon hangi tanrıya adanmıştır?',
        'option_a': 'Zeus',
        'option_b': 'Athena', 
        'option_c': 'Poseidon',
        'option_d': 'Hera',
        'correct_answer': '1', // Index of Athena
        'explanation': 'Parthenon, bilgelik ve savaş tanrıçası Athena\'ya adanmış bir tapınaktır.',
        'difficulty': 'orta',
        'created_at': timestamp,
      },
      {
        'id': 'quiz_2',
        'category': 'Antik Yunan',
        'question': 'İlk Olimpiyat Oyunları hangi yılda düzenlenmiştir?',
        'option_a': 'MÖ 776',
        'option_b': 'MÖ 500',
        'option_c': 'MÖ 1000',
        'option_d': 'MÖ 323',
        'correct_answer': '0',
        'explanation': 'İlk Olimpiyat Oyunları MÖ 776 yılında Olympia\'da düzenlenmiştir.',
        'difficulty': 'kolay',
        'created_at': timestamp,
      },
      {
        'id': 'quiz_3',
        'category': 'Antik Yunan',
        'question': 'Büyük İskender\'in hocası kimdir?',
        'option_a': 'Sokrates',
        'option_b': 'Platon',
        'option_c': 'Aristoteles',
        'option_d': 'Herakleitos',
        'correct_answer': '2',
        'explanation': 'Aristoteles, Büyük İskender\'in özel hocası olarak görev yapmıştır.',
        'difficulty': 'orta',
        'created_at': timestamp,
      },
      // Antik Mısır
      {
        'id': 'quiz_4',
        'category': 'Antik Mısır',
        'question': 'Hangi firavun tek tanrılı dini (Aton) tanıtmıştır?',
        'option_a': 'Ramses II',
        'option_b': 'Tutankhamun',
        'option_c': 'Akhenaton',
        'option_d': 'Thutmose III',
        'correct_answer': '2',
        'explanation': 'Akhenaton (IV. Amenhotep), güneş diski Aton\'a tapınmayı merkeze alan tek tanrılı bir din reformu yapmıştır.',
        'difficulty': 'zor',
        'created_at': timestamp,
      },
      {
        'id': 'quiz_5',
        'category': 'Antik Mısır',
        'question': 'Büyük Giza Piramidi kimin için inşa edilmiştir?',
        'option_a': 'Kefren',
        'option_b': 'Keops (Khufu)',
        'option_c': 'Mikerinos',
        'option_d': 'Zoser',
        'correct_answer': '1',
        'explanation': 'Büyük Piramit, Firavun Khufu (Yunanca Keops) için inşa edilmiştir.',
        'difficulty': 'kolay',
        'created_at': timestamp,
      },
      // Antik Roma
      {
        'id': 'quiz_6',
        'category': 'Antik Roma',
        'question': 'Roma İmparatorluğu\'nun ilk imparatoru kimdir?',
        'option_a': 'Julius Caesar',
        'option_b': 'Augustus',
        'option_c': 'Nero',
        'option_d': 'Trajan',
        'correct_answer': '1',
        'explanation': 'MÖ 27\'de Augustus (Octavian) unvanını alarak Roma\'nın ilk imparatoru olmuştur.',
        'difficulty': 'orta',
        'created_at': timestamp,
      },
      {
        'id': 'quiz_7',
        'category': 'Antik Roma',
        'question': 'Kolezyum\'un asıl adı nedir?',
        'option_a': 'Flavius Amfitiyatrosu',
        'option_b': 'Büyük Arena',
        'option_c': 'Roma Sirki', 
        'option_d': 'Sezar Sarayı',
        'correct_answer': '0',
        'explanation': 'Kolezyum, Flavius Hanedanı döneminde yapıldığı için Flavius Amfitiyatrosu olarak bilinir.',
        'difficulty': 'zor',
        'created_at': timestamp,
      },
      // Mezopotamya
      {
        'id': 'quiz_8',
        'category': 'Mezopotamya',
        'question': 'Tarihin bilinen ilk yazılı kanunları kime aittir?',
        'option_a': 'Gılgamış',
        'option_b': 'Musa',
        'option_c': 'Hammurabi',
        'option_d': 'Sargon',
        'correct_answer': '2',
        'explanation': 'Babil Kralı Hammurabi tarafından hazırlanan Hammurabi Kanunları, tarihin en eski kapsamlı yazılı yasalarıdır.',
        'difficulty': 'kolay',
        'created_at': timestamp,
      },
      {
        'id': 'quiz_9',
        'category': 'Mezopotamya',
        'question': 'Sümerler hangi yazı sistemini geliştirmiştir?',
        'option_a': 'Hiyeroglif',
        'option_b': 'Çivi Yazısı',
        'option_c': 'Fenike Alfabesi',
        'option_d': 'Latin Alfabesi',
        'correct_answer': '1',
        'explanation': 'Sümerler, kil tabletler üzerine yazılan Çivi Yazısını icat etmiştir.',
        'difficulty': 'kolay',
        'created_at': timestamp,
      },
       {
        'id': 'quiz_10',
        'category': 'Genel Tarih',
        'question': 'Dünyanın 7 Harikası\'ndan günümüze ulaşan tek yapı hangisidir?',
        'option_a': 'İskenderiye Feneri',
        'option_b': 'Babil\'in Asma Bahçeleri',
        'option_c': 'Artemis Tapınağı',
        'option_d': 'Keops Piramidi',
        'correct_answer': '3',
        'explanation': 'Keops Piramidi (Büyük Giza Piramidi), Dünyanın Yedi Harikası arasında ayakta kalan tek yapıdır.',
        'difficulty': 'orta',
        'created_at': timestamp,
      },
    ];

    final batch = db.batch();
    for (final q in questions) {
      batch.insert(
        'quiz_questions',
        q,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }

        'title': 'Truva Atını kim önermişti?',
        'activities': 'Akhilleus|||Odysseus|||Agamemnon|||Hektor',
        'time_of_day': '1',
        'description': 'Odysseus, zekası ile ünlü kahraman, Truva Atı planını önermiştir.',
        'season': 'kolay',
      },
      
      // Antik Roma
      {
        'id': 'quiz_5',
        'scene_type': 'quiz',
        'civilization': 'Antik Roma',
        'title': 'Roma İmparatorluğu\'nun ilk imparatoru kimdir?',
        'activities': 'Julius Caesar|||Augustus|||Nero|||Tiberius',
        'time_of_day': '1',
        'description': 'Augustus (Octavianus), Roma\'nın ilk imparatorudur (MÖ 27 - MS 14).',
        'season': 'kolay',
      },
      {
        'id': 'quiz_6',
        'scene_type': 'quiz',
        'civilization': 'Antik Roma',
        'title': 'Roma\'nın efsanevi kurucuları kimlerdir?',
        'activities': 'Romulus ve Remus|||Castor ve Pollux|||Caesar ve Augustus|||Antonius ve Kleopatra',
        'time_of_day': '0',
        'description': 'Romulus ve Remus, dişi bir kurt tarafından emzirildiği söylenen efsanevi kuruculardır.',
        'season': 'kolay',
      },
      {
        'id': 'quiz_7',
        'scene_type': 'quiz',
        'civilization': 'Antik Roma',
        'title': 'Julius Caesar hangi nehri geçerek "Zarlar atıldı" demiştir?',
        'activities': 'Tiber|||Rubicon|||Nil|||Fırat',
        'time_of_day': '1',
        'description': 'Caesar, MÖ 49\'da Rubicon Nehri\'ni ordularıyla geçerek iç savaşı başlattı.',
        'season': 'orta',
      },
      {
        'id': 'quiz_8',
        'scene_type': 'quiz',
        'civilization': 'Antik Roma',
        'title': 'Hannibal hangi ülkenin komutanıdır?',
        'activities': 'Roma|||Kartaca|||Yunanistan|||Mısır',
        'time_of_day': '1',
        'description': 'Hannibal Barkas, Kartaca\'nın ünlü komutanıdır.',
        'season': 'kolay',
      },
      
      // Antik Mısır
      {
        'id': 'quiz_9',
        'scene_type': 'quiz',
        'civilization': 'Antik Mısır',
        'title': 'En büyük piramit hangisidir?',
        'activities': 'Menkaure|||Khafre|||Keops|||Djoser',
        'time_of_day': '2',
        'description': 'Keops (Khufu) Piramidi, Giza\'daki en büyük piramittir.',
        'season': 'kolay',
      },
      {
        'id': 'quiz_10',
        'scene_type': 'quiz',
        'civilization': 'Antik Mısır',
        'title': 'Tutankhamun\'un mezarını kim bulmuştur?',
        'activities': 'Napoleon|||Jean-François Champollion|||Howard Carter|||Flinders Petrie',
        'time_of_day': '2',
        'description': 'Howard Carter, 1922\'de Tutankhamun\'un mezarını buldu.',
        'season': 'kolay',
      },
      {
        'id': 'quiz_11',
        'scene_type': 'quiz',
        'civilization': 'Antik Mısır',
        'title': 'Mısır\'da güneş tanrısının adı nedir?',
        'activities': 'Osiris|||Horus|||Ra|||Anubis',
        'time_of_day': '2',
        'description': 'Ra (veya Re), Mısır mitolojisinde ana güneş tanrısıdır.',
        'season': 'kolay',
      },
      
      // Mezopotamya
      {
        'id': 'quiz_12',
        'scene_type': 'quiz',
        'civilization': 'Mezopotamya',
        'title': 'İlk yazı sistemi nerede geliştirilmiştir?',
        'activities': 'Mısır|||Çin|||Sümer|||Hindistan',
        'time_of_day': '2',
        'description': 'Çivi yazısı, Sümer\'de MÖ 3200 civarında geliştirildi.',
        'season': 'kolay',
      },
      {
        'id': 'quiz_13',
        'scene_type': 'quiz',
        'civilization': 'Mezopotamya',
        'title': 'Gılgamış Destanı hangi medeniyete aittir?',
        'activities': 'Babil|||Sümer|||Asur|||Hitit',
        'time_of_day': '1',
        'description': 'Gılgamış Destanı, Sümer kökenli dünyanın en eski edebi eserlerinden biridir.',
        'season': 'orta',
      },
      
      // Genel Tarih
      {
        'id': 'quiz_14',
        'scene_type': 'quiz',
        'civilization': 'Genel Tarih',
        'title': 'Hangi medeniyet ilk alfabeyi geliştirdi?',
        'activities': 'Yunan|||Fenike|||Mısır|||Roma',
        'time_of_day': '1',
        'description': 'Fenikeli tüccarlar, ilk fonetik alfabeyi MÖ 1050\'de geliştirdiler.',
        'season': 'orta',
      },
      {
        'id': 'quiz_15',
        'scene_type': 'quiz',
        'civilization': 'Genel Tarih',
        'title': 'İpek Yolu hangi iki bölgeyi bağlar?',
        'activities': 'Çin-Avrupa|||Hindistan-Afrika|||Roma-Mısır|||Yunanistan-Pers',
        'time_of_day': '0',
        'description': 'İpek Yolu, Çin\'den Akdeniz\'e uzanan ticaret yoluydu.',
        'season': 'kolay',
      },
    ];

    void for (final question in questions) {
      await db.insert('daily_life_scenes', {
        ...question,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  Future<List<QuizResult>> getAllQuizResults() async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'quiz_results',
      orderBy: 'completed_at DESC',
    );
    return results.map((e) => QuizResult.fromMap(e)).toList();
  }

  Future<void> saveQuizResult(String quizId, int score, int totalQuestions) async {
    final db = await AppDatabase().database;
    final resultId = _uuid.v4();
    
    await db.insert('quiz_results', {
      'id': resultId,
      'quiz_id': quizId,
      'score': score,
      'total_questions': totalQuestions,
      'completed_at': DateTime.now().millisecondsSinceEpoch,
    });

    // Award XP based on score
    final percentage = (score / totalQuestions * 100).round();
    int xpReward = 0;
    
    if (percentage >= 90) {
      xpReward = 50;
    } else if (percentage >= 70) {
      xpReward = 30;
    } else if (percentage >= 50) {
      xpReward = 15;
    } else {
      xpReward = 5;
    }

    final achievementService = ref.read(achievementServiceProvider);
    await achievementService.addExperiencePoints(xpReward);

    // Unlock quiz master achievement if applicable
    final results = await getAllQuizResults();
    if (results.length >= 10) {
      await achievementService.unlockAchievement('quiz_master');
    }
  }

  Future<Map<String, dynamic>> getQuizStatistics() async {
    final results = await getAllQuizResults();
    
    if (results.isEmpty) {
      return {
        'total_quizzes': 0,
        'average_score': 0.0,
        'best_score': 0,
        'total_questions_answered': 0,
      };
    }

    int totalScore = 0;
    int totalQuestions = 0;
    int bestScore = 0;

    for (final result in results) {
      totalScore += result.score;
      totalQuestions += result.totalQuestions;
      final percentage = (result.score / result.totalQuestions * 100).round();
      if (percentage > bestScore) {
        bestScore = percentage;
      }
    }

    return {
      'total_quizzes': results.length,
      'average_score': totalScore / results.length,
      'best_score': bestScore,
      'total_questions_answered': totalQuestions,
    };
  }
}
