clear, clc
addpath('src')

syms x             %aux variable for distributions
syms EJ EA GJ L k  % geometrical constants
syms W P F q           % loads
syms V H          % external actions variables
vs = [H V];        % collect each external action variable you defined
plvars = [H];       % collect PLV variables


numerical_solution = true;

%%%% DO YOU HAVE EXTERNAL WORKS DIFFERENT FROM ZERO?
override_dWe = false; % true if the external work of any quantity is not 0 
                      % (i.e. springs or imposed structural failures of a given value)
imposed_dWe = [-V/k];      % in case you override dWe then define the value of the external work
                           % if you defined X Y as your av then define a column
                           % vector of [dWe_PLV_X; dWe_PLV_Y]; 
                           % --> for a Spring: dF * F/k
%%%%%

% EQUILIBRIA EQUATIONS - usually not needed
eqbrs = [  V == (P*L + W)/L       
];

% INTERNAL ACTIONS EQUATIONS
actions = [ %attention to spaces!!
    -V 
    x*H

    H
    V*x-W + H*L

    V
    H*(L-x)-P*x-W+V*L
];

% wrt to the previous internal actions define the corresponding stifnesses and the length
% (i.e. if actions(1) is an axial action of a beam of length L then conj_stiffness = EA and conj_length = L)
conj_stiffness = [EA EJ EA EJ EA EJ];
conj_length = [L L L L L L];

% Data: Insert numerical value for every simbolic variable you defined
dati = struct( ...
    'EJ', 1e12, ...
    'EA', 1e6, ...
    'L', 1e3, ...
    'W', 5e4, ...
    'P', 300);

%%%%%%%%%%%%%%%%% SOURCE CODE
NfPCVWsrc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% DISPLACEMENT EVALUATION
syms WW
Dummies = [WW];
numerical_eval = true;

NewActions = [ %attention to spaces!!
    -V-WW
    x*H

    H
    V*x-W + H*L+x*WW

    V+WW
    H*(L-x)-P*x-W+V*L 
];

%%%%%%%%%%%%%%%%% SOURCE CODE
DispEval
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

displacements = subs(displacements, solution)/L;

if numerical_eval
     val = double(subs(displacements, dati))
else
    displacements
end






