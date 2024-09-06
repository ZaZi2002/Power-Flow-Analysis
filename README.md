# Power Flow Analysis Project

This project is for Energy Systems Analysis 1 and performs power flow analysis on an electrical grid using various scenarios and constraints. The analysis includes checking voltage and line power flow limits, handling N-1 contingency cases, and improving system conditions to eliminate violations.

## Requirements

- MATLAB or Octave
- MATPOWER Toolbox

## Files and Structure

- **PowerFlowAnalysis.m**: Main script for power flow analysis.
- **Part2_violations.txt**: Text file generated during the N-1 contingency analysis, storing voltage and line flow violations.
- **Part3_violations.txt**: Text file generated during the N-1 contingency analysis with system improvements, storing violations.

## Power Flow Analysis Without Limits

The script performs power flow analysis on the system without considering voltage or line flow limits. Results are presented in tables and include the following parameters:
- Bus voltages (amplitude and phase)
- Generator active and reactive powers
- Branch active, reactive, and apparent powers

### Output

- Voltage violations: Checks if bus voltages exceed max/min limits (1.05/0.95 p.u.)
- Line power flow violations: Checks if line power flow exceeds the branch limits

## Power Flow Analysis with Limits and Improvements

The system is modified to eliminate voltage and power flow violations by adjusting generator outputs and bus voltages. The new power flow analysis shows improved results without violations.

### Output

- Voltage violations and line flow violations are checked and displayed.
- System improvements are applied manually by modifying generator powers and bus voltages.

## N-1 Contingency Analysis

The N-1 contingency analysis simulates the failure of each branch individually, running a new power flow analysis each time.

### Output

- Voltage and line flow violations are displayed and written to `Part2_violations.txt`.

## N-1 Analysis with System Improvements

This analysis repeats the N-1 analysis after applying improvements to the system (e.g., adding shunt and series capacitance or adjusting generator outputs).

### Output

- Voltage and line flow violations are written to `Part3_violations.txt` for each case where a branch is removed.

## System Parameter Functions

- **firstCase(a1, a2, a3, a4)**: Initializes the system for analysis with the initial configuration.
- **secondCase(a1, a2, a3, a4, V1, V2, V3, P2, P3)**: Configures the system with modified voltages and generator outputs.
- **thirdCase(a1, a2, a3, a4, V1, V2, V3, P2, P3, B, G)**: Adds shunt and series capacitance to the system for enhanced analysis.

## How to Run

1. Set the parameters in the script (such as `a1`, `a2`, `a3`, `a4`).
2. Run each part sequentially in MATLAB/Octave to perform the power flow analysis.
3. The analysis results will be displayed in tables, and violations will be logged in the output files.
4. Adjust system parameters to improve performance and rerun the analysis.

## License

This project is licensed under the MIT License.
