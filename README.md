# Propeller-Design-Optimizer
Propeller Design Optimizer

This program is designed to produce the propeller design with the highest efficiency. It tests all combinations of geometric twist and chord length across the given paramter space. An example would be testing 500 different angles of attack from -45-90 deg and 200 different chord lengths from 0.01m to 0.1m. The expected design fluid velocity range and RPM of the propeller have to be put in along with the ranges of AoA and chord length. It then has the capability to determine what the ACTUAL RPM would be at a given thrust, fluid velocity, or motor power**. It also has the capability to visually represent the Thrust, Efficiency, and Motor Power across ANY fluid speed and RPM in order to determine the best conditions for a given design requirement.

This was created for purpose of entering a propeller into RCTestFlight's Propeller competition, Season 1. Link: https://www.rctestflight.com/propeller-competition

To use the program, you either need to create tables for the polar graphs of a certain airfoil, or use the ones already created.
The process to make your own is very tedious and not fun.

To use one already made, just use the command load(_Filename_) to load the CLReMat and CDReMat variables into the workspace (Example: load("NACA6409CL-CD.mat")). The NACA 6409.mat file is a record of the optimal design for the propeller competiton I was entering into.
From there all you need to do is specify the parameters in OpimtimizingPropellers3.m and run it!
To get the optimal design, you need to run FindMaxinEffSum.m right after.

The DetermineAngVel.m program will determine the actual RPM of the motor given a certain motor power or thrust. It will also plot efficiency vs. RPM for a given fluid velocity.

The DetermineAngVelOverManyVWaters.m is the same as the previous program, but it gives you many many more visualization tools. It will plot efficiency and more over a range of fluid speeds and RPMs on a surface plot.

**By motor power, I'm referring to the useful power that actually gets imparted into the propeller, not the amount of power put into the motor itself. Motor efficiency has to be taken into account.
