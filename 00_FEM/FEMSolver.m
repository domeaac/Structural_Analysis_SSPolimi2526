%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INIT AND PROBLEM DEFINITION
clear, clc
L = 800; % mm
EJ = 1e9; % N*mm^2
q = 1; % N/mm
a = 1/3;
kt = 2*EJ/L;

number_of_elements = 2;
nodes_per_element = 2;
nnodes = 3;
nodes_order = 2;
ndofs = 9;

%%%%%%%%%%%%%%%%%%%%%%%% START
number_of_nodes = nodes_per_element;
nn = number_of_nodes*nodes_order;
nels = number_of_elements;
%%%%%%%%%%%%%%%%%%%%%%%% END

% COMPUTE 
[K1, SS1] = KMatrix(number_of_nodes, nodes_order, [0 L*(1-a)], EJ, []);
[K2, SS2] = KMatrix(number_of_nodes, nodes_order, [0 L*a], EJ, []);
%[K3, SS3] = KMatrix(number_of_nodes, nodes_order, [0 L/4], EA, []);
%[K4, SS4] = KMatrix(number_of_nodes, nodes_order, [0 L/4], EA, []);
%connMatrix = [1 2 3 4; 3 4 5 6; 5 6 7 8; 7 8 9 10; 9 10 11 12];
connMatrix = [1 2 3 4 5 6; 4 5 6 7 8 9];
alpha = [0; 0];
% ASSEMBLE
%KK = [K1; K2; K3; K4];
KK = [K1; K2];
ff = zeros(ndofs, 1);

%%%%%%%%%%%%%%%%%%%%%%%% START
K = sym(zeros(ndofs, ndofs)); % AUX VARIABLE
for i = 1:nels
    Kel = KK((nn*(i-1) +1):(nn*i),:);
    % BUILD NEW T FOR NON CANONICAL CASES (no 2 elements but more)
    T = [cos(alpha(i)) sin(alpha(i)) 0 0
        0 0 cos(alpha(i)) sin(alpha(i))];
    % BUILD NEW T FOR UNFORTUNATE BEAM ELEMENTS
    if nodes_order == 2
        T = [-sin(alpha(i)) cos(alpha(i)) 0 0 0 0
            0 0 1 0 0 0
            0 0 0 -sin(alpha(i)) cos(alpha(i)) 0
            0 0 0 0 0 1
            ];
    end
    if nodes_order == 3
        T = [cos(alpha(i))    sin(alpha(i)) 0 0 0 0
             -sin(alpha(i))   cos(alpha(i)) 0 0 0 0
             0 0 1 0 0 0 0
             0 0 0 0 cos(alpha(i))  sin(alpha(i))
             0 0 0 0 -sin(alpha(i)) cos(alpha(i))
             0 0 0 0 0 0 1];
    end
    Kel = T' * Kel * T;
    idxs = connMatrix(i, :);
    K(idxs, idxs) = K(idxs, idxs) + Kel;
end

%%%%%%%%%%%%%%%%%%%%%%%% END

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPUTE ADDITIONAL F ELEMENTS
syms x

idx = 1;
fadditional = int(SS1*q,x,0,L*(1-a)); 
%%%%%%%%%%%%%%%%%%%%%%%% START
fadditional = T'*fadditional;
idxs = connMatrix(idx,:);
ff(idxs) = ff(idxs) + fadditional;
%%%%%%%%%%%%%%%%%%%%%%%% END

idx = 2;
fadditional = int(SS2*q,x,0,L*a); 
%%%%%%%%%%%%%%%%%%%%%%%% START
fadditional = T'*fadditional;
idxs = connMatrix(idx,:);
ff(idxs) = ff(idxs) + fadditional;
%%%%%%%%%%%%%%%%%%%%%%%% END

% idx = 3;
% fadditional = int(SS3*nf2(x+L/2),x,0,L/4); 
% %%%%%%%%%%%%%%%%%%%%%%%% START
% fadditional = T'*fadditional;
% idxs = connMatrix(idx,:);
% ff(idxs) = ff(idxs) + fadditional;
% %%%%%%%%%%%%%%%%%%%%%%%% END
% 
% idx = 4;
% fadditional = int(SS4*nf2(x+0.75*L),x,0,L/4);  
% %%%%%%%%%%%%%%%%%%%%%%%% START
% fadditional = T'*fadditional;
% idxs = connMatrix(idx,:);
% ff(idxs) = ff(idxs) + fadditional;
% %%%%%%%%%%%%%%%%%%%%%%%% END

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPUTE ADDITIONAL K CONTRIBUTIONS

K(end, end) = K(end,end) + kt;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REDUCED PROBLEM
uReduced = [5 6 8 9];

%%%%%%%%%%%%%%%%%%%%%%%% START
KReduced = K(uReduced, uReduced);
freduced = ff(uReduced);
Ured = double(KReduced\freduced);
%%%%%%%%%%%%%%%%%%%%%%%% END

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RECOVER STRAIN ENERGY
U = double(0.5*Ured'*KReduced*Ured);