// lib/logic/cosmology_calculator.dart

import 'dart:math';

class CosmologyCalculator {
  // --- CALIBRATED CONSTANTS in Standard Astronomical Units ---
  static const double c = 299792.458; // Speed of light in km/s
  static const double hubbleTimeFactor = 977.8; // Factor to get Gyr from 1/(km/s/Mpc)
  static const double tCMB0 = 2.725; // CMB temperature today in Kelvin

  // --- INPUT PARAMETERS ---
  final double h0;
  final double omegaM;
  final double omegaLambda;
  final double omegaR;
  final double z;

  // --- DERIVED PARAMETERS ---
  final double omegaK;
  final double hubbleTime;
  final double hubbleDistance; // This is Dh

  CosmologyCalculator({
    required this.h0,
    required this.omegaM,
    required this.omegaLambda,
    required this.omegaR,
    required this.z,
  })  : omegaK = 1.0 - omegaM - omegaLambda - omegaR,
        hubbleTime = hubbleTimeFactor / h0,
        hubbleDistance = c / h0;

  // --- CORE PRIVATE METHODS ---
  double _eZ(double zValue) {
    final double onePlusZ = 1.0 + zValue;
    return sqrt(omegaR * pow(onePlusZ, 4) +
        omegaM * pow(onePlusZ, 3) +
        omegaK * pow(onePlusZ, 2) +
        omegaLambda);
  }

  double _sinh(double x) => (exp(x) - exp(-x)) / 2.0;
  double _asinh(double x) => log(x + sqrt(pow(x, 2) + 1));

  double _numericalIntegrate({
    required double from,
    required double to,
    required double Function(double) f,
  }) {
    int n = 30000;
    final double h = (to - from) / n;
    double sum = f(from) + f(to);
    for (int i = 1; i < n; i += 2) sum += 4 * f(from + i * h);
    for (int i = 2; i < n - 1; i += 2) sum += 2 * f(from + i * h);
    return sum * h / 3.0;
  }
  
  double get _distanceIntegral => _numericalIntegrate(from: 0, to: z, f: (zPrime) => 1.0 / _eZ(zPrime));
  double get _comovingLineOfSightDistance => hubbleDistance * _distanceIntegral;

  double get _transverseComovingDistance {
    final double dc = _comovingLineOfSightDistance;
    if (omegaK.abs() < 1e-6) return dc;
    final double dh = hubbleDistance;
    final double sqrtOkAbs = sqrt(omegaK.abs());
    if (omegaK > 0) return dh / sqrtOkAbs * _sinh(sqrtOkAbs * dc / dh);
    return dh / sqrtOkAbs * sin(sqrtOkAbs * dc / dh);
  }

  // --- PUBLIC GETTERS ---
  double get presentAge => hubbleTime * _numericalIntegrate(from: 0, to: 15000, f: (zPrime) => 1.0 / ((1.0 + zPrime) * _eZ(zPrime)));
  double get ageAtRedshiftZ => hubbleTime * _numericalIntegrate(from: z, to: 15000, f: (zPrime) => 1.0 / ((1.0 + zPrime) * _eZ(zPrime)));
  double get lookbackTime => presentAge - ageAtRedshiftZ;
  double get cmbTemperatureAtZ => tCMB0 * (1 + z);
  double get comovingRadialDistance => _comovingLineOfSightDistance;
  double get angularDiameterDistance => _transverseComovingDistance / (1.0 + z);
  double get luminosityDistance => _transverseComovingDistance * (1.0 + z);
  
  double get angularScale {
    final double da = angularDiameterDistance;
    if (da.abs() < 1e-9) return 0.0;
    return (da * 1000) / 206264.806;
  }
  
  double get comovingVolume {
    final double dh = hubbleDistance;
    double vcMpc3;

    if (omegaK.abs() < 1e-6) {
      vcMpc3 = (4.0 / 3.0) * pi * pow(comovingRadialDistance, 3);
    } else {
      final double dc = comovingRadialDistance;
      final double x = dc / dh;
      final double sqrtOkAbs = sqrt(omegaK.abs());
      final double term1 = x * sqrt(1 + omegaK * pow(x, 2));
      
      if (omegaK > 0) { // Open universe
        final double term2 = _asinh(sqrtOkAbs * x) / sqrtOkAbs;
        vcMpc3 = (2.0 * pi * pow(dh, 3) / omegaK) * (term1 - term2);
      } else { // Closed universe
        final double arg = (sqrtOkAbs * x).clamp(-1.0, 1.0);
        final double term2 = asin(arg) / sqrtOkAbs;
        // THE FIX IS HERE: We divide by omegaK itself, not its absolute value.
        vcMpc3 = (2.0 * pi * pow(dh, 3) / omegaK) * (term1 - term2);
      }
    }
    return vcMpc3 / 1e9;
  }
}