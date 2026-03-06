// lib/screens/calculator_screen.dart

import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:my_app/logic/cosmology_calculator.dart';
import 'package:my_app/models/calculator_params.dart';
import 'package:my_app/models/calculator_results.dart';
import 'package:my_app/screens/readme_screen.dart';
import 'package:my_app/screens/tabs/calculator_tab.dart';
import 'package:my_app/screens/tabs/graphs_tab.dart';
import 'package:my_app/screens/tabs/formulas_tab.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

// Helper classes for background processing
class CalculationInput {
  final double h0, omegaM, omegaLambda, omegaR, z;
  CalculationInput({ required this.h0, required this.omegaM, required this.omegaLambda, required this.omegaR, required this.z });
}

class CalculationOutput {
  final CalculatorResults results;
  final Map<String, List<FlSpot>> lcdmData;
  final Map<String, List<FlSpot>> edsData;
  final Map<String, List<FlSpot>> emptyData;
  CalculationOutput({ required this.results, required this.lcdmData, required this.edsData, required this.emptyData });
}

// Top-level function for background isolate
CalculationOutput _performCalculations(CalculationInput input) {
  Map<String, List<FlSpot>> generateLogGraphDataForModel({
    required double h0, required double omegaM, required double omegaLambda, required double omegaR,
  }) {
    final data = {'D_L': <FlSpot>[], 'D_C': <FlSpot>[], 'D_ltt': <FlSpot>[], 'D_A': <FlSpot>[]};
    for (double z = 0.01; z <= 2000; z *= 1.15) {
      final calc = CosmologyCalculator(h0: h0, omegaM: omegaM, omegaLambda: omegaLambda, omegaR: omegaR, z: z);
      final dDc = calc.comovingRadialDistance / calc.hubbleDistance;
      final dDa = calc.angularDiameterDistance / calc.hubbleDistance;
      final dDl = calc.luminosityDistance / calc.hubbleDistance;
      final dLtt = calc.lookbackTime / (977.8 / h0);
      if (dDc.isFinite && dDc > 0) data['D_C']!.add(FlSpot(log(z) / ln10, log(dDc) / ln10));
      if (dDa.isFinite && dDa > 0) data['D_A']!.add(FlSpot(log(z) / ln10, log(dDa) / ln10));
      if (dDl.isFinite && dDl > 0) data['D_L']!.add(FlSpot(log(z) / ln10, log(dDl) / ln10));
      if (dLtt.isFinite && dLtt > 0) data['D_ltt']!.add(FlSpot(log(z) / ln10, log(dLtt) / ln10));
    }
    return data;
  }
  final resultsCalc = CosmologyCalculator(h0: input.h0, omegaM: input.omegaM, omegaLambda: input.omegaLambda, omegaR: input.omegaR, z: input.z);
  final newResults = CalculatorResults.fromCalculator(resultsCalc);
  final newLcdmData = generateLogGraphDataForModel(h0: input.h0, omegaM: input.omegaM, omegaLambda: input.omegaLambda, omegaR: input.omegaR);
  final newEdsData = generateLogGraphDataForModel(h0: input.h0, omegaM: 1.0, omegaLambda: 0.0, omegaR: 0.0);
  final newEmptyData = generateLogGraphDataForModel(h0: input.h0, omegaM: 0.0, omegaLambda: 0.0, omegaR: 0.0);
  return CalculationOutput(results: newResults, lcdmData: newLcdmData, edsData: newEdsData, emptyData: newEmptyData);
}

class CalculatorScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  const CalculatorScreen({super.key, required this.toggleTheme});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  late final TextEditingController _h0Controller;
  late final TextEditingController _omegaMController;
  late final TextEditingController _omegaLambdaController;
  late final TextEditingController _omegaRController;
  late final TextEditingController _zController;
  CalculatorResults? _results;
  Map<String, List<FlSpot>> _lcdmData = {};
  Map<String, List<FlSpot>> _edsData = {};
  Map<String, List<FlSpot>> _emptyData = {};
  bool _isGraphLoading = false;
  final Map<String, String?> _errors = {
    'h0': null, 'omegaM': null, 'omegaLambda': null, 'omegaR': null, 'z': null
  };

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }
  void _initializeControllers() {
    final defaultParams = CalculatorParams.defaultValues();
    _h0Controller = TextEditingController(text: defaultParams.h0.toString());
    _omegaMController = TextEditingController(text: defaultParams.omegaM.toString());
    _omegaLambdaController = TextEditingController(text: defaultParams.omegaLambda.toString());
    _omegaRController = TextEditingController(text: defaultParams.omegaR.toString());
    _zController = TextEditingController(text: defaultParams.z.toString());
  }
  @override
  void dispose() {
    _h0Controller.dispose();_omegaMController.dispose();_omegaLambdaController.dispose();
    _omegaRController.dispose();_zController.dispose();
    super.dispose();
  }

  void _showPresetFeedback(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 2)));
  }

  void _setGeneralPreset() {
    final p = CalculatorParams.defaultValues();
    _h0Controller.text = p.h0.toString();_omegaMController.text = p.omegaM.toString();
    _omegaLambdaController.text = p.omegaLambda.toString();_omegaRController.text = p.omegaR.toString();
    _showPresetFeedback("General preset loaded.");_runCalculation();
  }

  void _setOpenPreset() {
    _omegaMController.text = "0.3";
    _omegaLambdaController.text = "0.0"; _omegaRController.text = "0.0";
    _showPresetFeedback("Open Universe preset applied.");_runCalculation();
  }

  void _setFlatPreset() {
    final m=0.3,r=0.0; _omegaMController.text=m.toString();_omegaRController.text=r.toString();
    _omegaLambdaController.text=(1.0 - m - r).toStringAsFixed(3);
    _showPresetFeedback("Flat Universe preset applied.");_runCalculation();
  }

  Future<void> _runCalculation() async {
    if(mounted) FocusScope.of(context).unfocus();

    setState(() {
      _errors.updateAll((key, value) => null);
      _isGraphLoading = true;
    });

    try {
      final h0 = double.parse(_h0Controller.text);
      final omegaM = double.parse(_omegaMController.text);
      final omegaLambda = double.parse(_omegaLambdaController.text);
      final omegaR = double.parse(_omegaRController.text);
      final z = double.parse(_zController.text);

      if (h0 <= 0 || h0 > 500) throw FormatException('H₀ must be between 1 and 500.', _h0Controller.text);
      if (omegaM < 0 || omegaM > 2) throw FormatException('Ωₘ must be between 0 and 2.', _omegaMController.text);
      if (omegaLambda < 0 || omegaLambda > 2) throw FormatException('Ω_Λ must be between 0 and 2.', _omegaLambdaController.text);
      if (omegaR < 0 || omegaR > 2) throw FormatException('Ω_R must be between 0 and 2.', _omegaRController.text);
      if (z < 0 || z > 15000) throw FormatException('z must be between 0 and 15000.', _zController.text);

      final input = CalculationInput(h0: h0, omegaM: omegaM, omegaLambda: omegaLambda, omegaR: omegaR, z: z);
      final output = await compute(_performCalculations, input);
      
      if(mounted) {
        setState(() {
          _results = output.results;
          _lcdmData = output.lcdmData;
          _edsData = output.edsData;
          _emptyData = output.emptyData;
          _isGraphLoading = false;
        });
      }
    } catch (e) {
      String message = 'Invalid input in one of the fields.';
      String field = '';
      if (e is FormatException) {
        message = e.message;
        if (message.contains('H₀')) field = 'h0';
        else if (message.contains('Ωₘ')) field = 'omegaM';
        else if (message.contains('Ω_Λ')) field = 'omegaLambda';
        else if (message.contains('Ω_R')) field = 'omegaR';
        else if (message.contains('z')) field = 'z';
      }
      
      if(mounted) {
        setState(() {
          if (field.isNotEmpty) _errors[field] = message;
          _isGraphLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.redAccent));
      }
    }
  }
  
  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not launch $urlString')));
      }
    }
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: const Text("About Cosmology Calculator"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text("Developed by Sumukha R Bharadwaj.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              const Text("This app is a scientific tool for calculating key parameters of the universe based on the standard FLRW cosmological model.", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 4),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ReadmeScreen()));
                },
                child: const Text("Know More..."),
              ),
              const Divider(height: 24),
              const Text("For an excellent introduction to these topics, please visit Ned Wright's Cosmology Tutorial:"),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _launchURL("https://www.astro.ucla.edu/~wright/intro.html"),
                child: const Text("www.astro.ucla.edu/~wright/intro.html", style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
              ),
              const SizedBox(height: 16),
              const Text("For feedback or contributions, please contact:"),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _launchURL(Uri(scheme: 'mailto', path: 'bharadwaj.sumukha@gmail.com', query: 'subject=Cosmology Calculator Feedback').toString()),
                child: const Text("bharadwaj.sumukha@gmail.com", style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(child: const Text('Close'), onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cosmology Calculator'),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              tooltip: "About",
              onPressed: _showAboutDialog,
            ),
            // *** MODIFICATION START ***
            IconButton(
              icon: const Icon(Icons.brightness_6),
              tooltip: "Toggle Theme",
              onPressed: () {
                // Determine the new mode BEFORE toggling
                final currentBrightness = Theme.of(context).brightness;
                final newMode = currentBrightness == Brightness.dark ? "Light" : "Dark";

                // Show a confirmation SnackBar
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Switched to $newMode Mode"),
                    duration: const Duration(milliseconds: 1500),
                  ),
                );

                // Call the actual function to change the theme
                widget.toggleTheme();
              },
            ),
            // *** MODIFICATION END ***
          ],
          bottom: const TabBar(tabs: [
            Tab(icon: Icon(Icons.calculate), text: 'Calculator'),
            Tab(icon: Icon(Icons.bar_chart), text: 'Graphs'),
            Tab(icon: Icon(Icons.functions), text: 'Formulas'),
          ]),
        ),
        body: TabBarView(
          children: [
            CalculatorTab(
              h0Controller: _h0Controller, omegaMController: _omegaMController, omegaLambdaController: _omegaLambdaController,
              omegaRController: _omegaRController, zController: _zController,
              results: _results,
              onGeneralPressed: _setGeneralPreset, onOpenPressed: _setOpenPreset,
              onFlatPressed: _setFlatPreset, onSubmit: _runCalculation,
              errors: _errors,
            ),
            GraphsTab(lcdmData: _lcdmData, edsData: _edsData, emptyData: _emptyData, isLoading: _isGraphLoading),
            const FormulasTab(),
          ],
        ),
      ),
    );
  }
}