clc
clear all

% AMIRHOSSEIN ZAHEDI 99101705
% MELIKA KORDEMIL 400101786
% EESA PROJECT
% SPRING OF 1403
% MATPOWER

a1 = 5.5;
a2 = 4;
a3 = 7;
a4 = 1;

%% PART 1-1 -> POWER FLOW ANALYSIS WITHOUT LIMITS
clc

%%%%% Analysis %%%%%
mpc_1 = firstCase(a1,a2,a3,a4);
results_1 = runpf(mpc_1);

%%%%% Finding system's parameters %%%%%
Buses_Vm_normal = results_1.bus(:,8);                                   % Buses voltage amplitude
Buses_Vp_normal = results_1.bus(:,9);                                   % Buses voltage phase

Generators_P_normal = results_1.gen(:,2);                               % Generators active power
Generators_Q_normal = results_1.gen(:,3);                               % Generators reactive power

Branches_P_normal = max(abs(results_1.branch(:,14)),abs(results_1.branch(:,16)));   % Branches active power
Branches_Q_normal = max(abs(results_1.branch(:,15)),abs(results_1.branch(:,17)));   % Branches reactive power
Branches_S_normal = sqrt(Branches_P_normal.^2 + Branches_Q_normal.^2);  % Branches apparent  power


%%%%% Tables %%%%%
% Buses voltage amplitude and phase
fig1 = uifigure;
uitable(fig1,'Data', [Buses_Vm_normal,Buses_Vp_normal], ...
    'ColumnName', {'Buses Voltage Amplitude (p.u.)','Buses Voltage Phase (Degree)'}, ...
    'RowName', {results_1.bus(:,1)});

% Generators powers
fig2 = uifigure;
uitable(fig2,'Data', [Generators_P_normal,Generators_Q_normal], ...
    'ColumnName', {'Generators Active Power (MW)','Generators Reactive Power (MVAR)'}, ...
    'RowName', {results_1.gen(:,1)});

% Branches powers
fig3 = uifigure;
uitable(fig3,'Data', [int32(results_1.branch(:,1)),int32(results_1.branch(:,2)),Branches_P_normal,Branches_Q_normal,Branches_S_normal], ...
    'ColumnName', {'From Bus','To Bus','Branches Active Power (MW)','Branches Reactive Power (MVAR)','Branches Apparent Power (MVA)'});


%%%%% Checking limitations %%%%%
% Voltage limitations
Buses_Vm_max = results_1.bus(:,12);     % Max of voltage -> 1.05
Buses_Vm_min = results_1.bus(:,13);     % Min of voltage -> 1.05

voltage_violations = (Buses_Vm_normal > Buses_Vm_max) | (Buses_Vm_normal < Buses_Vm_min);

if any(voltage_violations)
    disp('Voltage violation on bus:');
    disp(find(voltage_violations));
else
    disp('No voltage violations.');
end

% Branch flow limitations
Branches_S_max = results_1.branch(:,6); % Max of powers of each branch

line_violations = (Branches_S_normal > Branches_S_max);

% Display results
if any(line_violations)
    disp('Power violation on branch:');
    index = find(line_violations);
    for i = 1:size(index,1)
        fprintf('%d to %d\n', results_1.branch(index(i),1), results_1.branch(index(i),2))
    end
else
    disp('No line violations.');
end


%% PART 1-2 -> POWER FLOW ANALYSIS WITH LIMITS AND IMPROVEMENTS
% In this part we change  in order to clear violations of limits.
clc

