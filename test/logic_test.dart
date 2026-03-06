// test/logic_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/logic/cosmology_calculator.dart';

// The main function is the entry point for the test runner.
// All tests must be inside this block.
void main() {
  
  // A 'group' helps organize related tests.
  group('CosmologyCalculator Logic Tests', () {

    // --- TEST 1: AGE CALCULATION ---
    test('presentAge should be accurate for a standard ΛCDM model', () {
      final calculator = CosmologyCalculator(
        h0: 67.4,
        omegaM: 0.315,
        omegaLambda: 0.685,
        omegaR: 0.0,
        z: 0,
      );

      final calculatedAge = calculator.presentAge;
      expect(calculatedAge, closeTo(13.8, 0.1));
    });


    // --- TEST 2: DISTANCE CALCULATION ---
    test('comovingRadialDistance should be accurate for a standard ΛCDM model at z=1', () {
      
      final calculator = CosmologyCalculator(
        h0: 67.4,
        omegaM: 0.315,
        omegaLambda: 0.685,
        omegaR: 0.0,
        z: 1.0,
      );

      print('--- CHECKPOINT: Testing Comoving Radial Distance ---');
      print('INPUTS: H₀=${calculator.h0}, Ω_M=${calculator.omegaM}, Ω_Λ=${calculator.omegaLambda}, z=${calculator.z}');
      
      final calculatedDistance = calculator.comovingRadialDistance;

      print('OUTPUT: Calculated Comoving Distance = $calculatedDistance Mpc');
      print('----------------------------------------------------');

      expect(calculatedDistance, closeTo(3363.0, 1.0));
    });

  }); // End of group
} // End of main function