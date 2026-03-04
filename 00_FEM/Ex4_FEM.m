%% ESE 1
clear, clc
syms L1 L2 K E A1 A2 P

%angle = 0;
%element_nodes = 2;
%K1 = trussK(E*A1,L1,element_nodes,angle);
%K2 = trussK(E*A2,L2,element_nodes,angle);

% insert beam data
lVect = [L1 L2];
ndofs = 6;
nels = 2;
alphaVect = [0 0];
stiffVect = [E*A1; E*A2];

connMatrix = [1 2 3 4; 3 4 5 6];
F = [0 0 P 0 0 0];
uReduced = [3];
alphaForces = 0;
Freduced = [P*cos(alphaForces) P*sin(alphaForces)];


K = sym(zeros(ndofs, ndofs));
for i = 1:nels

    L = lVect(i);
    alpha = alphaVect(i);

    Kel = stiffVect(i)/L * [1 -1; -1 1];
    T = [cos(alpha) sin(alpha) 0 0
        0 0 cos(alpha) sin(alpha)];
    Kel = T' * Kel * T;

    idxs = connMatrix(i, :);
    K(idxs, idxs) = K(idxs, idxs) + Kel;
end

KReduced = K(uReduced, uReduced);
list = symvar(Freduced); assume(list, "real"); 
UReduced = KReduced\Freduced';

% u = N * unodes;
% eps = D*N*unodes = B*unodes



%% ESE 2 IS ALMOST EQUAL TO ESE 1

%% ESE 3
clear, clc
syms x

c = 2;
a = 1.5;
b = 0.5;
d = 0.5;
E = 28*1e6;
p = 20;
w = 25;

P = p*b*d;

nels = 2;
ndofs = 3;
number_of_nodes = 2; nodes_order = 1;

% first element
l = @(x) x*(a-d)/c + d;
A = @(x) l(x)*b;
P2 = @(x) int(w*A(x),x);
n = diff(P2,x,1);
EA = @(X) E*A(x);
[K1, SS1] = KMatrix(number_of_nodes, nodes_order, [0 c/2], EA, []);

f1d = int(n*SS1, x, 0, c/2);
f1c = [P; 0];

% second element
l = @(x) x/(c/2) *((a-d)/2) + (d + (a-d)/2);
A = @(x) l(x)*b;
P2 = @(x) int(w*A(x),x);
n = diff(P2,x,1);
EA = @(X) E*A(x);
[K2, SS2] = KMatrix(number_of_nodes, nodes_order, [0 c/2], EA, []);

f2d = int(n*SS2, x, 0, c/2);
f2c = [0;0];

K = sym(zeros(ndofs, ndofs));
f = sym(zeros(ndofs,1));

KK = [K1; K2];
ff = [f1c+f1d; f2c+f2d];

connMatrix = [1 2; 2 3];

%%%%%%%%%%
for i = 1:nels
    idxs = connMatrix(i, :);
    fel = ff((number_of_nodes*(i-1)+1):(number_of_nodes*i));
    Kel = KK((number_of_nodes*(i-1) +1):(number_of_nodes*i),:);
    K(idxs, idxs) = K(idxs, idxs) + Kel;
    f(idxs) = f(idxs) + fel;
end
uReduced = [1 2];
Freduced = f(uReduced);
KReduced = K(uReduced, uReduced);
list = symvar(KReduced); assume(list, "real"); 
list = symvar(Freduced); assume(list, "real"); 
UReduced = KReduced\Freduced;

%% ESE 4
clear, clc
E = 210*1e3; % N/mm^2
P = 10000; % N
A = 300; % mm^2

nels = 4;
ndofs = 8;
number_of_nodes = 2;
nodes_order = 1;
nn = ndofs/nels;

% COMPUTE
[K1, SS1] = KMatrix(number_of_nodes, nodes_order, [0 sqrt(17)*100], E*A, []);
[K2, SS2] = KMatrix(number_of_nodes, nodes_order, [0 300], E*A, []);
[K3, SS3] = KMatrix(number_of_nodes, nodes_order, [0 sqrt(16+16)*100], E*A, []);
[K4, SS4] = KMatrix(number_of_nodes, nodes_order, [0 sqrt(1+16)*100], E*A, []);
connMatrix = [1 2 3 4; 3 4 5 6; 3 4 7 8; 5 6 7 8];
alpha = [atan2(4,1)+pi/2; pi/2; atan2(4,4); atan2(1,4)];

K = zeros(ndofs, ndofs);
f = zeros(ndofs, 1);

% ASSEMBLE
KK = [K1; K2; K3; K4];
ff = [0; 0; 0; 0; P; 0; 0; 0];


for i = 1:nels
    Kel = KK((number_of_nodes*(i-1) +1):(number_of_nodes*i),:);
    T = [cos(alpha(i)) sin(alpha(i)) 0 0
        0 0 cos(alpha(i)) sin(alpha(i))];
    Kel = T' * Kel * T;
    idxs = connMatrix(i, :);
    K(idxs, idxs) = K(idxs, idxs) + Kel;

    % fel = ff((n*(i-1)+1):(number_of_nodes*i));
    % f(idxs) = f(idxs) + fel;
end

% for i = 1:nels
%     idxs = connMatrix(i, :);
%     fel = ff((number_of_nodes*(i-1)+1):(number_of_nodes*i));
%     f(idxs) = f(idxs) + fel;
% end


% REDUCE
uReduced = [3 4 5 6];
KReduced = K(uReduced, uReduced);
freduced = ff(uReduced);
Ured = KReduced\freduced;