%%%%% Finding solution (Calculation) %%%%%
% counter = 0;
% for V1 = 0.96:0.02:1.04
%     for V2 = 0.96:0.02:1.04
%         for V3 = 0.96:0.02:1.04
%             for P2 = 20:20:120
%                 for P3 = 20:20:120
%                     clc
%                     counter = counter+1;
%                     error = 2;
%                     %%%%% Analysis %%%%%
%                     mpc_2 = secondCase(a1,a2,a3,a4,V1,V2,V3,P2,P3);
%                     results_2 = runpf(mpc_2);
% 
%                     %%%%% Finding system's parameters %%%%%
%                     Buses_Vm_normal = results_2.bus(:,8);   % Buses voltage amplitude
% 
%                     Branches_P_normal = max(abs(results_2.branch(:,14)),abs(results_2.branch(:,16)));   % Branches active power
%                     Branches_Q_normal = max(abs(results_2.branch(:,15)),abs(results_2.branch(:,17)));   % Branches reactive power
%                     Branches_S_normal = sqrt(Branches_P_normal.^2 + Branches_Q_normal.^2);  % Branches apparent  power
% 
%                     %%%%% Checking limitations %%%%%
%                     % Voltage limitations
%                     Buses_Vm_max = results_2.bus(:,12);     % Max of voltage -> 1.05
%                     Buses_Vm_min = results_2.bus(:,13);     % Min of voltage -> 1.05
% 
%                     voltage_violations = (Buses_Vm_normal > Buses_Vm_max) | (Buses_Vm_normal < Buses_Vm_min);
% 
%                     if any(voltage_violations)
%                         disp('Voltage violation on bus:');
%                         disp(find(voltage_violations));
%                     else
%                         disp('No voltage violations.');
%                         error = error - 1;
%                     end
% 
%                     % Branch flow limitations
%                     Branches_S_max = results_2.branch(:,6); % Max of powers of each branch
% 
%                     line_violations = (Branches_S_normal > Branches_S_max);
% 
%                     % Display results
%                     if any(line_violations)
%                         disp('Power violation on branch:');
%                         index = find(line_violations);
%                         for i = 1:size(index,1)
%                             fprintf('%d to %d\n', results_2.branch(index(i),1), results_2.branch(index(i),2))
%                         end
%                     else
%                         disp('No line violations.');
%                         error = error - 1;
%                     end
% 
%                     if error == 0
%                         break;
%                     end
%                 end
%                 if error == 0
%                         break;
%                 end
%             end
%             if error == 0
%                         break;
%             end
%         end
%         if error == 0
%                         break;
%         end
%     end
%     if error == 0
%                         break;
%     end
% end
% 

%%%%% Finding solution (manual) %%%%%
V1 = 1.04;      % Voltage of bus 1
V2 = 1.005;     % Voltage of bus 2     
V3 = 1.00;      % Voltage of bus 3
P2 = 50;        % Power of gen 2
P3 = 60;        % Power of gen 3

mpc_2 = secondCase(a1,a2,a3,a4,V1,V2,V3,P2,P3);
results_2 = runpf(mpc_2);

%%%%% Finding system's parameters %%%%%
Buses_Vm_normal = results_2.bus(:,8);                                   % Buses voltage amplitude
Buses_Vp_normal = results_2.bus(:,9);                                   % Buses voltage phase

Generators_P_normal = results_2.gen(:,2);                               % Generators active power
Generators_Q_normal = results_2.gen(:,3);                               % Generators reactive power

Branches_P_normal = max(abs(results_2.branch(:,14)),abs(results_2.branch(:,16)));   % Branches active power
Branches_Q_normal = max(abs(results_2.branch(:,15)),abs(results_2.branch(:,17)));   % Branches reactive power
Branches_S_normal = sqrt(Branches_P_normal.^2 + Branches_Q_normal.^2);  % Branches apparent  power


%%%%% Tables %%%%%
% Buses voltage amplitude and phase
fig1 = uifigure;
uitable(fig1,'Data', [Buses_Vm_normal,Buses_Vp_normal], ...
    'ColumnName', {'Buses Voltage Amplitude (p.u.)','Buses Voltage Phase (Degree)'}, ...
    'RowName', {results_2.bus(:,1)});

