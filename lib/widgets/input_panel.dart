// lib/widgets/input_panel.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputPanel extends StatelessWidget {
  // We will require controllers to manage the text in each field.
  final TextEditingController h0Controller;
  final TextEditingController omegaMController;
  final TextEditingController omegaLambdaController;
  final TextEditingController omegaRController;
  final TextEditingController zController;
  final Map<String, String?> errors;

  const InputPanel({
    super.key,
    required this.h0Controller,
    required this.omegaMController,
    required this.omegaLambdaController,
    required this.omegaRController,
    required this.zController,
    required this.errors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextField(
          controller: h0Controller,
          label: 'Hubble Constant (H₀)',
          suffixText: 'km/s/Mpc',
          hintText: 'e.g., 69.6', // Hint Added
          errorText: errors['h0'],
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: omegaMController,
          label: 'Matter Density (Ω_M)',
          hintText: 'e.g., 0.286', // Hint Added
          errorText: errors['omegaM'],
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: omegaLambdaController,
          label: 'Dark Energy Density (Ω_Λ)',
          hintText: 'e.g., 0.714', // Hint Added
          errorText: errors['omegaLambda'],
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: omegaRController,
          label: 'Radiation Density (Ω_R)',
          hintText: 'e.g., 8.4e-5', // Hint Added
          errorText: errors['omegaR'],
        ),
         const SizedBox(height: 12),
        _buildTextField(
          controller: zController,
          label: 'Redshift (z)',
          hintText: 'e.g., 1.0', // Hint Added
          errorText: errors['z'],
        ),
      ],
    );
  }

  // Helper method to avoid repeating code for each text field.
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? suffixText,
    String? hintText, // Add hintText parameter
    String? errorText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText, // Use hintText here
        suffixText: suffixText,
        errorText: errorText,
        border: const OutlineInputBorder(),
        helperText: errorText != null ? null : ' ', // To prevent the layout from jumping
      ),
      // Allow only numbers (and a decimal point)
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
    );
  }
}