clear, clc
syms x w1(x) w2(x)
syms EJ1 EJ2 L P

 
odes = [
    EJ1* diff(w1,x,4) == 0
    EJ2* diff(w2,x,4) == 0
];

bcs = [
    w1(0) == 0;
    subs(diff(w1,x,1),x,0) == 0

    w1(L) == w2(0);
    subs(diff(w2,x,1),x,0) == subs(diff(w1,x,1),x,L);

    EJ2*subs(diff(w2,x,2),x,0) == subs(diff(w1,x,2),x,L)*EJ1;
    EJ2*subs(diff(w2,x,3),x,0) == subs(diff(w1,x,3),x,L)*EJ1;

    EJ2*subs(diff(w2,x,2),x,L) == 0;
    - EJ2*subs(diff(w2,x,3),x,L) == - P
    ];

 
sol = dsolve(odes, bcs);

%% POSTPROCESSING 1

sol = subs(sol, EJ1, 2*EJ2);

% %%
% alpha = ((P*L^2)/(EJ2));
% sol.w1 = simplify(sol.w1/(P*L^2 /(EJ2)));
% sol.w2 = simplify(sol.w2/(P*L^2 /(EJ2)));
% sol

%% XBAR FORM SOLUTION

syms xbar
solbarw1 = simplify(subs(sol.w1, x, xbar*L))
ccc1 = simplify(coeffs(solbarw1, xbar)); nomi = symvar(ccc1); assume(nomi, 'real'); ccc1 = ccc1'
[~, Tc1] = coeffs(solbarw1, xbar); Tc1 = flip(Tc1)
solbarw2 = simplify(subs(sol.w2, x, xbar*L))
ccc2 = simplify(coeffs(solbarw2, xbar)); nomi = symvar(ccc2); assume(nomi, 'real'); ccc2 = ccc2'
[~, Tc2] = coeffs(solbarw2, xbar); Tc2 = flip(Tc2)

%% POSTPROCESSING EXAMPLE
dati = struct( ...
    'EJ', 1e10, ...
    'k', 1e4, ...
    'kt', 1e7, ...
    'L', 1000, ...
    'q', 10);

sol = subs(sol, dati);


M1 = double(-subs(diff(sol, x),x, 0)*dati.kt)
M2 = double(-subs(diff(sol, x),x, dati.L)*dati.kt)
F1 = double(subs(sol, x, 0)*dati.k)
F2 = double(subs(sol, x, dati.L)*dati.k)