% Generators powers
fig2 = uifigure;
uitable(fig2,'Data', [Generators_P_normal,Generators_Q_normal], ...
    'ColumnName', {'Generators Active Power (MW)','Generators Reactive Power (MVAR)'}, ...
    'RowName', {results_2.gen(:,1)});

% Branches powers
fig3 = uifigure;
uitable(fig3,'Data', [int32(results_2.branch(:,1)),int32(results_2.branch(:,2)),Branches_P_normal,Branches_Q_normal,Branches_S_normal], ...
    'ColumnName', {'From Bus','To Bus','Branches Active Power (MW)','Branches Reactive Power (MVAR)','Branches Apparent Power (MVA)'});


%%%%% Checking limitations %%%%%
% Voltage limitations
Buses_Vm_max = results_2.bus(:,12);     % Max of voltage -> 1.05
Buses_Vm_min = results_2.bus(:,13);     % Min of voltage -> 1.05

voltage_violations = (Buses_Vm_normal > Buses_Vm_max) | (Buses_Vm_normal < Buses_Vm_min);

if any(voltage_violations)
    disp('Voltage violation on bus:');
    disp(find(voltage_violations));
else
    disp('No voltage violations.');
end

% Branch flow limitations
Branches_S_max = results_2.branch(:,6); % Max of powers of each branch

line_violations = (Branches_S_normal > Branches_S_max);

% Display results
if any(line_violations)
    disp('Power violation on branch:');
    index = find(line_violations);
    for i = 1:size(index,1)
        fprintf('%d to %d\n', results_2.branch(index(i),1), results_2.branch(index(i),2))
    end
else
    disp('No line violations.');
end


%% PART 2 -> POWER FLOW ANALYSIS WITH N-1
clc

% Opening a text file for writing violations
textFile = fopen('Part2_violations.txt', 'w');

% N-1 analysis
for i = 1:size(mpc_2.branch, 1)

    %%%%% Deleting a branch %%%%%
    mpc_deleted = mpc_2;
    mpc_deleted.branch(i,:) = [];       % Deleting branch i
    results_deleted = runpf(mpc_deleted);

    %%%%% Finding system's parameters %%%%%
    Buses_Vm_normal = results_deleted.bus(:,8);         % Buses voltage amplitude
    
    Branches_P_normal = max(abs(results_deleted.branch(:,14)),abs(results_deleted.branch(:,16)));   % Branches active power
    Branches_Q_normal = max(abs(results_deleted.branch(:,15)),abs(results_deleted.branch(:,17)));   % Branches reactive power
    Branches_S_normal = sqrt(Branches_P_normal.^2 + Branches_Q_normal.^2);  % Branches apparent  power
    

    %%%%% Checking limitations %%%%%
    fprintf('%d to %d branch is deleted ---------->\n', results_2.branch(i,1), results_2.branch(i,2))
    fprintf(textFile, '\n\n%d to %d branch is deleted ---------->\n', results_2.branch(i,1), results_2.branch(i,2));

    % Voltage limitations
    Buses_Vm_max = results_deleted.bus(:,12);     % Max of voltage -> 1.05
    Buses_Vm_min = results_deleted.bus(:,13);     % Min of voltage -> 1.05
    
    voltage_violations = (Buses_Vm_normal > Buses_Vm_max) | (Buses_Vm_normal < Buses_Vm_min);
    
    if any(voltage_violations)
        disp('Voltage violation on bus:');
        disp(find(voltage_violations));
        fprintf(textFile,'Voltage violation on bus:\n');
        fprintf(textFile,'%d\n',find(voltage_violations));
    else
        disp('No voltage violations.');
        fprintf(textFile,'No voltage violations.\n');
    end
    

    % Branch flow limitations
    Branches_S_max = results_deleted.branch(:,6); % Max of powers of each branch
    
    line_violations = (Branches_S_normal > Branches_S_max);
    
    % Display results
    if any(line_violations)
        disp('Power violation on branch:');
        fprintf(textFile,'Power violation on branch:\n');
        index = find(line_violations);
        for i = 1:size(index,1)
            fprintf('%d to %d\n', results_deleted.branch(index(i),1), results_deleted.branch(index(i),2));
            fprintf(textFile,'%d to %d\n', results_deleted.branch(index(i),1), results_deleted.branch(index(i),2));
        end
    else
        disp('No line violations.');
        fprintf(textFile,'No line violations.');
    end

