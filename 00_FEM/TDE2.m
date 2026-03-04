clear
clc

syms a2 a3 b3 L x1 x2 EA EJ
u = [a2 a3 b3]';

phiu1 = [-L*x1; -3/2 *L*x1; L^2 *x1 + 3/2 *L*x1];
phiu2 = [L*x2; L^2 *x2; 0];
phiw1 = [x1^2 /L^2; x1^3/L^3; 0];
phiw2 = [(-x2^2 )/L^2; -3/2 * (x2^2)/L^2; (x2^3)/L^3 + ((3/2)*x2^2)/L^2];

a = diff(phiu1, x1, 1)
b = diff(phiu2, x2, 1)
c = diff(phiw1, x1, 2)
d = diff(phiw2, x2, 2)

assume(L, "real")
K = int(a*a', x1, 0, L) + int(b*b', x2, 0, L) + int(c*c', x1, 0, L) + int(d*d', x2, 0, L);

Lval = 1300;
EAval = 3e5;
dati = struct( ...
    'EJ', EAval*(Lval^2)*5, ...
    'L', Lval, ...
    'EA', EAval, ...
    'P', 2000);

Knum = subs(K, dati);

f = subs(subs(phiw1,x1,Lval)*(-dati.P), dati)

a = double(Knum\f)


