clear, clc
addpath('src')

syms x             %aux variable for distributions
syms EJ EA GJ L k  % geometrical constants
syms W P F q           % loads
syms M H          % external actions variables
vs = [M H];        % collect each external action variable you defined
plvars = [M H];       % collect PLV variables


numerical_solution = true;

%%%% DO YOU HAVE EXTERNAL WORKS DIFFERENT FROM ZERO?
override_dWe = false; % true if the external work of any quantity is not 0 
                      % (i.e. springs or imposed structural failures of a given value)
imposed_dWe = [];     % in case you override dWe then define the value of the external work
                           % if you defined X Y as your av then define a column
                           % vector of [dWe_PLV_X; dWe_PLV_Y]; 
                           % --> for a Spring: dF * F/k
%%%%%

% EQUILIBRIA EQUATIONS - usually not needed
eqbrs = [     
];

% INTERNAL ACTIONS EQUATIONS
actions = [ %attention to spaces!!
    -H
    M + q*x^2/2

    q*L
    H*x + M + q*L*L/2
];

% wrt to the previous internal actions define the corresponding stifnesses and the length
% (i.e. if actions(1) is an axial action of a beam of length L then conj_stiffness = EA and conj_length = L)
conj_stiffness = [EA EJ EA EJ];
conj_length = [L L L L];

% Data: Insert numerical value for every simbolic variable you defined
beta = 0.001;
a = 1e6;
b = 800;

dati = struct( ...
    'EJ', beta*a*b^2, ...
    'EA', a, ...
    'L', b, ...
    'q', 1);

%%%%%%%%%%%%%%%%% SOURCE CODE
NfPCVWsrc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% STIFFNESS ENERGIES

%%%%%%%%%%%%%%%%% SOURCE CODE
augdati = dati;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


augdati.M = subs(solution.M, dati);
augdati.H = subs(solution.H, dati);
actions2 = subs(actions, augdati);


%%%%%%%%%%%%%%%%% SOURCE CODE
integrals = [];
for i = 1:max(size(conj_stiffness))
    integrals = [integrals, int(actions2(i)*actions2(i)/conj_stiffness(i), x, 0, conj_length(i))];
end
integrals = subs(integrals, dati)

Uaxial = 0; Ubending = 0;
for i = 1:max(size(conj_stiffness))
   if conj_stiffness(i) == EA
       Uaxial = Uaxial + integrals(i);
   else
       Ubending = Ubending + integrals(i);
   end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Uaxial = double(Uaxial)
Ubending = double(Ubending)
UaxOverUbend = double(Uaxial/Ubending)

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






