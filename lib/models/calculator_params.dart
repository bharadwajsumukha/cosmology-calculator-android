// lib/models/calculator_params.dart

import 'package:flutter/foundation.dart';

/// A data class to hold all the user-configurable input parameters
/// for the cosmology calculation.
@immutable
class CalculatorParams {
  final double h0;
  final double omegaM;
  final double omegaLambda;
  final double omegaR;
  final double z;

  const CalculatorParams({
    required this.h0,
    required this.omegaM,
    required this.omegaLambda,
    required this.omegaR,
    required this.z,
  });

  /// A factory constructor to create the default parameters for when the app starts.
  factory CalculatorParams.defaultValues() {
    return const CalculatorParams(
      h0: 69.6,
      omegaM: 0.286,
      omegaLambda: 0.714,
      omegaR: 8.4e-5,
      z: 1.0, // A default redshift to show some initial results.
    );
  }
}