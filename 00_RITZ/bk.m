%%% INIT
addpath('srcRitzSolver\')
clear, clc, syms m EJ GJ EA k h F x L I M 
%%% RITZ SOLVER:
% 1) RITZ BASE FUNCTIONS COMPUTATION GIVEN BCs
% 2) RITZ K MATRIX AND F VECTOR COMPUTATION GIVEN DATA and BCs
% 3) DISPLACEMENT FUNCTION AND DISPLACEMENT EVALUATION IN SPECIFIC SPOTS

ngdl = 1;   % d(s)of of the Ritz model to employ
nmodel = 2; % which is the order of the derivatives? phi/xx EJ phi/xx --> nmodel = 2
nbcs = 3;
n = ngdl + nbcs;         % Ordine espansione
basetype = 'polynomial'; % which Ritz base do you want to use?

%help variablestiffnessExample % <-- uncomment and run if you need an example of var.stiff.
stiffnessfunc = @(x) EJ;

integralstart = 0; % domain start
integralend = L;   % domain end

% forcing entities data
syms q
distributedloads = true;
dl = @(x) q;
dl_start = 0;
dl_end = L;

distributedsprings = true;
kds = @(x) h;
kds_start = 0;
kds_end = L;

springs = true;
springlocation = L;

loads = false;
loadvalue = F;
loadlocation = L;

% displacement evaluation
where = L/2;

% dynamical properties evaluation:
dynamicalmodel = false;

mass = true;
massvalue = M;
masslocation = L;

distributedmass = true;
distributedmassfunc = @(x) I;
dmf_start = 0;
dmf_end = L;

% static deflections
staticdeflections = false;



%%%%%%%%%%%%%%%%%%%%% SOURCE CODE START %%%%%%%%%%%%%%%%%%%%%
RS1
%%%%%%%%%%%%%%%%%%%%% SOURCE CODE END %%%%%%%%%%%%%%%%%%%%%%%

% INSERT BCs HERE
syms th
eqs = [subs(w_temp, x, 0) == 0; 
       subs(diff(w_temp, x, 1),x, 0) == 0
       subs(diff(w_temp, x, 1),x, L) == 0];


% WANT TO IMPOSE A SPECIFIC BASE? MIGHT BE USEFUL
override_phi = false;
phioverridden = [1 - cos(2*pi*x/L); 1 - cos(4*pi*x/L); 1- cos(6*pi*x/L)];
% example: trig with sym constraints - > take only cosines

%%%%%%%%%%%%%%%%%%%%% SOURCE CODE START %%%%%%%%%%%%%%%%%%%%%
RS2
%%%%%%%%%%%%%%%%%%%%% SOURCE CODE END %%%%%%%%%%%%%%%%%%%%%%%

% OBTAINED RITZ BASE DATA
% phi is the ritz base
% w_p is the particular solution
% w is the general solution form, with general coefficients

% OBTAINED SOLUTION DATA:
% K is the stiffness matrix coming from the displacement field itself
% Kds is the stiffness matrix coming from distributed springs
% Ks is the stiffness matrix coming from springs
% Kfinal is the final stiffness matrix

% f0 is the particular solution contribution to the f vector
% fdl is the f vector contribution coming from distributed loads
% floads is the f vector contribution coming from concentrated loads
% ffinal is the final f vector

% cfinal is the final c vector

%%%%%%%%%%%%%%%%%%%%% SOURCE CODE START %%%%%%%%%%%%%%%%%%%%%
if dynamicalmodel
  RS3  % <- dynamical solver 
end
%%%%%%%%%%%%%%%%%%%%% SOURCE CODE END %%%%%%%%%%%%%%%%%%%%%%%

%% EVALUATION OF THE NUMERICAL VALUE OF A SPECIFIC VARIABLE

dati = struct( ...
    'EJ', 1e9, ...
    'k', 1e9/1e9, ...
    'h', 1e9/1e12, ...
    'L', 1000, ...
    'q', 1);

eval = strain_energy;

%%%%%%%%%%%%%%%%%%%%% SOURCE CODE START %%%%%%%%%%%%%%%%%%%%%
nomi_sym = symvar(eval);
nomi_cell = cellstr(string(nomi_sym));
valori = cellfun(@(x) dati.(x), nomi_cell);
risultato = double(simplify(subs(eval, nomi_sym, valori)))
%%%%%%%%%%%%%%%%%%%%% SOURCE CODE END %%%%%%%%%%%%%%%%%%%%%%%
