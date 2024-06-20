# Propeller-Design-Optimizer
Propeller Design Optimizer

This program is designed to produce the propeller design with the highest efficiency. It tests all combinations of geometric twist and chord length across the given paramter space. An example would be testing 500 different angles of attack from -45-90 deg and 200 different chord lengths from 0.01m to 0.1m. The expected design fluid velocity range and RPM of the propeller have to be put in along with the ranges of AoA and chord length. It then has the capability to determine what the ACTUAL RPM would be at a given thrust, fluid velocity, or motor power**. It also has the capability to visually represent the Thrust, Efficiency, and Motor Power across ANY fluid speed and RPM in order to determine the best conditions for a given design requirement.

This was created for purpose of entering a propeller into RCTestFlight's Propeller competition, Season 1. Link: https://www.rctestflight.com/propeller-competition




**By motor power, I'm referring to the useful power that actually gets imparted into the propeller, not the amount of power put into the motor itself. Motor efficiency has to be taken into account.
