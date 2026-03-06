// lib/screens/tabs/formulas_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:animations/animations.dart';

class FormulasTab extends StatelessWidget {
  const FormulasTab({super.key});

  @override
  Widget build(BuildContext context) {
    // This main layout remains the same.
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
         _buildFormulaCard(
          context,
          title: 'Dimensionless Hubble Parameter',
          icon: '🌌',
          info: 'E(z) describes how the expansion rate of the universe (the Hubble parameter) changes with redshift, normalized to its value today.',
          formula: r'E(z) = \sqrt{ \Omega_R(1+z)^4 + \Omega_M(1+z)^3 + \Omega_k(1+z)^2 + \Omega_\Lambda }',
        ),
        _buildFormulaCard(
          context,
          title: 'Age of the Universe',
          icon: '⏳',
          info: 'The time elapsed from the Big Bang to today (z=0), calculated by integrating the inverse of the expansion rate over all of history.',
          formula: r't_0 = \frac{1}{H_0} \int_0^\infty \frac{dz}{(1+z)E(z)}',
        ),
        _buildFormulaCard(
          context,
          title: 'Lookback Time',
          icon: '👀',
          info: 'The amount of time light has been traveling from a distant object to us. It is the difference between the present age and the age at redshift z.',
          formula: r't_L = t_0 - t(z)',
        ),
        _buildFormulaCard(
          context,
          title: 'Lookback Time Distance',
          icon: '⏱️',
          info: """This is the distance light travels during the lookback time, i.e., the time elapsed between the emission of light from a distant object and its reception by an observer on Earth.""",
          formula: r'D_{ltt} = c \times (t_0 - t_{em})',
        ),
        _buildFormulaCard(
          context,
          title: 'Comoving Distance (Transverse)',
          icon: '📏',
          info: 'The comoving distance at a fixed redshift z. For a non-flat universe (where Ωₖ ≠ 0), this can differ from the line-of-sight distance.',
          formula: r'D_M = \begin{cases} D_H \frac{1}{\sqrt{\Omega_k}} \sinh(\sqrt{\Omega_k} \frac{D_C}{D_H}) & \text{if } \Omega_k > 0 \\ D_C & \text{if } \Omega_k = 0 \\ D_H \frac{1}{\sqrt{|\Omega_k|}} \sin(\sqrt{|\Omega_k|} \frac{D_C}{D_H}) & \text{if } \Omega_k < 0 \end{cases}',
        ),
        _buildFormulaCard(
          context,
          title: 'Angular Diameter Distance',
          icon: '📐',
          info: 'A distance measure used to relate an object\'s physical size to its apparent angular size in the sky. It peaks at a certain redshift and then decreases.',
          formula: r'D_A = \frac{D_M}{1+z}',
        ),
        _buildFormulaCard(
          context,
          title: 'Luminosity Distance',
          icon: '💡',
          info: 'A distance measure used to relate an object\'s intrinsic brightness (luminosity) to its apparent brightness (flux).',
          formula: r'D_L = D_M(1+z)',
        ),
        _buildFormulaCard(
          context,
          title: 'Angular Scale',
          icon: '✨',
          info: 'The physical scale (in kiloparsecs) that corresponds to one arcsecond of angular size on the sky at a given redshift.',
          formula: r'\text{Scale} = \frac{D_A \times 1000}{206265} \quad (\text{kpc}/\text{arcsec})',
        ),
        _buildFormulaCard(
          context,
          title: 'Comoving Volume',
          icon: '🗺️',
          info: 'The total comoving volume of the universe out to a given redshift z. The formula depends on the curvature of space.',
          formula: r'V_C \approx \frac{4}{3}\pi D_M^3 \quad (\text{for nearly flat space})',
        ),
        _buildFormulaCard(
          context,
          title: 'CMB Temperature',
          icon: '🌡️',
          info: 'The temperature of the Cosmic Microwave Background radiation scales linearly with redshift.',
          formula: r'T(z) = T_0 (1+z)',
        ),
      ],
    );
  }

  // Helper widget using OpenContainer for the "expanding page" animation.
  Widget _buildFormulaCard(
    BuildContext context, {
    required String title,
    required String icon,
    required String info,
    required String formula
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    // Choose colors based on the current theme.
    final cardColor = isDarkMode ? const Color(0xFF161B22) : Colors.white;
    final formulaTextColor = isDarkMode ? Colors.cyanAccent : const Color(0xFF673AB7);
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final infoTextColor = isDarkMode ? Colors.white70 : Colors.black54;
    final popUpBgColor = isDarkMode ? const Color(0xFF0D1117) : theme.scaffoldBackgroundColor;
    final secondaryTextColor = isDarkMode ? Colors.blueAccent : const Color(0xFF673AB7);

    const closedBorderRadius = BorderRadius.all(Radius.circular(16));

    return OpenContainer(
      transitionType: ContainerTransitionType.fadeThrough, // A very smooth and professional transition
      transitionDuration: const Duration(milliseconds: 450),
      closedElevation: 4.0,
      openElevation: 0.0,
      closedShape: const RoundedRectangleBorder(borderRadius: closedBorderRadius),
      openShape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      closedColor: cardColor,
      openColor: popUpBgColor,

      // The "closed" widget: our clickable card.
      closedBuilder: (context, action) {
        return InkWell(
          onTap: action, // This function triggers the animation
          borderRadius: closedBorderRadius,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor))),
                    const SizedBox(width: 8),
                    Text(icon, style: const TextStyle(fontSize: 24)),
                  ],
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Math.tex(formula, mathStyle: MathStyle.display, textStyle: TextStyle(fontSize: 20, color: formulaTextColor)),
                ),
              ],
            ),
          ),
        );
      },

      // THE FIX: The "open" widget is now a custom-built, stable page layout.
      openBuilder: (context, action) {
        return Container(
          color: popUpBgColor,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. A custom "app bar" that won't cause rendering errors.
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Row(
                    children: [
                      const Spacer(), // Pushes the close button to the right
                      IconButton(
                        icon: Icon(Icons.close, color: textColor),
                        onPressed: action, // The 'action' function closes the page
                      ),
                    ],
                  ),
                ),
                // 2. The scrollable content for the page.
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    children: [
                      Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor)),
                      const SizedBox(height: 24),
                      Text("Formula", style: TextStyle(fontSize: 16, color: secondaryTextColor, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Math.tex(formula, mathStyle: MathStyle.display, textStyle: TextStyle(fontSize: 24, color: formulaTextColor)),
                      ),
                      const Divider(height: 48),
                      Text("Definition", style: TextStyle(fontSize: 16, color: secondaryTextColor, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(info, style: TextStyle(fontSize: 18, color: infoTextColor, height: 1.5)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}