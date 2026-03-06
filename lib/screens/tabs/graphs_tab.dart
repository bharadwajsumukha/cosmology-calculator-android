// lib/screens/tabs/graphs_tab.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:my_app/widgets/redshift_graph.dart';

class GraphsTab extends StatelessWidget {
  final Map<String, List<FlSpot>> lcdmData;
  final Map<String, List<FlSpot>> edsData;
  final Map<String, List<FlSpot>> emptyData;
  final bool isLoading;

  const GraphsTab({
    super.key,
    required this.lcdmData,
    required this.edsData,
    required this.emptyData,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (lcdmData.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            "Press 'SUBMIT' in the Calculator tab to generate the graphs.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }
    
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        RedshiftGraph(
          // --- CORRECTED TITLE ---
          title: 'ΛCDM Model',
          lineData: lcdmData,
        ),
        const SizedBox(height: 48),
        RedshiftGraph(
          title: 'Einstein-de Sitter Model',
          lineData: edsData,
        ),
        const SizedBox(height: 48),
        RedshiftGraph(
          title: 'Empty Universe Model',
          lineData: emptyData,
        ),
      ],
    );
  }
}