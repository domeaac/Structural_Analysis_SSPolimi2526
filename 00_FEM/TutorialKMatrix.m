clear, clc, syms L x xbar

nodes_order = 1; % 1 for truss, 2 for beam, 
                 % 3 for truss beam, which is only available in 2 nodes form
number_of_nodes = 2;  
nodal_coordinates = [0; L];
syms EA EJ
vars = [];
stiffness_function = @(x) EJ;


[KK, SS] = KMatrix(number_of_nodes, nodes_order, nodal_coordinates, stiffness_function, vars)
% KK
% SS = subs(SS, x, xbar*L)

%% MASS MATRIX
syms m
vars = symvar(SS); assume(vars, "real");
M = int(SS*SS'*m, x,  0, L)