end


%% PART 3 (EXTRA) -> POWER FLOW ANALYSIS WITH N-1 AND IMPROVEMENTS FOR LIMITS
clc

%%%%% Finding solution (manual) %%%%%
V1 = 1.04;      % Voltage of bus 1
V2 = 1.005;     % Voltage of bus 2     
V3 = 1.00;      % Voltage of bus 3
P2 = 50;        % Power of gen 2
P3 = 60;        % Power of gen 3
B = [0,0,0,-0.1,0.1,0];      % Shunt capacitance or reactance of buses
G = [0,0,0,0,0,0.05];      % Series capacitance or reactance of buses


mpc_3 = thirdCase(a1,a2,a3,a4,V1,V2,V3,P2,P3,B,G);
results_3 = runpf(mpc_2);

%%%%% Finding system's parameters %%%%%
Buses_Vm_normal = results_3.bus(:,8);                                   % Buses voltage amplitude
Buses_Vp_normal = results_3.bus(:,9);                                   % Buses voltage phase

Generators_P_normal = results_3.gen(:,2);                               % Generators active power
Generators_Q_normal = results_3.gen(:,3);                               % Generators reactive power

Branches_P_normal = max(abs(results_3.branch(:,14)),abs(results_3.branch(:,16)));   % Branches active power
Branches_Q_normal = max(abs(results_3.branch(:,15)),abs(results_3.branch(:,17)));   % Branches reactive power
Branches_S_normal = sqrt(Branches_P_normal.^2 + Branches_Q_normal.^2);  % Branches apparent  power


% %%%%% Tables %%%%%
% % Buses voltage amplitude and phase
% fig1 = uifigure;
% uitable(fig1,'Data', [Buses_Vm_normal,Buses_Vp_normal], ...
%     'ColumnName', {'Buses Voltage Amplitude (p.u.)','Buses Voltage Phase (Degree)'}, ...
%     'RowName', {results_3.bus(:,1)});
% 
% % Generators powers
% fig2 = uifigure;
% uitable(fig2,'Data', [Generators_P_normal,Generators_Q_normal], ...
%     'ColumnName', {'Generators Active Power (MW)','Generators Reactive Power (MVAR)'}, ...
%     'RowName', {results_3.gen(:,1)});
% 
% % Branches powers
% fig3 = uifigure;
% uitable(fig3,'Data', [int32(results_3.branch(:,1)),int32(results_3.branch(:,2)),Branches_P_normal,Branches_Q_normal,Branches_S_normal], ...
%     'ColumnName', {'From Bus','To Bus','Branches Active Power (MW)','Branches Reactive Power (MVAR)','Branches Apparent Power (MVA)'});


%%%%% Checking limitations %%%%%
% Voltage limitations
Buses_Vm_max = results_3.bus(:,12);     % Max of voltage -> 1.05
Buses_Vm_min = results_3.bus(:,13);     % Min of voltage -> 1.05

voltage_violations = (Buses_Vm_normal > Buses_Vm_max) | (Buses_Vm_normal < Buses_Vm_min);

if any(voltage_violations)
    disp('Voltage violation on bus:');
    disp(find(voltage_violations));
else
    disp('No voltage violations.');
end

% Branch flow limitations
Branches_S_max = results_3.branch(:,6); % Max of powers of each branch

line_violations = (Branches_S_normal > Branches_S_max);

% Display results
if any(line_violations)
    disp('Power violation on branch:');
    index = find(line_violations);
    for i = 1:size(index,1)
        fprintf('%d to %d\n', results_3.branch(index(i),1), results_3.branch(index(i),2))
    end
