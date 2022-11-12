# 16-point-Hdmd-Tx

# Hadamard Transform
Hadamard transform is non-sinusoidal, orthogonal transformation techniques. A signal is composed of basic functions like harmonics in Fourier Transform.This signal can be divided using these fast transforms. In contrast to the Fourier transform, which uses Nlog2N multiplication and addition and is faster, Hadamard Transform uses Nlog2N addition or subtraction.

The advantage of the discrete Hadamard transform is that it only requires 1 & -1 during the transformation procedure. This results in an increase in performance but also avoids multiplication, which significantly lowers the hardware requirement.

# Design using open source silicon kit

Open Source Digital ASIC Design requires three open-source components:  
- **RTL Designs** = github.com, librecores.org, opencores.org
- **EDA Tools** = OpenROAD, OpenLANE,QFlow  
- **PDK** = Google + Skywater 130nm Production PDK

Design has been carried out using Skywater 130nm PDK using openLANE and caravel open source silicon development tools,

![openlane flow](https://user-images.githubusercontent.com/106398260/200923562-10258199-deb3-4f2c-9889-5fffb18edf0b.jpg)

# Theory

A 2-point Hadamard matrix is represented as,

![image](https://user-images.githubusercontent.com/106398260/200916745-71ffaf15-d4e9-40d0-8fa0-6eded2f11194.png)

Recursive property of Hadamard matrix allows us to easily generate its M order matrices

![image](https://user-images.githubusercontent.com/106398260/200917431-a13524f4-af09-47cd-a95f-fff0f045cb7a.png)

4-point DHT (Discrete Hadamard Transform) can be instantiated using 2-point DHT and stages can be divided,

![ex2](https://user-images.githubusercontent.com/106398260/200920895-18d07759-c20d-4b66-8080-383a4cef58e2.png)


Similarly 16-point DHT,

![butterfly 16 point Hdmd Tx](https://user-images.githubusercontent.com/106398260/200912744-7210721f-9a68-4bdb-93bc-4dfb3b3bcfa9.png)

Circuit is developed in Verilog HDL using instantiation of 2,4,8 point DHTs which in turn uses adder/subtractor


![image](https://user-images.githubusercontent.com/106398260/200922435-9a479b2f-748f-42b0-9478-5169eeeafcb6.png)

# Results and Reports

Verilog HDL RTL simulation Waveforms


![combined 6](https://user-images.githubusercontent.com/106398260/200920074-1722c314-1fa6-46ec-a4ef-a6d89479d32e.png)


Reports, 

Synthesis Report -


![syn rpt](https://user-images.githubusercontent.com/106398260/200923842-4dde56d9-3eed-429c-997d-70986c9dec91.png)

Power Report -


![power rpt](https://user-images.githubusercontent.com/106398260/200923932-fef7b6c7-7fd3-40da-8c33-72353d239319.png)

Congestion report - 


![cong rpt](https://user-images.githubusercontent.com/106398260/200924171-cf73b80b-f087-4f61-8078-bd7ffb73d837.png)

OpenLANE Flow,

![combined 2](https://user-images.githubusercontent.com/106398260/200921075-787d82c2-355f-4c4f-9a3c-17ec11989529.png)

Caravel and OpenLANE reports for manufacturability,

![image](https://user-images.githubusercontent.com/106398260/200925271-fc4c2061-1067-4e88-a349-576d4a2f9d24.png)

# Resources

- [SkyWater Open PDK](https://github.com/google/skywater-pdk)
- [OpenLane RTL2GDS Compiler](https://github.com/efabless/openlane)
- [Caravel Harness](https://github.com/efabless/caravel)
- [Caravel User Project](https://github.com/efabless/caravel_user_project)
- [Open MPW Precheck](https://github.com/efabless/open_mpw_precheck)



# Caravel User Project

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) [![UPRJ_CI](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml) [![Caravel Build](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml)

| :exclamation: Important Note            |
|-----------------------------------------|

## Please fill in your project documentation in this README.md file 

Refer to [README](docs/source/index.rst#section-quickstart) for a quickstart of how to use caravel_user_project

Refer to [README](docs/source/index.rst) for this sample project documentation. 


# Caravel User Project

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) [![UPRJ_CI](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml) [![Caravel Build](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml)

| :exclamation: Important Note            |
|-----------------------------------------|

## Please fill in your project documentation in this README.md file 

Refer to [README](docs/source/index.rst#section-quickstart) for a quickstart of how to use caravel_user_project

Refer to [README](docs/source/index.rst) for this sample project documentation. 
