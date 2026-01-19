import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/archaeological_layers_service.dart';

final layersProvider = FutureProvider<List<ArchaeologicalLayer>>((ref) async {
  final service = ArchaeologicalLayersService();
  return service.getAllLayers();
});

class ArchaeologicalLayersScreen extends ConsumerWidget {
  const ArchaeologicalLayersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layersAsync = ref.watch(layersProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Arkeolojik Katmanlar'),
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: layersAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Hata: $error')),
        data: (layers) {
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: layers.length,
            itemBuilder: (context, index) {
              final layer = layers[index];
              return _LayerCard(layer: layer, index: index);
            },
          );
        },
      ),
    );
  }
}

class _LayerCard extends StatelessWidget {
  final ArchaeologicalLayer layer;
  final int index;

  const _LayerCard({required this.layer, required this.index});

  Color _getDepthColor(int depth) {
    // Yumuşak mor/pembe gradyan tonları
    if (depth < 100) return Color(0xFFE1BEE7); // Açık mor
    if (depth < 300) return Color(0xFFCE93D8); // Orta açık mor
    if (depth < 500) return Color(0xFFBA68C8); // Orta mor
    if (depth < 800) return Color(0xFFAB47BC); // Koyu mor
    return Color(0xFF9C27B0); // En koyu mor
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _getDepthColor(layer.depthCm).withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => _LayerDetailDialog(layer: layer),
            );
          },
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        _getDepthColor(layer.depthCm),
                        _getDepthColor(layer.depthCm).withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: _getDepthColor(layer.depthCm).withOpacity(0.4),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${layer.depthCm}cm',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      layer.layerName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    if (layer.period != null) ...[
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              layer.period!,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (layer.dateEstimated != null) ...[
                      SizedBox(height: 4),
                      Text(
                        layer.dateEstimated!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.info_outline, color: _getDepthColor(layer.depthCm)),
            ],
          ),
        ),
      ),
    ),
    );
  }
}

class _LayerDetailDialog extends StatelessWidget {
  final ArchaeologicalLayer layer;

  const _LayerDetailDialog({required this.layer});

  Color _getDepthColor(int depth) {
    // Yumuşak mor/pembe gradyan tonları
    if (depth < 100) return Color(0xFFE1BEE7); // Açık mor
    if (depth < 300) return Color(0xFFCE93D8); // Orta açık mor
    if (depth < 500) return Color(0xFFBA68C8); // Orta mor
    if (depth < 800) return Color(0xFFAB47BC); // Koyu mor
    return Color(0xFF9C27B0); // En koyu mor
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          _getDepthColor(layer.depthCm),
                          _getDepthColor(layer.depthCm).withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: _getDepthColor(layer.depthCm).withOpacity(0.4),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.layers, color: Colors.white, size: 28),
                        SizedBox(height: 4),
                        Text(
                          '${layer.depthCm}cm',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          layer.layerName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        if (layer.period != null)
                          Text(
                            layer.period!,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              if (layer.dateEstimated != null) ...[
                _buildInfoRow('Tarih', layer.dateEstimated!, Icons.calendar_today),
                SizedBox(height: 12),
              ],
              _buildInfoRow('Derinlik', '${layer.depthCm} cm', Icons.height),
              if (layer.findings != null) ...[
                SizedBox(height: 20),
                Text(
                  'Bulgular',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFE1BEE7).withOpacity(0.3),
                        Color(0xFFCE93D8).withOpacity(0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color(0xFFBA68C8).withOpacity(0.3), width: 1.5),
                  ),
                  child: Text(
                    layer.findings!,
                    style: TextStyle(fontSize: 15, height: 1.6, color: Colors.black87),
                  ),
                ),
              ],
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('KAPAT'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.purple[700]),
          SizedBox(width: 12),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
