%%% INIT
clear, clc, syms m EJ GJ EA k h F x L 
%%% RITZ SOLVER:
% 1) RITZ BASE FUNCTIONS COMPUTATION GIVEN BCs
% 2) RITZ K MATRIX AND F VECTOR COMPUTATION GIVEN DATA and BCs
% 3) DISPLACEMENT FUNCTION AND DISPLACEMENT EVALUATION IN SPECIFIC SPOTS

ngdl = 2;   % d(s)of of the Ritz model to employ
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

distributedsprings = false;
kds = @(x) h;
kds_start = 0;
kds_end = L/2;

springs = false;
springlocation = L;

loads = false;
loadvalue = F;
loadlocation = L;

% displacement evaluation
where = L/2;

%%%%%%%%%%%%%%%%%%%%% SOURCE CODE START %%%%%%%%%%%%%%%%%%%%%
RS1
%%%%%%%%%%%%%%%%%%%%% SOURCE CODE END %%%%%%%%%%%%%%%%%%%%%%%

% INSERT BCs HERE
syms wbar
eqs = [subs(w_temp, x, 0) == 0; 
       subs(diff(w_temp,x,1), x, 0) == 0;
       subs(w_temp, x, L) == wbar];
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

%%%%%%%%%%%%%%%%%%%% DISPLACEMENT EVALUATION %%%%%%%%%%%%%%%%%%%%%%%
displacement = subs(displacement_function, x, where);
fprintf('displacement value in %s: %s \n', where, displacement);