else
    disp('No line violations.');
end



% Opening a text file for writing violations
textFile = fopen('Part3_violations.txt', 'w');

% N-1 analysis
for i = 1:size(mpc_3.branch, 1)

    %%%%% Deleting a branch %%%%%
    mpc_deleted = mpc_3;
    mpc_deleted.branch(i,:) = [];       % Deleting branch i
    results_deleted = runpf(mpc_deleted);

    %%%%% Finding system's parameters %%%%%
    Buses_Vm_normal = results_deleted.bus(:,8);         % Buses voltage amplitude
    Buses_Vp_normal = results_deleted.bus(:,9);         % Buses voltage phase
    
    Generators_P_normal = results_deleted.gen(:,2);     % Generators active power
    Generators_Q_normal = results_deleted.gen(:,3);     % Generators reactive power
    
    Branches_P_normal = max(abs(results_deleted.branch(:,14)),abs(results_deleted.branch(:,16)));   % Branches active power
    Branches_Q_normal = max(abs(results_deleted.branch(:,15)),abs(results_deleted.branch(:,17)));   % Branches reactive power
    Branches_S_normal = sqrt(Branches_P_normal.^2 + Branches_Q_normal.^2);  % Branches apparent  power
    

    %%%%% Checking limitations %%%%%
    fprintf('%d to %d branch is deleted ---------->\n', results_3.branch(i,1), results_3.branch(i,2))
    fprintf(textFile, '\n\n%d to %d branch is deleted ---------->\n', results_3.branch(i,1), results_3.branch(i,2));

    % Voltage limitations
    Buses_Vm_max = results_deleted.bus(:,12);     % Max of voltage -> 1.05
    Buses_Vm_min = results_deleted.bus(:,13);     % Min of voltage -> 1.05
    
    voltage_violations = (Buses_Vm_normal > Buses_Vm_max) | (Buses_Vm_normal < Buses_Vm_min);
    
    if any(voltage_violations)
        disp('Voltage violation on bus:');
        disp(find(voltage_violations));
        fprintf(textFile,'Voltage violation on bus:\n');
        fprintf(textFile,'%d\n',find(voltage_violations));
    else
        disp('No voltage violations.');
        fprintf(textFile,'No voltage violations.\n');
    end
    

    % Branch flow limitations
    Branches_S_max = results_deleted.branch(:,6); % Max of powers of each branch
    
    line_violations = (Branches_S_normal > Branches_S_max);
    
    % Display results
    if any(line_violations)
        disp('Power violation on branch:');
        fprintf(textFile,'Power violation on branch:\n');
        index = find(line_violations);
        for i = 1:size(index,1)
            fprintf('%d to %d\n', results_deleted.branch(index(i),1), results_deleted.branch(index(i),2));
            fprintf(textFile,'%d to %d\n', results_deleted.branch(index(i),1), results_deleted.branch(index(i),2));
        end
    else
        disp('No line violations.');
        fprintf(textFile,'No line violations.');
    end

end


%% SYSTEM INITIAL PARAMETERS' FUNCTIONS

function mpc = firstCase(a1,a2,a3,a4)
mpc.version = '2';

% %%%%% SYSTEM'S Sb %%%%%
mpc.baseMVA = 100;


% %%%%% BUS MATRIX %%%%%
%   busNumber  type    Pd    Qd          Gs  Bs  area    Vm              Va      baseKV  zone    Vmax    Vmin
mpc.bus = [
    1          3       0     0           0   0   1       1.00            0       230      1      1.05    0.95;
    2          2       0     0           0   0   1       (105-a4)/100    0       230      1      1.05    0.95;
    3          2       0     0           0   0   1       (105-a4)/100    0       230      1      1.05    0.95;
    4          1       70    (70-5*a1)   0   0   1       1.00            0       230      1      1.05    0.95;
    5          1       70    (70-5*a2)   0   0   1       1.00            0       230      1      1.05    0.95;
    6          1       70    (70-5*a3)   0   0   1       1.00            0       230      1      1.05    0.95;
];


