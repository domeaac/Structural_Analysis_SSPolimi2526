clear, clc
L = 800; % mm
EJ = 1e9; % N*mm^2
q = 1; % N/mm
kt = 2*EJ/L; % m
syms a;

number_of_elements = 2;
nodes_per_element = 2;
nnodes = 3;
nodes_order = 2;
ndofs = 6;

%%%%%%%%%%%%%%%%%%%%
number_of_nodes = nodes_per_element;
nn = number_of_nodes*nodes_order;
nels = number_of_elements;
%%%%%%%%%%%%%%%%%%%%

% COMPUTE
[K1, SS1] = KMatrix(number_of_nodes, nodes_order, [0 (1-a)*L], EJ, []);
[K2, SS2] = KMatrix(number_of_nodes, nodes_order, [0 a*L], EJ, []);
connMatrix = [1 2 3 4; 3 4 5 6];
connMatrix2 = [];
alpha = [0; 0];

% ASSEMBLE
KK = [K1; K2];
KK2 = []; out = 0;
ff = zeros(6,1);

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
alpha = [];
for i = 1: out
    Kel = KK2((nn*(i-1) +1):(nn*i),:);
    % BUILD NEW T FOR NON CANONICAL CASES (no 2 elements but more)
    T = [cos(alpha(i)) sin(alpha(i)) 0 0
        0 0 cos(alpha(i)) sin(alpha(i))];

    % BUILD NEW T FOR UNFORTUNATE BEAM ELEMENTS
    if nodes_order_2 == 2
        T = eye(4);
    end
    if nodes_order_2 == 3
        T = [cos(alpha(i))    sin(alpha(i)) 0 0 0 0
             -sin(alpha(i))   cos(alpha(i)) 0 0 0 0
             0 0 1 0 0 0 0
             0 0 0 0 cos(alpha(i))  sin(alpha(i))
             0 0 0 0 -sin(alpha(i)) cos(alpha(i))
             0 0 0 0 0 0 1];
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
