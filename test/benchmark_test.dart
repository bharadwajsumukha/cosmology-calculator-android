// test/benchmark_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/logic/cosmology_calculator.dart';

void main() {
  group('Comprehensive Cosmology Benchmark Tests', () {

    // --- BENCHMARK 1: Flat/General ΛCDM Model ---
    // Values from: For Ho = 67.4, OmegaM = 0.315, Omegavac = 0.685, z = 1.000
    test('Matches all benchmark values for a standard Flat model within tolerance', () {
      
      final calculator = CosmologyCalculator(
        h0: 67.4,
        omegaM: 0.315,
        omegaLambda: 0.685,
        omegaR: 0.0, // Per benchmark, this implies Omega_k is 0
        z: 1.0,
      );

      print('--- BENCHMARK 1: TESTING ALL FLAT MODEL OUTPUTS ---');
      print('Present Age (Gyr):            ${calculator.presentAge}');
      print('Age at Redshift z (Gyr):      ${calculator.ageAtRedshiftZ}');
      print('Lookback Time (Gyr):          ${calculator.lookbackTime}');
      print('Comoving Distance (Mpc):      ${calculator.comovingRadialDistance}');
      print('Comoving Volume (Gpc^3):      ${calculator.comovingVolume}');
      print('Angular Diameter Dist (Mpc):  ${calculator.angularDiameterDistance}');
      print('Luminosity Distance (Mpc):    ${calculator.luminosityDistance}');
      print('Angular Scale (kpc/"):        ${calculator.angularScale}');
      print('---------------------------------------------------------');

      // Using a tolerance of 0.1 as requested
      expect(calculator.presentAge, closeTo(13.791, 0.1));
      expect(calculator.ageAtRedshiftZ, closeTo(5.841, 0.1));
      expect(calculator.lookbackTime, closeTo(7.950, 0.1));
      expect(calculator.comovingRadialDistance, closeTo(3400.9, 1.0)); // Distance can vary slightly more
      expect(calculator.comovingVolume, closeTo(164.772, 2.0));      // Volume is very sensitive, larger tolerance
      expect(calculator.angularDiameterDistance, closeTo(1700.5, 1.0));
      expect(calculator.luminosityDistance, closeTo(6801.9, 1.0));
      expect(calculator.angularScale, closeTo(8.244, 0.1));
    });


    // --- BENCHMARK 2: Open Universe Model ---
    // Values from: For Ho = 67.4, OmegaM = 0.315, Omegavac = 0.000, z = 1.000
    test('Matches all benchmark values for an Open Universe model within tolerance', () {
      
      final calculator = CosmologyCalculator(
        h0: 67.4,
        omegaM: 0.315,
        omegaLambda: 0.000,
        omegaR: 0.0,
        z: 1.0,
      );
      
      print('--- BENCHMARK 2: TESTING ALL OPEN MODEL OUTPUTS ---');
      print('Present Age (Gyr):            ${calculator.presentAge}');
      print('Age at Redshift z (Gyr):      ${calculator.ageAtRedshiftZ}');
      print('Lookback Time (Gyr):          ${calculator.lookbackTime}');
      print('Comoving Distance (Mpc):      ${calculator.comovingRadialDistance}');
      print('Comoving Volume (Gpc^3):      ${calculator.comovingVolume}');
      print('Angular Diameter Dist (Mpc):  ${calculator.angularDiameterDistance}');
      print('Luminosity Distance (Mpc):    ${calculator.luminosityDistance}');
      print('Angular Scale (kpc/"):        ${calculator.angularScale}');
      print('---------------------------------------------------------');

      // Using a tolerance of 0.1 as requested
      expect(calculator.presentAge, closeTo(11.659, 0.1));
      expect(calculator.ageAtRedshiftZ, closeTo(4.794, 0.1));
      expect(calculator.lookbackTime, closeTo(6.864, 0.1));
      expect(calculator.comovingRadialDistance, closeTo(2894.9, 1.0));
      expect(calculator.comovingVolume, closeTo(107.690, 2.0));
      expect(calculator.angularDiameterDistance, closeTo(1518.5, 1.0));
      expect(calculator.luminosityDistance, closeTo(6073.9, 1.0));
      expect(calculator.angularScale, closeTo(7.362, 0.1));
    });

  });
}