% %%%%% GENERATOR MATRIX %%%%%
%   bus     Pg      Qg      Qmax    Qmin    Vg            mBase   status   Pmax    Pmin    Pc1     Pc2     Qc1min  Qc1max  Qc2min  Qc2max  ramp_agc    ramp_10    ramp_30    ramp_q    apf
mpc.gen = [
    1       0       0       100     -100    1.00            100     1       500      0      0       0       0       0       0       0       0           0           0           0       0;
    2       50      0       100     -100    (105-a4)/100    100     1       500      0      0       0       0       0       0       0       0           0           0           0       0;
    3       60      0       100     -100    (105-a4)/100    100     1       500      0      0       0       0       0       0       0       0           0           0           0       0;
];


% %%%%% BRANCH MATRIX %%%%%
%   fbus    tbus    r       x       b       rateA   rateB   rateC   ratio   angle   status  angmin  angmax
mpc.branch = [
    1       2       0.10    0.20    0.04    30      30      30      0       0       1       -360    360;
    1       4       0.05    0.20    0.04    50      50      50      0       0       1       -360    360;
    1       5       0.08    0.30    0.06    40      40      40      0       0       1       -360    360;
    2       3       0.05    0.25    0.06    20      20      20      0       0       1       -360    360;
    2       4       0.05    0.10    0.02    40      40      40      0       0       1       -360    360;
    2       5       0.10    0.30    0.04    20      20      20      0       0       1       -360    360;
    2       6       0.07    0.20    0.05    30      30      30      0       0       1       -360    360;
    3       5       0.12    0.26    0.05    20      20      20      0       0       1       -360    360;
    3       6       0.02    0.10    0.02    60      60      60      0       0       1       -360    360;
    4       5       0.20    0.40    0.08    20      20      20      0       0       1       -360    360;
    5       6       0.10    0.30    0.06    20      20      20      0       0       1       -360    360;
];

end

function mpc = secondCase(a1,a2,a3,a4,V1,V2,V3,P2,P3)
mpc.version = '2';

% %%%%% SYSTEM'S Sb %%%%%
mpc.baseMVA = 100;


% %%%%% BUS MATRIX %%%%%
%   busNumber  type    Pd    Qd          Gs  Bs  area    Vm              Va      baseKV  zone    Vmax    Vmin
mpc.bus = [
    1          3       0     0           0   0   1       V1              0       230      1      1.05    0.95;
    2          2       0     0           0   0   1       V2              0       230      1      1.05    0.95;
    3          2       0     0           0   0   1       V3              0       230      1      1.05    0.95;
    4          1       70    (70-5*a1)   0   0   1       1.00            0       230      1      1.05    0.95;
    5          1       70    (70-5*a2)   0   0   1       1.00            0       230      1      1.05    0.95;
    6          1       70    (70-5*a3)   0   0   1       1.00            0       230      1      1.05    0.95;
];


% %%%%% GENERATOR MATRIX %%%%%
%   bus     Pg      Qg      Qmax    Qmin    Vg            mBase   status   Pmax    Pmin    Pc1     Pc2     Qc1min  Qc1max  Qc2min  Qc2max  ramp_agc    ramp_10    ramp_30    ramp_q    apf
mpc.gen = [
    1       0       0       100     -100    V1              100     1       500      0      0       0       0       0       0       0       0           0           0           0       0;
    2       P2      0       100     -100    V2              100     1       500      0      0       0       0       0       0       0       0           0           0           0       0;
    3       P3      0       100     -100    V3              100     1       500      0      0       0       0       0       0       0       0           0           0           0       0;
];


