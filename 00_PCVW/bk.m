clear, clc
addpath('src')

syms x             %aux variable for distributions
syms EJ EA GJ L k  % geometrical constants
syms F q           % loads
syms V MX MZ           % external actions variables
av = [V MX MZ];          % collect each external action variable you defined

numerical_solution = true;
%%%% DO YOU HAVE EXTERNAL WORKS DIFFERENT FROM ZERO?
override_dWe = false; % true if the external work of any quantity is not 0 
                      % (i.e. springs or imposed structural failures of a given value)

imposed_dWe = [-V/k];     % in case you override dWe then define the value of the external work
                           % if you defined X Y as your av then define a column
                           % vector of [dWe_PLV_X; dWe_PLV_Y]; 
                           % --> for a Spring: dF * F/k
%%%%%

% EQUILIBRIA EQUATIONS - usually not needed
eqbrs = [             
];

% INTERNAL ACTIONS EQUATIONS
actions = [
    % staring from the right:
    % Beam 1 
    MZ + V*x % Mz 
    MX       % Mx

    % Beam 2
    MX - V*x - int(q*x,x)% Mx
    V*L + MZ% Mz
];

% wrt to the previous internal actions define the corresponding stifnesses and the length
% (i.e. if actions(1) is an axial action of a beam of length L then conj_stiffness = EA and conj_length = L)
conj_stiffness = [EJ GJ EJ GJ];
conj_length = [L L L L];

% only for underdetermined problems, where not all equations are needed, 
% can serve as a double check of the correctness of the result
shift = 0; % change only if you want to bruteforce the problem (nice)
           % if changed, change dWe accordingly (nice as well)

% Data: Insert numerical value for every simbolic variable you defined
dati = struct( ...
    'EJ', 1e9, ...
    'GJ', 2*1e9, ...
    'L', 1000, ...
    'q', 0.5);

%%%%%%%%%%%%%%%%% SOURCE CODE
NfPCVWsrc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


