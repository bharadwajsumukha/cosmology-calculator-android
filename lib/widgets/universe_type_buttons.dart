// lib/widgets/universe_type_buttons.dart

import 'package:flutter/material.dart';

class UniverseTypeButtons extends StatelessWidget {
  final VoidCallback onGeneralPressed;
  final VoidCallback onOpenPressed;
  final VoidCallback onFlatPressed;

  const UniverseTypeButtons({
    super.key,
    required this.onGeneralPressed,
    required this.onOpenPressed,
    required this.onFlatPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Theme.of(context).primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'UNIVERSE PRESETS',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.spaceEvenly,
          spacing: 16,
          runSpacing: 12,
          children: [
            _buildButton(
              context,
              'General ΛCDM',
              onPressed: onGeneralPressed,
            ),
            _buildButton(
              context,
              'Open Universe (Ωₖ>0)',
              onPressed: onOpenPressed,
            ),
            _buildButton(
              context,
              'Flat Universe (Ωₖ=0)',
              onPressed: onFlatPressed,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildButton(BuildContext context, String text, {required VoidCallback onPressed}) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDarkMode ? Colors.blue[400] : theme.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: const TextStyle(fontSize: 16),
      ),
      child: Text(text),
    );
  }
}