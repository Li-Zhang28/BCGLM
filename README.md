# BGLMC
Develop
The BGLMC (Bayesian Generalized Linear Model for Compositional Predictors) was developed to address the challenges of analyzing compositional data, and it incorporates a sum-to-zero constraint on the coefficients. This package provides simulation code and analysis code for both continuous and binary outcomes.

# Installation
Please download the packge to your computer and put it in a workpath that your Rstudio can access to it. The codes are developped under R version 4.0.5.

This package includes 2 folders: Continuous and Binary. We introduce each of these as follows.

# Continuous
In this directory, you will find two main files: "simulation" and "analysis".
- The "simulation" file contains the code for data simulation, allowing you to generate synthetic data for testing and validation purposes.

- The "analysis" file contains the analysis code for our proposed method BGLMC (Bayesian Generalized Linear Models with Constraints) specifically designed for continuous response data. This code includes implementations of three different Bayesian methods with distinct prior distributions: hierarchical Normal prior, hierarchical double-exponential prior, and regularized horseshoe prior.

# Binary
In this directory, you will find three main subfolders: "simulation", "analysis" and "data".
- The "simulation" folder contains the code for binay data simulation.

- The "analysis" file contains the analysis code for our proposed method BGLMC (Bayesian Generalized Linear Models with Constraints) specifically designed for binay response data.

- The "data" file contains real data.
