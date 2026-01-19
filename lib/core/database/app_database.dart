import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  static Database? _database;

  factory AppDatabase() => _instance;

  AppDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'ancientkey.db');

    return await openDatabase(
      path,
      version: 4,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createNewTables(db);
    }
    if (oldVersion < 3) {
      await _createAdvancedFeaturesTables(db);
    }
    if (oldVersion < 4) {
      // Add new achievements
      await _addNewAchievements(db);
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    // Offline Maps Cache
    await db.execute('''
      CREATE TABLE offline_maps (
        id TEXT PRIMARY KEY,
        map_id TEXT NOT NULL,
        file_path TEXT NOT NULL,
        downloaded_at INTEGER NOT NULL
      )
    ''');

    // User Visited Places
    await db.execute('''
      CREATE TABLE visited_places (
        id TEXT PRIMARY KEY,
        map_id TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        visited_at INTEGER NOT NULL
      )
    ''');

    // User Notes
    await db.execute('''
      CREATE TABLE user_notes (
        id TEXT PRIMARY KEY,
        map_id TEXT NOT NULL,
        note TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');

    // User Photos
    await db.execute('''
      CREATE TABLE user_photos (
        id TEXT PRIMARY KEY,
        map_id TEXT NOT NULL,
        file_path TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');

    // Achievements
    await db.execute('''
      CREATE TABLE achievements (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        icon TEXT NOT NULL,
        unlocked INTEGER DEFAULT 0,
        unlocked_at INTEGER
      )
    ''');

    // User Progress
    await db.execute('''
      CREATE TABLE user_progress (
        id TEXT PRIMARY KEY,
        level INTEGER DEFAULT 1,
        experience_points INTEGER DEFAULT 0,
        places_visited INTEGER DEFAULT 0,
        maps_explored INTEGER DEFAULT 0
      )
    ''');

    // User Comments
    await db.execute('''
      CREATE TABLE user_comments (
        id TEXT PRIMARY KEY,
        map_id TEXT NOT NULL,
        comment TEXT NOT NULL,
        rating INTEGER DEFAULT 0,
        created_at INTEGER NOT NULL
      )
    ''');

    // Audio Guides
    await db.execute('''
      CREATE TABLE audio_guides (
        id TEXT PRIMARY KEY,
        map_id TEXT NOT NULL,
        title TEXT NOT NULL,
        file_path TEXT NOT NULL,
        duration INTEGER NOT NULL,
        downloaded INTEGER DEFAULT 0
      )
    ''');

    // Insert default user progress
    await db.insert('user_progress', {
      'id': 'default',
      'level': 1,
      'experience_points': 0,
      'places_visited': 0,
      'maps_explored': 0,
    });

    // Insert default achievements
    await _insertDefaultAchievements(db);
    
    // Create extended tables for ancient civilizations features
    await _createNewTables(db);
    
    // Create advanced modern features
    await _createAdvancedFeaturesTables(db);
  }

  Future<void> _createAdvancedFeaturesTables(Database db) async {
    // AI Image Recognition Results
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ai_artifact_scans (
        id TEXT PRIMARY KEY,
        image_path TEXT NOT NULL,
        detected_artifact TEXT,
        confidence REAL,
        period_estimate TEXT,
        material_analysis TEXT,
        similar_artifacts TEXT,
        scan_date INTEGER NOT NULL,
        location_lat REAL,
        location_lng REAL,
        verified INTEGER DEFAULT 0
      )
    ''');

    // AI Generated Historical Reconstructions
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ai_reconstructions (
        id TEXT PRIMARY KEY,
        original_image TEXT NOT NULL,
        reconstructed_image TEXT,
        description TEXT,
        ai_model TEXT,
        processing_time INTEGER,
        accuracy_score REAL,
        user_rating INTEGER,
        created_at INTEGER NOT NULL
      )
    ''');

    // Voice-to-Text Historical Notes
    await db.execute('''
      CREATE TABLE IF NOT EXISTS voice_notes (
        id TEXT PRIMARY KEY,
        map_id TEXT NOT NULL,
        audio_path TEXT NOT NULL,
        transcription TEXT,
        language TEXT,
        duration INTEGER,
        recorded_at INTEGER NOT NULL,
        location_lat REAL,
        location_lng REAL,
        tags TEXT
      )
    ''');

    // AI Chatbot Conversations (Historical Expert)
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ai_conversations (
        id TEXT PRIMARY KEY,
        topic TEXT NOT NULL,
        messages TEXT NOT NULL,
        context_data TEXT,
        civilization TEXT,
        started_at INTEGER NOT NULL,
        last_message_at INTEGER,
        rating INTEGER
      )
    ''');

    // Machine Learning Predictions
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ml_predictions (
        id TEXT PRIMARY KEY,
        prediction_type TEXT NOT NULL,
        input_data TEXT NOT NULL,
        output_data TEXT NOT NULL,
        model_version TEXT,
        confidence REAL,
        created_at INTEGER NOT NULL
      )
    ''');

    // Multiplayer Challenges
    await db.execute('''
      CREATE TABLE IF NOT EXISTS multiplayer_challenges (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        challenge_type TEXT NOT NULL,
        difficulty TEXT DEFAULT 'medium',
        participants TEXT,
        max_participants INTEGER,
        start_date INTEGER,
        end_date INTEGER,
        reward_xp INTEGER,
        status TEXT DEFAULT 'active',
        created_at INTEGER NOT NULL
      )
    ''');

    // User Challenge Progress
    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_challenge_progress (
        id TEXT PRIMARY KEY,
        challenge_id TEXT NOT NULL,
        user_id TEXT NOT NULL,
        progress INTEGER DEFAULT 0,
        completed INTEGER DEFAULT 0,
        score INTEGER,
        rank INTEGER,
        completed_at INTEGER
      )
    ''');

    // Social Expeditions (Group Tours)
    await db.execute('''
      CREATE TABLE IF NOT EXISTS social_expeditions (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        route_data TEXT,
        participants TEXT,
        leader_id TEXT NOT NULL,
        scheduled_date INTEGER,
        duration_minutes INTEGER,
        difficulty TEXT,
        status TEXT DEFAULT 'upcoming',
        created_at INTEGER NOT NULL
      )
    ''');

    // Live Events & Webinars
    await db.execute('''
      CREATE TABLE IF NOT EXISTS live_events (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        event_type TEXT NOT NULL,
        presenter TEXT,
        stream_url TEXT,
        scheduled_time INTEGER NOT NULL,
        duration_minutes INTEGER,
        attendees TEXT,
        recording_url TEXT,
        status TEXT DEFAULT 'scheduled',
        created_at INTEGER NOT NULL
      )
    ''');

    // Friend System
    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_friends (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        friend_id TEXT NOT NULL,
        friendship_date INTEGER NOT NULL,
        status TEXT DEFAULT 'active',
        shared_discoveries INTEGER DEFAULT 0,
        combined_xp INTEGER DEFAULT 0
      )
    ''');

    // AR Multiplayer Sessions
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ar_multiplayer_sessions (
        id TEXT PRIMARY KEY,
        session_name TEXT NOT NULL,
        host_id TEXT NOT NULL,
        participants TEXT,
        map_id TEXT,
        shared_objects TEXT,
        started_at INTEGER NOT NULL,
        ended_at INTEGER,
        recording_data TEXT
      )
    ''');

    // VR Historical Experiences
    await db.execute('''
      CREATE TABLE IF NOT EXISTS vr_experiences (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        civilization TEXT,
        scene_data TEXT,
        duration_minutes INTEGER,
        difficulty TEXT,
        downloads INTEGER DEFAULT 0,
        rating REAL,
        file_size_mb INTEGER,
        created_at INTEGER NOT NULL
      )
    ''');

    // Hologram Projections
    await db.execute('''
      CREATE TABLE IF NOT EXISTS hologram_projections (
        id TEXT PRIMARY KEY,
        artifact_id TEXT,
        hologram_data TEXT NOT NULL,
        rotation_data TEXT,
        scale REAL DEFAULT 1.0,
        animations TEXT,
        sound_effects TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    // Spatial Audio Guides
    await db.execute('''
      CREATE TABLE IF NOT EXISTS spatial_audio_guides (
        id TEXT PRIMARY KEY,
        map_id TEXT NOT NULL,
        title TEXT NOT NULL,
        audio_tracks TEXT NOT NULL,
        position_data TEXT,
        trigger_radius REAL,
        volume_data TEXT,
        binaural INTEGER DEFAULT 1,
        created_at INTEGER NOT NULL
      )
    ''');

    // Quest System
    await db.execute('''
      CREATE TABLE IF NOT EXISTS quests (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        quest_type TEXT NOT NULL,
        objectives TEXT NOT NULL,
        rewards TEXT,
        difficulty TEXT DEFAULT 'medium',
        required_level INTEGER DEFAULT 1,
        time_limit_minutes INTEGER,
        prerequisite_quests TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    // User Quest Progress
    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_quest_progress (
        id TEXT PRIMARY KEY,
        quest_id TEXT NOT NULL,
        user_id TEXT NOT NULL,
        objectives_completed TEXT,
        progress_percentage INTEGER DEFAULT 0,
        started_at INTEGER NOT NULL,
        completed_at INTEGER,
        rewards_claimed INTEGER DEFAULT 0
      )
    ''');

    // Treasure Hunt System
    await db.execute('''
      CREATE TABLE IF NOT EXISTS treasure_hunts (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        clues TEXT NOT NULL,
        treasure_locations TEXT NOT NULL,
        difficulty TEXT DEFAULT 'medium',
        reward_xp INTEGER,
        reward_items TEXT,
        active_period_start INTEGER,
        active_period_end INTEGER,
        created_at INTEGER NOT NULL
      )
    ''');

    // Mini Games
    await db.execute('''
      CREATE TABLE IF NOT EXISTS mini_games (
        id TEXT PRIMARY KEY,
        game_name TEXT NOT NULL,
        game_type TEXT NOT NULL,
        description TEXT,
        difficulty TEXT DEFAULT 'easy',
        high_score INTEGER DEFAULT 0,
        times_played INTEGER DEFAULT 0,
        last_played INTEGER,
        achievements_unlocked TEXT
      )
    ''');

    // User Leaderboards
    await db.execute('''
      CREATE TABLE IF NOT EXISTS leaderboards (
        id TEXT PRIMARY KEY,
        category TEXT NOT NULL,
        user_id TEXT NOT NULL,
        username TEXT NOT NULL,
        score INTEGER NOT NULL,
        rank INTEGER,
        avatar_url TEXT,
        achievements_count INTEGER,
        updated_at INTEGER NOT NULL
      )
    ''');

    // 3D Object Creator
    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_3d_creations (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        model_data TEXT NOT NULL,
        texture_data TEXT,
        category TEXT,
        tags TEXT,
        likes INTEGER DEFAULT 0,
        downloads INTEGER DEFAULT 0,
        public INTEGER DEFAULT 1,
        created_at INTEGER NOT NULL
      )
    ''');

    // Photo Filters & Effects
    await db.execute('''
      CREATE TABLE IF NOT EXISTS photo_filters (
        id TEXT PRIMARY KEY,
        filter_name TEXT NOT NULL,
        filter_type TEXT NOT NULL,
        parameters TEXT,
        civilization_theme TEXT,
        preview_image TEXT,
        usage_count INTEGER DEFAULT 0,
        is_premium INTEGER DEFAULT 0
      )
    ''');

    // Video Editor Projects
    await db.execute('''
      CREATE TABLE IF NOT EXISTS video_projects (
        id TEXT PRIMARY KEY,
        project_name TEXT NOT NULL,
        clips TEXT NOT NULL,
        transitions TEXT,
        music_track TEXT,
        filters TEXT,
        duration INTEGER,
        resolution TEXT,
        exported_path TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER
      )
    ''');

    // Custom Map Creator
    await db.execute('''
      CREATE TABLE IF NOT EXISTS custom_maps (
        id TEXT PRIMARY KEY,
        creator_id TEXT NOT NULL,
        map_name TEXT NOT NULL,
        description TEXT,
        base_image TEXT,
        markers TEXT,
        annotations TEXT,
        shared_with TEXT,
        views INTEGER DEFAULT 0,
        likes INTEGER DEFAULT 0,
        public INTEGER DEFAULT 0,
        created_at INTEGER NOT NULL
      )
    ''');

    // Archaeological Site Simulator
    await db.execute('''
      CREATE TABLE IF NOT EXISTS site_simulations (
        id TEXT PRIMARY KEY,
        site_name TEXT NOT NULL,
        civilization TEXT NOT NULL,
        simulation_data TEXT NOT NULL,
        excavation_layers TEXT,
        artifacts_buried TEXT,
        grid_size TEXT,
        difficulty TEXT DEFAULT 'medium',
        completed_percentage INTEGER DEFAULT 0,
        created_at INTEGER NOT NULL
      )
    ''');

    // Dating Methods Calculator
    await db.execute('''
      CREATE TABLE IF NOT EXISTS dating_calculations (
        id TEXT PRIMARY KEY,
        sample_type TEXT NOT NULL,
        method_used TEXT NOT NULL,
        input_data TEXT NOT NULL,
        calculated_age TEXT,
        uncertainty_range TEXT,
        calibration_curve TEXT,
        notes TEXT,
        calculated_at INTEGER NOT NULL
      )
    ''');

    // Restoration Planner
    await db.execute('''
      CREATE TABLE IF NOT EXISTS restoration_plans (
        id TEXT PRIMARY KEY,
        artifact_id TEXT,
        site_id TEXT,
        plan_name TEXT NOT NULL,
        current_state_image TEXT,
        restoration_steps TEXT NOT NULL,
        materials_needed TEXT,
        estimated_cost TEXT,
        estimated_duration TEXT,
        priority TEXT DEFAULT 'medium',
        created_at INTEGER NOT NULL
      )
    ''');

    // Field Notes & Sketches
    await db.execute('''
      CREATE TABLE IF NOT EXISTS field_notes (
        id TEXT PRIMARY KEY,
        site_id TEXT NOT NULL,
        date INTEGER NOT NULL,
        weather TEXT,
        observations TEXT NOT NULL,
        sketches TEXT,
        measurements TEXT,
        team_members TEXT,
        coordinates TEXT,
        tags TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    // Heatmaps & Analytics
    await db.execute('''
      CREATE TABLE IF NOT EXISTS visit_heatmaps (
        id TEXT PRIMARY KEY,
        map_id TEXT NOT NULL,
        period_start INTEGER NOT NULL,
        period_end INTEGER NOT NULL,
        heatmap_data TEXT NOT NULL,
        total_visits INTEGER,
        unique_visitors INTEGER,
        peak_hours TEXT,
        generated_at INTEGER NOT NULL
      )
    ''');

    // User Behavior Analytics
    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_analytics (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        favorite_civilizations TEXT,
        most_visited_sites TEXT,
        learning_patterns TEXT,
        engagement_score REAL,
        retention_rate REAL,
        last_calculated INTEGER NOT NULL
      )
    ''');

    // Content Recommendations
    await db.execute('''
      CREATE TABLE IF NOT EXISTS recommendations (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        recommendation_type TEXT NOT NULL,
        content_id TEXT NOT NULL,
        relevance_score REAL,
        reason TEXT,
        viewed INTEGER DEFAULT 0,
        interacted INTEGER DEFAULT 0,
        generated_at INTEGER NOT NULL
      )
    ''');

    // Time Travel Simulator Advanced
    await db.execute('''
      CREATE TABLE IF NOT EXISTS time_travel_scenarios (
        id TEXT PRIMARY KEY,
        scenario_name TEXT NOT NULL,
        location TEXT NOT NULL,
        time_periods TEXT NOT NULL,
        narrative TEXT,
        choices TEXT,
        outcomes TEXT,
        animations TEXT,
        sound_design TEXT,
        educational_content TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    // Weather & Climate Simulator
    await db.execute('''
      CREATE TABLE IF NOT EXISTS climate_simulations (
        id TEXT PRIMARY KEY,
        location TEXT NOT NULL,
        time_period TEXT NOT NULL,
        season TEXT,
        temperature_data TEXT,
        precipitation_data TEXT,
        natural_disasters TEXT,
        agricultural_impact TEXT,
        simulation_data TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    // Virtual Laboratory
    await db.execute('''
      CREATE TABLE IF NOT EXISTS virtual_lab_experiments (
        id TEXT PRIMARY KEY,
        experiment_name TEXT NOT NULL,
        experiment_type TEXT NOT NULL,
        instructions TEXT,
        materials TEXT,
        steps TEXT,
        expected_results TEXT,
        user_results TEXT,
        completed INTEGER DEFAULT 0,
        created_at INTEGER NOT NULL
      )
    ''');

    // Collaborative Research Projects
    await db.execute('''
      CREATE TABLE IF NOT EXISTS research_projects (
        id TEXT PRIMARY KEY,
        project_title TEXT NOT NULL,
        description TEXT,
        lead_researcher TEXT,
        team_members TEXT,
        research_area TEXT,
        findings TEXT,
        publications TEXT,
        status TEXT DEFAULT 'active',
        funding_info TEXT,
        started_at INTEGER NOT NULL,
        updated_at INTEGER
      )
    ''');

    // Badges & Certifications
    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_badges (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        badge_name TEXT NOT NULL,
        badge_type TEXT NOT NULL,
        description TEXT,
        criteria TEXT,
        icon_url TEXT,
        earned_at INTEGER NOT NULL,
        shareable INTEGER DEFAULT 1
      )
    ''');
  }

  Future<void> _createNewTables(Database db) async {
    // Historical Timeline Events
    await db.execute('''
      CREATE TABLE IF NOT EXISTS timeline_events (
        id TEXT PRIMARY KEY,
        map_id TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        year_start INTEGER NOT NULL,
        year_end INTEGER,
        era TEXT,
        civilization TEXT,
        category TEXT,
        image_url TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    // 3D Models
    await db.execute('''
      CREATE TABLE IF NOT EXISTS models_3d (
        id TEXT PRIMARY KEY,
        map_id TEXT NOT NULL,
        name TEXT NOT NULL,
        description TEXT,
        model_url TEXT NOT NULL,
        texture_url TEXT,
        scale REAL DEFAULT 1.0,
        downloaded INTEGER DEFAULT 0,
        created_at INTEGER NOT NULL
      )
    ''');

    // Virtual Reconstructions
    await db.execute('''
      CREATE TABLE IF NOT EXISTS reconstructions (
        id TEXT PRIMARY KEY,
        map_id TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        before_image TEXT,
        after_image TEXT,
        year_period TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    // Historical Characters
    await db.execute('''
      CREATE TABLE IF NOT EXISTS historical_characters (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        title TEXT,
        biography TEXT,
        birth_year INTEGER,
        death_year INTEGER,
        civilization TEXT,
        occupation TEXT,
        image_url TEXT,
        famous_for TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    // Artifacts Database
    await db.execute('''
      CREATE TABLE IF NOT EXISTS artifacts (
        id TEXT PRIMARY KEY,
        map_id TEXT NOT NULL,
        name TEXT NOT NULL,
        description TEXT,
        period TEXT,
        material TEXT,
        discovered_year INTEGER,
        current_location TEXT,
        image_url TEXT,
        historical_significance TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    // Quiz Questions
    await db.execute('''
      CREATE TABLE IF NOT EXISTS quiz_questions (
        id TEXT PRIMARY KEY,
        map_id TEXT,
        question TEXT NOT NULL,
        option_a TEXT NOT NULL,
        option_b TEXT NOT NULL,
        option_c TEXT NOT NULL,
        option_d TEXT NOT NULL,
        correct_answer TEXT NOT NULL,
        difficulty TEXT DEFAULT 'medium',
        category TEXT,
        explanation TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    // User Quiz Results
    await db.execute('''
      CREATE TABLE IF NOT EXISTS quiz_results (
        id TEXT PRIMARY KEY,
        quiz_id TEXT NOT NULL,
        score INTEGER NOT NULL,
        total_questions INTEGER NOT NULL,
        completed_at INTEGER NOT NULL
      )
    ''');

    // Historical Stories
    await db.execute('''
      CREATE TABLE IF NOT EXISTS historical_stories (
        id TEXT PRIMARY KEY,
        map_id TEXT NOT NULL,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        narrator TEXT,
        duration INTEGER,
        audio_url TEXT,
        era TEXT,
        civilization TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    // Ancient Languages
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ancient_languages (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        civilization TEXT,
        script_type TEXT,
        example_text TEXT,
        translation TEXT,
        pronunciation_guide TEXT,
        image_url TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    // User Language Progress
    await db.execute('''
      CREATE TABLE IF NOT EXISTS language_progress (
        id TEXT PRIMARY KEY,
        language_id TEXT NOT NULL,
        words_learned INTEGER DEFAULT 0,
        lessons_completed INTEGER DEFAULT 0,
        proficiency_level TEXT DEFAULT 'beginner',
        last_practice INTEGER
      )
    ''');

    // Mythology Database
    await db.execute('''
      CREATE TABLE IF NOT EXISTS mythology (
        id TEXT PRIMARY KEY,
        civilization TEXT NOT NULL,
        deity_name TEXT NOT NULL,
        role TEXT,
        description TEXT,
        symbols TEXT,
        related_myths TEXT,
        image_url TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    // Trade Routes
    await db.execute('''
      CREATE TABLE IF NOT EXISTS trade_routes (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        start_location TEXT NOT NULL,
        end_location TEXT NOT NULL,
        waypoints TEXT,
        goods_traded TEXT,
        active_period TEXT,
        length_km REAL,
        description TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    // Battle Maps
    await db.execute('''
      CREATE TABLE IF NOT EXISTS battles (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        date TEXT NOT NULL,
        location TEXT NOT NULL,
        latitude REAL,
        longitude REAL,
        belligerents TEXT,
        result TEXT,
        casualties TEXT,
        significance TEXT,
        map_image_url TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    // Archaeological Layers
    await db.execute('''
      CREATE TABLE IF NOT EXISTS archaeological_layers (
        id TEXT PRIMARY KEY,
        map_id TEXT NOT NULL,
        layer_name TEXT NOT NULL,
        depth_cm INTEGER,
        period TEXT,
        findings TEXT,
        date_estimated TEXT,
        image_url TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    // Time Travel Snapshots
    await db.execute('''
      CREATE TABLE IF NOT EXISTS time_snapshots (
        id TEXT PRIMARY KEY,
        map_id TEXT NOT NULL,
        year INTEGER NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        image_url TEXT,
        changes TEXT,
        population INTEGER,
        created_at INTEGER NOT NULL
      )
    ''');

    // Daily Life Simulations
    await db.execute('''
      CREATE TABLE IF NOT EXISTS daily_life_scenes (
        id TEXT PRIMARY KEY,
        civilization TEXT NOT NULL,
        scene_type TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        activities TEXT,
        time_of_day TEXT,
        season TEXT,
        image_url TEXT,
        video_url TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    // Ancient Scripts/Inscriptions
    await db.execute('''
      CREATE TABLE IF NOT EXISTS inscriptions (
        id TEXT PRIMARY KEY,
        map_id TEXT NOT NULL,
        script_type TEXT NOT NULL,
        original_text TEXT NOT NULL,
        translation TEXT,
        transliteration TEXT,
        language TEXT,
        date_carved TEXT,
        image_url TEXT,
        deciphered INTEGER DEFAULT 0,
        created_at INTEGER NOT NULL
      )
    ''');

    // Virtual Museum Exhibits
    await db.execute('''
      CREATE TABLE IF NOT EXISTS museum_exhibits (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        civilization TEXT,
        period TEXT,
        artifacts TEXT,
        virtual_tour_url TEXT,
        image_gallery TEXT,
        curator_notes TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    // Guided Tours
    await db.execute('''
      CREATE TABLE IF NOT EXISTS guided_tours (
        id TEXT PRIMARY KEY,
        map_id TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        duration_minutes INTEGER,
        stops TEXT,
        guide_name TEXT,
        difficulty TEXT DEFAULT 'easy',
        audio_url TEXT,
        completed INTEGER DEFAULT 0,
        created_at INTEGER NOT NULL
      )
    ''');

    // Historical Weather Data
    await db.execute('''
      CREATE TABLE IF NOT EXISTS historical_weather (
        id TEXT PRIMARY KEY,
        location TEXT NOT NULL,
        year INTEGER NOT NULL,
        month INTEGER,
        climate_description TEXT,
        temperature_avg REAL,
        precipitation TEXT,
        natural_events TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    // Civilization Comparisons
    await db.execute('''
      CREATE TABLE IF NOT EXISTS civilizations (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        region TEXT,
        time_period TEXT,
        population_peak INTEGER,
        government_type TEXT,
        achievements TEXT,
        decline_reason TEXT,
        notable_cities TEXT,
        cultural_traits TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    // Religious/Sacred Sites
    await db.execute('''
      CREATE TABLE IF NOT EXISTS sacred_sites (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        religion TEXT NOT NULL,
        location TEXT NOT NULL,
        latitude REAL,
        longitude REAL,
        built_year INTEGER,
        significance TEXT,
        rituals TEXT,
        architecture_style TEXT,
        image_url TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    // Ancient Art Gallery
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ancient_art (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        artist TEXT,
        civilization TEXT,
        period TEXT,
        medium TEXT,
        dimensions TEXT,
        current_location TEXT,
        description TEXT,
        image_url TEXT,
        high_res_url TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    // Historical Documents
    await db.execute('''
      CREATE TABLE IF NOT EXISTS historical_documents (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        author TEXT,
        date_written TEXT,
        language TEXT,
        document_type TEXT,
        content TEXT,
        translation TEXT,
        significance TEXT,
        image_url TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    // Expert Interviews
    await db.execute('''
      CREATE TABLE IF NOT EXISTS expert_interviews (
        id TEXT PRIMARY KEY,
        expert_name TEXT NOT NULL,
        title TEXT NOT NULL,
        specialization TEXT,
        topic TEXT NOT NULL,
        interview_text TEXT,
        video_url TEXT,
        audio_url TEXT,
        duration_minutes INTEGER,
        recorded_date TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    // Virtual Excavation Progress
    await db.execute('''
      CREATE TABLE IF NOT EXISTS excavation_progress (
        id TEXT PRIMARY KEY,
        site_id TEXT NOT NULL,
        user_level INTEGER DEFAULT 1,
        artifacts_found INTEGER DEFAULT 0,
        areas_explored INTEGER DEFAULT 0,
        discoveries TEXT,
        last_dig INTEGER,
        created_at INTEGER NOT NULL
      )
    ''');

    // Period Costumes
    await db.execute('''
      CREATE TABLE IF NOT EXISTS period_costumes (
        id TEXT PRIMARY KEY,
        civilization TEXT NOT NULL,
        period TEXT NOT NULL,
        costume_type TEXT NOT NULL,
        gender TEXT,
        social_class TEXT,
        materials TEXT,
        description TEXT,
        image_url TEXT,
        pattern_url TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    // Ancient Music
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ancient_music (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        civilization TEXT NOT NULL,
        period TEXT,
        instrument TEXT,
        description TEXT,
        audio_url TEXT NOT NULL,
        duration INTEGER,
        recreation_notes TEXT,
        downloaded INTEGER DEFAULT 0,
        created_at INTEGER NOT NULL
      )
    ''');

    // Historical Recipes
    await db.execute('''
      CREATE TABLE IF NOT EXISTS historical_recipes (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        civilization TEXT NOT NULL,
        period TEXT,
        ingredients TEXT NOT NULL,
        instructions TEXT NOT NULL,
        serving_size TEXT,
        occasion TEXT,
        historical_notes TEXT,
        image_url TEXT,
        difficulty TEXT DEFAULT 'medium',
        created_at INTEGER NOT NULL
      )
    ''');

    // Dynasty/Family Trees
    await db.execute('''
      CREATE TABLE IF NOT EXISTS dynasties (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        civilization TEXT NOT NULL,
        founder TEXT,
        time_period TEXT,
        capital_city TEXT,
        notable_rulers TEXT,
        achievements TEXT,
        downfall TEXT,
        family_tree_data TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    // Archaeological News Feed
    await db.execute('''
      CREATE TABLE IF NOT EXISTS archaeology_news (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        summary TEXT NOT NULL,
        content TEXT,
        source TEXT,
        author TEXT,
        published_date TEXT NOT NULL,
        category TEXT,
        location TEXT,
        image_url TEXT,
        url TEXT,
        bookmarked INTEGER DEFAULT 0,
        created_at INTEGER NOT NULL
      )
    ''');

    // Community Forum
    await db.execute('''
      CREATE TABLE IF NOT EXISTS forum_posts (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        username TEXT NOT NULL,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        category TEXT,
        tags TEXT,
        likes INTEGER DEFAULT 0,
        replies INTEGER DEFAULT 0,
        views INTEGER DEFAULT 0,
        pinned INTEGER DEFAULT 0,
        created_at INTEGER NOT NULL,
        updated_at INTEGER
      )
    ''');

    // Forum Comments
    await db.execute('''
      CREATE TABLE IF NOT EXISTS forum_comments (
        id TEXT PRIMARY KEY,
        post_id TEXT NOT NULL,
        user_id TEXT NOT NULL,
        username TEXT NOT NULL,
        content TEXT NOT NULL,
        likes INTEGER DEFAULT 0,
        created_at INTEGER NOT NULL
      )
    ''');

    // User Bookmarks/Favorites (extended)
    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_bookmarks (
        id TEXT PRIMARY KEY,
        item_id TEXT NOT NULL,
        item_type TEXT NOT NULL,
        title TEXT,
        notes TEXT,
        created_at INTEGER NOT NULL
      )
    ''');
  }

  Future<void> _insertDefaultAchievements(Database db) async {
    final achievements = [
      {
        'id': 'first_visit',
        'name': 'İlk Keşif',
        'description': 'İlk tarihi yeri ziyaret et',
        'icon': '🗺️',
        'unlocked': 0,
      },
      {
        'id': 'explorer_5',
        'name': 'Kaşif',
        'description': '5 farklı yer ziyaret et',
        'icon': '🧭',
        'unlocked': 0,
      },
      {
        'id': 'explorer_10',
        'name': 'Gezgin',
        'description': '10 farklı yer ziyaret et',
        'icon': '🏛️',
        'unlocked': 0,
      },
      {
        'id': 'explorer_25',
        'name': 'Tarihçi',
        'description': '25 farklı yer ziyaret et',
        'icon': '📜',
        'unlocked': 0,
      },
      {
        'id': 'explorer_50',
        'name': 'Dünya Gezgini',
        'description': '50 farklı yer ziyaret et',
        'icon': '🌍',
        'unlocked': 0,
      },
      {
        'id': 'explorer_100',
        'name': 'Tarih Ustası',
        'description': '100 farklı yer ziyaret et',
        'icon': '👑',
        'unlocked': 0,
      },
      {
        'id': 'photographer',
        'name': 'Fotoğrafçı',
        'description': 'İlk fotoğrafını çek',
        'icon': '📸',
        'unlocked': 0,
      },
      {
        'id': 'photo_collector',
        'name': 'Fotoğraf Koleksiyoncusu',
        'description': '10 fotoğraf çek',
        'icon': '📷',
        'unlocked': 0,
      },
      {
        'id': 'writer',
        'name': 'Yazar',
        'description': 'İlk notunu yaz',
        'icon': '✍️',
        'unlocked': 0,
      },
      {
        'id': 'storyteller',
        'name': 'Hikaye Anlatıcısı',
        'description': '10 not yaz',
        'icon': '📖',
        'unlocked': 0,
      },
      {
        'id': 'level_5',
        'name': 'Seviye 5',
        'description': '5. seviyeye ulaş',
        'icon': '⭐',
        'unlocked': 0,
      },
      {
        'id': 'level_10',
        'name': 'Seviye 10',
        'description': '10. seviyeye ulaş',
        'icon': '🌟',
        'unlocked': 0,
      },
      {
        'id': 'level_20',
        'name': 'Seviye 20',
        'description': '20. seviyeye ulaş',
        'icon': '💫',
        'unlocked': 0,
      },
      {
        'id': 'level_50',
        'name': 'Seviye 50',
        'description': '50. seviyeye ulaş',
        'icon': '✨',
        'unlocked': 0,
      },
      {
        'id': 'social_butterfly',
        'name': 'Sosyal Kelebek',
        'description': 'İlk yorumunu yaz',
        'icon': '💬',
        'unlocked': 0,
      },
      {
        'id': 'night_explorer',
        'name': 'Gece Kaşifi',
        'description': 'Gece 00:00-06:00 arası ziyaret yap',
        'icon': '🌙',
        'unlocked': 0,
      },
      {
        'id': 'early_bird',
        'name': 'Erken Kalkan',
        'description': 'Sabah 05:00-07:00 arası ziyaret yap',
        'icon': '🌅',
        'unlocked': 0,
      },
      {
        'id': 'weekend_warrior',
        'name': 'Hafta Sonu Savaşçısı',
        'description': 'Cumartesi veya Pazar ziyaret yap',
        'icon': '🎉',
        'unlocked': 0,
      },
      {
        'id': 'favorite_collector',
        'name': 'Favorileri Toplayan',
        'description': '10 haritayı favorilere ekle',
        'icon': '❤️',
        'unlocked': 0,
      },
    ];

    for (final achievement in achievements) {
      await db.insert('achievements', achievement);
    }
  }

  Future<void> _addNewAchievements(Database db) async {
    final newAchievements = [
      {
        'id': 'explorer_50',
        'name': 'Dünya Gezgini',
        'description': '50 farklı yer ziyaret et',
        'icon': '🌍',
        'unlocked': 0,
      },
      {
        'id': 'explorer_100',
        'name': 'Tarih Ustası',
        'description': '100 farklı yer ziyaret et',
        'icon': '👑',
        'unlocked': 0,
      },
      {
        'id': 'photo_collector',
        'name': 'Fotoğraf Koleksiyoncusu',
        'description': '10 fotoğraf çek',
        'icon': '📷',
        'unlocked': 0,
      },
      {
        'id': 'storyteller',
        'name': 'Hikaye Anlatıcısı',
        'description': '10 not yaz',
        'icon': '📖',
        'unlocked': 0,
      },
      {
        'id': 'level_20',
        'name': 'Seviye 20',
        'description': '20. seviyeye ulaş',
        'icon': '💫',
        'unlocked': 0,
      },
      {
        'id': 'level_50',
        'name': 'Seviye 50',
        'description': '50. seviyeye ulaş',
        'icon': '✨',
        'unlocked': 0,
      },
      {
        'id': 'social_butterfly',
        'name': 'Sosyal Kelebek',
        'description': 'İlk yorumunu yaz',
        'icon': '💬',
        'unlocked': 0,
      },
      {
        'id': 'night_explorer',
        'name': 'Gece Kaşifi',
        'description': 'Gece 00:00-06:00 arası ziyaret yap',
        'icon': '🌙',
        'unlocked': 0,
      },
      {
        'id': 'early_bird',
        'name': 'Erken Kalkan',
        'description': 'Sabah 05:00-07:00 arası ziyaret yap',
        'icon': '🌅',
        'unlocked': 0,
      },
      {
        'id': 'weekend_warrior',
        'name': 'Hafta Sonu Savaşçısı',
        'description': 'Cumartesi veya Pazar ziyaret yap',
        'icon': '🎉',
        'unlocked': 0,
      },
      {
        'id': 'favorite_collector',
        'name': 'Favorileri Toplayan',
        'description': '10 haritayı favorilere ekle',
        'icon': '❤️',
        'unlocked': 0,
      },
    ];

    for (final achievement in newAchievements) {
      try {
        await db.insert('achievements', achievement);
      } catch (e) {
        // Achievement already exists, ignore
      }
    }
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
