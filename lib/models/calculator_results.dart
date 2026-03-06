// lib/models/calculator_results.dart

import 'package:flutter/foundation.dart';
import 'package:my_app/logic/cosmology_calculator.dart';

@immutable
class CalculatorResults {
  final double presentAge;
  final double ageAtRedshiftZ;
  final double lookbackTime;
  final double comovingRadialDistanceMpc;
  final double comovingRadialDistanceGly;
  final double comovingVolumeGpc3;
  final double angularDiameterDistanceMpc;
  final double angularDiameterDistanceGly;
  final double luminosityDistanceMpc;
  final double luminosityDistanceGly;
  final double angularScaleKpc;
  final double cmbTemperatureAtZ;

  const CalculatorResults({
    required this.presentAge,
    required this.ageAtRedshiftZ,
    required this.lookbackTime,
    required this.comovingRadialDistanceMpc,
    required this.comovingRadialDistanceGly,
    required this.comovingVolumeGpc3,
    required this.angularDiameterDistanceMpc,
    required this.angularDiameterDistanceGly,
    required this.luminosityDistanceMpc,
    required this.luminosityDistanceGly,
    required this.angularScaleKpc,
    required this.cmbTemperatureAtZ,
  });

  // Factory constructor to create results from a calculator instance
  factory CalculatorResults.fromCalculator(CosmologyCalculator calculator) {
    const mpcToGly = 0.00326156;
    return CalculatorResults(
      presentAge: calculator.presentAge,
      ageAtRedshiftZ: calculator.ageAtRedshiftZ,
      lookbackTime: calculator.lookbackTime,
      comovingRadialDistanceMpc: calculator.comovingRadialDistance,
      comovingRadialDistanceGly: calculator.comovingRadialDistance * mpcToGly,
      comovingVolumeGpc3: calculator.comovingVolume,
      angularDiameterDistanceMpc: calculator.angularDiameterDistance,
      angularDiameterDistanceGly: calculator.angularDiameterDistance * mpcToGly,
      luminosityDistanceMpc: calculator.luminosityDistance,
      luminosityDistanceGly: calculator.luminosityDistance * mpcToGly,
      angularScaleKpc: calculator.angularScale,
      cmbTemperatureAtZ: calculator.cmbTemperatureAtZ,
    );
  }
}