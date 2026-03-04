%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% INIT
addpath('srcRitzSolverMD\')
clear, clc, syms m EJ GJ EA k h F x L I M 
%%% RITZ SOLVER:
% 1) RITZ BASE FUNCTIONS COMPUTATION GIVEN BCs
% 2) RITZ K MATRIX AND F VECTOR COMPUTATION GIVEN DATA and BCs
% 3) DISPLACEMENT FUNCTION AND DISPLACEMENT EVALUATION IN SPECIFIC SPOTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%% DOMAIN 1 %%%%%%%%%%%%%
ngdl1 = 1;   % d(s)of of the Ritz model to employ
nmodel1 = 2; % which is the order of the derivatives? phi/xx EJ phi/xx --> nmodel = 2
nbcs1 = 3;
n1 = ngdl1 + nbcs1;         % Ordine espansione
n1 = 3;
basetype1 = 'polynomial'; % which Ritz base do you want to use?
%help variablestiffnessExample % <-- uncomment and run if you need an example of var.stiff.
stiffnessfunc1 = @(x) EJ;

integralstart1 = 0; % domain start
integralend1 = L;   % domain end

% forcing entities data 
syms q
distributedloads1 = false;
dl1 = @(x) q;
dl_start1 = 0;
dl_end1 = L;
distributedsprings1 = false;
kds1 = @(x) h;
kds_start1 = 0;
kds_end1 = L;
springs1 = false;
springlocation1 = L;
loads1 = true;
loadvalue1 = -F;
loadlocation1 = L;

% displacement evaluation
where1 = L/2;

% dynamics properties
dynamicalmodel1 = false;
mass1 = true;
massvalue1 = M;
masslocation1 = L;
distributedmass1 = true;
distributedmassfunc1 = @(x) I;
dmf_start1 = 0;
dmf_end1 = L;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%% DOMAIN 2 %%%%%%%%%%%%%
ngdl2 = 1;   % d(s)of of the Ritz model to employ
nmodel2 = 2; % which is the order of the derivatives? phi/xx EJ phi/xx --> nmodel = 2
nbcs2 = 3;
n2 = ngdl2 + nbcs2;         % Ordine espansione
%n2 = 3;
basetype2 = 'polynomial'; % which Ritz base do you want to use?
%help variablestiffnessExample % <-- uncomment and run if you need an example of var.stiff.
stiffnessfunc2 = @(x) EJ;

integralstart2 = 0; % domain start
integralend2 = L;   % domain end

% forcing entities data 
syms q
distributedloads2 = false;
dl2 = @(x) q;
dl_start2 = 0;
dl_end2 = L;
distributedsprings2 = false;
kds2 = @(x) h;
kds_start2 = 0;
kds_end2 = L;
springs2 = false;
springlocation2 = L;
loads2 = true;
loadvalue2 = 1;
loadlocation2 = L;

% displacement evaluation
where2 = L/2;

% dynamics properties
dynamicalmodel2 = false;
mass2 = true;
massvalue2 = M;
masslocation2 = L;
distributedmass2 = true;
distributedmassfunc2 = @(x) I;
dmf_start2 = 0;
dmf_end2 = L;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%% SOURCE CODE START %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RS1MD
%%%%%%%%%%%%%%%%%%%%% SOURCE CODE END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%% DOMAIN 1 %%%%%%%%%%%%%
% INSERT BCs HERE - w_temp is the reference function
syms th
eqs = [subs(w_temp1, x, 0) == 0; 
       subs(diff(w_temp1, x, 1),x, 0) == 0
       subs(w_temp1, x, L) == subs(w_temp2, x2, 0); 
       subs(diff(w_temp2, x2, 1),x2, 0) == subs(diff(w_temp1, x, 1),x, 0)
       subs(diff(w_temp2, x2, 3),x2, L) == 1];

% WANT TO IMPOSE A SPECIFIC BASE? MIGHT BE USEFUL
override_phi1 = false;
phioverridden1 = [1 - cos(2*pi*x/L); 1 - cos(4*pi*x/L); 1- cos(6*pi*x/L)];
override_phi2 = false;
phioverridden2 = [1 - cos(2*pi*x/L); 1 - cos(4*pi*x/L); 1- cos(6*pi*x/L)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%% SOURCE CODE START %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RS2MD
%%%%%%%%%%%%%%%%%%%%% SOURCE CODE END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
% if dynamicalmodel
%   RS3MD  % <- dynamical solver 
% end
%%%%%%%%%%%%%%%%%%%%% SOURCE CODE END %%%%%%%%%%%%%%%%%%%%%%%

strain_energy;

%% EVALUATION OF THE NUMERICAL VALUE OF A SPECIFIC VARIABLE

dati = struct( ...
    'EJ', 1e9, ...
    'L', 800, ...
    'q', 0.5, ...
    'M', 1.6e4);

%eval = strain_energy;
%eval = omegas;
eval = cfinal;

%%%%%%%%%%%%%%%%%%%%% SOURCE CODE START %%%%%%%%%%%%%%%%%%%%%
nomi_sym = symvar(eval);
nomi_cell = cellstr(string(nomi_sym));
valori = cellfun(@(x) dati.(x), nomi_cell);
risultato = double(simplify(subs(eval, nomi_sym, valori)))
%%%%%%%%%%%%%%%%%%%%% SOURCE CODE END %%%%%%%%%%%%%%%%%%%%%%%
