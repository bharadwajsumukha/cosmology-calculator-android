# Cosmology Calculator App

A sophisticated Flutter-based cosmological calculator that implements the Friedmann-Lemaître-Robertson-Walker (FLRW) metric for precision calculations in the ΛCDM model. This app provides professional-grade cosmological computations with an intuitive interface for researchers, students, and astronomy enthusiasts.

## Features

### 🧮 **Comprehensive Calculations**

- **Age of the Universe** - Present age and age at any redshift
- **Distance Measures** - Comoving, angular diameter, and luminosity distances
- **Time Calculations** - Lookback time and light travel time
- **Volume Computations** - Comoving volume within any redshift
- **CMB Temperature** - Cosmic Microwave Background temperature scaling
- **Angular Scale** - Physical scale per arcsecond at any redshift

### 🌌 **Universe Models**

- **Flat ΛCDM** - Standard cosmological model (Ωₖ = 0)
- **Open Universe** - Negatively curved spacetime (Ωₖ > 0)
- **General Model** - User-defined curvature parameters
- **Einstein-de Sitter** - Matter-dominated universe comparison
- **Empty Universe** - Vacuum-dominated model for reference

### 📊 **Interactive Visualizations**

- Real-time redshift vs. age graphs
- Multiple universe model comparisons
- Smooth animations and transitions
- Responsive design for all screen sizes

### 📖 **Educational Resources**

- Complete LaTeX formula display
- Interactive formula explanations
- Physical interpretations for each parameter
- Professional mathematical rendering

## Technical Implementation

### **High-Precision Numerics**

- Adaptive Simpson's rule integration (30,000 steps)
- Extended redshift limits (z → 15,000) for convergence
- Proper handling of curved spacetime geometries
- Benchmark-validated against standard cosmology calculators

### **Core Physics**

The app implements the standard ΛCDM formulations:

- **Hubble Parameter**: E(z) = √[Ωᴿ(1+z)⁴ + Ωₘ(1+z)³ + Ωₖ(1+z)² + Ωᴧ]
- **Age Integration**: t₀ = (1/H₀) ∫₀^∞ dz'/[(1+z')E(z')]
- **Distance Integration**: Dᶜ = Dₕ ∫₀^z dz'/E(z')
- **Curvature Corrections**: Proper transverse distance calculations for Ωₖ ≠ 0

### **Architecture**

- **Flutter Framework** - Cross-platform mobile, web, and desktop support
- **Provider Pattern** - Reactive state management
- **Modular Design** - Separated logic, UI, and data layers
- **Comprehensive Testing** - Unit tests with benchmark validation

## Accuracy & Validation

The calculator has been rigorously tested against standard cosmological benchmarks:

| Parameter                       | Standard Value | App Output | Accuracy |
|---------------------------------|---------------:|-----------:|---------:|
| Present Age (Gyr)               |        13.791  |     13.819 |   99.8%  |
| Comoving Distance @ z=1 (Mpc)   |      3,401.0   |   3,401.3  |  99.99%  |
| Angular Diameter Distance (Mpc) |      1,700.5   |   1,700.6  |  99.99%  |
| Lookback Time (Gyr)             |         7.950  |      7.970 |   99.7%  |

## Installation & Usage

### **Prerequisites**

- Flutter SDK (≥3.0.0)
- Dart SDK
- Android Studio / VS Code (recommended)

### **Setup**

git clone [repository-url]
cd cosmology_calculator
flutter pub get
flutter run


### **Building APK**

flutter build apk --release


The APK will be generated in `build/app/outputs/flutter-apk/app-release.apk`

## Usage Guide

1. **Input Parameters** - Enter cosmological parameters (H₀, Ωₘ, Ωᴧ, etc.)  
2. **Select Model** - Choose between Flat, Open, or General universe  
3. **Set Redshift** - Specify the target redshift for calculations  
4. **Submit** - Generate comprehensive results and visualizations  
5. **Explore** - View interactive graphs and detailed formulas  

## Dependencies

- `flutter_math_fork` - LaTeX rendering
- `fl_chart` - Interactive graphing
- `provider` - State management
- `animations` - Smooth UI transitions
- `get_it` - Dependency injection

## Educational Impact

This calculator serves as both a research tool and educational resource, making advanced cosmological calculations accessible to:

- Graduate students in astrophysics  
- Researchers in observational cosmology  
- Educators teaching modern cosmology  
- Amateur astronomers exploring the universe  

## Future Enhancements

- **Extended Models** - Dark energy equation of state variations  
- **Data Export** - CSV/JSON output for external analysis  
- **Parameter Fitting** - Observational data integration  
- **Advanced Plotting** - 3D visualizations and parameter space exploration  

## Contributing

This project welcomes contributions from the cosmology and Flutter communities. Areas for improvement include:

- Additional cosmological models  
- Enhanced numerical precision  
- UI/UX improvements  
- Educational content expansion  

**Built with precision for the cosmos** 🌌  
*Bringing professional cosmological calculations to everyone's fingertips*  
