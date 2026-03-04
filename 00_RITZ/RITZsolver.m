%%% INIT
addpath('srcRitzSolver\')
clear, clc, syms m EJ GJ EA k h F x L I M k
%%% RITZ SOLVER:
% 1) RITZ BASE FUNCTIONS COMPUTATION GIVEN BCs
% 2) RITZ K MATRIX AND F VECTOR COMPUTATION GIVEN DATA and BCs
% 3) DISPLACEMENT FUNCTION AND DISPLACEMENT EVALUATION IN SPECIFIC SPOTS

ngdl = 1;   % d(s)of of the Ritz model to employ
nmodel = 2; % which is the order of the derivatives? phi/xx EJ phi/xx --> nmodel = 2
nbcs = 2;
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

distributedsprings = false;
kds = @(x) h;
kds_start = 0;
kds_end = L;
typedspring = 'torsional';

springs = true;
springlocation = L;
typespring = 'torsional';

loads = false;
loadvalue = F;
loadlocation = L;

% displacement evaluation
where = L/2;

% dynamical properties evaluation:
% attenzione se è un problema assiale cambia source code!!!
dynamicalmodel = false;

mass = true;
massvalue = M;
masslocation = L;

distributedmass = true;
distributedmassfunc = @(x) I;
dmf_start = 0;
dmf_end = L;

% static deflections
% PVD to get the solution shape, which then you use as single ritz trial
% function
staticdeflections = false;



%%%%%%%%%%%%%%%%%%%%% SOURCE CODE START %%%%%%%%%%%%%%%%%%%%%
RS1
%%%%%%%%%%%%%%%%%%%%% SOURCE CODE END %%%%%%%%%%%%%%%%%%%%%%%

% INSERT BCs HERE - w_temp is the reference function
syms th
eqs = [subs(w_temp, x, 0) == 0; 
       subs(diff(w_temp, x, 1),x, 0) == 0];


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

strain_energy;

%% EVALUATION OF THE SYMBOLICAL VALUE OF A SPECIFIC VARIABLE

displacement_function = subs(displacement_function, k, 2*EJ/L)


%% EVALUATION OF THE NUMERICAL VALUE OF A SPECIFIC VARIABLE

dati = struct( ...
    'EJ', 1e9, ...
    'L', 800, ...
    'q', 1);


%eval = strain_energy;
%eval = omegas;
eval = displacement_function
xpresence = true;
%%%%%%%%%%%%%%%%%%%%% SOURCE CODE START %%%%%%%%%%%%%%%%%%%%%
nomi_sym = symvar(eval);
if xpresence
    nomi_sym = nomi_sym(nomi_sym ~= sym('x'));
end
nomi_cell = cellstr(string(nomi_sym));
valori = cellfun(@(x) dati.(x), nomi_cell);
if xpresence
   risultato = simplify(subs(eval, nomi_sym, valori))
else
   risultato = double(simplify(subs(eval, nomi_sym, valori)))
end
sol = risultato;
%%%%%%%%%%%%%%%%%%%%% SOURCE CODE END %%%%%%%%%%%%%%%%%%%%%%%


%% PLOT NUMERICAL SOLUTION
plotfun(sol, dati.L)

%% SUMMARY 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   LOGICA DEL METODO DI RAYLEIGH-RITZ (SPOSTAMENTI IMPOSTI)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 1. BASE GENERICA: 
%    Definisco w_temp = c * base(x). I coefficienti 'c' sono incogniti.
%
% 2. MATRICE DEI VINCOLI (A_bc * c = b_bc):
%    Impongo le BCs (Geometriche). b_bc contiene i valori non nulli 
%    (es. cedimenti o rotazioni imposte).
%
% 3. SEPARAZIONE CINEMATICA (w = w_p + phi * cc):
%    - phi (Base Ammissibile): null(A_bc). Soddisfa le BCs omogenee.
%    - w_p (Soluzione Particolare): A_bc \ b_bc. Soddisfa le BCs non omogenee.
%    - cc (Coordinate Generalizzate): Nuove incognite del sistema ridotto.
%
% 4. MATRICE DI RIGIDEZZA (K):
%    Calcolata SOLO sulle funzioni di base 'phi'. Rappresenta la rigidezza
%    della struttura con vincoli omogeneizzati.
%
% 5. VETTORE DEI CARICHI (f = f_ext + f0):
%    - f_ext: Carichi esterni (forze, momenti) proiettati su 'phi'.
%    - f0 (Contributo Particolare): L'energia interna "spesa" da w_p viene
%      portata al secondo membro come carico equivalente:
%      f0 = - integral( (EI * diff(w_p, n)) * diff(phi, n) )
%
% 6. SOLUZIONE E RICOSTRUZIONE:
%    - Risolvo: cc = K \ f
%    - Spostamento finale: w(x) = w_p(x) + phi(x) * cc
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%