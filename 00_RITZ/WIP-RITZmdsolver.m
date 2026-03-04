%%% INIT
clear, clc, syms m EJ EJ_2 GJ GJ_2 EA EA_2 k k2 h1 h2 F x L 
%%% RITZ SOLVER:
% 1) RITZ BASE FUNCTIONS COMPUTATION GIVEN BCs
% 2) RITZ K MATRIX AND F VECTOR COMPUTATION GIVEN DATA and BCs
% 3) DISPLACEMENT FUNCTION AND DISPLACEMENT EVALUATION IN SPECIFIC SPOTS

nbcs = 2;

% FIRST DOMAIN 
ngdl1 = 2;   % d(s)of of the Ritz model to employ
nmodel1 = 2; % which is the order of the derivatives? phi/xx EJ phi/xx --> nmodel = 2
n1 = ngdl1 + nbcs/2;         % Ordine espansione
basetype1 = 'polynomial'; % which Ritz base do you want to use?

% SECOND DOMAIN
ngdl2 = 2;   % d(s)of of the Ritz model to employ
nmodel2 = 2; % which is the order of the derivatives? phi/xx EJ phi/xx --> nmodel = 2
n2 = ngdl2 + nbcs/2;         % Ordine espansione
basetype2 = 'polynomial'; % which Ritz base do you want to use?

help variablestiffnessExample
stiffnessfunc1 = @(x) EJ;
stiffnessfunc2 = @(x) EJ_2;

% DOMAIN 1 BOUNDARIES
integralstart1 = 0; % domain start
integralend1 = L;   % domain end
% DOMAIN 2 BOUNDARIES
integralstart2 = 0; % domain start
integralend2 = L;   % domain end

% forcing entities data DOMAIN 1
syms q1
distributedloads1 = true;
dl1 = @(x) q1;
dl_start1 = 0;
dl_end1 = L;

distributedsprings1 = false;
kds1 = @(x) h1;
kds_start1 = 0;
kds_end1 = L/2;

springs1 = false;
springlocation1 = L;

loads1 = false;
loadvalue1 = F;
loadlocation1 = L;

% forcing entities data DOMAIN 2
syms q2
distributedloads2 = true;
dl2 = @(x) q2;
dl_start2 = 0;
dl_end2 = L;

distributedsprings = false;
kds2 = @(x) h2;
kds_start2 = 0;
kds_end2 = L/2;

springs2 = false;
springlocation2 = L;

loads2 = false;
loadvalue2 = F;
loadlocation2 = L;

% displacement evaluation
where = L/2;

%%%%%%%%%%%%%%%%%%%%% SOURCE CODE START %%%%%%%%%%%%%%%%%%%%%
RSMD1
%%%%%%%%%%%%%%%%%%%%% SOURCE CODE END %%%%%%%%%%%%%%%%%%%%%%%

% INSERT BCs HERE
syms wbar
eqs = [subs(w_temp, x, 0) == 0; 
       subs(diff(w_temp,x,1), x, 0) == 0;
       subs(w_temp, x, L) == wbar];
%%%%%%%%%%%%%%%%%%%%% SOURCE CODE START %%%%%%%%%%%%%%%%%%%%%
RSMD2
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