% %%%%% BRANCH MATRIX %%%%%
%   fbus    tbus    r       x       b       rateA   rateB   rateC   ratio   angle   status  angmin  angmax
mpc.branch = [
    1       2       0.10    0.20    0.04    30      30      30      0       0       1       -360    360;
    1       4       0.05    0.20    0.04    50      50      50      0       0       1       -360    360;
    1       5       0.08    0.30    0.06    40      40      40      0       0       1       -360    360;
    2       3       0.05    0.25    0.06    20      20      20      0       0       1       -360    360;
    2       4       0.05    0.10    0.02    40      40      40      0       0       1       -360    360;
    2       5       0.10    0.30    0.04    20      20      20      0       0       1       -360    360;
    2       6       0.07    0.20    0.05    30      30      30      0       0       1       -360    360;
    3       5       0.12    0.26    0.05    20      20      20      0       0       1       -360    360;
    3       6       0.02    0.10    0.02    60      60      60      0       0       1       -360    360;
    4       5       0.20    0.40    0.08    20      20      20      0       0       1       -360    360;
    5       6       0.10    0.30    0.06    20      20      20      0       0       1       -360    360;
];

end

function mpc = thirdCase(a1,a2,a3,a4,V1,V2,V3,P2,P3,B,G)
mpc.version = '2';

% %%%%% SYSTEM'S Sb %%%%%
mpc.baseMVA = 100;


% %%%%% BUS MATRIX %%%%%
%   busNumber  type    Pd    Qd          Gs     Bs    area    Vm              Va      baseKV  zone    Vmax    Vmin
mpc.bus = [
    1          3       0     0           G(1)   B(1)   1       V1              0       230      1      1.05    0.95;
    2          2       0     0           G(2)   B(2)   1       V2              0       230      1      1.05    0.95;
    3          2       0     0           G(3)   B(3)   1       V3              0       230      1      1.05    0.95;
    4          1       70    (70-5*a1)   G(4)   B(4)   1       1.00            0       230      1      1.05    0.95;
    5          1       70    (70-5*a2)   G(5)   B(5)   1       1.00            0       230      1      1.05    0.95;
    6          1       70    (70-5*a3)   G(6)   B(6)   1       1.00            0       230      1      1.05    0.95;
];


% %%%%% GENERATOR MATRIX %%%%%
%   bus     Pg      Qg      Qmax    Qmin    Vg            mBase   status   Pmax    Pmin    Pc1     Pc2     Qc1min  Qc1max  Qc2min  Qc2max  ramp_agc    ramp_10    ramp_30    ramp_q    apf
mpc.gen = [
    1       0       0       100     -100    V1              100     1       500      0      0       0       0       0       0       0       0           0           0           0       0;
    2       P2      0       100     -100    V2              100     1       500      0      0       0       0       0       0       0       0           0           0           0       0;
    3       P3      0       100     -100    V3              100     1       500      0      0       0       0       0       0       0       0           0           0           0       0;
];


% %%%%% BRANCH MATRIX %%%%%
%   fbus    tbus    r       x       b       rateA   rateB   rateC   ratio   angle   status  angmin  angmax
mpc.branch = [
    1       2       0.10    0.20    0.04    30      30      30      0       0       1       -360    360;
    1       4       0.05    0.20    0.04    50      50      50      0       0       1       -360    360;
    1       5       0.08    0.30    0.06    40      40      40      0       0       1       -360    360;
    2       3       0.05    0.25    0.06    20      20      20      0       0       1       -360    360;
    2       4       0.05    0.10    0.02    40      40      40      0       0       1       -360    360;
    2       5       0.10    0.30    0.04    20      20      20      0       0       1       -360    360;
    2       6       0.07    0.20    0.05    30      30      30      0       0       1       -360    360;
    3       5       0.12    0.26    0.05    20      20      20      0       0       1       -360    360;
    3       6       0.02    0.10    0.02    60      60      60      0       0       1       -360    360;
    4       5       0.20    0.40    0.08    20      20      20      0       0       1       -360    360;
    5       6       0.10    0.30    0.06    20      20      20      0       0       1       -360    360;
];

end