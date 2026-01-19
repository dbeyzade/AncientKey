import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';

// 3D Object Creator Service
final user3DCreationsServiceProvider = Provider((ref) => User3DCreationsService());

class User3DCreation {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final String modelData;
  final String? textureData;
  final String? category;
  final List<String> tags;
  final int likes;
  final int downloads;
  final bool isPublic;
  final DateTime createdAt;

  User3DCreation({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.modelData,
    this.textureData,
    this.category,
    this.tags = const [],
    this.likes = 0,
    this.downloads = 0,
    this.isPublic = true,
    required this.createdAt,
  });

  factory User3DCreation.fromMap(Map<String, dynamic> map) {
    return User3DCreation(
      id: map['id'],
      userId: map['user_id'],
      title: map['title'],
      description: map['description'],
      modelData: map['model_data'],
      textureData: map['texture_data'],
      category: map['category'],
      tags: map['tags'] != null ? (map['tags'] as String).split(',') : [],
      likes: map['likes'] ?? 0,
      downloads: map['downloads'] ?? 0,
      isPublic: map['public'] == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
    );
  }
}

class User3DCreationsService {
  final _uuid = const Uuid();

  Future<void> saveCreation(User3DCreation creation) async {
    final db = await AppDatabase().database;
    await db.insert('user_3d_creations', {
      'id': creation.id,
      'user_id': creation.userId,
      'title': creation.title,
      'description': creation.description,
      'model_data': creation.modelData,
      'texture_data': creation.textureData,
      'category': creation.category,
      'tags': creation.tags.join(','),
      'likes': creation.likes,
      'downloads': creation.downloads,
      'public': creation.isPublic ? 1 : 0,
      'created_at': creation.createdAt.millisecondsSinceEpoch,
    });
  }

  Future<List<User3DCreation>> getUserCreations(String userId) async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'user_3d_creations',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
    return results.map((e) => User3DCreation.fromMap(e)).toList();
  }

  Future<List<User3DCreation>> getPublicCreations({int limit = 50}) async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'user_3d_creations',
      where: 'public = ?',
      whereArgs: [1],
      orderBy: 'likes DESC, created_at DESC',
      limit: limit,
    );
    return results.map((e) => User3DCreation.fromMap(e)).toList();
  }

  Future<void> likeCreation(String creationId) async {
    final db = await AppDatabase().database;
    await db.rawUpdate(
      'UPDATE user_3d_creations SET likes = likes + 1 WHERE id = ?',
      [creationId],
    );
  }
}

// Custom Map Creator Service
final customMapsServiceProvider = Provider((ref) => CustomMapsService());

class CustomMap {
  final String id;
  final String creatorId;
  final String mapName;
  final String? description;
  final String? baseImage;
  final List<MapMarker> markers;
  final List<MapAnnotation> annotations;
  final List<String> sharedWith;
  final int views;
  final int likes;
  final bool isPublic;
  final DateTime createdAt;

  CustomMap({
    required this.id,
    required this.creatorId,
    required this.mapName,
    this.description,
    this.baseImage,
    this.markers = const [],
    this.annotations = const [],
    this.sharedWith = const [],
    this.views = 0,
    this.likes = 0,
    this.isPublic = false,
    required this.createdAt,
  });
}

class MapMarker {
  final double latitude;
  final double longitude;
  final String label;
  final String? icon;
  final String? color;

  MapMarker({
    required this.latitude,
    required this.longitude,
    required this.label,
    this.icon,
    this.color,
  });
}

class MapAnnotation {
  final String text;
  final double x;
  final double y;
  final String style;

  MapAnnotation({
    required this.text,
    required this.x,
    required this.y,
    required this.style,
  });
}

class CustomMapsService {
  final _uuid = const Uuid();

  Future<void> saveCustomMap(CustomMap map) async {
    final db = await AppDatabase().database;
    // In production, properly serialize markers and annotations as JSON
    await db.insert('custom_maps', {
      'id': map.id,
      'creator_id': map.creatorId,
      'map_name': map.mapName,
      'description': map.description,
      'base_image': map.baseImage,
      'markers': '[]', // JSON serialize markers
      'annotations': '[]', // JSON serialize annotations
      'shared_with': map.sharedWith.join(','),
      'views': map.views,
      'likes': map.likes,
      'public': map.isPublic ? 1 : 0,
      'created_at': map.createdAt.millisecondsSinceEpoch,
    });
  }

