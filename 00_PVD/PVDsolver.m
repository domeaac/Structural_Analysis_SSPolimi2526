clear, clc
syms x w0(x)
syms L EA EJ k kt
syms q F
n = @(x) sin(2*pi*x/L);

% ode = EA*diff(w0(x),x,2) - n == 0;
% bc1 = subs(w0(x),x,0) == 0;
% bc2 = subs(diff(w0(x),x,3),x,L) == 0;
% bc3 = subs(diff(w0(x),x,1),x,0) == 0;
% bc4 = subs(diff(w0(x),x,2),x,L) + (kt/EJ)*subs(diff(w0(x),x,1),x,L) == 0;
% sol = simplify(dsolve(ode, bc1, bc2, bc3, bc4));

ode = EJ*diff(w0(x),x,4) - q == 0;
bc1 = subs(diff(w0(x),x,1),x,0) == 0;
bc2 = EJ*subs(diff(w0(x),x,2),x,L) + kt*subs(diff(w0(x),x,1),x,L) == 0;
bc3 = subs(diff(w0(x),x,0),x,0) == 0;
bc4 = subs(diff(w0(x),x,3),x,L) == 0;
sol = simplify(dsolve(ode, bc1, bc2, bc3, bc4))

%% EVALUATION OF THE SYMBOLICAL VALUE OF A SPECIFIC VARIABLE

sol = simplify(subs(sol, kt, 2*EJ/L))

%% SYM POSTPROCESSING - RUN ONLY PART ONE BEFORRE THIS

syms xbar
solbar = simplify(subs(sol, x, xbar*L))
ccc = simplify(coeffs(solbar, xbar)); nomi = symvar(ccc); assume(nomi, 'real'); ccc = ccc'

%% POSTPROCESSING
dati = struct( ...
    'EJ', 1e9, ...
    'L', 800, ...
    'q', 1);

sol = subs(sol, dati)

% M1 = double(-subs(diff(sol, x),x, 0)*dati.kt)
% M2 = double(-subs(diff(sol, x),x, dati.L)*dati.kt)
% F1 = double(subs(sol, x, 0)*dati.k)
% F2 = double(subs(sol, x, dati.L)*dati.k)

%% PLOT NUMERICAL SOLUTION
plotfun(sol, dati.L)
