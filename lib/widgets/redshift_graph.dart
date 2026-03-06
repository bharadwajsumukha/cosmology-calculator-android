// lib/widgets/redshift_graph.dart

import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart'; // Import for LaTeX rendering

class RedshiftGraph extends StatelessWidget {
  final String title;
  final Map<String, List<FlSpot>> lineData;

  const RedshiftGraph({super.key, required this.title, required this.lineData});

  // --- HELPER FOR TASK 2 ---
  // Converts string keys to LaTeX format for the legend
  String _getLatexLegend(String key) {
    switch (key) {
      case 'D_L':
        return r'D_L';
      case 'D_C':
        return r'D_C';
      case 'D_ltt':
        return r'D_{ltt}';
      case 'D_A':
        return r'D_A';
      default:
        return key; // Fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    // --- STYLING CHANGES FOR TASK 3 ---
    // Theme-aware colors with increased visibility
    final textColor = isDarkMode ? Colors.white.withOpacity(0.9) : Colors.black.withOpacity(0.9);
    final secondaryTextColor = isDarkMode ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7);
    final gridLineColor = isDarkMode ? Colors.white12 : Colors.black12;
    final borderColor = isDarkMode ? Colors.white38 : Colors.black38; // Increased opacity
    final tooltipColor = isDarkMode ? Colors.blueGrey.withOpacity(0.8) : Colors.deepPurple[100];
    final tooltipTextColor = isDarkMode ? Colors.white : Colors.black;
    // --- END STYLING CHANGES ---

    const lineColors = {'D_L': Colors.redAccent, 'D_C': Colors.white, 'D_ltt': Colors.blueAccent, 'D_A': Colors.greenAccent};

    // Correct the D_C color for light mode
    final dynamicLineColors = Map.of(lineColors);
    if (!isDarkMode) {
      dynamicLineColors['D_C'] = Colors.purpleAccent;
    }
    
    final log10 = (double x) => log(x) / ln10;

    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
        const SizedBox(height: 16),
        AspectRatio(
          aspectRatio: 1.2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: LineChart(
              LineChartData(
                clipData: const FlClipData.all(),
                lineTouchData: LineTouchData(
                  getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
                    return spotIndexes.map((spotIndex) {
                      return TouchedSpotIndicatorData(
                        FlLine(color: gridLineColor, strokeWidth: 1),
                        FlDotData(
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 6,
                              color: barData.color ?? Colors.grey,
                              strokeWidth: 2,
                              strokeColor: Colors.white,
                            );
                          },
                        ),
                      );
                    }).toList();
                  },
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (LineBarSpot touchedSpot) => tooltipColor!,
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots.map((spot) {
                        final originalX = pow(10, spot.x);
                        final originalY = pow(10, spot.y);
                        String lineKey = dynamicLineColors.entries.firstWhere((e) => e.value == spot.bar.color, orElse: () => const MapEntry('', Colors.transparent)).key;
                        
                        // Use LaTeX here too for consistency in the tooltip
                        final keyAsLatex = _getLatexLegend(lineKey);

                        return LineTooltipItem(
                          '$keyAsLatex: ${originalY.toStringAsFixed(3)}',
                          TextStyle(color: tooltipTextColor, fontWeight: FontWeight.bold, fontSize: 12),
                          children: [
                              TextSpan(
                                text: '\nz = ${originalX.toStringAsFixed(2)}', // \n for new line
                                style: const TextStyle(fontWeight: FontWeight.normal)
                              )
                          ]
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: lineData.entries.map((entry) => LineChartBarData(
                  spots: entry.value, isCurved: true, color: dynamicLineColors[entry.key]!,
                  barWidth: 3, dotData: const FlDotData(show: false),
                )).toList(),
                titlesData: _buildTitlesData(log10, textColor, secondaryTextColor),
                gridData: _buildGridData(gridLineColor),
                borderData: _buildBorderData(borderColor),
                minX: log10(0.01),
                maxX: log10(2000),
                minY: log10(0.01),
                maxY: log10(500),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildLegend(dynamicLineColors, textColor),
      ],
    );
  }

  Widget _logAxisTitle(double logValue, TitleMeta meta, Function(double) log10, Color color) {
    final value = pow(10, logValue);
    bool isMajorTick = (logValue - logValue.round()).abs() < 1e-9;
    
    if (logValue == log10(0.01) || logValue == log10(0.1) || isMajorTick) {
      return SideTitleWidget(
        axisSide: meta.axisSide, space: 8,
        child: Text(value.toStringAsFixed(value < 1 ? 2 : 0), style: TextStyle(fontSize: 12, color: color)),
      );
    }
    return Container();
  }

  FlTitlesData _buildTitlesData(Function(double) log10, Color textColor, Color secondaryTextColor) {
    return FlTitlesData(
      bottomTitles: AxisTitles(axisNameWidget: Text("Redshift (z)", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)), sideTitles: SideTitles(showTitles: true, reservedSize: 32, getTitlesWidget: (v,m) => _logAxisTitle(v, m, log10, secondaryTextColor), interval: 1)),
      leftTitles: AxisTitles(axisNameWidget: Text("H₀D / c", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)), sideTitles: SideTitles(showTitles: true, reservedSize: 40, getTitlesWidget: (v,m) => _logAxisTitle(v, m, log10, secondaryTextColor), interval: 1)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  FlGridData _buildGridData(Color color) {
    return FlGridData(
      show: true,
      drawVerticalLine: true,
      getDrawingVerticalLine: (logValue) => FlLine(color: color, strokeWidth: 0.8),
      checkToShowVerticalLine: (logValue) => (logValue - logValue.round()).abs() < 1e-9,
      drawHorizontalLine: true,
      getDrawingHorizontalLine: (logValue) => FlLine(color: color, strokeWidth: 0.8),
      checkToShowHorizontalLine: (logValue) => (logValue - logValue.round()).abs() < 1e-9,
    );
  }

  // --- BORDER CHANGE FOR TASK 3 ---
  FlBorderData _buildBorderData(Color color) => FlBorderData(show: true, border: Border.all(color: color, width: 1.5));

  // --- LEGEND CHANGE FOR TASK 2 ---
  Widget _buildLegend(Map<String, Color> dynamicLineColors, Color textColor) {
    return Wrap(
      spacing: 24, // Increased spacing
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: dynamicLineColors.entries.map((entry) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 16, height: 16, color: entry.value),
            const SizedBox(width: 8),
            // Use the Math widget to render LaTeX
            Math.tex(
              _getLatexLegend(entry.key),
              mathStyle: MathStyle.text,
              textStyle: TextStyle(
                fontSize: 16,
                color: textColor,
              ),
            )
          ]
        );
      }).toList());
  }
}