  Future<List<CustomMap>> getUserMaps(String userId) async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'custom_maps',
      where: 'creator_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
    // In production, properly parse results
    return [];
  }
}

// Video Editor Service
final videoProjectsServiceProvider = Provider((ref) => VideoProjectsService());

class VideoProject {
  final String id;
  final String projectName;
  final List<String> clips;
  final String? transitions;
  final String? musicTrack;
  final String? filters;
  final int? duration;
  final String? resolution;
  final String? exportedPath;
  final DateTime createdAt;
  final DateTime? updatedAt;

  VideoProject({
    required this.id,
    required this.projectName,
    required this.clips,
    this.transitions,
    this.musicTrack,
    this.filters,
    this.duration,
    this.resolution,
    this.exportedPath,
    required this.createdAt,
    this.updatedAt,
  });

  factory VideoProject.fromMap(Map<String, dynamic> map) {
    return VideoProject(
      id: map['id'],
      projectName: map['project_name'],
      clips: (map['clips'] as String).split(','),
      transitions: map['transitions'],
      musicTrack: map['music_track'],
      filters: map['filters'],
      duration: map['duration'],
      resolution: map['resolution'],
      exportedPath: map['exported_path'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      updatedAt: map['updated_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updated_at'])
          : null,
    );
  }
}

class VideoProjectsService {
  final _uuid = const Uuid();

  Future<void> saveProject(VideoProject project) async {
    final db = await AppDatabase().database;
    await db.insert('video_projects', {
      'id': project.id,
      'project_name': project.projectName,
      'clips': project.clips.join(','),
      'transitions': project.transitions,
      'music_track': project.musicTrack,
      'filters': project.filters,
      'duration': project.duration,
      'resolution': project.resolution,
      'exported_path': project.exportedPath,
      'created_at': project.createdAt.millisecondsSinceEpoch,
      'updated_at': project.updatedAt?.millisecondsSinceEpoch,
    });
  }

  Future<List<VideoProject>> getAllProjects() async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'video_projects',
      orderBy: 'updated_at DESC, created_at DESC',
    );
    return results.map((e) => VideoProject.fromMap(e)).toList();
  }

  Future<void> updateProject(String projectId, Map<String, dynamic> updates) async {
    final db = await AppDatabase().database;
    updates['updated_at'] = DateTime.now().millisecondsSinceEpoch;
    await db.update(
      'video_projects',
      updates,
      where: 'id = ?',
      whereArgs: [projectId],
    );
  }
}

// Photo Filters Service
final photoFiltersServiceProvider = Provider((ref) => PhotoFiltersService());

class PhotoFilter {
  final String id;
  final String filterName;
  final String filterType;
  final Map<String, dynamic> parameters;
  final String? civilizationTheme;
  final String? previewImage;
  final int usageCount;
  final bool isPremium;

  PhotoFilter({
    required this.id,
    required this.filterName,
    required this.filterType,
    required this.parameters,
    this.civilizationTheme,
    this.previewImage,
    this.usageCount = 0,
    this.isPremium = false,
  });

  factory PhotoFilter.fromMap(Map<String, dynamic> map) {
    return PhotoFilter(
      id: map['id'],
      filterName: map['filter_name'],
      filterType: map['filter_type'],
      parameters: {}, // In production, parse JSON
      civilizationTheme: map['civilization_theme'],
      previewImage: map['preview_image'],
      usageCount: map['usage_count'] ?? 0,
      isPremium: map['is_premium'] == 1,
    );
  }
}

class PhotoFiltersService {
  Future<List<PhotoFilter>> getAllFilters() async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'photo_filters',
      orderBy: 'usage_count DESC',
    );
    return results.map((e) => PhotoFilter.fromMap(e)).toList();
  }

  Future<List<PhotoFilter>> getFiltersByCivilization(String civilization) async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'photo_filters',
      where: 'civilization_theme = ?',
      whereArgs: [civilization],
      orderBy: 'filter_name ASC',
    );
    return results.map((e) => PhotoFilter.fromMap(e)).toList();
  }

  Future<void> incrementUsage(String filterId) async {
    final db = await AppDatabase().database;
    await db.rawUpdate(
      'UPDATE photo_filters SET usage_count = usage_count + 1 WHERE id = ?',
      [filterId],
    );
  }
}
