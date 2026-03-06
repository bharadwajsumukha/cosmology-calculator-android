// lib/screens/tabs/calculator_tab.dart
import 'package:flutter/material.dart';
import 'package:my_app/models/calculator_results.dart';
import 'package:my_app/widgets/input_panel.dart';
import 'package:my_app/widgets/output_panel.dart';
import 'package:my_app/widgets/universe_type_buttons.dart';

class CalculatorTab extends StatelessWidget {
  final TextEditingController h0Controller;
  final TextEditingController omegaMController;
  final TextEditingController omegaLambdaController;
  final TextEditingController omegaRController;
  final TextEditingController zController;
  final CalculatorResults? results;
  final VoidCallback onGeneralPressed;
  final VoidCallback onOpenPressed;
  final VoidCallback onFlatPressed;
  final VoidCallback onSubmit;
  final Map<String, String?> errors;

  const CalculatorTab({
    super.key,
    required this.h0Controller,
    required this.omegaMController,
    required this.omegaLambdaController,
    required this.omegaRController,
    required this.zController,
    this.results,
    required this.onGeneralPressed,
    required this.onOpenPressed,
    required this.onFlatPressed,
    required this.onSubmit,
    required this.errors,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'INPUT PARAMETERS',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          InputPanel(
            h0Controller: h0Controller,
            omegaMController: omegaMController,
            omegaLambdaController: omegaLambdaController,
            omegaRController: omegaRController,
            zController: zController,
            errors: errors,
          ),
          const SizedBox(height: 24),
          UniverseTypeButtons(
            onGeneralPressed: onGeneralPressed,
            onOpenPressed: onOpenPressed,
            onFlatPressed: onFlatPressed,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onSubmit,
            child: const Text('SUBMIT'),
          ),
          const SizedBox(height: 24),
          Text(
            'RESULTS',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          OutputPanel(results: results),
        ],
      ),
    );
  }
}