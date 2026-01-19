import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ARViewScreen extends ConsumerStatefulWidget {
  final String mapId;
  final String mapName;

  const ARViewScreen({
    super.key,
    required this.mapId,
    required this.mapName,
  });

  @override
  ConsumerState<ARViewScreen> createState() => _ARViewScreenState();
}

class _ARViewScreenState extends ConsumerState<ARViewScreen> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;

  List<ARNode> nodes = [];
  bool _isPlacingObject = false;

  @override
  void dispose() {
    arSessionManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AR Görünüm - ${widget.mapName}'),
        backgroundColor: Colors.black87,
      ),
      body: Stack(
        children: [
          ARView(
            onARViewCreated: _onARViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    onPressed: _onPlaceObject,
                    icon: const Icon(Icons.add_location),
                    label: const Text('Tarihi Yer İşaretle'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _onRemoveAllObjects,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Tümünü Temizle'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isPlacingObject)
            const Positioned.fill(
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.deepPurple,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _onARViewCreated(
    ARSessionManager arSessionManager,
    ARObjectManager arObjectManager,
    ARAnchorManager arAnchorManager,
    ARLocationManager arLocationManager,
  ) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;

    this.arSessionManager!.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      showWorldOrigin: false,
      handlePans: true,
      handleRotation: true,
    );
    this.arObjectManager!.onInitialize();
  }

  Future<void> _onPlaceObject() async {
    if (arObjectManager == null || arAnchorManager == null) return;

    setState(() => _isPlacingObject = true);

    try {
      // Create a simple marker node
      final newNode = ARNode(
        type: NodeType.webGLB,
        uri: 'https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/DamagedHelmet/glTF-Binary/DamagedHelmet.glb',
        scale: vector.Vector3(0.2, 0.2, 0.2),
        position: vector.Vector3(0, 0, -0.5),
        rotation: vector.Vector4(1, 0, 0, 0),
      );

      final didAdd = await arObjectManager!.addNode(newNode);
      if (didAdd == true) {
        nodes.add(newNode);
        _showSnackBar('Tarihi yer işaretlendi!');
      }
    } catch (e) {
      _showSnackBar('Hata: $e');
    } finally {
      setState(() => _isPlacingObject = false);
    }
  }

  Future<void> _onRemoveAllObjects() async {
    if (nodes.isEmpty) return;

    for (final node in nodes) {
      await arObjectManager?.removeNode(node);
    }
    nodes.clear();
    _showSnackBar('Tüm işaretler silindi');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
