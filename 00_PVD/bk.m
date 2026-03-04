clear, clc
syms x w0(x)
syms L EJ k kt
syms q F

ode = EJ*diff(w0(x),x,4) - q == 0;
bc1 = EJ*subs(diff(w0(x), x, 2), 0) == subs(diff(w0(x), x), 0)*kt;
bc2 = EJ*subs(diff(w0(x), x, 2), L) == - subs(diff(w0(x), x), L)*kt;
bc3 = EJ*subs(diff(w0(x), x, 3), 0) == - w0(0)*k;
bc4 = EJ*subs(diff(w0(x), x, 3), L) == w0(L)*k;
sol = dsolve(ode, bc1, bc2, bc3, bc4);

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