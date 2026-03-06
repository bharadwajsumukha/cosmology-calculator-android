// lib/widgets/output_panel.dart

import 'package:flutter/material.dart';
import 'package:my_app/models/calculator_results.dart';

class OutputPanel extends StatelessWidget {
  final CalculatorResults? results;

  const OutputPanel({super.key, this.results});

  @override
  Widget build(BuildContext context) {
    if (results == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 48.0),
          child: Text("Press 'SUBMIT' to see the results."),
        ),
      );
    }

    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Define colors based on the current theme mode
    final Color highlightedValueColor;
    final Color nonHighlightedValueColor;
    final Color labelColor;

    if (isDarkMode) {
      // --- DARK MODE COLORS (As per your request) ---
      highlightedValueColor = Colors.cyanAccent;          // Important values are bright cyan
      nonHighlightedValueColor = Colors.lightBlue[200]!;   // Non-important values are light blue
      labelColor = Colors.white70;                         // All labels are a consistent dim white
    } else {
      // --- LIGHT MODE COLORS (Unchanged) ---
      highlightedValueColor = theme.primaryColor;          // Important values match the theme color
      nonHighlightedValueColor = Colors.black87;             // Non-important values are dark grey
      labelColor = Colors.black54;                           // All labels are a lighter grey
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black38 : Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- KEY METRICS ---
          // These rows will use the `highlightedValueColor`
          _buildResultRow(
            label: "Age of Universe (t₀)",
            value: "${results!.presentAge.toStringAsFixed(3)} Gyr",
            labelColor: labelColor,
            valueColor: highlightedValueColor,
            isHighlighted: true,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(color: isDarkMode ? Colors.white12 : Colors.black12),
          ),
          _buildResultRow(
            label: "Comoving Radial Distance",
            value: "${results!.comovingRadialDistanceGly.toStringAsFixed(3)} Gly",
            labelColor: labelColor,
            valueColor: highlightedValueColor,
            isHighlighted: true,
          ),
          _buildResultRow(
            label: "Angular Diameter Distance",
            value: "${results!.angularDiameterDistanceGly.toStringAsFixed(3)} Gly",
            labelColor: labelColor,
            valueColor: highlightedValueColor,
            isHighlighted: true,
          ),
          _buildResultRow(
            label: "Luminosity Distance",
            value: "${results!.luminosityDistanceGly.toStringAsFixed(3)} Gly",
            labelColor: labelColor,
            valueColor: highlightedValueColor,
            isHighlighted: true,
          ),
          _buildResultRow(
            label: "Angular Scale",
            value: "${results!.angularScaleKpc.toStringAsFixed(3)} kpc/arcsec",
            labelColor: labelColor,
            valueColor: highlightedValueColor,
            isHighlighted: true,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(color: isDarkMode ? Colors.white12 : Colors.black12),
          ),

          // --- OTHER METRICS ---
          // These rows will now use the `nonHighlightedValueColor`
          _buildResultRow(
            label: "Age at Redshift z",
            value: "${results!.ageAtRedshiftZ.toStringAsFixed(3)} Gyr",
            labelColor: labelColor,
            valueColor: nonHighlightedValueColor,
          ),
          _buildResultRow(
            label: "Lookback Time",
            value: "${results!.lookbackTime.toStringAsFixed(3)} Gyr",
            labelColor: labelColor,
            valueColor: nonHighlightedValueColor,
          ),
          _buildResultRow(
            label: "Comoving Volume",
            value: "${results!.comovingVolumeGpc3.toStringAsFixed(3)} Gpc³",
            labelColor: labelColor,
            valueColor: nonHighlightedValueColor,
          ),
          _buildResultRow(
            label: "CMB Temperature at z",
            value: "${results!.cmbTemperatureAtZ.toStringAsFixed(3)} K",
            labelColor: labelColor,
            valueColor: nonHighlightedValueColor,
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow({
    required String label,
    required String value,
    required Color labelColor,
    required Color valueColor,
    bool isHighlighted = false,
  }) {
    final double fontSize = isHighlighted ? 17 : 15;
    final FontWeight labelFontWeight = isHighlighted ? FontWeight.w500 : FontWeight.normal;
    final FontWeight valueFontWeight = isHighlighted ? FontWeight.bold : FontWeight.w600;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                color: labelColor,
                fontWeight: labelFontWeight,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: fontSize,
              color: valueColor,
              fontWeight: valueFontWeight,
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}