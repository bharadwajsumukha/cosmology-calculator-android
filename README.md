# Cosmology Calculator App

A sophisticated Flutter-based cosmological calculator that implements the Friedmann–Lemaître–Robertson–Walker (FLRW) metric for precision calculations in the ΛCDM model. This app provides professional-grade cosmological computations with an intuitive interface for researchers, students, and astronomy enthusiasts.

## Features

### 🧮 Comprehensive Calculations

* **Age of the Universe** – Present age and age at any redshift
* **Distance Measures** – Comoving, angular diameter, and luminosity distances
* **Time Calculations** – Lookback time and light travel time
* **Volume Computations** – Comoving volume within any redshift
* **CMB Temperature** – Cosmic Microwave Background temperature scaling
* **Angular Scale** – Physical scale per arcsecond at any redshift

### 🌌 Universe Models

* **Flat ΛCDM** – Standard cosmological model (Ωₖ = 0)
* **Open Universe** – Negatively curved spacetime (Ωₖ > 0)
* **General Model** – User-defined curvature parameters
* **Einstein–de Sitter** – Matter-dominated universe comparison
* **Empty Universe** – Vacuum-dominated model for reference

### 📊 Interactive Visualizations

* Real-time redshift vs. age graphs
* Multiple universe model comparisons
* Smooth animations and transitions
* Responsive design for all screen sizes

### 📖 Educational Resources

* Complete LaTeX formula display
* Interactive formula explanations
* Physical interpretations for each parameter
* Professional mathematical rendering

---

# Technical Implementation

## High-Precision Numerics

* Adaptive Simpson's rule integration (30,000 steps)
* Extended redshift limits (z → 15,000) for convergence
* Proper handling of curved spacetime geometries
* Benchmark-validated against standard cosmology calculators

---

# Core Physics

The calculator implements the standard $\Lambda$CDM cosmological framework.

### Dimensionless Hubble Parameter

$$
E(z) = \sqrt{\Omega_r(1+z)^4 + \Omega_m(1+z)^3 + \Omega_k(1+z)^2 + \Omega_\Lambda}
$$

### Age of the Universe

$$
t_0 = \frac{1}{H_0} \int_0^{\infty} \frac{dz'}{(1+z')E(z')}
$$

### Comoving Distance

$$
D_c = D_H \int_0^z \frac{dz'}{E(z')}
$$

where

$$
D_H = \frac{c}{H_0}
$$

### Curvature Effects

Proper transverse distances are computed using the standard curvature-dependent relations for $\Omega_k \neq 0$.

---

# Architecture

* **Flutter Framework** – Cross-platform mobile, web, and desktop support
* **Provider Pattern** – Reactive state management
* **Modular Design** – Separated logic, UI, and data layers
* **Comprehensive Testing** – Unit tests with benchmark validation

---

# Accuracy & Validation

The calculator has been rigorously tested against standard cosmological benchmarks:

| Parameter                       | Standard Value | App Output | Accuracy |
| ------------------------------- | -------------- | ---------- | -------- |
| Present Age (Gyr)               | 13.791         | 13.819     | 99.8%    |
| Comoving Distance @ z=1 (Mpc)   | 3401.0         | 3401.3     | 99.99%   |
| Angular Diameter Distance (Mpc) | 1700.5         | 1700.6     | 99.99%   |
| Lookback Time (Gyr)             | 7.950          | 7.970      | 99.7%    |

---

# Download Android App

You can directly download the Android application from the GitHub release:

[https://github.com/bharadwajsumukha/cosmology-calculator-android/releases](https://github.com/bharadwajsumukha/cosmology-calculator-android/releases)

Install the APK on your Android device and start using the cosmology calculator.

---

# Usage Guide

1. Input Parameters – Enter cosmological parameters (H₀, Ωₘ, ΩΛ, etc.)
2. Select Model – Choose between Flat, Open, or General universe
3. Set Redshift – Specify the target redshift for calculations
4. Submit – Generate comprehensive results and visualizations
5. Explore – View interactive graphs and detailed formulas

---

# Dependencies

* flutter_math_fork – LaTeX rendering
* fl_chart – Interactive graphing
* provider – State management
* animations – Smooth UI transitions
* get_it – Dependency injection

---

# Educational Impact

This calculator serves as both a research tool and educational resource, making advanced cosmological calculations accessible to:

* Students learning cosmology
* Researchers needing quick cosmological calculations
* Educators teaching modern cosmology
* Amateur astronomers exploring the universe

---

# Future Enhancements

* Extended Models – Dark energy equation-of-state variations
* Data Export – CSV/JSON output for external analysis
* Parameter Fitting – Observational data integration
* Advanced Plotting – 3D visualizations and parameter-space exploration

---

**Built with precision for the cosmos** 🌌
*Bringing professional cosmological calculations to everyone's fingertips*