% RECOVER INTERNAL FORCES
% for each element
uu = [0; 0; Ured; 0; 0];
SS = [SS1 SS2 SS3 SS4];
syms x
for i = 1:nels
    T = [cos(alpha(i)) sin(alpha(i)) 0 0
        0 0 cos(alpha(i)) sin(alpha(i))];
    idxs = connMatrix(i, :);
    uvals = T*uu(idxs);
    dSSi = diff(SS(:,i), x, 1);
    eps_i = dSSi'*uvals;
    N = double(E*A*eps_i)

    % fel = ff((n*(i-1)+1):(number_of_nodes*i));
    % f(idxs) = f(idxs) + fel;
end


%% EX 5
clear, clc
EJ = 1000; % kN/m^2
EA = 1000; % kN
q = 300; % kN/m
l = 1; % m

number_of_elements = 3;
nodes_per_element = 2;
nnodes = 4;
nodes_order = 2;
ndofs = 7;

%%%%%%%%%%%%%%%%%%%%
number_of_nodes = nodes_per_element;
nn = number_of_nodes*nodes_order;
nels = number_of_elements;
%%%%%%%%%%%%%%%%%%%%

% COMPUTE
[K1, SS1] = KMatrix(number_of_nodes, 2, [0 l], EJ, []);
[K2, SS2] = KMatrix(number_of_nodes, 2, [0 2*l], 2*EJ, []);
[K3, SS3] = KMatrix(number_of_nodes, 1, [0 l], EA, []);
connMatrix = [1 2 3 4; 3 4 5 6];
connMatrix2 = [5 7];
alpha = [0; 0; -pi/2];

% ASSEMBLE
KK = [K1; K2];
KK2 = [K3]; out = 1;
ff = zeros(7,1);

%%%%%%%%%%%%%%%%%%%% K COMPUTATION
if nodes_order == 3
KK = subs(KK, 'EJ', EJ);
KK = subs(KK, 'EA', EA);
end

K = zeros(ndofs, ndofs);
f = zeros(ndofs, 1);

for i = 1:nels - out
    Kel = KK((nn*(i-1) +1):(nn*i),:);
    % BUILD NEW T FOR NON CANONICAL CASES (no 2 elements but more)
    T = [cos(alpha(i)) sin(alpha(i)) 0 0
        0 0 cos(alpha(i)) sin(alpha(i))];
    % BUILD NEW T FOR UNFORTUNATE BEAM ELEMENTS
    if nodes_order == 2
        T = eye(4);
    end
    if nodes_order == 3
        T = [cos(alpha(i)) sin(alpha(i)) 0 0 0 0
             0 0 1 0 0 0
             0 0 0 cos(alpha(i)) sin(alpha(i)) 0
             0 0 0 0 0 1];
    end
    Kel = T' * Kel * T;
    idxs = connMatrix(i, :);
    K(idxs, idxs) = K(idxs, idxs) + Kel;
end

nodes_order_2 = 1;
nn = number_of_nodes*nodes_order_2;
alpha = [0];
for i = 1: out
    Kel = KK2((nn*(i-1) +1):(nn*i),:);
    % BUILD NEW T FOR NON CANONICAL CASES (no 2 elements but more)
    T = [cos(alpha(i)) sin(alpha(i)) 0 0
        0 0 cos(alpha(i)) sin(alpha(i))];

    % BUILD NEW T FOR UNFORTUNATE BEAM ELEMENTS
    if nodes_order_2 == 2
        T = [1 1 0 0
             0 0 1 1];
    end
    if nodes_order_2 == 3
        T = [cos(alpha(i))    sin(alpha(i)) 0 0 0 0
             -sin(alpha(i))   cos(alpha(i)) 0 0 0 0
             0 0 0 0 cos(alpha(i))  sin(alpha(i))
             0 0 0 0 -sin(alpha(i)) cos(alpha(i))];
    end
    Kel = Kel; %T' * Kel * T 
    idxs = connMatrix2(i, :);
    K(idxs, idxs) = K(idxs, idxs) + Kel;
end
%%%%%%%%%%%%%%%%%%%%

% COMPUTE ADDITIONAL F ELEMENTS
syms x
idx = 2;
idxs = connMatrix(idx,:);
fadditional = int(SS2*q*x/(2*l),x,0,2*l); 
ff(idxs) = ff(idxs) + fadditional;

% REDUCE
uReduced = [3 4 5 6];
KReduced = K(uReduced, uReduced);
freduced = ff(uReduced);
Ured = KReduced\freduced;

% RECONSTRUCT 
uu = [0; 0; Ured; 0; 0];
SS = [SS1; SS2; SS3];

% % RECOVER
% syms x
% for i = 1:nels
%     T = [cos(alpha(i)) sin(alpha(i)) 0 0
%         0 0 cos(alpha(i)) sin(alpha(i))];
%     if nodes_order == 3
%         T = [cos(alpha(i)) sin(alpha(i)) 0 0 0 0
%             0 0 1 0 0 0
%             0 0 0 cos(alpha(i)) sin(alpha(i)) 0
%             0 0 0 0 0 1];
%     end
%     idxs = connMatrix(i, :);
%     uvals = T*uu(idxs);
%     dSSi = diff(SS(:,i), x, 1);
%     eps_i = dSSi'*uvals;
%     N = double(E*A*eps_i)
% 
%     % fel = ff((n*(i-1)+1):(number_of_nodes*i));
%     % f(idxs) = f(idxs) + fel;
% end




