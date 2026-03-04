clear, clc
EA = 72000*5*7;
a = 1500;
b = 1000;
P = 10e3;

lVect = [a sqrt(a^2+b^2) sqrt(a^2+b^2) b a];
alphaVect = [0 atan2(-b,a) atan2(-b,-a) -pi/2 0];

connMatrix = [1 2 3 4; 1 2 7 8; 3 4 5 6; 3 4 7 8; 5 6 7 8];
ndofs = 8;
nels = 5;

K = zeros(ndofs, ndofs);
for i = 1:nels

    L = lVect(i);
    alpha = alphaVect(i);

    Kel = EA/L * [1 -1; -1 1];
    T = [cos(alpha) sin(alpha) 0 0
        0 0 cos(alpha) sin(alpha)];
    Kel = T' * Kel * T;
    idxs = connMatrix(i, :);
    K(idxs, idxs) = K(idxs, idxs) + Kel;
end

uReduced = [3 4 5 6 7];
KReduced = K(uReduced, uReduced);

A = [0 0 1 0 0; 0 0 0 1 0];
Kaug = [KReduced A'; A, zeros(size(A,1), size(A,1))];

alphaForces = atan2(b,a);
F = [P*cos(alphaForces) P*sin(alphaForces) 0 0 0]';
Faug = [F; 0; 0];

UredLambda = Kaug\Faug;
UredSol = UredLambda(1:max(size(uReduced)));
Lambdas = UredLambda(max(size(uReduced))+1:end)
s = UredSol(1)*cos(alphaForces) + UredSol(2)*sin(alphaForces)